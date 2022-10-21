import 'dart:async';

import 'package:image_picker/image_picker.dart';

import 'picker.dart';

class V1ResourcePickerImpl extends ResourcePicker {
  final _picker = ImagePicker();

  V1ResourcePickerImpl(double maxWidth): super(maxWidth);

  final StreamController<String?> _onPickImageController = StreamController
      .broadcast();

  final StreamController<String?> _onPickVideoController = StreamController
      .broadcast();

  @override
  Stream<String?> get imageStream => _onPickImageController.stream;

  @override
  Stream<String?> get videoStream => _onPickVideoController.stream;

  @override
  void pickImageFromGallery() {
    _pickImage(ImageSource.gallery);
  }

  @override
  void pickImageFromCamera() {
    _pickImage(ImageSource.camera);
  }

  @override
  void pickVideoFromCamera() {
    _pickVideo(ImageSource.camera);
  }

  @override
  void pickVideoFromGallery() {
    _pickVideo(ImageSource.gallery);
  }

  void _pickImage(ImageSource source) async {
    final pickedImageFile = await _picker.pickImage(source: source, maxWidth: maxWidth);
    _onPickImageController.add(pickedImageFile?.path);
  }

  void _pickVideo(ImageSource source) async {
    final pickedVideoFile = await _picker.pickVideo(source: source);
    _onPickVideoController.add(pickedVideoFile?.path);
  }

  @override
  void dispose() {
    _onPickImageController.close();
    _onPickVideoController.close();
  }




}