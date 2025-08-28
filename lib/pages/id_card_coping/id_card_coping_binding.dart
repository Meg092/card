import 'package:get/get.dart';

import 'id_card_coping_logic.dart';

class IdCardCopingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => IdCardCopingLogic());
  }
}
