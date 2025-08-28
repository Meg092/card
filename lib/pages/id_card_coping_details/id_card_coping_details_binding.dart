import 'package:get/get.dart';

import 'id_card_coping_details_logic.dart';

class IdCardCopingDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => IdCardCopingDetailsLogic());
  }
}
