import 'package:get/get.dart';

import 'photo_cropping_logic.dart';

class PhotoCroppingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PhotoCroppingLogic());
  }
}
