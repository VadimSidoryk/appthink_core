
class MockUtils {
  MockUtils._();

  static Future<List<T>> generateItemsWithDelay<T>(
      Duration delay, int count, T Function(int) generator) async {
    return Future.delayed(
        delay, () => [for (var i = 0; i < count; i += 1) generator(i)]);
  }

}

