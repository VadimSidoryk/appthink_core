import 'package:applithium_core/blocs/list_bloc.dart';
import 'package:applithium_core/repositories/list_repository.dart';
import 'package:applithium_core_example/battle_details/domain.dart';
import 'package:applithium_core_example/battle_list/domain.dart';
import 'package:equatable/equatable.dart';

enum BetStatus {
  NOT_FINISHED,
  WIN,
  LOSE
}

class BetLiteModel extends Equatable {
  final int id;
  final int creationTime;
  final int cashAmount;
  final String battleTitle;
  final BetStatus status;

  BetLiteModel(this.id, this.creationTime, this.cashAmount, this.battleTitle, this.status);

  factory BetLiteModel.fromBattle(BattleLiteModel battle, BattleBetModel bet) {
    return BetLiteModel(-1, DateTime.now().millisecondsSinceEpoch, bet.cashAmount, battle.title, BetStatus.NOT_FINISHED);
  }

  @override
  List<Object> get props => [id];
}

abstract class BetsItemsSource {
  Future<List<BetLiteModel>> getUserBets();
}

class BaseBetsListEvent extends BaseListEvent {
  BaseBetsListEvent._(String analyticTag) : super(analyticTag);

  factory BaseBetsListEvent.betClicked(BattleBetModel model) => BetItemClicked(model);
}

class BetItemClicked extends BaseBetsListEvent {
  BetItemClicked(BattleBetModel model) : super._("bet_clicked");
}

class BetsListBloc extends ListBloc<BetLiteModel, BaseBetsListEvent> {
  BetsListBloc(ListRepository<BetLiteModel> repository) : super(repository);
}
