import 'package:applithium_core_example/profile/domain.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:uuid/uuid.dart';

class FirebaseUserSource extends UserDetailsSource {
  final String id;
  int _balance;

  FirebaseUserSource(this.id);

  DatabaseReference get _userRecord =>
      FirebaseDatabase.instance.reference().child("users").child(id);

  @override
  Future<UserDetailsModel> getUserDetails() {
    return _userRecord.once().then((data) {
      _balance = data.value["balance"];

      return UserDetailsModel(
          id,
          data.value["displayName"],
          data.value["thumbnail"],
          data.value["battleParticipant"],
          _balance,
          data.value["background"], []);
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
        Uuid().v4(),
        "Maksim Kaz",
        "https://yt3.ggpht.com/ytc/AAUvwnhj7hF3uTbk1UIOENKZ3P5XSh_gILMNaOznAbeU6w=s68-c-k-c0x00ffffff-no-rj",
        false,
        balance,
        "https://uaay.org/wp-content/uploads/2019/12/profile-background.png",
        []);
  }

  @override
  Future<int> reserveBalance(int amount) {
    balance -= amount;
    return Future.delayed(Duration(milliseconds: 1000), () => balance);
  }
}
