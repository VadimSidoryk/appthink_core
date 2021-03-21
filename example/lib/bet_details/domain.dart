import 'package:applithium_core_example/bets_list/domain.dart';

class BetModel extends BetLiteModel {

  final String battleId;

  BetModel(
      id,
      creationTime,
      cashAmount,
      battleTitle,
      resultTitle,
      status,
      this.battleId) : super(id, creationTime, cashAmount, battleTitle, resultTitle, status);

  factory BetModel.fromJson(String id, Map<String, dynamic> data) {
    return null;
  }
  

}