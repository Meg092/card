import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import 'dart:io';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_production/main.dart';
import 'package:photo_view/photo_view.dart';
import 'package:styled_widget/styled_widget.dart';

import 'photo_cropping_logic.dart';

class PhotoCroppingPage extends GetView<PhotoCroppingLogic> {
  @override
  Widget build(BuildContext context) {
    return PhotoCropScreen();
  }
}

enum SizeOption {
  oneInch(295, 413, "One inch 295x413 (Px)"),
  smallOneInch(260, 378, "Small one inch 260x378 (Px)"),
  largeOneInch(390, 567, "Large one inch 390x567 (Px)");

  final double width;
  final double height;
  final String label;

  const SizeOption(this.width, this.height, this.label);
}

class PhotoCropScreen extends StatefulWidget {
  @override
  _PhotoCropScreenState createState() => _PhotoCropScreenState();
}

class _PhotoCropScreenState extends State<PhotoCropScreen> {
  PhotoCroppingLogic controller = Get.find();

  double _cropWidth = SizeOption.oneInch.width/2;
  double _cropHeight = SizeOption.oneInch.height/2;

  final ImagePicker _picker = ImagePicker();

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
        ratioX: controller.selectedSize.width.toDouble(),
        ratioY: controller.selectedSize.height.toDouble(),
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
      controller.croppedImage = await croppedFile.readAsBytes();
      controller.update();
    }
  }

  Widget croppingWidget(SizeOption index) {
    final titles = ['One inch', 'Small one inch', 'Large one inch'];
    final sizeTitles = ['295x413(Px)', '260x378(Px)', '390x567(Px)'];
    return Expanded(
        child: Container(
      height: 114,
      child: <Widget>[
        Image.asset(
          'assets/icon9.png',
          fit: BoxFit.cover,
        ),
        Text(
          titles[index.index],
        ),
        Text(sizeTitles[index.index]),
      ].toColumn(mainAxisAlignment: MainAxisAlignment.center),
    )
            .decorated(
      color: controller.selectedSize == index
          ? const Color(0xffdde5ff)
          : Colors.white,
      borderRadius: BorderRadius.circular(4),
      border: Border.all(
          color: controller.selectedSize == index
              ? primaryColor
              : const Color(0xffdddddd)),
    )
            .gestures(onTap: () {
      controller.selectedSize = index;
      _cropWidth = controller.selectedSize.width/2;
      _cropHeight = controller.selectedSize.height/2;
      controller.update();
    }));
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

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PhotoCroppingLogic>(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Cut to size'),
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
                  controller.croppedImage = null;
                  controller.update();
                })),
            Visibility(
                visible: controller.croppedImage != null,
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
            child: controller.croppedImage == null
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
                    : PhotoView(
                        imageProvider: FileImage(controller.image!),
                        backgroundDecoration: const BoxDecoration(
                          color: Colors.transparent,
                        ))
                : <Widget>[
                    Image.memory(
                      controller.croppedImage!,
                      fit: BoxFit.cover,
                    )
                  ].toColumn(mainAxisAlignment: MainAxisAlignment.center),
          ),
          Visibility(
              visible:
                  controller.image != null && controller.croppedImage == null,
              child: _buildTransparentOverlay())
        ].toStack()),
        bottomNavigationBar: controller.image != null &&
                controller.croppedImage == null
            ? Container(
                width: double.infinity,
                height: 260,
                padding: const EdgeInsets.all(12),
                child: <Widget>[
                  <Widget>[
                    const Text('Select size'),
                    Text(
                      controller.selectedSize.label,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: primaryColor),
                    )
                  ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween),
                  const SizedBox(
                    height: 10,
                  ),
                  <Widget>[
                    croppingWidget(SizeOption.oneInch),
                    const SizedBox(width: 10),
                    croppingWidget(SizeOption.smallOneInch),
                    const SizedBox(width: 10),
                    croppingWidget(SizeOption.largeOneInch),
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
              ).decorated(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)))
            : null,
      );
    });
  }
}
