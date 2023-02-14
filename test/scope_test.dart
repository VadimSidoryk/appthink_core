import 'package:appthink_core/scopes/store.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final testId = 12;
  final testDescription = "TestDescription";

  test("create new instance from other providers", () {
    final store = Store();
    store.add((provider) => testId);
    store.add((provider) => testDescription);
    store.add((provider) => _ClassWithDependencies(provider.get(), provider.get()));

    final instanceFromStore = store.get<_ClassWithDependencies>();
    assert(instanceFromStore.id == testId);
    assert(instanceFromStore.description == testDescription);
  });

  test("store lazy provider test", () {
    final store = Store();
    store.add((provider) => _ClassWithDependencies(testId, testDescription));
    final firstInstanceFromStore = store.get<_ClassWithDependencies>();
    final secondInstanceFromStore = store.get<_ClassWithDependencies>();

    assert(firstInstanceFromStore == secondInstanceFromStore);
  });

  test("store factory provider test", () {
    final store = Store();
    store.addFactory((provider) => _ClassWithDependencies(testId, testDescription));
    final firstInstanceFromStore = store.get<_ClassWithDependencies>();
    final secondInstanceFromStore = store.get<_ClassWithDependencies>();

    assert(firstInstanceFromStore.id == secondInstanceFromStore.id);
    assert(firstInstanceFromStore.description == secondInstanceFromStore.description);
    assert(firstInstanceFromStore != secondInstanceFromStore);
  });

  test("store keys test", () {
    final store = Store();
    final key1 = "Key1";
    final key2 = "Key2";

    store.add((provider) => _ClassWithDependencies(testId, key1), key: key1);
    store.add((provider) => _ClassWithDependencies(testId, key2), key: key2);

    final firstInstanceFromStore = store.get<_ClassWithDependencies>(key: key1);
    assert(firstInstanceFromStore.description == key1);

    final secondInstanceFromStore = store.get<_ClassWithDependencies>(key: key2);
    assert(secondInstanceFromStore.description == key2);
  });

}

class _ClassWithDependencies {
  final int id;
  final String description;

  _ClassWithDependencies(this.id, this.description);
}

