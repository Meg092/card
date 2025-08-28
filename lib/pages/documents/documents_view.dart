import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_production/main.dart';
import 'package:styled_widget/styled_widget.dart';

import 'documents_logic.dart';

class DocumentsPage extends GetView<DocumentsLogic> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Documents'),
        actions: [
          Text(
            'Clean',
            style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
          ).marginOnly(right: 20).gestures(onTap: () {
            controller.cleanPhotoData();
          })
        ],
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: SafeArea(child: Obx(() {
          return controller.list.isEmpty
              ? const Center(
                  child: Text('No data'),
                )
              : GridView.builder(
                  padding: const EdgeInsets.all(15),
                  itemCount: controller.list.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 164 / 145),
                  itemBuilder: (_, index) {
                    final entity = controller.list[index];
                    return <Widget>[
                      Container(
                        padding: const EdgeInsets.only(
                            top: 15, left: 15, right: 15, bottom: 9),
                        child: <Widget>[
                          Expanded(
                              child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.memory(
                              entity.image,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          )),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            entity.createdTimeString,
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey),
                          )
                        ].toColumn(),
                      ).decorated(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      Positioned(
                          bottom: 5,
                          right: 5,
                          child: Icon(
                            Icons.save,
                            size: 25,
                            color: primaryColor,
                          ).gestures(onTap: () {
                            controller.saveImage(entity.image);
                          }))
                    ].toStack();
                  });
        })),
      ),
    );
  }
}
