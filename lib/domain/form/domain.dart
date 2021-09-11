import 'package:applithium_core/logs/extension.dart';
import 'package:applithium_core/usecases/base.dart';

import '../base_bloc.dart';
import '../repository.dart';

const STATE_FORM_INITIAL = "form_initial";
const STATE_FORM_LOADING = "form_loading";
const STATE_FORM_LOADED = "form_loaded";
const STATE_FORM_LOADING_ERROR = "form_loading_error";
const STATE_FORM_CHANGED = "form_changed";
const STATE_FORM_SENDING = "form_sending";
const STATE_FORM_SENT = "form_sent";
const STATE_FORM_SENDING_ERROR = "form_sending_error";

abstract class FormEvents extends WidgetEvents {
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

class FormState<M> extends BaseState<M> {
  final bool isFormSending;

  FormState._(
      {required String tag,
      this.isFormSending = false})
      : super(tag);

  factory FormState.initial() => FormState._(tag: "initial");

  @override
  BaseState withError(error) {
    return FormLoadingFailed(error);
  }
}

class FormLoading<M> extends FormState<M> {
  FormLoading() : super._(tag: STATE_FORM_LOADING);
}

class FormLoadingFailed<M> extends FormState<M> {
  final dynamic error;

  FormLoadingFailed(this.error) : super._(tag: STATE_FORM_LOADING_ERROR);
}

class FormChanged<M> extends FormState<M> {
  final M form;

  FormChanged(this.form) : super._(tag: STATE_FORM_CHANGED);
}

class FormSending<M> extends FormState<M> {
  FormSending() : super._(tag: STATE_FORM_SENDING, isFormSending: true);

  @override
  BaseState withError(error) {
    return FormSendingFailed(error);
  }
}

class FormSent<M> extends FormState<M> {
  FormSent() : super._(tag: STATE_FORM_SENT);

  @override
  BaseState withError(error) {
    return FormSendingFailed(error);
  }
}

class FormSendingFailed<M> extends FormState<M> {
  final dynamic error;

  FormSendingFailed(this.error) : super._(tag: STATE_FORM_SENDING_ERROR);

  @override
  BaseState withError(error) {
    return FormSendingFailed(error);
  }
}

class FormBloc<M> extends AplBloc<M, FormState<M>> {
  final UseCase<void, M> load;
  final UseCase<M?, M> post;

  FormBloc(
      {required AplRepository<M> repository,
      required this.load,
      required this.post,
      DomainGraph<M, FormState<M>>? customGraph})
      : super(
            initialState: FormState.initial(),
            repository: repository,
            customGraph: customGraph);

  @override
  Stream<FormState<M>> mapEventToStateImpl(WidgetEvents event) async* {
    yield* super.mapEventToStateImpl(event);

    if (event is WidgetCreated) {
      yield FormLoading();
      repository.applyInitial(load);
    } else if (event is WidgetShown) {
      repository.apply(load);
    } else if (event is _PresetUpdateRequested) {
      yield FormLoading();
      final isUpdated =
          await repository.apply(load, resetOperationsStack: true);
      log("isUpdated: $isUpdated");
    } else if (event is ModelUpdated<M>) {
      yield FormChanged(event.data);
    } else if (event is _SendForm) {
      yield FormSending();
      repository.apply(post);
      yield FormSent();
    }
  }
}
