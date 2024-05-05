import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:json_view/json_view.dart';
import 'package:my_image_picker/my_image_picker.dart';
import 'package:my_image_picker/my_multiple_image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueAccent,
        ),
        textTheme: const TextTheme(),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
