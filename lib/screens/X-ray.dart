import 'dart:io';
import 'package:covifind/screens/homepage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

class Scan extends StatefulWidget {
  @override
  _ScanState createState() => _ScanState();
}

class _ScanState extends State<Scan> {
  bool _loading;
  File _image;
  List _output;
  final _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loading = true;

    loadModel().then((value) {
      setState(() {
        _loading = false;
      });
    });
  }

  loadModel() async {
    await Tflite.loadModel(
        model: "assets/model_unquant.tflite",
        labels: "assets/labels.txt",
        numThreads: 1);
  }

  pickImage() async {
    var image = await _imagePicker.getImage(source: ImageSource.gallery);
    if (image == null) return null;
    setState(() {
      _loading = true;
      _image = File(image.path);
    });
    classifyImage(_image);
  }

  clickImage() async {
    var image = await _imagePicker.getImage(source: ImageSource.camera);
    if (image == null) return null;
    setState(() {
      _loading = true;
      _image = File(image.path);
    });
    classifyImage(_image);
  }

  classifyImage(File image) async {
    var output = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 2,
      threshold: 0.5,
      imageMean: 127.5,
      imageStd: 127.5,
    );

    setState(() {
      _loading = false;
      _output = output;
      print(_output);
    });
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
            title: Text(
              '    X-Ray Scan',
              style: TextStyle(color: Colors.white),
            ),
            leading: new IconButton(
              icon: new Icon(Icons.arrow_back_rounded),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomePage()));
              },
              color: Colors.black,
            ),
            backgroundColor: Colors.blue),
        backgroundColor: Colors.white,
        body: _loading
            ? Container(
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
              )
            : Container(
                child: Column(
                  children: [
                    SizedBox(height: 30),
                    _image == null
                        ? Container()
                        : Center(
                            child: Container(
                            child: Image.file(_image),
                            height: 300,
                          )),
                    SizedBox(
                      height: 10,
                    ),
                    _output != null
                        ? Text(
                            "${_output[0]["label"]}".replaceAll(
                              RegExp(r'[0-9]'),
                              '',
                            ),
                            style: TextStyle(color: Colors.red, fontSize: 20),
                          )
                        : Text("Waiting",
                            style:
                                TextStyle(color: Colors.yellow, fontSize: 20)),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 90, 20, 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              height: 70,
                              width: 150,
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: GestureDetector(
                                  onTap: () => clickImage(),
                                  child: Stack(
                                    children: [
                                      Positioned(
                                          top: 10,
                                          height: 20,
                                          left: 53,
                                          child: Text(
                                            'Click',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20),
                                          )),
                                      Positioned(
                                          top: 35,
                                          left: 62,
                                          child: Icon(Icons.camera_enhance))
                                    ],
                                  ))),
                          Container(
                              height: 70,
                              width: 150,
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: GestureDetector(
                                  onTap: () => pickImage(),
                                  child: Stack(
                                    children: [
                                      Positioned(
                                          top: 10,
                                          height: 25,
                                          left: 48,
                                          child: Text(
                                            'Upload',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20),
                                          )),
                                      Positioned(
                                          top: 35,
                                          left: 62,
                                          child: Icon(Icons.file_upload))
                                    ],
                                  ))),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                      child: Container(
                          height: 60,
                          width: 250,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: GestureDetector(
                              onTap: () {},
                              child: Stack(
                                children: [
                                  Positioned(
                                      top: 20,
                                      height: 25,
                                      left: 48,
                                      child: Text(
                                        'Consult a Doctor',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      )),
                                ],
                              ))),
                    ),
                  ],
                ),
              ));
  }
}
