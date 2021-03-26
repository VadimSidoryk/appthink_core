import 'package:applithium_core/blocs/content_bloc.dart';
import 'package:applithium_core/blocs/list_bloc.dart';
import 'package:applithium_core/repositories/content_repository.dart';
import 'package:applithium_core/repositories/list_repository.dart';
import 'package:applithium_core_example/battle_list/domain.dart';
import 'package:applithium_core_example/bet_details/domain.dart';
import 'package:applithium_core_example/bets_list/domain.dart';
import 'package:applithium_core_example/profile/domain.dart';
import 'package:equatable/equatable.dart';

abstract class BattleDetailsSource {
  Future<BattleDetailsModel> getBattleDetails(int id);

  Future<List<BaseMessageItemModel>> getMessagesFor(
      int battleId, int page, int itemsPerPage);

  Future<BattleBetModel> makeGeneralBet(
      BattleDetailsModel model, BattleResult result);

  Future<BattleBetModel> makePersonalBet(
      BattleBetModel model, BattleResult result);
}

abstract class MessagesListEvent extends BaseListEvents {
  MessagesListEvent._(String analyticTag) : super(analyticTag);
}

class PersonalBetClicked extends MessagesListEvent {
  final MessageWithBetItemModel messageModel;
  final BattleResult result;

  PersonalBetClicked(this.messageModel, this.result)
      : super._("personal_bet_clicked");
}

class MessagesListBloc
    extends ListBloc<MessagesListEvent, BaseMessageItemModel> {
  final MessagesRepository repository;

  MessagesListBloc(this.repository) : super(repository);

  @override
  Stream<ListState<MessageItemModel>> mapCustomEventToState(
      MessagesListEvent event) async* {
    if (event is PersonalBetClicked) {
      repository.makePersonalBet(event.messageModel, event.result);
    }
  }
}

class BattleDetailsBloc
    extends ContentBloc<BattleDetailsEvents, BattleDetailsModel> {
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

abstract class BattleDetailsEvents extends BaseContentEvents {
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

  BattleDetailsRepository(this._battleId, this._source, this._userRepo);

  @override
  Future<BattleDetailsModel> loadData() {
    return _source.getBattleDetails(_battleId);
  }

  Future<bool> makeGeneralBet(BattleResult result) async {
    print("makeGeneralBet");
    final amount = (await data.first).generalBets[result];
    final reserved = await _userRepo.reserveBalance(amount);
    print("reserved = $reserved");
    if (!reserved) {
      return false;
    } else {
      final bet = await _source.makeGeneralBet(data.value, result);
      print("bet= $bet");
      if (bet != null) {
        _userRepo.notifyBetMade(null);
      }
      return bet != null;
    }
  }
}

class MessagesRepository extends ListRepository<BaseMessageItemModel> {
  final BattleLiteModel _battle;
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
    print("makePersonalBet");
    updateItem(model.withBet(result == model.bet.result
        ? model.bet.increaseAgreed()
        : model.bet.increaseDisagreed()));
    final amount = model.bet.cashAmount;
    final reserved = await _userRepo.reserveBalance(amount);
    print("reserved = $reserved");

    if (!reserved) {
      return false;
    } else {
      final bet = await _source.makePersonalBet(model.bet, result);
      print("bet= $bet");
      if (bet != null) {
        _userRepo.notifyBetMade(null);
        updateItem(model.withBet(bet));
      }
      return bet != null;
    }
  }
}

class BattleDetailsModel extends BattleLiteModel {
  final String description;
  final BattleResult result;
  final BattleStatus status;
  final int endTime;
  final int watching;
  final String streamUrl;
  final Map<BattleResult, int> generalBets;

  BattleDetailsModel(
      id,
      title,
      this.description,
      ParticipantModel participant1,
      ParticipantModel participant2,
      this.status,
      this.result,
      startTime,
      this.endTime,
      this.watching,
      this.streamUrl,
      this.generalBets)
      : super(id, participant1, participant2, startTime, title);
  //
  // factory BattleDetailsModel.fromJson(String id, Map<String, dynamic> data) {
  //   return BattleDetailsModel(
  //     id,
  //     data["title"],
  //     data["description"],
  //     ParticipantModel.fromJson(data["participant1"]),
  //     ParticipantModel.fromJson(data["participant2"]),
  //     statusFromInt(data["status"]),
  //     resultFromInt(data["result"]),
  //     data["startTime"],
  //     data["endTime"],
  //     data["watching"],
  //     data["streamUrl"],
  //     (data["bets"] as List<dynamic>).map((item) => BetModel.fromJson(null, item))
  //   );
  // }

  @override
  List<Object> get props => [id];
}

enum BattleStatus { NOT_STARTED, STARTED, FINISHED }

int statusToInt(BattleStatus status) {
    switch(status) {
      case BattleStatus.NOT_STARTED:
        return -1;
      case BattleStatus.STARTED:
        return 0;
      case BattleStatus.FINISHED:
      default:
        return 1;
    }
}

BattleStatus statusFromInt(int value) {
  switch(value) {
    case -1:
      return BattleStatus.NOT_STARTED;
    case 0: 
      return BattleStatus.STARTED;
    case 1:
    default:
      return BattleStatus.FINISHED;
  }
}

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
    return BattleBetModel(this.id, this.result, this.cashAmount,
        this.agreed + 1, this.disagreed, this.isOpen);
  }

  BattleBetModel increaseDisagreed() {
    return BattleBetModel(this.id, this.result, this.cashAmount, this.agreed,
        this.disagreed + 1, this.isOpen);
  }
}

abstract class BaseMessageItemModel extends Equatable {
  final int id;
  final String message;
  final bool isBet;
  final UserLiteModel user;
  final int timeSend;

  BaseMessageItemModel(
      this.id, this.message, this.isBet, this.user, this.timeSend);

  @override
  List<Object> get props => [id];
}

class MessageItemModel extends BaseMessageItemModel {
  MessageItemModel(int id, String message, UserLiteModel user, int timeSend)
      : super(id, message, false, user, timeSend);
}

class MessageWithBetItemModel extends BaseMessageItemModel {
  final BattleBetModel bet;

  MessageWithBetItemModel(
      int id, String message, UserLiteModel user, int timeSend, this.bet)
      : super(id, message, true, user, timeSend);

  MessageWithBetItemModel withBet(BattleBetModel newBet) {
    return MessageWithBetItemModel(
        this.id, this.message, this.user, this.timeSend, newBet);
  }
}

enum BattleResult { PARTICIPANT_1_WIN, PARTICIPANT_2_WIN, DRAW }

BattleResult resultFromInt(int value) {

}

int resultToInt(BattleResult result) {
  switch(result) {
    case BattleResult.PARTICIPANT_1_WIN:
      return 0;
    case BattleResult.PARTICIPANT_2_WIN:
      return 1;
    case BattleResult.DRAW:
    default:
      return 2;
  }
}

class UserLiteModel extends Equatable {
  final String id;
  final String displayName;
  final String thumbnailUrl;
  final bool isBattleParticipant;

  const UserLiteModel(
      this.id, this.displayName, this.thumbnailUrl, this.isBattleParticipant);

  @override
  List<Object> get props => [id];
}
