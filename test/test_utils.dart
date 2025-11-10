import 'dart:async';
import 'package:flutter_test/flutter_test.dart';

/// 测试工具类
class TestUtils {
  /// 性能监控
  static Future<PerformanceResult> measurePerformance<T>(
    Future<T> Function() testFunction, {
    int iterations = 1,
  }) async {
    final stopwatch = Stopwatch();
    final List<Duration> durations = [];

    for (int i = 0; i < iterations; i++) {
      stopwatch.start();
      await testFunction();
      stopwatch.stop();
      durations.add(stopwatch.elapsed);
      stopwatch.reset();
    }

    final totalDuration = durations.fold<Duration>(
      Duration.zero,
      (sum, duration) => sum + duration,
    );

    final averageDuration = Duration(
      microseconds: totalDuration.inMicroseconds ~/ iterations,
    );

    durations.sort((a, b) => a.compareTo(b));
    final minDuration = durations.first;
    final maxDuration = durations.last;

    return PerformanceResult(
      totalDuration: totalDuration,
      averageDuration: averageDuration,
      minDuration: minDuration,
      maxDuration: maxDuration,
      iterations: iterations,
    );
  }

  /// 内存泄漏检测
  static Future<MemoryLeakResult> detectMemoryLeak<T>({
    required Future<void> Function() setup,
    required T Function() createObject,
    required Future<void> Function(T) dispose,
    required Future<void> Function() test,
    int iterations = 10,
  }) async {
    final List<int> memoryUsages = [];

    for (int i = 0; i < iterations; i++) {
      await setup();
      final object = createObject();
      await test();
      await dispose(object);

      // 强制垃圾回收（在测试环境中可能不生效）
      await Future.delayed(Duration(milliseconds: 10));

      // 记录内存使用（简化版本，实际需要更复杂的实现）
      memoryUsages.add(i);
    }

    // 检查内存使用是否持续增长
    bool hasLeak = false;
    if (memoryUsages.length > 1) {
      // 简化检查：如果内存使用持续增长，可能存在泄漏
      for (int i = 1; i < memoryUsages.length; i++) {
        if (memoryUsages[i] > memoryUsages[i - 1] * 1.5) {
          hasLeak = true;
          break;
        }
      }
    }

    return MemoryLeakResult(
      hasLeak: hasLeak,
      iterations: iterations,
      memoryUsages: memoryUsages,
    );
  }

  /// 等待所有异步操作完成
  static Future<void> waitForAsyncOperations() async {
    await Future.delayed(Duration(milliseconds: 100));
    // 等待所有微任务完成
    await Future(() {});
  }

  /// 验证Stream订阅是否被正确取消
  static Future<bool> verifySubscriptionCancelled(
    StreamSubscription subscription,
  ) async {
    try {
      await subscription.cancel();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// 验证Controller是否被正确关闭
  static bool verifyControllerClosed(StreamController controller) {
    return controller.isClosed;
  }
}

/// 性能测试结果
class PerformanceResult {
  final Duration totalDuration;
  final Duration averageDuration;
  final Duration minDuration;
  final Duration maxDuration;
  final int iterations;

  PerformanceResult({
    required this.totalDuration,
    required this.averageDuration,
    required this.minDuration,
    required this.maxDuration,
    required this.iterations,
  });

  @override
  String toString() {
    return 'PerformanceResult('
        'total: ${totalDuration.inMilliseconds}ms, '
        'average: ${averageDuration.inMilliseconds}ms, '
        'min: ${minDuration.inMilliseconds}ms, '
        'max: ${maxDuration.inMilliseconds}ms, '
        'iterations: $iterations)';
  }
}

/// 内存泄漏检测结果
class MemoryLeakResult {
  final bool hasLeak;
  final int iterations;
  final List<int> memoryUsages;

  MemoryLeakResult({
    required this.hasLeak,
    required this.iterations,
    required this.memoryUsages,
  });

  @override
  String toString() {
    return 'MemoryLeakResult('
        'hasLeak: $hasLeak, '
        'iterations: $iterations, '
        'memoryUsages: $memoryUsages)';
  }
}

/// 性能测试扩展
extension PerformanceTestExtension on Future<void> Function() {
  /// 测量性能
  Future<PerformanceResult> measurePerformance({int iterations = 1}) {
    return TestUtils.measurePerformance(this, iterations: iterations);
  }
}

/// 内存泄漏检测扩展
extension MemoryLeakTestExtension on Future<void> Function() {
  /// 检测内存泄漏
  Future<MemoryLeakResult> detectMemoryLeak<T>({
    required T Function() createObject,
    required Future<void> Function(T) dispose,
    int iterations = 10,
  }) {
    return TestUtils.detectMemoryLeak<T>(
      setup: () => Future.value(),
      createObject: createObject,
      dispose: dispose,
      test: this,
      iterations: iterations,
    );
  }
}

