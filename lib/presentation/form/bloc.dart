import 'package:applithium_core/presentation/base_bloc.dart';
import 'package:applithium_core/events/event.dart';
import 'package:applithium_core/presentation/form/repository.dart';
import 'package:applithium_core/usecases/base.dart';
import 'package:applithium_core/logs/extension.dart';

const STATE_FORM_PRESET_LOADING_TAG = "preset_loading";
const STATE_FORM_PRESET_LOADED_TAG = "preset_loading";
const STATE_FORM_SENDING_FORM_TAG = "sending_form";

class FormState extends BaseState {
  final Map<String, dynamic>? value;
  final bool isPresetLoading;
  final bool sendingForm;

  FormState(
      String tag, this.value, this.isPresetLoading, this.sendingForm, error)
      : super(tag, error);

  factory FormState.initial() =>
      FormState(STATE_BASE_INITIAL_TAG, null, true, false, null);

  FormState withDataPreset(Map<String, dynamic> value) {
    return FormState(STATE_FORM_PRESET_LOADED_TAG, value, false, false, null);
  }

  FormState withPresetLoading(bool isLoading) {
    return FormState(
        STATE_FORM_PRESET_LOADING_TAG, value, isLoading, false, null);
  }

  FormState withSendingForm(bool isFormSending) {
    return FormState(
        STATE_FORM_SENDING_FORM_TAG, value, false, isFormSending, null);
  }

  FormState withError(dynamic error) {
    return FormState(STATE_BASE_ERROR_TAG, value, false, false, error);
  }
}

class FormBloc<T> extends BaseBloc<FormState, FormRepository> {
  FormBloc(
      {required FormRepository repository,
      required Presenters presenters,
      required Map<String, UseCase<T>> domain})
      : super(
            initialState: FormState.initial(),
            repository: repository,
            presenters: presenters,
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
