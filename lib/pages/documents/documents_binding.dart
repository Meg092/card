import 'package:get/get.dart';

import 'documents_logic.dart';

class DocumentsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DocumentsLogic());
  }
}
