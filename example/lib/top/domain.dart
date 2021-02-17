
import 'package:applithium_core/blocs/list_bloc.dart';
import 'package:applithium_core/repositories/list_repository.dart';
import 'package:equatable/equatable.dart';

class ParticipantModel  extends Equatable {
  final int id;
 final String name;
 final String thumbnail;
 final double ranking;

  ParticipantModel(this.id, this.name, this.thumbnail, this.ranking);

  @override
  List<Object> get props => [id];
}

class BattleModel extends Equatable {
  final int id;
  final ParticipantModel participant1;
  final ParticipantModel participant2;
  final int startTime;
  final int waiters;

  BattleModel(this.id, this.participant1, this.participant2, this.startTime, this.waiters);

  @override
  List<Object> get props => [id];
}

abstract class BattlesSource {
  Future<List<BattleModel>> getTopBattles(int page, int itemsPerPage);
}

class TopBattlesRepository extends ListRepository<BattleModel> {

  final BattlesSource _source;

  TopBattlesRepository(this._source) : super(20);

  @override
  Future<List<BattleModel>> loadItems(int startIndex, BattleModel lastValue, int itemsToLoad) {
    return _source.getTopBattles(startIndex ~/ itemsToLoad + 1, itemsToLoad);
  }

}

class TopBattlesBloc extends ListBloc<BattleModel, TopBattlesEvent> {
  TopBattlesBloc(TopBattlesRepository repository) : super(repository);
}

class TopBattlesEvent extends BaseListEvent {
  TopBattlesEvent(String analyticTag) : super(analyticTag);
}