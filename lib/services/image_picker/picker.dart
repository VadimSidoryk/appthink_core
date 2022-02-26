import 'dart:async';

abstract class ImagePickerService {
  final double maxWidth;

  Stream<String?> get onPickImage;

  ImagePickerService(this.maxWidth);

  void pickImageFromGallery();

  void pickImageFromCamera();

  void dispose();
}
