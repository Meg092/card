import 'package:get/get.dart';

import 'id_photo_create_logic.dart';

class IdPhotoCreateBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => IdPhotoCreateLogic());
  }
}
