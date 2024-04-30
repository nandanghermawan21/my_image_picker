import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:json_view/json_view.dart';
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
        child: ElevatedButton(
          onPressed: () {
            setState(() {});
          },
          child: const Text("Get Data"),
        ),
      ),
    );
  }
}
