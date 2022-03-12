import 'dart:io';

import 'package:applithium_core/presentation/bloc.dart';
import 'package:applithium_core/services/image_picker/picker.dart';
import 'package:applithium_core_onboarding/controller.dart';
import 'package:async/async.dart';

import 'events.dart';
import 'state.dart';

class UserPhotoPageBloc extends AplBloc<UserPhotoPageState> {
  final ImagePickerService _pickerManager;

  UserPhotoPageBloc(OnboardingController controller, this._pickerManager,
      {Function()? onBack, Function()? onSkip, Function()? onContinue})
      : super(UserPhotoPageState()) {
    bind(_pickerManager.onPickImage, (state, String? picturePath) {
      return state.copyWith(photoPath: picturePath ?? "");
    });

    doOn<SkipClicked>((event, emit) {
      onSkip?.call();
    });

    doOn<ContinueClicked>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      final result = await _updatePictureIfNeeded(controller);
      if (result.isError) {
        emit(state.copyWith(error: result.asError, isLoading: false));
      } else {
        emit(state.copyWith(isLoading: false));
        onContinue?.call();
      }
    });

    doOn<GalleryClicked>((event, emit) {
      _pickerManager.pickImageFromGallery();
    });

    doOn<CameraClicked>((event, emit) {
      _pickerManager.pickImageFromCamera();
    });

    doOn<BackClicked>((event, emit) {
      onBack?.call();
    });
  }

  Future<Result<void>> _updatePictureIfNeeded(OnboardingController controller) {
    final newPath = state.photoPath;
    if (newPath == null) {
      return Future.value(Result.value(null));
    }
    final file = File(newPath);
    return controller.onPhotoSelected(file);
  }
}
