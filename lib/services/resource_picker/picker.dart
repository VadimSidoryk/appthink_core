import 'dart:async';

abstract class ResourcePicker {
  final double maxWidth;

  Stream<String?> get imageStream;

  Stream<String?> get videoStream;

  ResourcePicker(this.maxWidth);

  void pickImageFromGallery();

  void pickVideoFromGallery();

  void pickImageFromCamera();

  void pickVideoFromCamera();

  void dispose();
}
