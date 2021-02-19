import 'package:applithium_core/blocs/content_bloc.dart';
import 'package:applithium_core/repositories/content_repository.dart';
import 'package:applithium_core/repositories/list_repository.dart';
import 'package:applithium_core_example/battle_list/domain.dart';
import 'package:applithium_core_example/bet_details/domain.dart';
import 'package:applithium_core_example/profile/domain.dart';
import 'package:equatable/equatable.dart';

abstract class BattleDetailsSource {
  Future<BattleDetailsModel> getBattleDetails(int id);

  Future<List<MessageModel>> getMessagesFor(
      int battleId, int page, int itemsPerPage);

  Future<bool> makeABet(BetDetailsModel model);
}

class BattleDetailsBloc
    extends ContentBloc<BattleDetailsModel, BaseContentEvent> {
  final BattleDetailsRepository _repository;

  BattleDetailsBloc(this._repository) : super(_repository);
}

abstract class BattleDetailsEvents extends BaseContentEvent {
  BattleDetailsEvents._(String analyticTag) : super(analyticTag);

  factory BattleDetailsEvents.participant1Clicked() => Participant1Clicked();
  factory BattleDetailsEvents.drawClicked() => DrawClicked();
  factory BattleDetailsEvents.participant2Clicked() => Participant2Clicked();
}

class Participant1Clicked extends BattleDetailsEvents {
  Participant1Clicked() : super._("vote_for_participant_1");
}

class DrawClicked extends BattleDetailsEvents {
  DrawClicked() : super._("vote_draw");
}

class Participant2Clicked extends BattleDetailsEvents {
  Participant2Clicked() : super._("vote_for_participant_2");
}

class BattleDetailsRepository extends ContentRepository<BattleDetailsModel> {
  final int _battleId;
  final BattleDetailsSource _source;
  final UserDetailsRepository _userRepo;

  final _MessagesRepository messagesRepository;

  BattleDetailsRepository(this._battleId, this._source, this._userRepo)
      : messagesRepository = _MessagesRepository(_battleId, _source);

  @override
  Future<BattleDetailsModel> loadData() {
    return _source.getBattleDetails(_battleId);
  }

  @override
  void preloadData() {
    super.preloadData();
    messagesRepository.preloadData();
  }
  
  Future<bool> makeBet(BetDetailsModel model) async {
     final reserved = await _userRepo.reserveBalance(model.cashAmount);
     if(!reserved){
       return false;
     } else {
        final betStatus = await _source.makeABet(model);
        if(betStatus) {
          _userRepo.notifyBetMade(model);
        }
     }
  }
}

class _MessagesRepository extends ListRepository<MessageModel> {
  final int _battleId;
  final BattleDetailsSource _source;

  _MessagesRepository(
    this._battleId,
    this._source,
  ) : super(20);

  @override
  Future<List<MessageModel>> loadItems(
      int startIndex, MessageModel lastValue, int itemsToLoad) {
    return _source.getMessagesFor(
        _battleId, startIndex ~/ itemsToLoad + 1, itemsToLoad);
  }
}

class BattleDetailsModel {
  final int id;
  final String title;
  final String description;
  final ParticipantModel participant1;
  final ParticipantModel participant2;
  final BattleResult result;
  final BattleStatus status;
  final int startTime;
  final int endTime;
  final int watching;
  final String streamUrl;
  final Map<BattleResult, int> cashAmount;

  BattleDetailsModel(
      this.id,
      this.title,
      this.description,
      this.participant1,
      this.participant2,
      this.status,
      this.result,
      this.startTime,
      this.endTime,
      this.watching,
      this.streamUrl,
      this.cashAmount);
}

enum BattleStatus { NOT_STARTED, STARTED, FINISHED }

class MessageModel extends Equatable {
  final int id;
  final String message;
  final bool isBet;
  final UserModel user;
  final int timeSend;

  MessageModel(this.id, this.message, this.isBet, this.user, this.timeSend);

  @override
  List<Object> get props => [id];
}

enum BattleResult { PARTICIPANT_1_WIN, PARTICIPANT_2_WIN, DRAW }

class UserModel {
  final int id;
  final String name;
  final String thumbnail;

  UserModel(this.id, this.name, this.thumbnail);
}
