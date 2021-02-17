import 'dart:math';

import 'package:applithium_core_example/top/domain.dart';

class MockedBattlesSource extends BattlesSource {
  final _random = Random();

  @override
  Future<List<BattleItemModel>> getTopBattles(int page, int itemsPerPage) {
    return Future.delayed(Duration(milliseconds: 1500),
        () => List.generate(itemsPerPage, (i) => mockBattle()));
  }

  BattleItemModel mockBattle() {
    return BattleItemModel(
        _random.nextInt(1000000),
        mockParticipant(),
        mockParticipant(),
        DateTime.now().millisecondsSinceEpoch + _random.nextInt(10000),
        _random.nextInt(1000));
  }

  ParticipantModel mockParticipant() {
    final id = _random.nextInt(participantNames.length - 1);

    return ParticipantModel(id, participantNames[id], thumbnails[id], fullSizeImages[id], rankings[id]);
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
    "https://yt3.ggpht.com/ytc/AAUvwngMV_xY8iFp1qgSGY5k7VpUjkW9__HqgtHInjDL=s176-c-k-c0x00ffffff-no-rj",
    "https://yt3.ggpht.com/ytc/AAUvwnhEQ6YDdgheCifYTb5VmQDYfy5mw0u7UJ5fU41c1A=s176-c-k-c0x00ffffff-no-rj-mo",
    "https://yt3.ggpht.com/ytc/AAUvwnh58Wtyi_6thsG8keKeNS9yBNQEI4tAz8si9tid=s176-c-k-c0x00ffffff-no-rj-mo",
    "https://yt3.ggpht.com/ytc/AAUvwnhbPk3EMmUEBIi1DiJZ9ApCMNkCT_wDFXZszS9Muw=s176-c-k-c0x00ffffff-no-rj",
    "https://yt3.ggpht.com/ytc/AAUvwniUm7TvkMEsq-HqJlALKxzpaJsIW6eCfyspQ1AtGQ=s176-c-k-c0x00ffffff-no-rj-mo",
    "https://yt3.ggpht.com/ytc/AAUvwniUNo8Xo0j8CiDF0Vf8z-rlgN-LkgkUlY-vB7SjoA=s176-c-k-c0x00ffffff-no-rj-mo",
    "https://yt3.ggpht.com/ytc/AAUvwnhTAJE0Pt4eMVdas9KS_y3YaTbahbPT6QuATmIZxg=s176-c-k-c0x00ffffff-no-rj-mo",
    "https://yt3.ggpht.com/ytc/AAUvwnhaIKwFbvy6iBKbUwRpyOc7GGeyVZNWk-RG1WtjWA=s176-c-k-c0x00ffffff-no-rj-mo"
  ];

  static const List<String> fullSizeImages = const [
    "https://static.wikia.nocookie.net/rutube9658/images/d/df/%D0%9C%D0%B0%D0%BA%D1%81%D0%B8%D0%BC_%D0%9A%D0%B8%D1%81%D0%B5%D0%BB%D1%91%D0%B2.jpg/revision/latest/top-crop/width/450/height/450?cb=20170317154457&path-prefix=ru",
    "https://png.cmtt.space/paper-preview-fox/c/ar/caramba-ctc/f14d29e58263-original.jpg",
    "https://24smi.org/public/media/celebrity/2016/11/22/ExBPUk14SKCD_amiran-sardarov.jpg",
    "https://avatars.mds.yandex.net/get-zen_doc/1601070/pub_5ccda891e520c700b32166f9_5ccff789d31aa100b3452ee5/scale_1200",
    "data:image/jpeg;base64,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",
    "https://www.wmagazine.com/wp-content/uploads/2018/08/03/5b64785a01041017b2094596_ma__resdefault.jpg?crop=4px,2px,1195px,896px&w=1536px&resize=1536px,1151.6786610879px",
    "https://i.ytimg.com/vi/P1RdIvXFu1g/hqdefault.jpg",
    "data:image/jpeg;base64,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",
    "https://lh3.googleusercontent.com/proxy/uMJv5DcJzmGl2PE981MIRyoACMszYoXDqFIAN8IjSrPJALlMLa6jWZno5lAfwtfHYM-eJtToDzYx4_A0RyJW7gq5Fg9lBtHfr_yQZWFDtDEYphLCPxvwWINFwcT7zCGclRG1GQL5fg4xkLUA7zCNu3eidvh_oKQ0Igxv0GY7kgFBeh8xKwdZLF6qvD5nQOzs4YbaqYaJ9h1up8PCD78MqmklmxWQMSpJArlDh2M-kmtoda4b4DE7I3NCWMNb1wNUcaA_WQp-cYwLNPRQ0Hx3xGlIVxs9ggbrAJfJznJMyyi_5nY8fwI5eesi64uiIUNlGqZgWHIOlJY7dbkYUjBm1slhWJ1GSayIAZprdUFjeVXLrc_K6IUjI1XK8P-nRIGdGRRkBEFAPXNJRcQd3dpCjA-UpcaNOVKd8sQn9abfT5cMOQ",
    "https://n1s1.starhit.ru/f5/aa/5f/f5aa5f59e6cdf0437108561e5d57462b/480x497_0_02fe0ae973e4bf08710250b0e865130b@480x497_0xac120003_17772535881580371701.jpg"
  ];
}
