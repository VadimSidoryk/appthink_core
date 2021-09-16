import 'package:applithium_core/domain/listing/model.dart';
import 'package:applithium_core/unions/union_3.dart';

import '../base_bloc.dart';

abstract class BaseListEvents extends WidgetEvents with Union3<DisplayData, ScrolledToEnd, ReloadList> {
  BaseListEvents(String name) : super(name);
}

class DisplayData<T extends WithList> extends BaseListEvents {
  final T data;
  final isEndReached;

  DisplayData(this.data, this.isEndReached) : super("data_updated");
}

class ScrolledToEnd extends BaseListEvents {
  ScrolledToEnd._() : super("scrolled_to_end");
}

class ReloadList extends BaseListEvents {
   ReloadList._(): super("reload_list");
}