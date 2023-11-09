import 'dart:async';
import 'dart:io';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:file_picker/file_picker.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:kids_care_demo/core/colored_print.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class HomeController extends GetxController {
  bool isUploading = false;
  List<int> items = [];

  int selectedValue = 50;
  Directory? appDocDir;
  FilePickerResult? result;
  List<File> images = [];

 
  @override
  Future<void> onInit() async {
    super.onInit();
    appDocDir = await getApplicationDocumentsDirectory();
    _initResolution();
  }

  void dropImage(int index) {
    images.removeAt(index);
    update(["images"]);
  }

  Future<void> pickImages() async {
    result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      withData: true,
      type: FileType.custom,
      allowedExtensions: ['png', 'jpg', 'jpeg'],
    );
    if (result != null) {
      images.addAll(result!.paths.map((path) => File(path ?? "")).toList());
      update(["images"]);
    }
  }

  Future<void> resizeImages() async {
    if (isUploading) return;
    isUploading = true;

    update(["loading"]);

    if (images.isNotEmpty) {
      await _resizeImages().then((value) {
        images.clear();
        update(["images"]);

        Get.snackbar(
          "Alert",
          "Images have been resized!\nPlease take a moment to check the 'KidsCareResizer' folder",
          snackPosition: SnackPosition.BOTTOM,
        );
        isUploading = false;
        update(["loading"]);
      });
    } else {
      isUploading = false;
      update(["loading"]);
      Get.snackbar(
        "Alert",
        "Choose images firstly",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> _resizeImages() async {
    for (int i = 0; i < images.length; i++) {
      String outPutLocation =
          "${appDocDir?.path}/${DateTime.now().millisecondsSinceEpoch}_${basename(images.elementAt(i).path)}";
      await FFmpegKit.execute(
              '-i ${images.elementAt(i).path} -vf "scale=iw*0.$selectedValue:ih*0.$selectedValue" $outPutLocation')
          .then((session) async {
        if (ReturnCode.isSuccess(await session.getReturnCode())) {
          // coloredPrint('Image processing completed successfully');
          await GallerySaver.saveImage(outPutLocation,
              albumName: "KidsCareResizer");
        } else {
          coloredPrint(
              'Image processing failed. Error: ${await session.getReturnCode()}');
        }
      });
    }
  }

  void onDropdownChanged(int? value) {
    selectedValue = value ?? 20;
    update(["resize"]);
  }

  void _initResolution() {
    for (int i = 10; i < 100; i += 10) {
      items.add(i);
      coloredPrint("I= $i");
    }
    update(["resize"]);
  }
}
