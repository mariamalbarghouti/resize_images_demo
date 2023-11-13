import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kids_care_demo/app/modules/home/controllers/home_controller.dart';
import 'package:path/path.dart';

class PickedVideosWidget extends StatelessWidget {
  const PickedVideosWidget();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      id: "videos",
      builder: (controller) => ListView.builder(
        itemCount: controller.videos.length,
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) =>
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          // Video Name
          Text(
            basename(controller.videos[index].path),
          ),
          // Drop Videos
          IconButton(
            onPressed: () => controller.isResizing? null:controller.dropVideo(index),
            icon: Icon(
              Icons.delete,
              color: Colors.purple.withOpacity(0.7),
            ),
          ),
        ]),
      ),
    );
  }
}
