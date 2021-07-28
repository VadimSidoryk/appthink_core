import 'package:applithium_core/json/mappable.dart';
import 'package:applithium_core/logs/extension.dart';
import 'package:applithium_core/presentation/base_bloc.dart';
import 'package:applithium_core/usecases/base.dart';

import '../repository.dart';

const STATE_FORM_PRESET_INITIAL_TAG = "form_initial";
const STATE_FORM_PRESET_LOADING_TAG = "preset_loading";
const STATE_FORM_PRESET_LOADED_TAG = "preset_loaded";
const STATE_FORM_SENDING_FORM_TAG = "sending_form";
const STATE_FORM_SENT_FORM_TAG = "form_sent";
const STATE_FORM_ERROR = "form_error";

abstract class FormEvents extends BaseEvents {
  FormEvents(String name) : super(name);

  factory FormEvents.presetRequestUpdate() => _PresetUpdateRequested._();

  factory FormEvents.sendForm() => _SendForm._();
}

class _PresetUpdateRequested extends FormEvents {
  _PresetUpdateRequested._() : super("preset_update_requested");
}

class _SendForm extends FormEvents {
  _SendForm._() : super("send_form");
}

class FormState<M extends Mappable> extends BaseState<M> {
  final bool isPresetLoading;
  final bool sendingForm;

  FormState(String tag, M? value, this.isPresetLoading, this.sendingForm, error)
      : super(tag: tag, error: error, value: value);

  factory FormState.initial() =>
      FormState(STATE_FORM_PRESET_INITIAL_TAG, null, true, false, null);

  FormState<M> withPresetData(M value) {
    return FormState(STATE_FORM_PRESET_LOADED_TAG, value, false, false, null);
  }

  FormState<M> withPresetLoading() {
    return FormState(STATE_FORM_PRESET_LOADING_TAG, value, true, false, null);
  }

  FormState<M> withSendingForm(bool isFormSending) {
    return FormState(
        STATE_FORM_SENDING_FORM_TAG, value, false, isFormSending, null);
  }

  @override
  FormState<M> withError(dynamic error) {
    return FormState(STATE_FORM_ERROR, value, false, false, error);
  }
}

class FormBloc<M extends Mappable> extends BaseBloc<M, FormState<M>> {
  final UseCase<void, M> load;
  final UseCase<M?, M> post;

  FormBloc(
      {required AplRepository<M> repository,
      required Presenters presenters,
      required this.load,
      required this.post,
      DomainGraph<M, FormState<M>>? customGraph})
      : super(
            initialState: FormState.initial(),
            repository: repository,
            presenters: presenters,
            customGraph: customGraph);

  @override
  Stream<FormState<M>> mapEventToStateImpl(BaseEvents event) async* {
    yield* super.mapEventToStateImpl(event);

    if (event is ScreenCreated) {
      yield currentState.withPresetLoading();
      repository.apply(load, resetOperationsStack: true);
    } else if (event is ScreenOpened) {
      repository.apply(load);
    } else if (event is _PresetUpdateRequested) {
      yield currentState.withPresetLoading();
      final isUpdated =
          await repository.apply(load, resetOperationsStack: true);
      log("isUpdated: $isUpdated");
    } else if (event is ModelUpdated<M>) {
      yield currentState.withPresetData(event.data);
    } else if (event is _SendForm) {
      yield currentState.withSendingForm(true);
      final result = repository.apply(post);
      yield currentState.withSendingForm(false);
    }
  }
}
