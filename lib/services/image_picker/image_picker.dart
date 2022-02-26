import 'dart:async';

import 'package:image_picker/image_picker.dart';

import 'picker.dart';

class ImagePickerImpl extends ImagePickerService {
  final _picker = ImagePicker();

  ImagePickerImpl(double maxWidth): super(maxWidth);

  final StreamController<String?> _onPickImageController = StreamController
      .broadcast();

  @override
  Stream<String?> get onPickImage => _onPickImageController.stream;

  @override
  void pickImageFromGallery() {
    _pickImage(ImageSource.gallery);
  }

  @override
  void pickImageFromCamera() {
    _pickImage(ImageSource.camera);
  }

  void _pickImage(ImageSource source) async {
    final pickedImageFile = await _picker.pickImage(source: source, maxWidth: maxWidth);
    _onPickImageController.add(pickedImageFile?.path);
  }

  @override
  void dispose() {
    _onPickImageController.close();
  }

}