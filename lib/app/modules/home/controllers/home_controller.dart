import 'dart:async';
import 'dart:io';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:kids_care_demo/core/colored_print.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class HomeController extends GetxController {
  bool isResizing = false;
  List<int> resolutionsItems = [];
  int selectedValue = 50;
  Directory? _appDocDir;
  bool _isPicking = false;
  FilePickerResult? result;
  List<File> images = [];
  List<File> videos = [];

  @override
  Future<void> onInit() async {
    super.onInit();
    _appDocDir = await getApplicationDocumentsDirectory();
    _initResolution();
  }

  void dropImage(int index) {
    images.removeAt(index);
    update(["images"]);
  }

  void dropVideo(int index) {
    videos.removeAt(index);
    update(["videos"]);
  }

  Future<void> pickFromGallery() async {
    if (_isPicking) return;
    //  FileType.video
    await Get.defaultDialog(
        title: "Pick From Gallery",
        content: const Text("Choose what will you pick"),
        actions: [
          // Video
          TextButton(
            onPressed: () async {
              if (_isPicking) return;
              _isPicking = true;
              await _pickVideos();
            },
            child: const Text(
              "Video",
              style: TextStyle(color: Colors.purple),
            ),
          ),
          // Images
          TextButton(
            onPressed: () async {
              if (_isPicking) return;
              _isPicking = true;
              await _pickImages();
            },
            child: const Text(
              "Image",
              style: TextStyle(color: Colors.purple),
            ),
          ),
        ]).then((_) => _isPicking = false);
  }

  Future<void> _pickVideos() async {
    result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      withData: true,
      type: FileType.video,
    );
    if (result != null) {
      videos.addAll(result!.paths.map((path) => File(path ?? "")).toList());
      update(["videos"]);
      Get.back();
    }
  }

  Future<void> _pickImages() async {
    result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      withData: true,
      type: FileType.image,
    );
    if (result != null) {
      images.addAll(result!.paths.map((path) => File(path ?? "")).toList());
      update(["images"]);
      Get.back();
    }
  }

  Future<void> resizeFiles() async {
    if (isResizing) return;
    isResizing = true;
    update(["loading"]);
    if (videos.isEmpty && images.isEmpty) {
      Get.snackbar(
        "Alert",
        "Choose Files firstly",
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      await _resizeFiles().then((_) {
        Get.snackbar(
          "Alert",
          "Files have been resized!\nPlease take a moment to check the 'KidsCareResizer' folder",
          snackPosition: SnackPosition.BOTTOM,
        );
      });
    }
    isResizing = false;
    update(["loading"]);
  }

  Future<void> _resizeFiles() async {
    if (images.isNotEmpty) {
      await _resizeImages(file: images, isImage: true).then((_) {
        images.clear();
        update(["images"]);
      });
    }
    if (videos.isNotEmpty) {
      await _resizeImages(file: videos, isImage: false).then((value) {
        videos.clear();
        update(["videos"]);
      });
    }
  }

  Future<void> _resizeImages({
    required List<File> file,
    required bool isImage,
  }) async {
    for (int i = 0; i < file.length; i++) {
      String outPutLocation =
          "${_appDocDir?.path}/${DateTime.now().millisecondsSinceEpoch}_${basename(file.elementAt(i).path)}";
      await FFmpegKit.execute(
              '-i ${file.elementAt(i).path} -vf "scale=iw*0.$selectedValue:ih*0.$selectedValue" $outPutLocation')
          .then((session) async {
        if (ReturnCode.isSuccess(await session.getReturnCode())) {
          if (isImage) {
            await GallerySaver.saveImage(
              outPutLocation,
              albumName: "KidsCareResizer",
            );
            coloredPrint('Image Saved');
          } else {
            await GallerySaver.saveVideo(
              outPutLocation,
              albumName: "KidsCareResizer",
            );
            coloredPrint('Video Saved');
          }
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
      resolutionsItems.add(i);
    }
    update(["resize"]);
  }
}
