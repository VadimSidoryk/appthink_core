import '../../presentation/base_bloc.dart';


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