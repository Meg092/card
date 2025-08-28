import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../main.dart';
import 'photo_enlargement_logic.dart';

class PhotoEnlargementPage extends GetView<PhotoEnlargementLogic> {
  final ImagePicker _picker = ImagePicker();

  final double _cropWidth = 304;
  final double _cropHeight = 414;

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
          imageQuality: 90, maxWidth: 1024, source: ImageSource.gallery);
      if (image != null) {
        final imageFile = File(image.path);
        controller.image = imageFile;
        controller.update();
      }
    } catch (e) {
      Fluttertoast.showToast(
          msg: 'Please check album permissions or select a new image');
      return;
    }
  }

  Future<void> _cropImage(File imageFile) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      aspectRatio: CropAspectRatio(
        ratioX: _cropWidth,
        ratioY: _cropHeight,
      ),
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Cut to size',
          toolbarColor: Colors.blue,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: true,
        ),
        IOSUiSettings(
          title: 'Cut to size',
          aspectRatioLockEnabled: true,
        ),
      ],
    );

    if (croppedFile != null) {
      controller.imageBytes = await croppedFile.readAsBytes();
      controller.update();
    }
  }

  Widget _buildTransparentOverlay() {
    return IgnorePointer(
      child: Stack(
        children: [
          Positioned.fill(
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.6), BlendMode.srcOut),
              child: Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      backgroundBlendMode: BlendMode.dstOut,
                    ),
                  ),
                  Center(
                    child: Container(
                      width: _cropWidth,
                      height: _cropHeight,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Center(
            child: Container(
              width: _cropWidth,
              height: _cropHeight,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                color: Colors.transparent,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomItem(int index) {
    final titles = ['x2', 'x3', 'x4'];
    return Expanded(
        child: Container(
      height: 53,
      alignment: Alignment.center,
      child: Text(
        titles[index],
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    )
            .decorated(
                color: controller.index == index
                    ? const Color(0xffdde5ff)
                    : Colors.white,
                border: Border.all(
                    color: controller.index == index
                        ? primaryColor
                        : const Color(0xffdddddd)),
                borderRadius: BorderRadius.circular(4))
            .gestures(onTap: () {
      if (index != controller.index) {
        controller.index = index;
        controller.scale = index + 2;
      } else {
        controller.index = -1;
        controller.scale = 1;
      }
      controller.update();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PhotoEnlargementLogic>(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Enlarge the photo'),
          backgroundColor: Colors.white,
          actions: [
            Visibility(
                visible: controller.image != null,
                child: const Text(
                  'Clean',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.red),
                ).marginOnly(right: 20).gestures(onTap: () {
                  controller.image = null;
                  controller.imageBytes = null;
                  controller.scale = 1;
                  controller.index = -1;
                  controller.update();
                })),
            Visibility(
                visible: controller.imageBytes != null,
                child: const Text(
                  'Save',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ).marginOnly(right: 20).gestures(onTap: () {
                  controller.save();
                }))
          ],
        ),
        body: SafeArea(
            child: <Widget>[
          Container(
            width: double.infinity,
            height: double.infinity,
            child: controller.imageBytes == null
                ? controller.image == null
                    ? <Widget>[
                        Container(
                          width: 120,
                          height: 120,
                          child: <Widget>[
                            Icon(
                              Icons.add,
                              size: 40,
                              color: primaryColor,
                            )
                          ].toColumn(
                              mainAxisAlignment: MainAxisAlignment.center),
                        )
                            .decorated(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.grey[100]!))
                            .gestures(onTap: () {
                          _pickImage();
                        }),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text('Add photo')
                      ].toColumn(mainAxisAlignment: MainAxisAlignment.center)
                    : IgnorePointer(
                        child: PhotoView(
                          imageProvider: FileImage(controller.image!),
                          initialScale: controller.scale *
                              PhotoViewComputedScale.contained.multiplier,
                          minScale: PhotoViewComputedScale.contained * 0.8,
                          maxScale: PhotoViewComputedScale.covered * 4,
                          backgroundDecoration: const BoxDecoration(
                            color: Colors.transparent,
                          )
                        ),
                      )
                : <Widget>[
                    Image.memory(
                      controller.imageBytes!,
                      fit: BoxFit.cover,
                    )
                  ].toColumn(mainAxisAlignment: MainAxisAlignment.center),
          ),
          Visibility(
              visible:
                  controller.image != null && controller.imageBytes == null,
              child: _buildTransparentOverlay())
        ].toStack()),
        bottomNavigationBar:
            controller.image != null && controller.imageBytes == null
                ? Container(
                    width: double.infinity,
                    height: 200,
                    padding: const EdgeInsets.all(15),
                    color: const Color(0xfff7f7f7),
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: <Widget>[
                        const Text(
                          'Select the magnification',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        <Widget>[
                          _bottomItem(0),
                          const SizedBox(
                            width: 10,
                          ),
                          _bottomItem(1),
                          const SizedBox(
                            width: 10,
                          ),
                          _bottomItem(2),
                        ].toRow(),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: double.infinity,
                          height: 44,
                          alignment: Alignment.center,
                          child: const Text(
                            'Confirm',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          ),
                        )
                            .decorated(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(6))
                            .gestures(onTap: () {
                          _cropImage(controller.image!);
                        })
                      ].toColumn(crossAxisAlignment: CrossAxisAlignment.start),
                    ),
                  )
                : null,
      );
    });
  }
}
