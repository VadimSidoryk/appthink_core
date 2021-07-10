import 'package:applithium_core/blocs/types.dart';
import 'package:applithium_core/events/action.dart';
import 'package:applithium_core/events/event.dart';
import 'package:applithium_core/services/resources/model.dart';

class PresentationConfig {
  final BlocTypes type;
  final String ui;
  final ResourceConfig resources;
  final Map<AplEvent, AplAction> domain;

  PresentationConfig(this.type, this.ui, this.resources, this.domain);
}
