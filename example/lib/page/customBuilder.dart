import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:json_view/json_view.dart';
import 'package:my_image_picker/my_image_picker.dart';
import 'package:my_image_picker/my_multiple_image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class CustomBuilderExample extends StatefulWidget {
  const CustomBuilderExample(
      {super.key, required this.title, required this.drawer});
  final String title;
  final Drawer Function(BuildContext context) drawer;

  @override
  State<CustomBuilderExample> createState() => _CustomBuilderExampleState();
}

class _CustomBuilderExampleState extends State<CustomBuilderExample> {
  ImagePickerController controller = ImagePickerController();

  //dummy data

  @override
  void initState() {
    super.initState();
    Permission.camera.request();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      drawer: widget.drawer(context),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ImagePickerComponent(
              controller: controller,
              showDescription: false,
              container: (ctx, value) {
                return CircleAvatar(
                  radius: 50,
                  backgroundImage: value.base64 != null
                      ? MemoryImage(base64Decode(value.base64!.split(',').last))
                      : Image.asset('assets/avatar.png').image,
                );
              },
              containerHeight: 100,
              containerWidth: 100,
            )
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(10),
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {});
              },
              child: const Text("Read"),
            ),
            const SizedBox(
              width: 10,
            ),
            ElevatedButton(
              onPressed: () {
                controller.clear();
              },
              child: const Text("Clear"),
            ),
            const SizedBox(
              width: 10,
            ),
          ],
        ),
      ),
    );
  }
}
