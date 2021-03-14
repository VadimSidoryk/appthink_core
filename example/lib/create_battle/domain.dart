import 'dart:async';

import 'package:applithium_core/blocs/content_bloc.dart';
import 'package:applithium_core_example/battle_details/domain.dart';
import 'package:applithium_core_example/battle_list/domain.dart';
import 'package:applithium_core_example/profile/domain.dart';

abstract class CreateBattleSource {
  Future<List<UserDetailsModel>> getParticipants();

  Future<BattleDetailsModel> createBattle(
      String title, String description, String participant2, int startDate);
}

abstract class CreateBattleEvent extends BaseContentEvent {
  CreateBattleEvent._(String analyticTag) : super(analyticTag);
}

class ScreenOpened extends CreateBattleEvent {}

class CreateButtonClicked extends CreateBattleEvent {}

class CreateBattleRepository {
  final BattleListRepository _listRepository;
  final CreateBattleSource _source;

  CreateBattleRepository(this._listRepository, this._source);

  Future<bool> createBattle(
      String title, UserDetailsModel participant, int startDate) async {
    return _source.createBattle(title, participant.id, startDate).then((model) {
      if (model != null) {
        _listRepository.notifyBattleAdded(model);
      }
      return model != null;
    });
  }

  Future<List<UserDetailsModel>> getParticipants() {
    return _source.getParticipants();
  }
}
