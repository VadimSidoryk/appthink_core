
class MockUtils {
  MockUtils._();

  static List<T> generateItems<T>(int count, T Function(int) generator) {
    return  [for (var i = 0; i < count; i += 1) generator(i)];
  }
}

