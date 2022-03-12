import 'dart:io';

import 'package:async/async.dart';

abstract class OnboardingController {
  void markAsShown();
  Future<Result<void>> onNameEntered(String? name);
  Future<Result<void>> onPhotoSelected(File file);
}
