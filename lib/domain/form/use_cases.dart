import 'package:applithium_core/domain/content/use_cases.dart';
import 'package:applithium_core/usecases/base.dart';

class FormUseCases<M> extends ContentUseCases<M> {

  final UseCase<M, bool> post;

  FormUseCases({required this.post, required UseCase<void, M> load, required UseCase<M, M> update}) : super(load: load, update: update);

}