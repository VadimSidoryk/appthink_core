import 'package:applithium_core/blocs/content_bloc.dart';
import 'package:applithium_core/blocs/list_bloc.dart';
import 'package:applithium_core/repositories/content_repository.dart';
import 'package:applithium_core/repositories/list_repository.dart';
import 'package:applithium_core_example/battle_list/domain.dart';
import 'package:applithium_core_example/bets_list/domain.dart';
import 'package:applithium_core_example/profile/domain.dart';
import 'package:equatable/equatable.dart';

abstract class BattleDetailsSource {
  Future<BattleDetailsModel> getBattleDetails(int id);

  Future<List<BaseMessageItemModel>> getMessagesFor(
      int battleId, int page, int itemsPerPage);

  Future<BattleBetModel> makeGeneralBet(
      BattleDetailsModel model, BattleResult result);

  Future<BattleBetModel> makePersonalBet(BattleBetModel model, BattleResult result);
}

abstract class MessagesListEvent extends BaseListEvent {
  MessagesListEvent._(String analyticTag) : super(analyticTag);
}

class PersonalBetClicked extends MessagesListEvent {
  final MessageWithBetItemModel messageModel;
  final BattleResult result;

  PersonalBetClicked(this.messageModel, this.result)
      : super._("personal_bet_clicked");
}

class MessagesListBloc
    extends ListBloc<BaseMessageItemModel, MessagesListEvent> {
  final MessagesRepository _repository;

  MessagesListBloc(this._repository) : super(_repository);

  @override
  Stream<ListState<MessageItemModel>> mapCustomEventToState(
      MessagesListEvent event) async* {
    if (event is PersonalBetClicked) {
      _repository.makePersonalBet(event.messageModel, event.result);
    }
  }
}

class BattleDetailsBloc
    extends ContentBloc<BattleDetailsModel, BattleDetailsEvents> {
  final BattleDetailsRepository _detailsRepository;

  BattleDetailsBloc(this._detailsRepository) : super(_detailsRepository);

  @override
  Stream<ContentState<BattleDetailsModel>> mapCustomEventToState(
      BattleDetailsEvents event) async* {
    if (event is Participant1Clicked) {
      _detailsRepository.makeGeneralBet(BattleResult.PARTICIPANT_1_WIN);
    } else if (event is DrawClicked) {
      _detailsRepository.makeGeneralBet(BattleResult.DRAW);
    } else if (event is Participant2Clicked) {
      _detailsRepository.makeGeneralBet(BattleResult.PARTICIPANT_2_WIN);
    }
  }
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

  BattleDetailsRepository(
      this._battleId, this._source, this._userRepo);

  @override
  Future<BattleDetailsModel> loadData() {
    return _source.getBattleDetails(_battleId);
  }

  Future<bool> makeGeneralBet(BattleResult result) async {
    final amount = data.value.generalBets[result];
    final reserved = await _userRepo.reserveBalance(amount);
    if (!reserved) {
      return false;
    } else {
      final bet = await _source.makeGeneralBet(data.value, result);
      if (bet != null) {
        _userRepo.notifyBetMade(BetLiteModel.fromBattle(data.value, bet));
      }
      return bet != null;
    }
  }
}

class MessagesRepository extends ListRepository<BaseMessageItemModel> {
  final BattleDetailsModel _battle;
  final BattleDetailsSource _source;
  final UserDetailsRepository _userRepo;

  MessagesRepository(
    this._battle,
    this._source,
    this._userRepo,
  ) : super(20);

  @override
  Future<List<BaseMessageItemModel>> loadItems(
      int startIndex, BaseMessageItemModel lastValue, int itemsToLoad) {
    return _source.getMessagesFor(
        _battle.id, startIndex ~/ itemsToLoad + 1, itemsToLoad);
  }

  Future<bool> makePersonalBet(
      MessageWithBetItemModel model, BattleResult result) async {
    final amount = model.bet.cashAmount;
    final reserved = await _userRepo.reserveBalance(amount);
    if (!reserved) {
      return false;
    } else {
      final bet = await _source.makePersonalBet(model.bet, result);
      if (bet != null) {
        _userRepo.notifyBetMade(BetLiteModel.fromBattle(_battle, bet));
        updateItem(model.withBet(bet));
      }
      return bet != null;
    }
  }
}

class BattleDetailsModel extends BattleLiteModel {
  final String title;
  final String description;
  final BattleResult result;
  final BattleStatus status;
  final int endTime;
  final int watching;
  final String streamUrl;
  final Map<BattleResult, int> generalBets;

  BattleDetailsModel(
      id,
      this.title,
      this.description,
      participant1,
      participant2,
      this.status,
      this.result,
      startTime,
      this.endTime,
      this.watching,
      this.streamUrl,
      this.generalBets): super(id, participant1, participant2, startTime, "$participant1 VS $participant2");

  @override
  List<Object> get props => [id];
}

enum BattleStatus { NOT_STARTED, STARTED, FINISHED }

class BattleBetModel extends Equatable {
  final int id;
  final BattleResult result;
  final int cashAmount;
  final int agreed;
  final int disagreed;
  final bool isOpen;

  BattleBetModel(this.id, this.result, this.cashAmount, this.agreed,
      this.disagreed, this.isOpen);

  @override
  List<Object> get props => [id];

  BattleBetModel increaseAgreed() {
    return BattleBetModel(this.id, this.result, this.cashAmount, this.agreed + 1, this.disagreed, this.isOpen);
  }

  BattleBetModel increaseDisagreed() {
    return BattleBetModel(this.id, this.result, this.cashAmount, this.agreed, this.disagreed + 1, this.isOpen);
  }
}

abstract class BaseMessageItemModel extends Equatable {
  final int id;
  final String message;
  final bool isBet;
  final UserModel user;
  final int timeSend;

  BaseMessageItemModel(
      this.id, this.message, this.isBet, this.user, this.timeSend);

  @override
  List<Object> get props => [id];
}

class MessageItemModel extends BaseMessageItemModel {
  MessageItemModel(int id, String message, UserModel user, int timeSend)
      : super(id, message, false, user, timeSend);
}

class MessageWithBetItemModel extends BaseMessageItemModel {
  final BattleBetModel bet;

  MessageWithBetItemModel(
      int id, String message, UserModel user, int timeSend, this.bet)
      : super(id, message, true, user, timeSend);

  MessageWithBetItemModel withBet(BattleBetModel newBet) {
    return MessageWithBetItemModel(
        this.id, this.message, this.user, this.timeSend, newBet);
  }
}

enum BattleResult { PARTICIPANT_1_WIN, PARTICIPANT_2_WIN, DRAW }

class UserModel {
  final int id;
  final String name;
  final String thumbnail;

  const UserModel(this.id, this.name, this.thumbnail);
}
