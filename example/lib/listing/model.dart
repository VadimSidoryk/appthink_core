import 'package:flutter/foundation.dart';

@immutable
class ListItemModel {
  final int id;
  final String title;
  final String subtitle;

  ListItemModel(this.id, this.title, this.subtitle);
}