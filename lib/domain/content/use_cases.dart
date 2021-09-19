import 'package:applithium_core/usecases/base.dart';

class ContentUseCases<M> {
  final UseCase<void, M> load;
  final UseCase<M, M> update;

  ContentUseCases({required this.load, required this.update});
}