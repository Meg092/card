import 'package:get/get.dart';

import 'photo_main_logic.dart';

class PhotoMainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PhotoMainLogic());
  }
}