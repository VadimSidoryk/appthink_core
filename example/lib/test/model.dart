import 'package:flutter/foundation.dart';

@immutable
class TestViewModel {
  final String title;
  final String description;
  final int likes;

  TestViewModel(this.title, this.description, this.likes);

  TestViewModel copyWith({String? title, String? description, int? likes}) {
    return TestViewModel(
      title != null ? title : this.title,
      description != null ? description : this.description,
      likes != null ? likes : this.likes
    );
  }
}
