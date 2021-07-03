import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mongolian_culture/content/recognition_page.dart';
import 'package:mongolian_culture/globals.dart' as globals;
import 'package:tflite/tflite.dart';

import '../app_theme.dart';
import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:image/image.dart' as img;

const String mobile = "MobileNet";
const String ssd = "SSD MobileNet";
const String yolo = "Tiny YOLOv2";
const String deeplab = "DeepLab";
const String posenet = "PoseNet";

class LanguagePage extends StatefulWidget {
  @override
  _LanguagePageState createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
//  String url;
//  loadAsset() async {
//      await globals
//          .getImg('contents/language/overall.jpg')
//          .then((data) {
//        setState(() {
//          url=data;
//        });
//      });
//  }
//  @override
//  initState() {
//    super.initState();
//    Future.delayed(
//        Duration.zero,
//            () => setState(() {
//          loadAsset();
//        }));
//  }
//  @override
//  Widget build(BuildContext context) {
//    // TODO: implement build
//
//    if (url == null) {
//      return MaterialApp(
//        home: Scaffold(
//          appBar: AppBar(
//            backgroundColor: AppTheme.mainColor,
//            title: Center(
//              child: Text("文字"),
//            ),
//            leading: new IconButton(
//              icon: const Icon(Icons.arrow_back),
//              onPressed: () {
//                Navigator.of(context).pop();
//              },),
//          ),
//          body: Center(
//            child: CircularProgressIndicator(
//              backgroundColor: AppTheme.subColor,
//              valueColor: new AlwaysStoppedAnimation<Color>(AppTheme.mainColor),
//            ),
//          ),
//        ),
//      );
//    } else {
//      return MaterialApp(
//          home: Scaffold(
//            appBar: AppBar(
//              backgroundColor: AppTheme.mainColor,
//              title: Center(
//                child: Text("文字"),
//              ),
//              leading: new IconButton(
//                icon: const Icon(Icons.arrow_back),
//                onPressed: () {
//                  Navigator.of(context).pop();
//                },),
//            ),
//            body: GestureDetector(
//              onTap: ()async{
//                String res = await Tflite.loadModel(
//                  model: "assets/mobilenet_v1_1.0_224.tflite",
//                  labels: "assets/mobilenet_v1_1.0_224.txt",
//                );
//                var recognitions = await Tflite.runModelOnImage(
//                  path: 'images/logo.png',   // required
//                  inputSize: 224,   // wanted input size, defaults to 224
//                  numChannels: 3,   // wanted input channels, defaults to 3
//                  imageMean: 127.5, // defaults to 117.0
//                  imageStd: 127.5,  // defaults to 1.0
//                  numResults: 6,    // defaults to 5
//                  threshold: 0.05,  // defaults to 0.1
//                  numThreads: 1,    // defaults to 1
//                );
//                print(res);
//                print(recognitions);
//                await Tflite.close();
//              },
//    child:Padding(
//
//              padding: EdgeInsets.all(30.0),
//              child: Image.network(url),
//            ),
//            ),
//          )
//      );
//    }
//  }
  File _image;
  List _recognitions;
  String _model = yolo;
  double _imageHeight;
  double _imageWidth;
  bool _busy = false;

  Future predictImagePicker() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image == null) return;
    setState(() {
      _busy = true;
    });
    predictImage(image);
  }

  Future predictImage(File image) async {
    if (image == null) return;

    switch (_model) {
      case yolo:
        await yolov2Tiny(image);
        break;
      case ssd:
        await ssdMobileNet(image);
        break;
      case deeplab:
        await segmentMobileNet(image);
        break;
      case posenet:
        await poseNet(image);
        break;
      default:
        await recognizeImage(image);
      // await recognizeImageBinary(image);
    }

    new FileImage(image)
        .resolve(new ImageConfiguration())
        .addListener(ImageStreamListener((ImageInfo info, bool _) {
      setState(() {
        _imageHeight = info.image.height.toDouble();
        _imageWidth = info.image.width.toDouble();
      });
    }));

    setState(() {
      _image = image;
      _busy = false;
    });
  }

  @override
  void initState() {
    super.initState();

    _busy = true;

    loadModel().then((val) {
      setState(() {
        _busy = false;
      });
    });
  }

  Future loadModel() async {
    print(_model);
    Tflite.close();
    try {
      String res;
      switch (_model) {
        case yolo:
          res = await Tflite.loadModel(
            model: "assets/yolov2_tiny.tflite",
            labels: "assets/yolov2_tiny.txt",
            // useGpuDelegate: true,
          );
          break;
        case ssd:
          res = await Tflite.loadModel(
            model: "assets/ssd_mobilenet.tflite",
            labels: "assets/ssd_mobilenet.txt",
            // useGpuDelegate: true,
          );
          break;
        case deeplab:
          res = await Tflite.loadModel(
            model: "assets/deeplabv3_257_mv_gpu.tflite",
            labels: "assets/deeplabv3_257_mv_gpu.txt",
            // useGpuDelegate: true,
          );
          break;
        case posenet:
          res = await Tflite.loadModel(
            model: "assets/posenet_mv1_075_float_from_checkpoints.tflite",
            // useGpuDelegate: true,
          );
          break;
        default:
          res = await Tflite.loadModel(
            model: "assets/mobilenet_v1_1.0_224.tflite",
            labels: "assets/mobilenet_v1_1.0_224.txt",
            // useGpuDelegate: true,
          );
      }
      print(res);
    } on PlatformException {
      print('Failed to load model.');
    }
  }

  Uint8List imageToByteListFloat32(
      img.Image image, int inputSize, double mean, double std) {
    var convertedBytes = Float32List(1 * inputSize * inputSize * 3);
    var buffer = Float32List.view(convertedBytes.buffer);
    int pixelIndex = 0;
    for (var i = 0; i < inputSize; i++) {
      for (var j = 0; j < inputSize; j++) {
        var pixel = image.getPixel(j, i);
        buffer[pixelIndex++] = (img.getRed(pixel) - mean) / std;
        buffer[pixelIndex++] = (img.getGreen(pixel) - mean) / std;
        buffer[pixelIndex++] = (img.getBlue(pixel) - mean) / std;
      }
    }
    return convertedBytes.buffer.asUint8List();
  }

  Uint8List imageToByteListUint8(img.Image image, int inputSize) {
    var convertedBytes = Uint8List(1 * inputSize * inputSize * 3);
    var buffer = Uint8List.view(convertedBytes.buffer);
    int pixelIndex = 0;
    for (var i = 0; i < inputSize; i++) {
      for (var j = 0; j < inputSize; j++) {
        var pixel = image.getPixel(j, i);
        buffer[pixelIndex++] = img.getRed(pixel);
        buffer[pixelIndex++] = img.getGreen(pixel);
        buffer[pixelIndex++] = img.getBlue(pixel);
      }
    }
    return convertedBytes.buffer.asUint8List();
  }

  Future recognizeImage(File image) async {
    int startTime = new DateTime.now().millisecondsSinceEpoch;
    var recognitions = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 6,
      threshold: 0.05,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    setState(() {
      _recognitions = recognitions;
    });
    print(recognitions);
    int endTime = new DateTime.now().millisecondsSinceEpoch;
    print("Inference took ${endTime - startTime}ms");
  }

  Future recognizeImageBinary(File image) async {
    int startTime = new DateTime.now().millisecondsSinceEpoch;
    var imageBytes = (await rootBundle.load(image.path)).buffer;
    img.Image oriImage = img.decodeJpg(imageBytes.asUint8List());
    img.Image resizedImage = img.copyResize(oriImage, height: 224, width: 224);
    var recognitions = await Tflite.runModelOnBinary(
      binary: imageToByteListFloat32(resizedImage, 224, 127.5, 127.5),
      numResults: 6,
      threshold: 0.05,
    );
    setState(() {
      _recognitions = recognitions;
    });
    print(recognitions);
    int endTime = new DateTime.now().millisecondsSinceEpoch;
    print("Inference took ${endTime - startTime}ms");
  }

  Future yolov2Tiny(File image) async {
    int startTime = new DateTime.now().millisecondsSinceEpoch;
    var recognitions = await Tflite.detectObjectOnImage(
      path: image.path,
      model: "YOLO",
      threshold: 0.3,
      imageMean: 0.0,
      imageStd: 255.0,
      numResultsPerClass: 1,
    );
    // var imageBytes = (await rootBundle.load(image.path)).buffer;
    // img.Image oriImage = img.decodeJpg(imageBytes.asUint8List());
    // img.Image resizedImage = img.copyResize(oriImage, 416, 416);
    // var recognitions = await Tflite.detectObjectOnBinary(
    //   binary: imageToByteListFloat32(resizedImage, 416, 0.0, 255.0),
    //   model: "YOLO",
    //   threshold: 0.3,
    //   numResultsPerClass: 1,
    // );
    int index = 1;
    for (var item in recognitions) {
      item['index'] = index++;
      await globals
          .getImg('recognition/word/' + item['detectedClass'] + '.jpg')
          .then((data) {
        item['url'] = data;
      });
    }
    setState(() {
      _recognitions = recognitions;
    });
    print(_recognitions);
    int endTime = new DateTime.now().millisecondsSinceEpoch;
    print("Inference took ${endTime - startTime}ms");
  }

  Future ssdMobileNet(File image) async {
    int startTime = new DateTime.now().millisecondsSinceEpoch;
    var recognitions = await Tflite.detectObjectOnImage(
      path: image.path,
      numResultsPerClass: 1,
    );
    // var imageBytes = (await rootBundle.load(image.path)).buffer;
    // img.Image oriImage = img.decodeJpg(imageBytes.asUint8List());
    // img.Image resizedImage = img.copyResize(oriImage, 300, 300);
    // var recognitions = await Tflite.detectObjectOnBinary(
    //   binary: imageToByteListUint8(resizedImage, 300),
    //   numResultsPerClass: 1,
    // );
    int index = 1;
    for (int i = 0; i < recognitions.length; i++) {
      recognitions[i]['index'] = index++;
      print(recognitions[i]);
    }
    setState(() {
      _recognitions = recognitions;
    });
    print(_recognitions);
    int endTime = new DateTime.now().millisecondsSinceEpoch;
    print("Inference took ${endTime - startTime}ms");
  }

  Future segmentMobileNet(File image) async {
    int startTime = new DateTime.now().millisecondsSinceEpoch;
    var recognitions = await Tflite.runSegmentationOnImage(
      path: image.path,
      imageMean: 127.5,
      imageStd: 127.5,
    );

    setState(() {
      _recognitions = recognitions;
    });
    print(recognitions);
    int endTime = new DateTime.now().millisecondsSinceEpoch;
    print("Inference took ${endTime - startTime}");
  }

  Future poseNet(File image) async {
    int startTime = new DateTime.now().millisecondsSinceEpoch;
    var recognitions = await Tflite.runPoseNetOnImage(
      path: image.path,
      numResults: 2,
    );

    print(recognitions);

    setState(() {
      _recognitions = recognitions;
    });
    int endTime = new DateTime.now().millisecondsSinceEpoch;
    print("Inference took ${endTime - startTime}ms");
  }

  onSelect(model) async {
    setState(() {
      _busy = true;
      _model = model;
      _recognitions = null;
    });
    await loadModel();

    if (_image != null)
      predictImage(_image);
    else
      setState(() {
        _busy = false;
      });
  }

  List<Widget> renderBoxes(Size screen) {
    if (_recognitions == null) return [];
    if (_imageHeight == null || _imageWidth == null) return [];

    double factorX = screen.width;
    double factorY = _imageHeight / _imageWidth * screen.width;
    Color color = AppTheme.mainColor;
    return _recognitions.map((re) {
      return Positioned(
        left: re["rect"]["x"] * factorX,
        top: re["rect"]["y"] * factorY,
        width: re["rect"]["w"] * factorX,
        height: re["rect"]["h"] * factorY,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            border: Border.all(
              color: color,
              width: 2,
            ),
          ),
          child: Text(
            "object${re["index"]} ${(re["confidenceInClass"] * 100).toStringAsFixed(0)}%",
            style: TextStyle(
              background: Paint()..color = color,
              color: Colors.white,
              fontSize: 12.0,
            ),
          ),
        ),
      );
    }).toList();
  }

  List<Widget> renderKeypoints(Size screen) {
    if (_recognitions == null) return [];
    if (_imageHeight == null || _imageWidth == null) return [];

    double factorX = screen.width;
    double factorY = _imageHeight / _imageWidth * screen.width;

    var lists = <Widget>[];
    _recognitions.forEach((re) {
      var color = Color((Random().nextDouble() * 0xFFFFFF).toInt() << 0)
          .withOpacity(1.0);
      var list = re["keypoints"].values.map<Widget>((k) {
        return Positioned(
          left: k["x"] * factorX - 6,
          top: k["y"] * factorY - 6,
          width: 100,
          height: 12,
          child: Text(
            "● ${k["part"]}",
            style: TextStyle(
              color: color,
              fontSize: 12.0,
            ),
          ),
        );
      }).toList();

      lists..addAll(list);
    });

    return lists;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    List<Widget> stackChildren = [];

    if (_model == deeplab && _recognitions != null) {
      stackChildren.add(Positioned(
        top: 0.0,
        left: 0.0,
        width: size.width,
        child: _image == null
            ? Text('No image selected.')
            : Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        alignment: Alignment.topCenter,
                        image: MemoryImage(_recognitions),
                        fit: BoxFit.fill)),
                child: Opacity(opacity: 0.3, child: Image.file(_image))),
      ));
    } else {
      stackChildren.add(Positioned(
        top: 0.0,
        left: 0.0,
        width: size.width,
        child: _image == null
            ? Container(
                padding: EdgeInsets.all(20.0),
                child: Column(children: [
                  Container(
                      padding: EdgeInsets.only(bottom: 30.0),
                      child: Text(
                        '请选择一张图片进行识别。',
                        style: AppTheme.body1,
                      )),
                  TextButton(
                      child: Text(
                        "点击此处查看可识别图象列表。",
                        style: AppTheme.body2,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RecognitionPage(),
                          ),
                        );
                      },
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all(EdgeInsets.all(20)),
                        side: MaterialStateProperty.all(
                            BorderSide(color: AppTheme.mainColor, width: 1)),
                        shape: MaterialStateProperty.all(StadiumBorder()),
                      ))
                ]))
            : Image.file(_image),
      ));
    }

    if (_model == mobile) {
      stackChildren.add(Center(
        child: Column(
          children: _recognitions != null
              ? _recognitions.map((res) {
                  return Text(
                    "${res["index"]} - ${res["label"]}: ${res["confidence"].toStringAsFixed(3)}",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                      background: Paint()..color = Colors.white,
                    ),
                  );
                }).toList()
              : [],
        ),
      ));
    } else if (_model == ssd || _model == yolo) {
      stackChildren.addAll(renderBoxes(size));
      if (_imageWidth != null) {
        double factorY = _imageHeight / _imageWidth * size.width;
        stackChildren.add(
          Container(
              height: 340,
              margin: EdgeInsets.only(top: factorY + 20.0),
              child: Center(
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: _recognitions != null
                      ? _recognitions.map((res) {
                          return Container(
                            padding: EdgeInsets.all(30.0),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadiusDirectional.circular(20)),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(
                                        top: 50.0, right: 10.0, left: 10.0),
                                    child: Text(
                                      "object${res["index"]} - ${res["detectedClass"]}",
                                      style: AppTheme.headline,
                                    ),
                                  ),
                                  Image.network(res['url']),
                                ],
                              ),
                            ),
                          );
                        }).toList()
                      : [],
                ),
              )),
        );
      }
    } else if (_model == posenet) {
      stackChildren.addAll(renderKeypoints(size));
    }

    if (_busy) {
      stackChildren.add(const Center(
        child: CircularProgressIndicator(
          backgroundColor: AppTheme.subColor,
          valueColor: AlwaysStoppedAnimation<Color>(AppTheme.mainColor),
        ),
      ));
    }

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('文字'),
        ),
        backgroundColor: AppTheme.mainColor,
        leading: new IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Stack(
        children: stackChildren,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: predictImagePicker,
        backgroundColor: AppTheme.mainColor,
        tooltip: '选择一张照片',
        child: Icon(Icons.image),
      ),
    );
  }
}
