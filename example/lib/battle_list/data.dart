import 'dart:math';

import 'domain.dart';


class MockedBattlesSource extends BattlesSource {
  final _random = Random();

  @override
  Future<List<BattleLiteModel>> getTopBattles(int page, int itemsPerPage) {
    return Future.delayed(Duration(milliseconds: 1500),
            () => List.generate(itemsPerPage, (i) => mockBattle()));
  }

  BattleLiteModel mockBattle() {
    final participant1 = mockParticipant();
    final participant2 = mockParticipant();

    return BattleLiteModel(
        _random.nextInt(1000000),
        participant1,
        participant2,
        DateTime
            .now()
            .millisecondsSinceEpoch + _random.nextInt(10000),
        "${participant1.name} VS ${participant2.name}");
  }

  ParticipantModel mockParticipant() {
    final id = _random.nextInt(participantNames.length - 1);

    return ParticipantModel(
        id, participantNames[id], thumbnails[id], fullSizeImages[id],
        rankings[id]);
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
    "Амиран",
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
    "https://primamedia.gcdn.co/f/main/1968/1967699.jpg?0965bccaa934d730f0d5388bac7ad0ba",
    "https://www.wmagazine.com/wp-content/uploads/2018/08/03/5b64785a01041017b2094596_ma__resdefault.jpg?crop=4px,2px,1195px,896px&w=1536px&resize=1536px,1151.6786610879px",
    "https://i.ytimg.com/vi/P1RdIvXFu1g/hqdefault.jpg",
    "https://uznayvse.ru/images/celebs/2020/2/vlad-bumaga_big.jpg",
    "https://lh3.googleusercontent.com/proxy/uMJv5DcJzmGl2PE981MIRyoACMszYoXDqFIAN8IjSrPJALlMLa6jWZno5lAfwtfHYM-eJtToDzYx4_A0RyJW7gq5Fg9lBtHfr_yQZWFDtDEYphLCPxvwWINFwcT7zCGclRG1GQL5fg4xkLUA7zCNu3eidvh_oKQ0Igxv0GY7kgFBeh8xKwdZLF6qvD5nQOzs4YbaqYaJ9h1up8PCD78MqmklmxWQMSpJArlDh2M-kmtoda4b4DE7I3NCWMNb1wNUcaA_WQp-cYwLNPRQ0Hx3xGlIVxs9ggbrAJfJznJMyyi_5nY8fwI5eesi64uiIUNlGqZgWHIOlJY7dbkYUjBm1slhWJ1GSayIAZprdUFjeVXLrc_K6IUjI1XK8P-nRIGdGRRkBEFAPXNJRcQd3dpCjA-UpcaNOVKd8sQn9abfT5cMOQ",
    "https://n1s1.starhit.ru/f5/aa/5f/f5aa5f59e6cdf0437108561e5d57462b/480x497_0_02fe0ae973e4bf08710250b0e865130b@480x497_0xac120003_17772535881580371701.jpg"
  ];
}
