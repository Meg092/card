import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:photo_production/db_photo/db_photo.dart';
import 'package:photo_production/pages/documents/documents_binding.dart';
import 'package:photo_production/pages/documents/documents_view.dart';
import 'package:photo_production/pages/id_card_coping/id_card_coping_binding.dart';
import 'package:photo_production/pages/id_card_coping/id_card_coping_view.dart';
import 'package:photo_production/pages/id_card_coping_details/id_card_coping_details_binding.dart';
import 'package:photo_production/pages/id_card_coping_details/id_card_coping_details_view.dart';
import 'package:photo_production/pages/id_photo_create/id_photo_create_binding.dart';
import 'package:photo_production/pages/id_photo_create/id_photo_create_view.dart';
import 'package:photo_production/pages/id_photo_details/id_photo_details_binding.dart';
import 'package:photo_production/pages/id_photo_details/id_photo_details_view.dart';
import 'package:photo_production/pages/photo_cropping/photo_cropping_binding.dart';
import 'package:photo_production/pages/photo_cropping/photo_cropping_view.dart';
import 'package:photo_production/pages/photo_enlargement/photo_enlargement_binding.dart';
import 'package:photo_production/pages/photo_enlargement/photo_enlargement_view.dart';
import 'package:photo_production/pages/photo_main/photo_main_binding.dart';
import 'package:photo_production/pages/photo_main/photo_main_view.dart';
import 'package:photo_production/pages/question_answer/question_answer_binding.dart';
import 'package:photo_production/pages/question_answer/question_answer_view.dart';
import 'package:photo_production/pages/question_answer_details/question_answer_details_binding.dart';
import 'package:photo_production/pages/question_answer_details/question_answer_details_view.dart';

Color primaryColor = const Color(0xff3964e8);
Color bgColor = const Color(0xfff7f7f7);

List<String> qaTitles = ['Why is the ID photo not clear?', 'How to upload it to the computer end?', 'How to take a good ID photo?', 'How to beautify ID photos?'];
List<String> qaAnswers = [
  'The clarity of a photo is related to its pixels. The larger the pixels, the clearer it is; the smaller the pixels, the blurrier it is. For standard documents, it is recommended to look for smaller sizes. The screen of a mobile phone is larger, and when viewed on a mobile phone, it is an enlarged photo, so it is rather blurry. It is suggested to view it on a computer using the original aspect ratio. All the certificates made by this software are in line with the printing size of ID photos. Please use it with confidence. If you need a large-sized and clear ID photo, you can use a custom size when making it. Manually input the width and height of the ID photo (in pixels). When manually inputting, you can use the pixel value of the preset ID photo size that is proportionally enlarged by the same multiple of width and height.',
  '''Please save the photos to your phone's album. The phone will then upload the photos from the album to the computer.''',
  'It is recommended to use an ID photo-making software. When making ID photos with the software, do not take pictures with your mobile phone. Do not use the mobile phone flash when taking pictures with your mobile phone. Do not use the mobile phone filter when taking pictures with your mobile phone. Do not use the mobile phone beauty function when taking pictures with your mobile phone. Do not use the mobile phone zoom function when taking pictures with your mobile phone.',
  '''You can edit photos in your phone's album and modify them to the effect you want.'''
];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await Get.putAsync(() => DBPhoto().init());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      getPages: Cards,
      initialRoute: '/photo_main',
      theme: ThemeData(
          useMaterial3: true,
          primaryColor: primaryColor,
          scaffoldBackgroundColor: bgColor,
          colorScheme: ColorScheme.light(
            primary: primaryColor,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent,
            elevation: 0,
            scrolledUnderElevation: 0,
            centerTitle: true,
            titleTextStyle: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 20,
            ),
          ),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            selectedItemColor: primaryColor,
            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
            backgroundColor: Colors.white,
          ),
          inputDecorationTheme: const InputDecorationTheme(
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          )),
    );
  }
}
List<GetPage<dynamic>> Cards = [
  GetPage(name: '/photo_main', page: () => PhotoMainWidget(), binding: PhotoMainBinding()),
  GetPage(name: '/id_photo_create', page: () => const IdPhotoCreatePage(), binding: IdPhotoCreateBinding()),
  GetPage(name: '/id_photo_details', page: () => IdPhotoDetailsPage(), binding: IdPhotoDetailsBinding()),
  GetPage(name: '/photo_cropping', page: () => PhotoCroppingPage(), binding: PhotoCroppingBinding()),
  GetPage(name: '/documents', page: () => DocumentsPage(), binding: DocumentsBinding()),
  GetPage(name: '/question_answer', page: () => QuestionAnswerPage(), binding: QuestionAnswerBinding()),
  GetPage(name: '/question_answer_details', page: () => QuestionAnswerDetailsPage(), binding: QuestionAnswerDetailsBinding()),
  GetPage(name: '/id_card_coping', page: () => IdCardCopingPage(), binding: IdCardCopingBinding()),
  GetPage(name: '/id_card_coping_details', page: () => IdCardCopingDetailsPage(), binding: IdCardCopingDetailsBinding()),
  GetPage(name: '/photo_enlargement', page: () => PhotoEnlargementPage(), binding: PhotoEnlargementBinding())
];