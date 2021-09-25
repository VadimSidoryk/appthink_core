import 'package:applithium_core/domain/form/model.dart';

import '../states.dart';

const STATE_FORM_INITIAL = "form_initial";
const STATE_FORM_LOADING = "form_loading";
const STATE_FORM_LOADED = "form_loaded";
const STATE_FORM_LOADING_ERROR = "form_loading_error";
const STATE_FORM_DISPLAYING = "form_displaying";
const STATE_FORM_UPDATING = "form_updating";
const STATE_FORM_POSTING = "form_posting";
const STATE_FORM_POSTED = "form_posted";
const STATE_FORM_POSTING_ERROR = "form_posting_error";

class FormScreenState<M extends BaseFormModel> extends BaseState<M> {
  FormScreenState._(String tag) : super(tag);

  factory FormScreenState.initial() => FormLoadingState._();

  @override
  FormScreenState<M> withError(error) {
    return FormLoadingFailedState._(error);
  }

  @override
  FormScreenState<M> withData(M data) {
    return FormDisplayingState._(data);
  }
}

class FormLoadingState<M extends BaseFormModel> extends FormScreenState<M> {
  FormLoadingState._() : super._(STATE_FORM_LOADING);
}

class FormLoadingFailedState<M extends BaseFormModel>
    extends FormScreenState<M> {
  final dynamic error;

  FormLoadingFailedState._(this.error) : super._(STATE_FORM_LOADING_ERROR);

  FormScreenState<M> reload() => FormLoadingState._();
}

abstract class HasForm<M extends BaseFormModel> extends FormScreenState<M> {
  final M form;
  final bool isUpdating;
  final bool isPosting;

  HasForm._(tag,
      {required this.form, required this.isUpdating, required this.isPosting})
      : super._(tag);

  FormScreenState<M> reload() => FormLoadingState._();
}

class FormDisplayingState<M extends BaseFormModel> extends HasForm<M> {
  FormDisplayingState._(M form)
      : super._(STATE_FORM_DISPLAYING,
            form: form, isUpdating: false, isPosting: false);

  HasForm<M> update() => FormUpdatingState._(form);

  FormPostingState<M> post() => FormPostingState._(form);
}

class FormUpdatingState<M extends BaseFormModel> extends HasForm<M> {
  FormUpdatingState._(M form)
      : super._(STATE_FORM_UPDATING,
            isPosting: false, isUpdating: true, form: form);
}

class FormPostingState<M extends BaseFormModel> extends HasForm<M> {
  FormPostingState._(M form)
      : super._(STATE_FORM_POSTING,
            isUpdating: false, isPosting: true, form: form);

  HasForm<M> posted() => FormPostedState._(form);

  HasForm<M> failed(dynamic error) => FormPostingFailedState._(error, form);
}

class FormPostedState<M extends BaseFormModel> extends HasForm<M> {
  FormPostedState._(M form)
      : super._(STATE_FORM_POSTED,
            isUpdating: false, isPosting: false, form: form);

  HasForm<M> update() => FormUpdatingState._(form);
}

class FormPostingFailedState<M extends BaseFormModel> extends HasForm<M> {
  final dynamic error;

  FormPostingFailedState._(this.error, M form)
      : super._(STATE_FORM_POSTING_ERROR,
            isUpdating: false, isPosting: false, form: form);

  HasForm<M> update() => FormUpdatingState._(form);
}
