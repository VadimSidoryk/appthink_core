import 'package:applithium_core/presentation/bloc.dart';
import 'package:applithium_core/presentation/screen_with_bloc.dart';
import 'package:applithium_core/services/image_picker/picker.dart';
import 'package:applithium_core_onboarding/controller.dart';
import 'package:flutter/cupertino.dart';

import 'bloc.dart';
import 'events.dart';
import 'state.dart';
import 'widget.dart';

class PhotoPageScreen extends StatefulWidget {
  final OnboardingController controller;
  final Function()? onBack;
  final Function()? onContinue;

  PhotoPageScreen(
      {Key? key, required this.controller, this.onBack, this.onContinue})
      : super(key: key);

  @override
  State createState() => _PhotoPageScreenState();
}

class _PhotoPageScreenState extends AplBlocScreenState<PhotoPageScreen,
    UserPhotoPageEvents, UserPhotoPageState> {
  @override
  AplBloc<UserPhotoPageState> createBloc(BuildContext context) {
    return UserPhotoPageBloc(widget.controller, ImagePickerImpl(350),
        onBack: widget.onBack,
        onContinue: widget.onContinue,
        onSkip: widget.onContinue);
  }

  @override
  Widget createWidget(BuildContext context, UserPhotoPageState state) {
    return UserPhotoPage(
      userPhotoPath: stateStream().map((it) => it.photoPath),
      isLoading: stateStream().map((it) => it.isLoading),
      onCamera: send0(UserPhotoPageEvents.cameraClicked),
      onGallery: send0(UserPhotoPageEvents.galleryClicked),
      onContinue: send0(UserPhotoPageEvents.continueClicked),
      onSkip: send0(UserPhotoPageEvents.skipClicked),
      onBack: send0(UserPhotoPageEvents.backClicked),
    );
  }
}
