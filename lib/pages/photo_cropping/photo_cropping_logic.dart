import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:photo_production/db_photo/db_photo.dart';
import 'package:photo_production/db_photo/photo_entity.dart';
import 'package:photo_production/pages/photo_cropping/photo_cropping_view.dart';

class PhotoCroppingLogic extends GetxController {

  DBPhoto dbPhoto = Get.find();

  File? image;
  Uint8List? croppedImage;

  SizeOption selectedSize = SizeOption.oneInch;

  void save() async {
    await dbPhoto.insertPhoto(PhotoEntity(id: 0, createdTime: DateTime.now(), image: croppedImage!));
    Fluttertoast.showToast(msg: 'Save success');
    Get.back();
  }
}
