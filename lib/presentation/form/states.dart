import '../states.dart';

const STATE_FORM_INITIAL = "form_initial";
const STATE_FORM_LOADING = "form_loading";
const STATE_FORM_LOADED = "form_loaded";
const STATE_FORM_LOADING_ERROR = "form_loading_error";
const STATE_FORM_CHANGED = "form_changed";
const STATE_FORM_SENDING = "form_sending";
const STATE_FORM_SENT = "form_sent";
const STATE_FORM_SENDING_ERROR = "form_sending_error";

class FormState<M> extends BaseState<M> {
  final bool isFormSending;

  FormState._({required String tag, this.isFormSending = false}) : super(tag);

  factory FormState.initial() => FormState._(tag: "initial");

  @override
  FormState<M> withError(error) {
    return FormLoadingFailedState(error);
  }

  @override
  FormState<M> withData(M data) {
    return FormDisplayingState(data);
  }
}

class FormLoadingState<M> extends FormState<M> {
  FormLoadingState() : super._(tag: STATE_FORM_LOADING);
}

class FormLoadingFailedState<M> extends FormState<M> {
  final dynamic error;

  FormLoadingFailedState(this.error) : super._(tag: STATE_FORM_LOADING_ERROR);
}

class FormDisplayingState<M> extends FormState<M> {
  final M form;

  FormDisplayingState(this.form) : super._(tag: STATE_FORM_CHANGED);
}

class FormSendingState<M> extends FormState<M> {
  FormSendingState() : super._(tag: STATE_FORM_SENDING, isFormSending: true);
}

class FormSentState<M> extends FormState<M> {
  FormSentState() : super._(tag: STATE_FORM_SENT);
}

class FormSendingFailedState<M> extends FormState<M> {
  final dynamic error;

  FormSendingFailedState(this.error) : super._(tag: STATE_FORM_SENDING_ERROR);
}
