import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_test/HiveDB/test_hive.dart';
import 'package:hive_test/string.dart';
import 'package:path_provider/path_provider.dart';

/// code must be written below manner to delete previous box
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Directory hiveDb = await getApplicationDocumentsDirectory();

  /// [1st way] to delete previous hive Db
  // await hiveDb.delete(recursive: true);

  Hive.init(hiveDb.path);
  await Hive.initFlutter();
  Hive.registerAdapter(HiveTestAdapter());

  /// [2nd way] is to delete hive-box from disk
  // open that hive-box , because without open a box you can not delete that box from disk
  await Hive.openBox<HiveTest>(boxName);
  // delete from disk by using [deleteFromDisk] method
  Hive.box<HiveTest>(boxName).deleteFromDisk();
  // open that box again to prevent error called [did you forgot open the box]
  await Hive.openBox<HiveTest>(boxName);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Delete Privous Hive Box',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final hiveBox = Hive.box<HiveTest>(boxName);
  List<Map<String, dynamic>> names = [
    {'name': 'devarsh', 'age': 22},
    {'name': 'primus', 'age': 10},
    {'name': 'ironman', 'age': 54}
  ];
  List<Map<String, dynamic>> getNames = [];
  Future<void> getValues() async {
    for (var i = 0; i < names.length; i++) {
      await hiveBox.put(names[i]['name'],
          HiveTest(name: names[i]['name'], age: names[i]['age']));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      child: const Text('Get values'),
                      onPressed: () async {
                        HiveTest? testObj;

                        for (var i = 0; i < names.length; i++) {
                          testObj = hiveBox.get(names[i]['name']);
                          if (testObj != null) {
                            getNames.add({
                              'name': '${testObj.name}',
                              'age': '${testObj.age}'
                            });
                          }
                        }
                        setState(() {});
                      }),
                  ElevatedButton(
                      onPressed: () async {
                        await hiveBox.clear().then((value) {
                          getNames.clear();
                          setState(() {});
                        });
                      },
                      child: const Text('Delete'))
                ],
              ),
              Text(
                '$getNames',
                style: Theme.of(context).textTheme.headline4,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await getValues();
        },
        tooltip: 'ADD VALUES',
        child: const Icon(Icons.add),
      ),
    );
  }
}
