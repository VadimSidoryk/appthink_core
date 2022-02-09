import 'package:async/async.dart';
import 'package:flutter/material.dart';

import 'models/auth_option.dart';
import 'sources/auth_model.dart';

abstract class Auth<C, M> {
  static createMock<C, M>(M model) => _MockedAuth(model);

  Stream<M?> get userObs;

  @protected
  final AuthModelSource<C, M> modelSource;

  Auth({required this.modelSource});

  Future<Result<void>> signIn(AuthMethod creds);

  Future<Result<void>> signUp(
      {required String email, required String password, M? initialData});

  Future<Result<void>> signOut();

  Future<Result<void>> editUser(Future<M> Function(M) data);

  Future<Result<void>> deleteUser();
}

class _MockedAuth<C, M> extends Auth<C, M> {
  final M model;

  _MockedAuth(this.model)
      : super(modelSource: AuthModelSource.createMock(Result.value(model)));

  @override
  Future<Result<void>> signIn(AuthMethod creds) async {
    return Result.value(null);
  }

  @override
  Future<Result<void>> signOut() async {
    return Result.value(null);
  }

  @override
  Future<Result<void>> signUp(
      {required String email, required String password, M? initialData}) async {
    return Result.value(null);
  }

  @override
  Stream<M?> get userObs => Stream.value(model);

  @override
  Future<Result<void>> editUser(Future<M> Function(M) updater) async {
    return Result.value(null);
  }

  @override
  Future<Result<void>> deleteUser() async {
    return Result.value(null);
  }
}
