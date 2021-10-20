import 'package:applithium_core/presentation/content/bloc.dart';
import 'package:applithium_core/presentation/content/states.dart';
import 'package:applithium_core_example/content/domain/model.dart';
import 'package:applithium_core_example/content/domain/use_cases.dart';
import 'package:applithium_core_example/content/presentation/events.dart';

class ExampleContentBloc extends ContentBloc<ExampleContentModel> {
  final ExampleContentUseCases useCases;
  ExampleContentBloc(this.useCases) : super(useCases) {
    changeOn<AddLike, HasContent<ExampleContentModel>>(
        changingUCProvider: (event) => useCases.addLike
    );
    changeOn<RemoveLike, HasContent<ExampleContentModel>>(
        changingUCProvider: (event) => useCases.removeLike
    );
  }

}