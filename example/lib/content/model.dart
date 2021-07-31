import 'package:flutter/foundation.dart';

@immutable
class ContentViewModel {
  final String title;
  final String description;
  final int likes;

  ContentViewModel(this.title, this.description, this.likes);

  ContentViewModel copyWith({String? title, String? description, int? likes}) {
    return ContentViewModel(
      title != null ? title : this.title,
      description != null ? description : this.description,
      likes != null ? likes : this.likes
    );
  }
}
