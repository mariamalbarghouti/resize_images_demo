import 'dart:async';
import 'dart:io';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:kids_care_demo/core/colored_print.dart';
import 'package:multi_image_picker_view/multi_image_picker_view.dart';
import 'package:path_provider/path_provider.dart';

class HomeController extends GetxController {
  // List<ImageFile> _outPutUrl = [];
  bool isUploading = false;
  List<int> items = [];

  // String logoPath = "";
  int selectedValue = 20;
  Directory? appDocDir;
  // int timeStamp = 0;
  MultiImagePickerController controller = MultiImagePickerController(
    maxImages: 100,
    allowedImageTypes: ['png', 'jpg', 'jpeg'],
    withData: true,
    withReadStream: true,
    // images: <ImageFile>[]
  );
  @override
  Future<void> onInit() async {
    super.onInit();
    appDocDir = await getApplicationDocumentsDirectory();
    _initResolution();
  }

  @override
  void onClose() {
    super.onClose();
    controller.dispose();
  }

  Future<void> resizeImages() async {
    for (int i = 0; i < controller.images.length; i++) {
      coloredPrint("Size: ${controller.images.elementAt(i).size}");
      String outPutLocation =
          "${appDocDir?.path}/${DateTime.now().millisecondsSinceEpoch}_${controller.images.elementAt(i).name}";

      await FFmpegKit.execute(
              '-i ${controller.images.elementAt(i).path} -vf "scale=iw*0.$selectedValue:ih*0.$selectedValue" $outPutLocation')
          .then((session) async {
        if (ReturnCode.isSuccess(await session.getReturnCode())) {
          // coloredPrint('Image processing completed successfully');
          await GallerySaver.saveImage(outPutLocation,albumName: "KidsCare resize");
       
        } else {
          coloredPrint(
              'Image processing failed. Error: ${await session.getReturnCode()}');
        }
      });
    }
  }
  // Future<void> saveImageToGalleryWithFolder(String imagePath) async {
  //   if (Platform.isAndroid) {
  //     final directory = appDocDir?.path;
  //     final albumDirectory = Directory('$directory/');

  //     if (!(await albumDirectory.exists())) {
  //       albumDirectory.create();
  //     }

  //     final result =
  //         await ImageGallerySaver.saveFile('$albumDirectory/$imagePath');
  //     if (result != null) {
  //       coloredPrint('Image saved to gallery: $result');
  //     } else {
  //       coloredPrint('Failed to save the image to the gallery.');
  //     }
  //   } else if (Platform.isIOS) {
  //     // On iOS, you can't create subdirectories in the gallery, so just save the image.
  //     final result = await ImageGallerySaver.saveFile(imagePath);
  //     if (result != null) {
  //       coloredPrint('Image saved to gallery: $result');
  //     } else {
  //       coloredPrint('Failed to save the image to the gallery.');
  //     }
  //   }
  // }

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
