class ExampleContentModel {
  final String title;
  final String description;
  final int likes;

  ExampleContentModel({required this.title, required this.description, required this.likes});

  ExampleContentModel copyWith({String? title, String? description, int? likes}) {
    return ExampleContentModel(
      title: title ?? this.title,
      description: description ?? this.description,
      likes: likes ?? this.likes
    );
  }
}