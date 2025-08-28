import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_production/main.dart';
import 'package:styled_widget/styled_widget.dart';

import 'id_card_coping_details_logic.dart';

class IdCardCopingDetailsPage extends GetView<IdCardCopingDetailsLogic> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff8e8e8e),
      appBar: AppBar(
        title: const Text('Copy of ID card'),
        backgroundColor: Colors.white,
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: <Widget>[
          Expanded(
              child: <Widget>[
            Image.memory(
              controller.entity.frontImage,
              width: 304,
              height: 170,
              fit: BoxFit.cover,
            ),
            const SizedBox(
              height: 10,
            ),
            Image.memory(
              controller.entity.backImage,
              width: 304,
              height: 170,
              fit: BoxFit.cover,
            )
          ].toColumn(mainAxisAlignment: MainAxisAlignment.center)),
          Container(
            width: double.infinity,
            height: 135,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: <Widget>[
              Container(
                width: double.infinity,
                height: 50,
                alignment: Alignment.center,
                child: const Text(
                  'Save',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              )
                  .decorated(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(25))
                  .gestures(onTap: () {
                controller.save();
              })
            ].toColumn(mainAxisAlignment: MainAxisAlignment.center),
          ).decorated(color: Colors.white)
        ].toColumn(),
      ),
    );
  }
}
