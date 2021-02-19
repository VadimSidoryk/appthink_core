import 'package:applithium_core_example/profile/domain.dart';

class MockedUserSource extends UserDetailsSource {

  int balance = 500;

  @override
  Future<UserDetailsModel> getUserDetails() {
    return Future.delayed(Duration(milliseconds: 1500), () => mockUserDetails());
  }

  @override
  Future<bool> increaseBalance(int amount) {
    amount += 100;
    return Future.delayed(Duration(milliseconds: 1000), () => true);
  }

  UserDetailsModel mockUserDetails() {
    return UserDetailsModel(
      "Maksim Kaz",
      balance,
      "https://yt3.ggpht.com/ytc/AAUvwnhj7hF3uTbk1UIOENKZ3P5XSh_gILMNaOznAbeU6w=s68-c-k-c0x00ffffff-no-rj",
      "https://uaay.org/wp-content/uploads/2019/12/profile-background.png",
      []
    );
  }

  @override
  Future<int> reserveBalance(int amount) {
    balance -= amount;
    return Future.delayed(Duration(milliseconds: 1000), () => balance);
  }
}