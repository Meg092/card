import 'dart:typed_data';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';


class IdCardCopingLogic extends GetxController {
  Uint8List? frontImage;
  Uint8List? backImage;

  void imageSelected({bool isFront = true}) async {
    final picker = ImagePicker();
    try {
      final pickedFile = await picker.pickImage(
          imageQuality: 90, maxWidth: 1024, source: ImageSource.gallery);
      if (pickedFile != null) {
        final imageBytes = await pickedFile.readAsBytes();
        if (isFront) {
          frontImage = imageBytes;
        } else {
          backImage = imageBytes;
        }
        update();
      }
    } catch (e) {
      Fluttertoast.showToast(
          msg: 'Please check album permissions or select a new image');
      return;
    }
  }

  void next() {
    if (frontImage == null) {
      Fluttertoast.showToast(msg: 'Please  select front image');
      return;
    }
    if (backImage == null) {
      Fluttertoast.showToast(msg: 'Please  select back image');
      return;
    }
    Get.toNamed('/id_card_coping_details',
        arguments:
            IdCardEntity(frontImage: frontImage!, backImage: backImage!));
  }
}

class IdCardEntity {
  final Uint8List frontImage;
  final Uint8List backImage;

  IdCardEntity({required this.frontImage, required this.backImage});
}
