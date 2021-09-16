import 'package:applithium_core/unions/union_3.dart';
import '../base_bloc.dart';

abstract class BaseContentEvents extends WidgetEvents
    with Union3<ReloadRequested, UpdateRequested, DisplayData> {
  BaseContentEvents._(String name) : super(name);
}

class ReloadRequested extends BaseContentEvents {
  ReloadRequested() : super._("reload_requested");
}

class UpdateRequested extends BaseContentEvents {
  UpdateRequested() : super._("screen_update");
}

class DisplayData<M> extends BaseContentEvents {
  final M data;

  DisplayData(this.data) : super._("data_updated");
}

