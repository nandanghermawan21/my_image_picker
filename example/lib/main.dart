import 'package:example/page/offlineExample.dart';
import 'package:example/page/onlineExample.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

Drawer drawer(BuildContext context) {
  return Drawer(
    child: ListView(
      children: [
        ListTile(
          title: const Text("Offline Example"),
          onTap: () {
            Navigator.of(context).pushNamed("/");
          },
        ),
        ListTile(
          title: const Text("Online Picker"),
          onTap: () {
            Navigator.of(context).pushNamed("/online");
          },
        ),
      ],
    ),
  );
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
      routes: {
        '/': (context) => const OfflineExample(
              title: 'Offline Image Picker Example',
              drawer: drawer,
            ),
        '/online': (context) => const OnlineExample(
              title: 'Online Image Picker Example',
              drawer: drawer,
            ),
      },
      initialRoute: "/",
    );
  }
}
