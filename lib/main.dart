import 'package:flutter/material.dart';
import 'package:flutter_mobile_vision/flutter_mobile_vision.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  bool isInitilized = false;
  @override
  void initState() {
    FlutterMobileVision.start().then((value) {
      isInitilized = true;
    });
    super.initState();
  }

  List<OcrText> list = List();

  _startScan() async {
    setState(() {
      textList.clear();
    });
    try {
      list = await FlutterMobileVision.read(
          waitTap: true,
          fps: 5,
          multiple: true,
          autoFocus: true,
          showText: true);

      for (OcrText text in list) {
        setState(() {
          textList.add(text.value);
        });
        print('--------------------------->>> ${text.value}');
      }
    } catch (e) {}
  }

  List<String> textList = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("OCR DEMO - FLUTTER"),
        centerTitle: true,
      ),
      body: Container(
        child: Center(
            child: ListView.builder(
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                "${index + 1}. ${textList[index]}",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
            );
          },
          itemCount: textList.length,
        )),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: _startScan,
        child: Icon(Icons.camera_alt_outlined),
      ),
    );
  }
}
