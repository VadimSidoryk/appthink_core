import 'dart:convert';
import 'dart:math' as math;

import 'package:async/async.dart';
import 'package:applithium_core/services/auth/auth.dart';
import 'package:applithium_core/services/auth/models/auth_option.dart';
import 'package:couples/utils/id_generator.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:applithium_core/logs/extension.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

const _KEY_FIREBASE_AUTH_METHOD = "FirebaseAuthMethod";

class FirebaseAuthImpl<M> extends Auth<User, M> {
  final FirebaseAuth _auth;
  final Future<SharedPreferences> preferencesProvider;

  final _userSubj = BehaviorSubject<M?>();

  @override
  Stream<M?> get userObs => _userSubj.distinct();

  FirebaseAuthImpl({FirebaseAuth? auth, required modelSource, required this.preferencesProvider})
      : _auth = auth ?? FirebaseAuth.instance, super(modelSource: modelSource) {
    _removeCachedUser();
    _initFlow();
  }

  void _initFlow() {
    _auth.authStateChanges().asyncMap((it) async {
      if(it == null) {
        return null;
      } else {
        log("userReceived: ${it.email}");
        final getResult  = await modelSource.getUser(it);
        log("getResult = $getResult");
        if(getResult.isValue) {
          return getResult.asValue!.value;
        } else {
          final createResult = await modelSource.createUser(it);
          return createResult.asValue?.value;
        }
      }
    }).listen((it) {
      _userSubj.add(it);
    });
  }

  //TODO: remove this when sign_out flow implemented
  void _removeCachedUser() async {
    final authorized = (await preferencesProvider).containsKey(_KEY_FIREBASE_AUTH_METHOD);
    if(!authorized) {
      await signOut();
    }
  }

  @override
  Future<Result<void>> signIn(AuthMethod option) async {
    final methodName = "signIn";
    logMethod(methodName, params: [option]);
    final preferences = await preferencesProvider;
    try {
      //TODO: remove this when sign_out flow implemented
      await preferences.setString(_KEY_FIREBASE_AUTH_METHOD, option.name);
      await _signInImpl(option);
      return Result.value(null);
    } catch (e, stacktrace) {
      logError(methodName, e, stacktrace);
      //TODO: remove this when sign_out flow implemented
      await preferences.remove(_KEY_FIREBASE_AUTH_METHOD);
      return Result.error(e);
    }
  }

  @override
  Future<Result<void>> signOut() async {
    final methodName = "signOut";
    logMethod(methodName);
    try {
      await FirebaseAuth.instance.signOut();
      (await preferencesProvider).remove(_KEY_FIREBASE_AUTH_METHOD);
      return Result.value(null);
    } catch (e, stacktrace) {
      logError(methodName, e, stacktrace);
      return Result.error(e);
    }
  }

  @override
  Future<Result<void>> signUp(
      {required String email, required String password, M? initialData}) async {
    final methodName = "signUp";
    logMethod(methodName, params: [initialData]);
    try {
      await _signUpImpl(email, password);
      return signIn(AuthMethod.emailAndPassword(email, password));
    } catch (e, stacktrace) {
      logError(methodName, e, stacktrace);
      return Result.error(e);
    }
  }

  @override
  Future<Result<void>> deleteUser() async {
    final methodName = "deleteUser";
    logMethod(methodName);
    try {
      await _auth.currentUser?.delete();
      return Result.value(null);
    } catch(e, stacktrace) {
      return Result.error(e)..logError(methodName, e, stacktrace);
    }
  }

  Future<UserCredential> _signInImpl(AuthMethod creds) async {
    if (creds is Anonymous) {
      return await _auth.signInAnonymously();
    } else if(creds is WithToken) {
      return await _auth.signInWithCustomToken(creds.token);
    } else if (creds is EmailAndPassword) {
      return await _auth.signInWithEmailAndPassword(
          email: creds.email, password: creds.password);
    } else if (creds is WithGoogle) {
      final scopes = ['email','https://www.googleapis.com/auth/userinfo.email','https://www.googleapis.com/auth/contacts.readonly'];
      GoogleSignInAccount? googleUser = await GoogleSignIn(scopes: scopes).signIn();
      GoogleSignInAuthentication? googleAuth = await googleUser!.authentication;
      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
      return await _auth.signInWithCredential(credential);
    } else if (creds is WithApple) {
      final helper = _AppleSignInHelper();
      final credential = await helper.signIn();
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: credential.identityToken,
        rawNonce: helper.rawNonce,
      );
      return _auth.signInWithCredential(oauthCredential);
    } else if (creds is WithFacebook) {
      final result = await FacebookAuth.instance.login();
      if (result.accessToken?.token != null) {
        final fbProvider = FacebookAuthProvider.credential(
            result.accessToken!.token);
        return _auth.signInWithCredential(fbProvider);
      } else {
        return Future.error("Failed to SignIn with Facebook: ${result.message}");
      }
    } else {
      throw "Invalid creds type, $creds";
    }
  }

  Future<UserCredential> _signUpImpl(String email, String password) async {
    return await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
  }

  @override
  Future<Result<void>> editUser(Future<M> Function(M) updater) async {
    final methodName = "editUser";
    try {
      logMethod(methodName, params: [updater]);
      final user = await userObs
          .where((it) => it != null)
          .first;
      final updatedUser = await updater.call(user!);
      await modelSource.updateUser(updatedUser);
      return Result.value(null);
    } catch(e, stacktrace) {
      logError(methodName, e, stacktrace);
      return Result.error(e);
    }
  }
}

class _AppleSignInHelper {
  String? _rawNonce;
  String get rawNonce {
    if (_rawNonce == null) {
      _rawNonce = _generateNonce();
    }
    return _rawNonce!;
  }

  String _generateNonce([int length = 32]) {
    final charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = math.Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String _sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<AuthorizationCredentialAppleID> signIn() async {
    if (await SignInWithApple.isAvailable() == false) {
      return Future.error('Apple signin Is not available');
    }
    final nonce = _sha256ofString(rawNonce);
    // get Apple credential
    return SignInWithApple.getAppleIDCredential(
        scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
        webAuthenticationOptions: WebAuthenticationOptions(clientId: "com.basenji.olo.service", redirectUri: Uri.https("olo-couples.firebaseapp.com", "/__/auth/handler")),
    );
  }
}
