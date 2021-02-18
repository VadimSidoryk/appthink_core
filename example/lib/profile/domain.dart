import 'package:applithium_core/blocs/content_bloc.dart';
import 'package:applithium_core/repositories/content_repository.dart';

class UserDetailsModel {
  final String displayName;
  final int balance;
  final String thumbnailUrl;
  final String backgroundUrl;

  UserDetailsModel(
      this.displayName, this.balance, this.thumbnailUrl, this.backgroundUrl);

  UserDetailsModel copyWithBalance(int balance) {
    return UserDetailsModel(
        this.displayName, balance, this.thumbnailUrl, this.backgroundUrl);
  }
}

abstract class UserDetailsSource {
  Future<UserDetailsModel> getUserDetails();

  Future<bool> increaseBalance(int amount);
}

class UserDetailsRepository extends ContentRepository<UserDetailsModel> {
  final UserDetailsSource _source;

  UserDetailsRepository(this._source);

  @override
  Future<UserDetailsModel> loadData() {
    return _source.getUserDetails();
  }

  Future<bool> increaseBalance(int amount) {
    updateLocalData((user) => user.copyWithBalance(user.balance + amount));
    return _source.increaseBalance(amount);
  }
}

class UserDetailsBloc extends ContentBloc<UserDetailsModel, UserDetailsEvent> {

  final UserDetailsRepository _repository;

  UserDetailsBloc(this._repository) : super(_repository);

  @override
  Stream<ContentState<UserDetailsModel>> mapCustomEventToState(
      UserDetailsEvent event) {
    if(event is IncreaseBalanceClicked) {
      _repository.increaseBalance(100);
    }
  }
}

class UserDetailsEvent extends BaseContentEvent {
  UserDetailsEvent._(String analyticTag) : super(analyticTag);

  factory UserDetailsEvent.increaseBalance() => IncreaseBalanceClicked();
}

class IncreaseBalanceClicked extends UserDetailsEvent {
  IncreaseBalanceClicked() : super._("increase_balance_clicked");

}
