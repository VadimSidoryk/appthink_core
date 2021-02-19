import 'dart:math';

import 'package:applithium_core_example/bet/domain.dart';
import 'package:applithium_core_example/top/domain.dart';

import 'domain.dart';

class MockedBattleDetailsSource extends BattleDetailsSource {
  final _random = Random();

  final BattleItemModel _model;

  MockedBattleDetailsSource(this._model);

  @override
  Future<BattleDetailsModel> getBattleDetails(int id) {
    return Future.delayed(
        Duration(milliseconds: 1500), () => mockBattleDetails());
  }

  BattleDetailsModel mockBattleDetails() {
    final status = BattleStatus.values[_random.nextInt(2)];
    BattleResult result;
    if (status == BattleStatus.FINISHED) {
      result = BattleResult.values[_random.nextInt(2)];
    } else {
      result = null;
    }

    return BattleDetailsModel(
        _model.id,
        "Epic Battle: ${_model.participant1.name} VS ${_model.participant2.name}!!!",
        "Is it what you waiting for? Absolutely!!",
        _model.participant1,
        _model.participant2,
        status,
        result,
        DateTime.now().microsecondsSinceEpoch - 60000,
        DateTime.now().microsecondsSinceEpoch + 60000,
        _random.nextInt(100000),
        streamsUrl[_random.nextInt(streamsUrl.length - 1)],
        mockCacheAmount());
  }

  @override
  Future<List<MessageModel>> getMessagesFor(
      int battleId, int page, int itemsPerPage) {
    return Future.delayed(Duration(milliseconds: 1000), () => []);
  }

  Map<BattleResult, int> mockCacheAmount() => {
        BattleResult.PARTICIPANT_1_WIN: _random.nextInt(10000),
        BattleResult.PARTICIPANT_2_WIN: _random.nextInt(10000),
        BattleResult.DRAW: _random.nextInt(10000),
      };

  static const streamsUrl = const [
    "https://www.youtube.com/watch?v=G5DhR1G6BJI&t",
    "https://www.youtube.com/watch?v=JqNECeH3dRU",
    "https://www.youtube.com/watch?v=Vh56HQ0glno"
  ];

  @override
  Future<bool> makeABet(BetDetailsModel model) {
    return Future.delayed(Duration(milliseconds: 1500), () => true);
  }
}
