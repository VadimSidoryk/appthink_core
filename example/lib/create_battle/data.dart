import 'package:applithium_core_example/battle_details/domain.dart';
import 'package:applithium_core_example/battle_list/domain.dart';
import 'package:applithium_core_example/create_battle/domain.dart';
import 'package:applithium_core_example/profile/domain.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:uuid/uuid.dart';

class FirebaseCreateBattleSource extends CreateBattleSource {

  final String userId;
  final Uuid _uuid = Uuid();
  DatabaseReference get _battlesRecord => FirebaseDatabase.instance
      .reference()
      .child("battles");

  DatabaseReference get _usersRecord => FirebaseDatabase.instance
      .reference()
      .child("users");

  FirebaseCreateBattleSource(this.userId);

  @override
  Future<BattleDetailsModel> createBattle(
      String title,
      String description,
      String participant2, int startTime) {
    return _battlesRecord.once().then((battlesResult) {
      final String uuid = _uuid.v4();
      final Map<String, dynamic> battles = battlesResult.value;
      battles[uuid] = {
        "title": title,
        "description": description,
        "startTime": startTime,
        "result": -1,
        "participant1": userId,
        "participant2": participant2
      };

      return BattleDetailsModel(
          uuid,
          title,
          description,
          ParticipantModel(),
          ParticipantModel(),
          BattleStatus.NOT_STARTED,
          null,
          startTime,
          null,
          0,
          null,
          {}
      );
    });
  }

  @override
  Future<List<UserDetailsModel>> getParticipants() {

  }

  static BattleDetailsModel fromJson(String id, Map<String, dynamic> data) {
    return BattleDetailsModel(
      id,
      data["title"],
      data["description"],
      ParticipantModel(),
      ParticipantModel(),
      data[""],


    );
  }

  static Map<String, dynamic> toJson(BattleDetailsModel model) {
    return {
      "title": model.title,
      "status": model.status
    };
  }
}