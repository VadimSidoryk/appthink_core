import 'dart:math';

import 'package:applithium_core_example/battle_list/domain.dart';
import 'package:applithium_core_example/bet_details/domain.dart';
import 'package:tuple/tuple.dart';

import 'domain.dart';

class MockedBattleDetailsSource extends BattleDetailsSource {
  final _random = Random();

  final BattleItemModel _model;

  MockedBattleDetailsSource(this._model);

  @override
  Future<BattleDetailsModel> getBattleDetails(int id) {
    return Future.delayed(
        Duration(milliseconds: 1000), () => mockBattleDetails());
  }

  @override
  Future<List<BaseMessageItemModel>> getMessagesFor(
      int battleId, int page, int itemsPerPage) {
    return Future.delayed(Duration(milliseconds: 2000),
        () => List.generate(itemsPerPage, (i) => mockMessage()));
  }

  @override
  Future<BetItemModel> makePersonalBet(
      BetItemModel model, BattleResult result) {
    return Future.delayed(Duration(milliseconds: 1000), () {
      if (result == model.result) {
        return model.increaseAgreed();
      } else {
        return model.increaseDisagreed();
      }
    });
  }

  @override
  Future<BetItemModel> makeGeneralBet(
      BattleDetailsModel model, BattleResult result) {
    return Future.delayed(Duration(milliseconds: 1000), () => mockBet(result));
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

  BaseMessageItemModel mockMessage() {
    final messageInf = messages[_random.nextInt(messages.length - 1)];
    final user = users[_random.nextInt(users.length - 1)];
    if (messageInf.item2) {
      return MessageWithBetItemModel(
          _random.nextInt(1000000),
          messageInf.item1,
          user,
          DateTime.now().millisecondsSinceEpoch - _random.nextInt(1000),
          mockBet(_random.nextBool()
              ? BattleResult.PARTICIPANT_1_WIN
              : BattleResult.PARTICIPANT_2_WIN));
    } else {
      return MessageItemModel(_random.nextInt(1000000), messageInf.item1, user,
          DateTime.now().millisecondsSinceEpoch - _random.nextInt(1000));
    }
  }

  BetItemModel mockBet(BattleResult result) {
    return BetItemModel(_random.nextInt(1000000), result, _random.nextInt(1000),
        _random.nextInt(20), _random.nextInt(20), true);
  }

  Map<BattleResult, int> mockCacheAmount() => {
        BattleResult.PARTICIPANT_1_WIN: _random.nextInt(500),
        BattleResult.PARTICIPANT_2_WIN: _random.nextInt(500),
        BattleResult.DRAW: _random.nextInt(500),
      };
}

const streamsUrl = const [
  "https://www.youtube.com/watch?v=G5DhR1G6BJI&t",
  "https://www.youtube.com/watch?v=JqNECeH3dRU",
  "https://www.youtube.com/watch?v=Vh56HQ0glno"
];

const messages = const [
  Tuple2(
      "Если Бил не выйдет, выпуск потонет в дизлайках. Поддержите, что бы до ебасосины дошло.",
      false),
  Tuple2(
      "I wish those comments where in English. I really want to read your thoughts",
      false),
  Tuple2("Это будет позор!", true),
  Tuple2("I’m willing to learn Russian just to understand this", false),
  Tuple2(
      "ЕСЛИ БИЛ НЕ ВЫЙДЕТ НА ПОЩЕЧИНУ В СЛЕДУЮЩЕМ БОЮ, МЫ ЕМУ НАБЕРЕМ 500К ДИСЛАЙКОВ!!!",
      false),
  Tuple2("Who came from caseeto ohh sorry kaseto 😅😂❤", false),
  Tuple2("супермен красава,поддержим его", true),
  Tuple2("1 миллион лайков за то,что Сарычев хорошенько звезданул Билла", true),
  Tuple2(
      "если Амиран нас наебёт, то ставим 500к дизов !)))Все по справедливости.. Кто за лайк",
      false),
  Tuple2("1 млн лайков,когда битва за хлеб???", false),
  Tuple2("КТО ЗА ТО, ЧТО БЫ ПРИКРУТИЛИ (ЗАФИКСИРОВАЛИ) СТОЛ - СТАВИМ ЛАЙКИ!!",
      false),
  Tuple2("С каждым лайком очко Билла все шире 😂", true),
];

const users = const [
  UserModel(121, "Мариша Учиха",
      "https://yt3.ggpht.com/ytc/AAUvwngUIVRnwlWhOpf6FhanN343KhUYFBOTO2wcJ_U9=s88-c-k-c0x00ffffff-no-rj"),
  UserModel(2512, "Thomas takes a toll for the dark",
      "https://yt3.ggpht.com/ytc/AAUvwnjodhCq2xpdjzjxnoqJWnbTXOvxyqGWa1-mSv3V=s88-c-k-c0x00ffffff-no-rj"),
  UserModel(201, "Дмитрий Мешков",
      "https://yt3.ggpht.com/ytc/AAUvwnjX-Oc3WwMO0bttGYDBySFluTKA9zGmqb-vZ6u86g=s88-c-k-c0x00ffffff-no-rj"),
  UserModel(12, "6CaNceR9 Official",
      "https://yt3.ggpht.com/ytc/AAUvwng4QmIJpYJ3XH9qQMf_IDSWlikTZb0J7eSUqyyHfA=s88-c-k-c0x00ffffff-no-rj"),
  UserModel(5420, "Хриплый Биток",
      "https://yt3.ggpht.com/ytc/AAUvwniWYWcxMtvUa3lqrnbkFviPIEBwHxbSC6JRzBgPKA=s88-c-k-c0x00ffffff-no-rj")
];
