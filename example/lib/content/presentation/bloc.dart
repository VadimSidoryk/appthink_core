import 'package:applithium_core/presentation/content/bloc.dart';
import 'package:applithium_core/presentation/content/states.dart';
import 'package:applithium_core_example/content/domain/model.dart';
import 'package:applithium_core_example/content/domain/use_cases.dart';
import 'package:applithium_core_example/content/presentation/events.dart';

class ExampleContentBloc extends ContentBloc<ExampleContentModel> {
  final ExampleContentUseCases useCases;
  ExampleContentBloc(this.useCases) : super(useCases) {
    updateOn<AddLike, HasContent<ExampleContentModel>>(
       updaterProvider: (event) => useCases.addLike
    );
    updateOn<RemoveLike, HasContent<ExampleContentModel>>(
        updaterProvider: (event) => useCases.removeLike
    );
  }

}