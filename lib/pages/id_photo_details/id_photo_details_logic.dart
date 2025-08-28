import 'dart:typed_data';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:photo_production/db_photo/db_photo.dart';
import 'package:photo_production/db_photo/photo_entity.dart';

class IdPhotoDetailsLogic extends GetxController {

  DBPhoto dbPhoto = Get.find();

  Uint8List image = Get.arguments;

  void save() async {
    await dbPhoto.insertPhoto(PhotoEntity(id: 0, createdTime: DateTime.now(), image: image));
    Fluttertoast.showToast(msg: 'Save success');
    Get.back();
  }

}
