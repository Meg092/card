import 'package:get/get.dart';

import 'question_answer_details_logic.dart';

class QuestionAnswerDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => QuestionAnswerDetailsLogic());
  }
}
