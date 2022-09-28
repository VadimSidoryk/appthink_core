import 'package:async/async.dart';

abstract class AuthModelSource<C, M> {

  Stream<Result<M>> observeUser(C creds);

  Future<Result<bool>> hasUser(C creds);

  Future<Result<void>> updateUser(M user);

  Future<Result<M>> createUser(C creds);

  static createMock<M>(Result<M> result) => _MockedAuthModelSource(result);
}

class _MockedAuthModelSource<C, M> extends AuthModelSource<C, M> {

  final Result<M> result;

  _MockedAuthModelSource(this.result);

  @override
  Future<Result<M>> createUser(C creds) async {
    return result;
  }

  @override
  Future<Result<void>> updateUser(M user) async {
    return Result.value(true);
  }

  @override
  Stream<Result<M>> observeUser(C creds) async* {
    yield result;
  }

  @override
  Future<Result<bool>> hasUser(C creds) async {
    return Result.value(true);
  }
}