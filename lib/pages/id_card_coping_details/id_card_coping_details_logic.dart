import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:photo_production/db_photo/db_photo.dart';
import 'dart:ui' as ui;
import 'package:photo_production/pages/id_card_coping/id_card_coping_logic.dart';

import '../../db_photo/photo_entity.dart';

class IdCardCopingDetailsLogic extends GetxController {
  DBPhoto dbPhoto = Get.find();

  IdCardEntity entity = Get.arguments;


  Future<Uint8List> mergeTwoIDPhotosVertically(
      Uint8List topImageBytes,
      Uint8List bottomImageBytes, {
        Color backgroundColor = Colors.white,
      }) async {
    const double containerWidth = 304;
    const double containerHeight = 170;

    const double totalHeight = containerHeight * 2+10;
    const double totalWidth = containerWidth;

    final ui.Image topImage = await _decodeImage(topImageBytes);
    final ui.Image bottomImage = await _decodeImage(bottomImageBytes);

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(
      recorder,
      Rect.fromPoints(
        const Offset(0, 0),
        Offset(totalWidth, totalHeight),
      ),
    );

    canvas.drawColor(backgroundColor, BlendMode.srcOver);

    _drawImageStretched(
      canvas: canvas,
      image: topImage,
      containerWidth: containerWidth,
      containerHeight: containerHeight,
      offsetY: 0,
    );

    _drawImageStretched(
      canvas: canvas,
      image: bottomImage,
      containerWidth: containerWidth,
      containerHeight: containerHeight,
      offsetY: containerHeight+10,
    );

    final picture = recorder.endRecording();
    final mergedImage = await picture.toImage(
        totalWidth.toInt(),
        totalHeight.toInt()
    );

    final byteData = await mergedImage.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  void _drawImageStretched({
    required Canvas canvas,
    required ui.Image image,
    required double containerWidth,
    required double containerHeight,
    required double offsetY,
  }) {
    final destRect = Rect.fromLTWH(0, offsetY, containerWidth, containerHeight);

    final srcRect = Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble());

    canvas.drawImageRect(
        image,
        srcRect,
        destRect,
        Paint()
    );
  }

  Future<ui.Image> _decodeImage(Uint8List bytes) async {
    final codec = await ui.instantiateImageCodec(bytes);
    final frame = await codec.getNextFrame();
    return frame.image;
  }

  void save() async {
    final image = await mergeTwoIDPhotosVertically(entity.frontImage, entity.backImage);
    await dbPhoto.insertPhoto(PhotoEntity(id: 0, createdTime: DateTime.now(), image: image));
    Fluttertoast.showToast(msg: 'Save success');
    Get.back();
  }


}
