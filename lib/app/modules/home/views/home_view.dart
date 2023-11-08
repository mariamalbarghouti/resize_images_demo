import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:multi_image_picker_view/multi_image_picker_view.dart';

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
        padding: const EdgeInsets.all(8.0),
        children: [
          MultiImagePickerView(
            controller: controller.controller,
          ),
          const SizedBox(height: 30),
          const Text("Choose Resolution"),
          GetBuilder<HomeController>(
              id: "resize",
              builder: (controller) {
                return DropdownButton<int>(
                  value: controller.selectedValue,
                  items: controller.items.map((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text('$value%'),
                    );
                  }).toList(),
                  onChanged: controller.onDropdownChanged,
                );
              }),
          const SizedBox(height: 30),
          TextButton(
            onPressed: () async => await controller.resizeImages(),
            child: GetBuilder<HomeController>(
                id: "loading",
                builder: (controller) {
                  if (controller.isUploading) {
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
        ],
      ),
    );
  }
}
