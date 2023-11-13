import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:kids_care_demo/app/modules/home/views/widgets/pick_videos.dart';
import 'package:kids_care_demo/app/modules/home/views/widgets/picked_images.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
        backgroundColor: Colors.purple,
      ),
      body: ListView(
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          padding: const EdgeInsets.only(
            top: 30.0,
            right: 9,
            bottom: 20,
            left: 9,
          ),
          children: [
            // Images
            const PickedImagesWidget(),
            const SizedBox(height: 30),
            // videos
            const PickedVideosWidget(),
            const SizedBox(height: 30),
            // Resolution
            const Text("Choose Resolution"),
            GetBuilder<HomeController>(
                id: "resize",
                builder: (controller) {
                  return DropdownButton<int>(
                    value: controller.selectedValue,
                    items: controller.resolutionsItems.map((int value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text('$value%'),
                      );
                    }).toList(),
                    onChanged: controller.onDropdownChanged,
                  );
                }),
            const SizedBox(height: 30),
            // Resize Button
            TextButton(
              onPressed: () async => await controller.resizeFiles(),
              child: GetBuilder<HomeController>(
                  id: "loading",
                  builder: (controller) {
                    if (controller.isResizing) {
                      return const CircularProgressIndicator(
                          color: Colors.purple);
                    } else {
                      return const Text(
                        "Resize",
                        style: TextStyle(
                          color: Colors.purple,
                        ),
                      );
                    }
                  }),
            ),
          ]),
    );
  }
}
