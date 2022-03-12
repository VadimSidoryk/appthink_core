import 'dart:io';

import 'package:applithium_core/utils/extension.dart';
import 'package:applithium_core_onboarding/widgets/action_button/widget.dart';
import 'package:applithium_core_onboarding/widgets/action_sheet/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'resources.dart';

class UserPhotoPage extends StatelessWidget {
  final Stream<String?> userPhotoPath;
  final Stream<bool> isLoading;
  final Function()? onSkip;
  final Function()? onGallery;
  final Function()? onCamera;
  final Function()? onContinue;
  final Function()? onBack;

  UserPhotoPage({
    Key? key,
    required this.userPhotoPath,
    required this.isLoading,
    this.onSkip,
    this.onGallery,
    this.onCamera,
    this.onContinue,
    this.onBack,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Scaffold(
        backgroundColor: bgColor,
        appBar: CouplesKit.appBar(
          leading: GestureDetector(
              child: SvgPicture.asset(icBarBack), onTap: onBack),
        ),
        body: _buildContent(context),
      ),
      isLoading.view((isLoading) {
        return isLoading ? CouplesKit.loadingIndicator() : Container();
      }),
    ]);
  }

  Widget _buildContent(BuildContext context) {
    return Container(
      width: double.infinity,
      child: SafeArea(
        child: Column(
          children: [
            Spacer(flex: 1),
            Text(title, style: textTitle),
            SizedBox(height: distanceTitleAvatar),
            userPhotoPath.view(_userPhotoContainer, loadingBuilder: (context) {
              return _userPhotoContainer(null);
            }),
            Spacer(flex: 1),
            userPhotoPath.view((path) => _buildButtonsBlock(context, path),
                loadingBuilder: (context) {
              return _buildButtonsBlock(context, null);
            }),
          ],
        ),
      ),
    );
  }

  Widget _userPhotoContainer(String? path) {
    if (path == null || path.isEmpty) {
      return Container(
          width: avatarDiameter,
          height: avatarDiameter,
          decoration: avatarDecoration,
          clipBehavior: Clip.hardEdge,
          child: SvgPicture.asset(
            icAddPhoto,
            height: avatarIconHeight,
            fit: BoxFit.scaleDown,
          ));
    } else {
      return CircleAvatar(
          radius: avatarDiameter / 2,
          foregroundImage: Image.file(File(path)).image);
    }
  }

  Widget _buildButtonsBlock(BuildContext context, String? path) {
    return Column(
      children: [
        Visibility(
          visible: path == null || path.isEmpty,
          child: SizedBox(
              width: skipButtonSize.width,
              height: skipButtonSize.height,
              child: TextButton(
                  onPressed: onSkip, child: Text(skipButton, style: textSkip))),
        ),
        ActionButton(
            title: path == null ? addPhotoButton : continueButton,
            onClick: () {
              if (path == null) {
                _showActionSheet(context);
              } else {
                onContinue?.call();
              }
            }),
      ],
    );
  }

  void _showActionSheet(BuildContext context) async {
    final actionSheetKit = ActionSheetKit();
    actionSheetKit.showPictureActionSheet(context,
        isDeleteAvailable: false, onGallery: onGallery, onCamera: onCamera);
  }
}
