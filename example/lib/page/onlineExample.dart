import 'package:flutter/material.dart';
import 'package:json_view/json_view.dart';
import 'package:my_image_picker/my_image_picker.dart';
import 'package:my_image_picker/my_multiple_image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class OnlineExample extends StatefulWidget {
  const OnlineExample({super.key, required this.title, required this.drawer});
  final String title;
  final Drawer Function(BuildContext context) drawer;

  @override
  State<OnlineExample> createState() => _OnlineExampleState();
}

class _OnlineExampleState extends State<OnlineExample> {
  MultipleImagePickerController controller = MultipleImagePickerController();

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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(5),
              margin: const EdgeInsets.all(10),
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
              ),
              child: SingleChildScrollView(
                child: MultipleImagePickerComponent(
                  controller: controller,
                  size: 150,
                  canReupload: true,
                  useDescriptionFieldAsQuery: true,
                  uploadUrl:
                      "https://dev2.enerren.com/SmartSafeteeMobileApi/api/HseFormData/UploadAttachment",
                  token:
                      "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9zaWQiOiI5OWI1NmU0My0zNzVlLTQ2NDItOGUyNy03OTM1ZWZlNGExY2QiLCJVc2VyTmFtZSI6ImFkbWluIiwiU3Vic2NyaXB0aW9uSWQiOiJhZGYxYWE0MC1lMmM0LTQ0NjQtOTVlMC0wOTY3MGUxZGQ4YjciLCJDb21wYW55TmFtZSI6IlBULiBFbmVycmVuIFRlY2hub2xvZ2llcyIsIm5iZiI6MTcxODE1NjEzMCwiZXhwIjoxNzE4MTk5MzMwLCJpYXQiOjE3MTgxNTYxMzB9.TZYFVFRih3saWVtUXpE1vnz9jhKKApiYxdUamuHbGzI",
                  onChange: (controller) {
                    controller.getImageData().forEach((element) {
                      print(element?.toJson());
                    });
                    setState(() {});
                  },
                ),
              ),
            ),
          ),
          Expanded(
              child: Container(
            padding: const EdgeInsets.all(5),
            margin: const EdgeInsets.all(10),
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
            ),
            child: JsonView(
              json: controller.getImageData().map((e) => e?.toJson()).toList(),
              arrow: const Icon(Icons.arrow_right_rounded),
            ),
          ))
        ],
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
            ElevatedButton(
              onPressed: () {
                controller.setState(() {
                  controller.value.imagePickerControllers?.addAll(
                    ImageData.dummyData.map(
                      (e) => ImagePickerController(
                        value: ImagePickerValue(
                          loadData: true,
                          uploadedId: e.imageUrl,
                          uploadedUrl: e.imageUrl,
                          imageDescription: e.description,
                        ),
                      ),
                    ),
                  );
                });
              },
              child: const Text("Load"),
            ),
          ],
        ),
      ),
    );
  }
}

class ImageData {
  String? imageUrl;
  String? description;

  ImageData({this.imageUrl, this.description});

  Map<String, dynamic> toJson() {
    return {
      "imageUrl": imageUrl,
      "description": description,
    };
  }

  factory ImageData.fromJson(Map<String, dynamic> json) {
    return ImageData(
      imageUrl: json["imageUrl"],
      description: json["description"],
    );
  }

  //dummy
  static List<ImageData> dummyData = [
    ImageData(
      imageUrl:
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS3yokf-qUHid3rVl9DMcd2ULqN85zdfLqjvA&usqp=CAU",
      description: "Foto 1",
    ),
    ImageData(
      imageUrl:
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ0ujC1_S6eEijjjhVs7GUBmGiF-L-sx1ehRg&usqp=CAU",
      description: "Foto 2",
    ),
    ImageData(
      imageUrl:
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS9ERqrM68QKjOeKGk-AyLfJOshCVqFR_VCCQ&usqp=CAU",
      description: "Image 3",
    ),
  ];
}
