import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_ppicker/image_picker_handler.dart';
import 'package:flutter_image_ppicker/image_picker_dialog.dart';
import 'package:http/io_client.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HomeScreenState createState() => new _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin,ImagePickerListener{

  File _image;
  AnimationController _controller;
  ImagePickerHandler imagePicker;

  @override
  void initState() {
    super.initState();
    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    imagePicker=new ImagePickerHandler(this,_controller);
    imagePicker.init();

  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title,
        style: new TextStyle(
          color: Colors.white
        ),
        ),
      ),
      body: new GestureDetector(
        onTap: () => imagePicker.showDialog(context),
        child: new Center(
          child: _image == null
              ? new Stack(
                  children: <Widget>[

                    new Center(
                      child: new CircleAvatar(
                        radius: 80.0,
                        backgroundColor: const Color(0xFF778899),
                      ),
                    ),
                    new Center(
                      child: new Image.asset("assets/photo_camera.png"),
                    ),

                  ],
                )
              : new Center(child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
              children : [Container(
                  height: 160.0,
                  width: 160.0,
                  decoration: new BoxDecoration(
                    color: const Color(0xff7c94b6),
                    image: new DecorationImage(
                      image: new ExactAssetImage(_image.path),
                      fit: BoxFit.cover,
                    ),
                    border:
                        Border.all(color: Colors.red, width: 5.0),
                    borderRadius:
                        new BorderRadius.all(const Radius.circular(80.0)),
                  ),
                ),

          GestureDetector(
            onTap: () => uploadImage(),
            child: roundedButton(
                "UPLOAD",
                EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                const Color(0xFF167F67),
                const Color(0xFFFFFFFF)),
          ),

          ]),),
        ),
      ),


    );
  }

  @override
  userImage(File _image) {
    setState(() {
      this._image = _image;
    });
  }


  uploadImage() async{
    print("inside upload");
    bool trustSelfSigned = true;
    HttpClient httpClient = new HttpClient()..badCertificateCallback = ((X509Certificate cert, String host, int port) => trustSelfSigned);
    IOClient ioClient = new IOClient(httpClient);


    List<int> imageBytes = _image.readAsBytesSync();
    print(imageBytes);
    String base64Image = base64Encode(imageBytes);


    print('base64 of image ' + base64Image);

    Map<String,String> data = {
      "pic": base64Image,
      "name": "sanket_image_test",
      "tags":"test"
    };

    var url = "http://contractpro.in/socvisimg.php?apicall=uploadpic";
    await ioClient.post(url, body: jsonEncode(data) , headers: {"Content-Type": "application/json"},)
        .then((response) {
          print('Request params : ${data}');
      print("Response url :: ${response.request.url} and status: ${response.statusCode}");
      print("Response body: ${response.body}");
    });

  }

  Widget roundedButton(
      String buttonLabel, EdgeInsets margin, Color bgColor, Color textColor) {
    var loginBtn = new Container(
      margin: margin,
      padding: EdgeInsets.all(15.0),
      alignment: FractionalOffset.center,
      decoration: new BoxDecoration(
        color: bgColor,
        borderRadius: new BorderRadius.all(const Radius.circular(100.0)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: const Color(0xFF696969),
            offset: Offset(1.0, 6.0),
            blurRadius: 0.001,
          ),
        ],
      ),
      child: Text(
        buttonLabel,
        style: new TextStyle(
            color: textColor, fontSize: 20.0, fontWeight: FontWeight.bold),
      ),
    );
    return loginBtn;
  }




}
