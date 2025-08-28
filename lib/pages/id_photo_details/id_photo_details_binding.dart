import 'package:get/get.dart';

import 'id_photo_details_logic.dart';

class IdPhotoDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => IdPhotoDetailsLogic());
  }
}
