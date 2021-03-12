import 'package:applithium_core_example/profile/domain.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class FirebaseUserSource extends UserDetailsSource {
  int _balance;

  DatabaseReference get _userRecord => FirebaseDatabase.instance
      .reference()
      .child("users")
      .child("052d28f9-658b-4c6e-bab3-788cd42279be");

  @override
  Future<UserDetailsModel> getUserDetails() {
    return _userRecord.once().then((data) {
      _balance = data.value["balance"];

      return UserDetailsModel(data.value["displayName"], _balance,
          data.value["thumbnail"], data.value["background"], []);
    });
  }

  @override
  Future<bool> increaseBalance(int amount) async {
    return _userRecord.child("balance").set(_balance + amount).then((ignored) {
      _balance += amount;
      return true;
    }, onError: () => false);
  }

  @override
  Future<int> reserveBalance(int amount) {
    return _userRecord.child("balance").once().then((balance) {
      _balance = balance.value;
      if (_balance < amount) {
        return -1;
      } else {
        return _userRecord.child("balance").set(_balance - amount).then(
            (ignored) {
          _balance -= amount;
          return _balance;
        }, onError: () => -1);
      }
    });
  }
}

class MockedUserSource extends UserDetailsSource {
  int balance = 10000;

  @override
  Future<UserDetailsModel> getUserDetails() {
    return Future.delayed(
        Duration(milliseconds: 1500), () => mockUserDetails());
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
        []);
  }

  @override
  Future<int> reserveBalance(int amount) {
    balance -= amount;
    return Future.delayed(Duration(milliseconds: 1000), () => balance);
  }
}
