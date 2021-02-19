import 'package:applithium_core_example/battle/domain.dart';

class BetDetailsModel {
  final int id;
  final BattleResult type;
  final int cashAmount;
  final Set<int> agreed;
  final Set<int> disagreed;
  final bool isOpen;

  BetDetailsModel(this.id, this.type, this.cashAmount, this.agreed,
      this.disagreed, this.isOpen);
}