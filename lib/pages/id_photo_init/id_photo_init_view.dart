import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'id_photo_init_logic.dart';

class IdPhotoInitView extends GetView<IdPhotoInitLogic> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Obx(
          () => controller.jerde.value
              ? const CircularProgressIndicator(color: Colors.blue)
              : buildError(),
        ),
      ),
    );
  }

  Widget buildError() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () {
              controller.debyphn();
            },
            icon: const Icon(
              Icons.restart_alt,
              size: 50,
            ),
          ),
        ],
      ),
    );
  }
}
