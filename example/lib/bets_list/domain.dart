import 'package:applithium_core/blocs/list_bloc.dart';
import 'package:applithium_core/logs/default_logger.dart';
import 'package:applithium_core/logs/logger.dart';
import 'package:applithium_core/repositories/list_repository.dart';
import 'package:applithium_core_example/battle_details/domain.dart';
import 'package:applithium_core_example/battle_list/domain.dart';
import 'package:applithium_core_example/profile/domain.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum BetStatus { NOT_FINISHED, WIN, LOSE }

class BetLiteModel extends Equatable {
  final int id;
  final int creationTime;
  final int cashAmount;
  final String battleTitle;
  final String battleResultTitle;
  final BetStatus status;

  BetLiteModel(this.id, this.creationTime, this.cashAmount, this.battleTitle,
      this.battleResultTitle,
      this.status);

  factory BetLiteModel.fromBattle(BattleLiteModel battle, BattleBetModel bet) {
    return BetLiteModel(-1, DateTime.now().millisecondsSinceEpoch,
        bet.cashAmount, battle.title,
        bet.result == BattleResult.PARTICIPANT_1_WIN ? battle.participant1.name : battle.participant2.name,
        BetStatus.NOT_FINISHED);
  }

  @override
  List<Object> get props => [id];
}

class BaseBetsListEvent extends BaseListEvent {
  BaseBetsListEvent._(String analyticTag) : super(analyticTag);

  factory BaseBetsListEvent.betClicked(BattleBetModel model) =>
      BetItemClicked(model);
}

class BetItemClicked extends BaseBetsListEvent {
  BetItemClicked(BattleBetModel model) : super._("bet_clicked");
}


class BetsListBloc extends Bloc<BaseListEvent, ListState<BetLiteModel>> {
  final Stream<List<BetLiteModel>> _listStream;

  @protected
  final Logger logger;

  BetsListBloc(this._listStream,
      {this.logger = const DefaultLogger("BetsListBloc")})
      : super(ListState(null, true, false, false, null)) {
    _listStream.listen((items) {
      add(DisplayData(items, true));
    });
  }

  @override
  Stream<ListState<BetLiteModel>> mapEventToState(BaseListEvent event) async* {
    if (event is DisplayData<List<BetLiteModel>>) {
      yield state.withValue(event.data, event.isEndReached);
    }
  }
}
