import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kids_care_demo/app/routes/app_pages.dart';
import 'package:kids_care_demo/core/logger_mixin.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return  GetMaterialApp(
       title: "KidsCareResizer",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      theme: ThemeData(primaryColor: Colors.purple),
      debugShowCheckedModeBanner: false,
      logWriterCallback: Logger.write,
    );
  }
}
