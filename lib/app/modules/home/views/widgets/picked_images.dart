import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kids_care_demo/app/modules/home/controllers/home_controller.dart';

class PickedImagesWidget extends StatelessWidget {
  const PickedImagesWidget({Key? key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      id: "images",
      builder: (controller) => GridView.builder(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 4.0,
            mainAxisSpacing: 6.0,
          ),
          itemCount: controller.images.length + 1,
          itemBuilder: (BuildContext context, int index) {
            if (index == controller.images.length) {
              return InkWell(
                onTap: () async => controller.isResizing
                    ? null
                    : await controller.pickFromGallery(),
                child: Container(
                  width: double.infinity,
                  height: 150.0,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                    color: Colors.grey.withOpacity(0.5),
                  ),
                  child: Center(
                    child: Text(
                      controller.images.isEmpty ? "Pick" : "Add More",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            } else {
              return Stack(clipBehavior: Clip.none, children: [
                Container(
                  width: double.infinity,
                  height: 150.0,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                    image: DecorationImage(
                      image: FileImage(controller.images[index]),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: -25.0,
                  right: -10.0,
                  child: Transform.scale(
                    scale: 0.5,
                    child: FloatingActionButton(
                      backgroundColor: Colors.grey.withOpacity(0.7),
                      child: const Icon(Icons.remove),
                      onPressed: () => controller.isResizing
                          ? null
                          : controller.dropImage(index),
                    ),
                  ),
                ),
              ]);
            }
          }),
    );
  }
}
