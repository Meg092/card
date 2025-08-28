import 'package:get/get.dart';

import 'question_answer_logic.dart';

class QuestionAnswerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => QuestionAnswerLogic());
  }
}
