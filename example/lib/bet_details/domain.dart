
import 'package:applithium_core_example/battle_details/domain.dart';
import 'package:equatable/equatable.dart';

class BetItemModel extends Equatable{
  final int id;
  final BattleResult result;
  final int cashAmount;
  final int agreed;
  final int disagreed;
  final bool isOpen;

  BetItemModel(this.id, this.result, this.cashAmount, this.agreed,
      this.disagreed, this.isOpen);

  @override
  List<Object> get props => [id];
  
  BetItemModel increaseAgreed() {
    return BetItemModel(this.id, this.result, this.cashAmount, this.agreed + 1, this.disagreed, this.isOpen);
  }

  BetItemModel increaseDisagreed() {
    return BetItemModel(this.id, this.result, this.cashAmount, this.agreed, this.disagreed + 1, this.isOpen);
  }
}