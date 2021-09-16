import 'package:flutter/foundation.dart';

@immutable
class ContentScreenModel {
  final String title;
  final String description;
  final int likes;

  ContentScreenModel(this.title, this.description, this.likes);

  ContentScreenModel copyWith({String? title, String? description, int? likes}) {
    return ContentScreenModel(
      title != null ? title : this.title,
      description != null ? description : this.description,
      likes != null ? likes : this.likes
    );
  }
}
