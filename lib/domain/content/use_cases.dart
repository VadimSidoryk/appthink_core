import '../use_case.dart';

class ContentUseCases<M> {
  final UseCase<void, M> load;
  final UseCase<M, M> update;

  ContentUseCases({required this.load, required this.update});
}