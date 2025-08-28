import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';

import 'photo_main_logic.dart';

class PhotoMainWidget extends GetView<PhotoMainLogic> {
  Widget _item(int index) {
    final titles = [
      'ID photo production',
      'ID photo cropping',
      'Photo enlargement',
      'ID card photocopying',
      'Frequently Asked Questions'
    ];
    return Container(
      width: double.infinity,
      height: 83,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: <Widget>[
        Image.asset(
          'assets/icon${index + 1}.png',
          fit: BoxFit.cover,
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
            child: Text(
          titles[index],
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        )),
        const SizedBox(
          width: 10,
        ),
        Image.asset(
          'assets/icon8.png',
          fit: BoxFit.cover,
        ),
      ].toRow(),
    )
        .decorated(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 6,
                  spreadRadius: 1,
                  offset: const Offset(0, 3))
            ])
        .marginOnly(bottom: 10)
        .gestures(onTap: () {
          switch (index) {
            case 0:
              Get.toNamed('/id_photo_create');
              break;
            case 1:
              Get.toNamed('/photo_cropping');
              break;
            case 2:
              Get.toNamed('/photo_enlargement');
              break;
            case 3:
              Get.toNamed('/id_card_coping');
              break;
            case 4:
              Get.toNamed('/question_answer');
              break;
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: SafeArea(
            child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: <Widget>[
            <Widget>[
              const Text(
                'Circle\ncalculation\nformula',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              Image.asset(
                'assets/icon0.png',
                fit: BoxFit.cover,
              )
            ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween),
            const SizedBox(
              height: 20,
            ),
            _item(0),
            _item(1),
            _item(2),
            _item(3),
            _item(4),
            const SizedBox(
              height: 20,
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              child: <Widget>[
                Container(
                  height: 40,
                  color: Colors.transparent,
                  child: <Widget>[
                    const Text('Document'),
                    const Icon(
                      Icons.keyboard_arrow_right,
                      size: 25,
                      color: Colors.grey,
                    )
                  ].toRow(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  ),
                ).gestures(onTap: () {
                  Get.toNamed('/documents');
                }),
                SizedBox(
                  height: 40,
                  child: <Widget>[
                    const Text('AppVersion'),
                    Obx(() {
                      return Text(
                        'v${controller.appVersion.value}',
                        style: const TextStyle(color: Colors.grey),
                      );
                    })
                  ].toRow(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  ),
                )
              ].toColumn(
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
