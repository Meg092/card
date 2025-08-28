import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_production/main.dart';
import 'package:styled_widget/styled_widget.dart';

import 'id_card_coping_logic.dart';

class IdCardCopingPage extends GetView<IdCardCopingLogic> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Copy of ID card'),
        backgroundColor: Colors.white,
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: SafeArea(
            child: GetBuilder<IdCardCopingLogic>(builder: (_) {
              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: <Widget>[
                  const Text(
                    'The front side of the ID card',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      width: 228,
                      height: 139,
                      child: controller.frontImage == null
                          ? <Widget>[
                        Image.asset(
                          'assets/icon10.png',
                          fit: BoxFit.cover,
                        )
                      ].toColumn(mainAxisAlignment: MainAxisAlignment.center)
                          : Image.memory(
                        controller.frontImage!,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    )
                        .decorated(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xffeaeaea)))
                        .gestures(onTap: () {
                      controller.imageSelected();
                    }),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  const Text(
                    'The back side of the ID card',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      width: 228,
                      height: 139,
                      child: controller.backImage == null
                          ? <Widget>[
                        Image.asset(
                          'assets/icon10.png',
                          fit: BoxFit.cover,
                        )
                      ].toColumn(mainAxisAlignment: MainAxisAlignment.center)
                          : Image.memory(
                        controller.backImage!,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    )
                        .decorated(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xffeaeaea)))
                        .gestures(onTap: () {
                      controller.imageSelected(isFront: false);
                    }),
                  ),
                  const SizedBox(
                    height: 208,
                  ),
                  Container(
                    width: double.infinity,
                    height: 50,
                    alignment: Alignment.center,
                    child: const Text(
                      'Start making',
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
                    controller.next();
                  })
                ].toColumn(crossAxisAlignment: CrossAxisAlignment.start),
              );
            })).marginAll(15),
      ),
    );
  }
}
