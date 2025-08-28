import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_production/main.dart';
import 'package:styled_widget/styled_widget.dart';

import 'question_answer_logic.dart';

class QuestionAnswerPage extends GetView<QuestionAnswerLogic> {
  Widget _item(int index) {
    return Container(
      height: 40,
      color: Colors.transparent,
      child: <Widget>[
        Expanded(
            child: Text(
          qaTitles[index],
          overflow: TextOverflow.ellipsis,
        )),
        const Icon(
          Icons.keyboard_arrow_right,
          size: 25,
          color: Colors.grey,
        )
      ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween),
    ).gestures(onTap: () {
      Get.toNamed('/question_answer_details', arguments: index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Q&A'),
        backgroundColor: Colors.white,
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: SafeArea(
            child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: <Widget>[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              child: <Widget>[_item(0), _item(1), _item(2), _item(3)].toColumn(
                  separator: Divider(
                height: 15,
                color: Colors.grey[300],
              )),
            ).decorated(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            )
          ].toColumn(),
        ).marginAll(15)),
      ),
    );
  }
}
