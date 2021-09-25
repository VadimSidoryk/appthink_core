import '../events.dart';


abstract class FormEvents extends WidgetEvents {
  FormEvents(String name) : super(name);

  factory FormEvents.requestReload() => FormReloadRequested._();

  factory FormEvents.requestUpdate() => FormReloadRequested._();

  factory FormEvents.postForm() => PostForm._();

  factory FormEvents.formChanged() => FormChanged._();
}

class FormReloadRequested extends FormEvents {
  FormReloadRequested._() : super("form_reload_requested");
}

class FormUpdateRequested extends FormEvents {
  FormUpdateRequested._() : super("form_update_requested");
}

class FormChanged extends FormEvents {
  FormChanged._(): super("form_changed");
}

class PostForm extends FormEvents {
  PostForm._() : super("post_form");
}