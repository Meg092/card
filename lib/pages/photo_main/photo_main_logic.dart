import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

class PhotoMainLogic extends GetxController {

  var appVersion = '1.0.0'.obs;

  @override
  void onInit() async {
    // TODO: implement onInit
    var info = await PackageInfo.fromPlatform();
    appVersion.value = info.version;
    super.onInit();
  }

}
