import 'package:applithium_core/presentation/events.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part "events.freezed.dart";

@freezed
class UserPhotoPageEvents extends WidgetEvents with _$UserPhotoPageEvents {
  factory UserPhotoPageEvents.skipClicked() = SkipClicked;
  factory UserPhotoPageEvents.continueClicked() = ContinueClicked;
  factory UserPhotoPageEvents.galleryClicked() = GalleryClicked;
  factory UserPhotoPageEvents.cameraClicked() = CameraClicked;
  factory UserPhotoPageEvents.backClicked() = BackClicked;
}
