import 'package:applithium_core/blocs/content_bloc.dart';
import 'package:applithium_core/logs/default_logger.dart';
import 'package:applithium_core/repositories/content_repository.dart';
import 'package:applithium_core_example/battle_details/domain.dart';
import 'package:applithium_core_example/bets_list/domain.dart';

class UserDetailsModel extends UserLiteModel {
  final int balance;
  final String backgroundUrl;
  final List<BetLiteModel> betHistory;

  UserDetailsModel(
      String id,
      String displayName,
      String thumbnailUrl,
      bool isBattleParticipant,
      this.balance,
      this.backgroundUrl,
      this.betHistory
      ): super(id, displayName, thumbnailUrl, isBattleParticipant);

  UserDetailsModel copyWithBalance(int balance) {
    return UserDetailsModel(
        this.id,
        this.displayName,
        this.thumbnailUrl,
        this.isBattleParticipant,
        balance,
         this.backgroundUrl,
        this.betHistory);
  }

  UserDetailsModel addBet(BetLiteModel model) {
    return UserDetailsModel(
        this.id,
        this.displayName,
        this.thumbnailUrl,
        this.isBattleParticipant,
        this.balance,
        this.backgroundUrl,
        List.from(this.betHistory)..add(model));
  }
}

abstract class UserDetailsSource {
  Future<UserDetailsModel> getUserDetails();

  Future<bool> increaseBalance(int amount);

  Future<int> reserveBalance(int amount);
}

class UserDetailsRepository extends ContentRepository<UserDetailsModel> {
  final UserDetailsSource _source;
  final _logger = DefaultLogger("UserDetailsRepo");

  UserDetailsRepository(this._source);

  @override
  Future<UserDetailsModel> loadData() {
    return _source.getUserDetails();
  }

  Future<bool> increaseBalance(int amount) {
    updateLocalData((user) => user.copyWithBalance(user.balance + amount));
    return _source.increaseBalance(amount);
  }

  Future<bool> reserveBalance(int amount) async {
    print("reserveBalance");
    if ((await data.first).balance > amount) {
      print("reserveBalance updateUI");
      updateLocalData((user) => user.copyWithBalance(user.balance - amount));
    }

    final result = await _source.reserveBalance(amount);
    if (result > 0) {
      updateLocalData((user) => user.copyWithBalance(result));
      return true;
    } else {
      return false;
    }
  }

  void notifyBetMade(BetLiteModel model) {
    _logger.log("notify bet made $model");
    updateLocalData((user) {
      _logger.log("update local data notifier $user");
      return user.addBet(model);
    });
  }

  Stream<List<BetLiteModel>> getUserBetsStream() {
    _logger.log("getUserBetsStream");
    return data.stream.map((data) {
      _logger.log("map called $data");
      return data.betHistory;
    });
  }
}

class UserDetailsBloc extends ContentBloc<UserDetailsEvent, UserDetailsModel> {
  final UserDetailsRepository repository;

  UserDetailsBloc(this.repository) : super(repository);

  @override
  Stream<ContentState<UserDetailsModel>> mapCustomEventToState(
      UserDetailsEvent event) async* {
    if (event is IncreaseBalanceClicked) {
      repository.increaseBalance(100);
    }
  }
}

class UserDetailsEvent extends BaseContentEvents {
  UserDetailsEvent._(String analyticTag) : super(analyticTag);

  factory UserDetailsEvent.increaseBalance() => IncreaseBalanceClicked();
}

class IncreaseBalanceClicked extends UserDetailsEvent {
  IncreaseBalanceClicked() : super._("increase_balance_clicked");
}
