import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';

import './routes/routes.dart';
import 'global_controller.dart';
import 'themes/apptheme.dart';
import 'utils/consts/app_settings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Get.put(GC(), permanent: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GetMaterialApp(
        title: kTitle,
        theme: currentTheme.value,
        initialBinding: BindingsBuilder(
          () => Get.find<GC>(),
        ),
        initialRoute: Routes.SPLASH,
        getPages: AppPages.routes,
        debugShowCheckedModeBanner: false,
        enableLog: true,
        logWriterCallback: (String t, {bool? isError}) {
          if (isError == true) {
            GC.e(t);
          } else {
            GC.d(t);
          }
        },
      ),
    );
  }
}
