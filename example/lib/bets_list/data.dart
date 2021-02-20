import 'domain.dart';

class MockedBetListSource extends BetsItemsSource {
  final List<BetLiteModel> _items;

  MockedBetListSource(this._items);

  @override
  Future<List<BetLiteModel>> getUserBets() {
    return Future.delayed(Duration(milliseconds: 1000), () => _items);
  }
}
