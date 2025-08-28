import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';

import 'id_photo_details_logic.dart';

class IdPhotoDetailsPage extends GetView<IdPhotoDetailsLogic> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: null,
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        actions: [
          const Text(
            'Save',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ).marginOnly(right: 20).gestures(onTap: () {
            controller.save();
          })
        ],
      ),
      body: Center(
        child: Image.memory(
          controller.image,
          width: Get.width,
          height: Get.height,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
