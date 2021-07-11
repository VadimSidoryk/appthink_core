import 'package:applithium_core/blocs/base_bloc.dart';
import 'package:applithium_core/events/event.dart';
import 'package:applithium_core/repositories/form_repository.dart';
import 'package:applithium_core/usecases/base.dart';
import 'package:applithium_core/logs/extension.dart';

class FormBloc<T> extends BaseBloc<FormState, FormRepository> {
  FormBloc(
      {required Presenters presenters,
        required FormRepository repository,
        required Map<String, UseCase<T>> domain})
      : super(
      initialState: FormState.initial(),
      presenters: presenters,
      repository: repository,
      domain: domain);

  @override
  Stream<FormState> mapEventToStateImpl(AplEvent event) async* {
    switch (event.name) {
      case EVENT_SHOWN_NAME:
        repository.loadData(false);
        break;
      case EVENT_UPDATE_REQUESTED_NAME:
        yield currentState.withPresetLoading(true);
        final isUpdated = await repository.loadData(true);
        log("isUpdated: $isUpdated");
        yield currentState.withPresetLoading(false);
        break;
      case EVENT_DATA_UPDATED_NAME:
        yield currentState.withDataPreset(
            event.params[EVENT_DATA_UPDATED_ARG_DATA] as Map<String, dynamic>);
        break;
      case EVENT_SEND_FORM_NAME:
        yield currentState.withSendingForm(true);
        final isSent = await repository.sendForm();
        log("isSent : $isSent");
        yield currentState.withSendingForm(false);
        break;
      default:
        yield* super.mapEventToStateImpl(event);
    }
  }
}

class FormState extends BaseState {
  final Map<String, dynamic>? value;
  final bool isPresetLoading;
  final bool sendingForm;

  FormState(this.value, this.isPresetLoading, this.sendingForm, error) : super(error);

  factory FormState.initial() => FormState(null, true, false, null);

  FormState withDataPreset(Map<String, dynamic> value) {
    return FormState(value, false, false, null);
  }

  FormState withPresetLoading(bool isLoading) {
    return FormState(value, isLoading, false, null);
  }

  FormState withSendingForm(bool isFormSending) {
    return FormState(value, false, isFormSending, null);
  }


  FormState withError(dynamic error) {
    return FormState(value, false, false, error);
  }
}