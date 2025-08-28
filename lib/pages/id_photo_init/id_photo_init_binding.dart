import 'package:get/get.dart';

import 'id_photo_init_logic.dart';

class IdPhotoInitBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(
      IdPhotoInitLogic(),
      permanent: true,
    );
  }
}
