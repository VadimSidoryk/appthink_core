import 'package:applithium_core/events/event.dart';
import 'package:applithium_core/logs/extension.dart';
import 'package:applithium_core/presentation/base_bloc.dart';
import 'package:applithium_core/presentation/content/bloc.dart';
import 'package:applithium_core/presentation/form/repository.dart';
import 'package:applithium_core/usecases/base.dart';

const STATE_FORM_PRESET_LOADING_TAG = "preset_loading";
const STATE_FORM_PRESET_LOADED_TAG = "preset_loading";
const STATE_FORM_SENDING_FORM_TAG = "sending_form";

class FormState<T> extends BaseState<T> {
  final bool isPresetLoading;
  final bool sendingForm;

  FormState(
      String tag, T? value, this.isPresetLoading, this.sendingForm, error)
      : super(tag: tag, error: error, value: value);

  factory FormState.initial() =>
      FormState(STATE_BASE_INITIAL_TAG, null, true, false, null);

  FormState withPresetData(T value) {
    return FormState(STATE_FORM_PRESET_LOADED_TAG, value, false, false, null);
  }

  FormState withPresetLoading() {
    return FormState(
        STATE_FORM_PRESET_LOADING_TAG, value, true, false, null);
  }

  FormState withSendingForm(bool isFormSending) {
    return FormState(
        STATE_FORM_SENDING_FORM_TAG, value, false, isFormSending, null);
  }

  @override
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
      case EVENT_CREATED_NAME:
        yield currentState.withPresetLoading();
        repository.loadData(isForced: true);
        break;
      case EVENT_SCREEN_OPENED_NAME:
        repository.loadData(isForced: false);
        break;
      case EVENT_UPDATE_REQUESTED_NAME:
        yield currentState.withPresetLoading();
        final isUpdated = await repository.loadData(isForced: true);
        log("isUpdated: $isUpdated");
        break;
      case EVENT_DATA_UPDATED_NAME:
        yield currentState.withPresetData(event.params[EVENT_DATA_UPDATED_ARG_DATA]);
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
