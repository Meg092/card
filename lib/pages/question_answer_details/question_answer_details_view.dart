import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_production/main.dart';
import 'package:styled_widget/styled_widget.dart';

import 'question_answer_details_logic.dart';

class QuestionAnswerDetailsPage extends GetView<QuestionAnswerDetailsLogic> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
        backgroundColor: Colors.white,
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: SafeArea(
            child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: <Widget>[
            Text(
              qaTitles[controller.type],
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 10,),
            Text(
              qaAnswers[controller.type],
            ),
          ].toColumn(crossAxisAlignment: CrossAxisAlignment.start),
        ).marginAll(15)),
      ),
    );
  }
}
