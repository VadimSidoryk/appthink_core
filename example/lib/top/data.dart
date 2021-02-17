import 'dart:math';

import 'package:applithium_core_example/top/domain.dart';

class MockedBattlesSource extends BattlesSource {
  Random _random = Random();

  @override
  Future<List<BattleModel>> getTopBattles(int page, int itemsPerPage) {
    return Future.delayed(Duration(milliseconds: 1500),
        () => List.generate(itemsPerPage, (i) => mockBattle()));
  }

  BattleModel mockBattle() {
    return BattleModel(
        _random.nextInt(1000000),
        mockParticipant(),
        mockParticipant(),
        DateTime.now().millisecondsSinceEpoch + _random.nextInt(10000),
        _random.nextInt(1000));
  }

  ParticipantModel mockParticipant() {
    final id = _random.nextInt(participantNames.length - 1);

    return ParticipantModel(id, participantNames[id], thumbnails[id], rankings[id]);
  }

  static const List<double> rankings = const [
    3.2,
    3.7,
    4.9,
    4.6,
    5.0,
    3.2,
    4.2,
    1.2,
    3.5,
    2.5
  ];

  static const List<String> participantNames = const [
    "Snail Kick",
    "Karamba",
    "Хач",
    "Эдвард Билл",
    "Пельмень",
    "Zombie boy",
    "Большой папа",
    "Влад Бумага",
    "Кирилл Сарычев",
    "Давидыч"
  ];

  static const List<String> thumbnails = const [
    "https://yt3.ggpht.com/ytc/AAUvwngLHMAHZY-Fe6Dmur0QtgZLPR_TnsbnS3k6hFUw=s176-c-k-c0x00ffffff-no-rj",
    "https://yt3.ggpht.com/ytc/AAUvwngaXLxft4mGDEF5LOivs24tsT5XolXeXvg9stVk=s176-c-k-c0x00ffffff-no-rj-mo",
    "https://yt3.ggpht.com/yhttps://yt3.ggpht.com/ytc/AAUvwnhaIKwFbvy6iBKbUwRpyOc7GGeyVZNWk-RG1WtjWA=s176-c-k-c0x00ffffff-no-rj-motc/AAUvwngMV_xY8iFp1qgSGY5k7VpUjkW9__HqgtHInjDL=s176-c-k-c0x00ffffff-no-rj-mo",
    "https://yt3.ggpht.com/ytc/AAUvwnhEQ6YDdgheCifYTb5VmQDYfy5mw0u7UJ5fU41c1A=s176-c-k-c0x00ffffff-no-rj-mo",
    "https://yt3.ggpht.com/ytc/AAUvwnh58Wtyi_6thsG8keKeNS9yBNQEI4tAz8si9tid=s176-c-k-c0x00ffffff-no-rj-mo",
    "https://yt3.ggpht.com/ytc/AAUvwnhbPk3EMmUEBIi1DiJZ9ApCMNkCT_wDFXZszS9Muw=s176-c-k-c0x00ffffff-no-rj",
    "https://yt3.ggpht.com/ytc/AAUvwniUm7TvkMEsq-HqJlALKxzpaJsIW6eCfyspQ1AtGQ=s176-c-k-c0x00ffffff-no-rj-mo",
    "https://yt3.ggpht.com/ytc/AAUvwniUNo8Xo0j8CiDF0Vf8z-rlgN-LkgkUlY-vB7SjoA=s176-c-k-c0x00ffffff-no-rj-mo",
    "https://yt3.ggpht.com/ytc/AAUvwnhTAJE0Pt4eMVdas9KS_y3YaTbahbPT6QuATmIZxg=s176-c-k-c0x00ffffff-no-rj-mo",
    "https://yt3.ggpht.com/ytc/AAUvwnhaIKwFbvy6iBKbUwRpyOc7GGeyVZNWk-RG1WtjWA=s176-c-k-c0x00ffffff-no-rj-mo"
  ];
}
