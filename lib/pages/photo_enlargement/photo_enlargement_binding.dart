import 'package:get/get.dart';

import 'photo_enlargement_logic.dart';

class PhotoEnlargementBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PhotoEnlargementLogic());
  }
}
