import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart' show ImageGallerySaver;
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_production/db_photo/db_photo.dart';
import 'package:photo_production/db_photo/photo_entity.dart';

class DocumentsLogic extends GetxController {

  DBPhoto dbPhoto = Get.find();

  var list = <PhotoEntity>[].obs;

  void getData() async {
    list.value = await dbPhoto.getPhotoAllData();
  }

  cleanPhotoData() async {
    Get.dialog(AlertDialog(
      title: const Text('Warm reminder'),
      content: const Text('Do you want to clean all records?'),
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
          },
          child: const Text('Cancel',style: TextStyle(color: Colors.black),),
        ),
        TextButton(
          onPressed: () async {
            await dbPhoto.cleanPhotoData();
            getData();
            Get.back();
          },
          child: const Text(
            'OK',
            style: TextStyle(color: Colors.red),
          ),
        ),
      ],
    ));
  }

  void saveImage(Uint8List image) async {
    final status = await Permission.storage.request();
    if (status.isGranted) {
      final result = await ImageGallerySaver.saveImage(image);
      if (result['isSuccess']) {
        Fluttertoast.showToast(msg: 'Save success');
      } else {
        Fluttertoast.showToast(msg: 'Save failed');
      }
    } else {
      _showPermissionDialog();
    }
  }

  void _showPermissionDialog() {
    showDialog(
      context: Get.context!,
      builder: (ctx) => AlertDialog(
        title: const Text('Storage permissions required'),
        content: const Text(
            'Please grant storage permission to get distance'),
        actions: [
          TextButton(
            onPressed: () => openAppSettings(),
            child: const Text('Setting'),
          ),
        ],
      ),
    );
  }

  @override
  void onInit() {
    // TODO: implement onInit
    getData();
    super.onInit();
  }

}
