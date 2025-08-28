import 'dart:io';
import 'dart:typed_data';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:photo_production/db_photo/db_photo.dart';

import '../../db_photo/photo_entity.dart';

class PhotoEnlargementLogic extends GetxController {
  DBPhoto dbPhoto = Get.find();
  int index = -1;
  double scale = 1;
  File? image;
  Uint8List? imageBytes;

  void save() async {
    await dbPhoto.insertPhoto(PhotoEntity(id: 0, createdTime: DateTime.now(), image: imageBytes!));
    Fluttertoast.showToast(msg: 'Save success');
    Get.back();
  }
}
