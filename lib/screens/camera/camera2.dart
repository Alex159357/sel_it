import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sel_it/screens/create_product/create_product_screen.dart';

import '../../main.dart';

class CameraApp extends StatefulWidget {
  @override
  _CameraAppState createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
  late CameraController controller;
  static int currentCamera = 0;
  static bool isSaving = false;

//todo use bloc for this page
  @override
  void initState() {
    super.initState();
    controller = CameraController(cameras[0], ResolutionPreset.max);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    return OrientationBuilder(builder: (context, orientation) {
      if(orientation == Orientation.portrait){
        return Scaffold(
          body: Stack(
            children: [
              Positioned.fill(
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                          child: _getAppBar(orientation)
                      )
                  )
              ),
              Center(child:  Text("Please rotate you device to landscape"),),
            ],
          ),
        );
      }
      return FutureBuilder(
        future: controller.initialize(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
                body: Material(
              child: Stack(
                children: [
                  Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      color: Colors.redAccent,
                      child: CameraPreview(controller)),
                  Positioned.fill(
                      child: Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                              child: _getAppBar(orientation)
                          )
                      )
                  ),
                  Positioned.fill(
                    child: Align(
                        alignment: orientation == Orientation.portrait? Alignment.bottomCenter : Alignment.centerRight,
                        child: GestureDetector(
                            onTap: () {
                              if (!isSaving) {
                                controller.takePicture().then((value) {
                                  File file = File(value.path);
                                  List<File> fList = [file];
                                  Navigator.of(context).pop(fList);
                                });
                              }
                            },
                            child: Container(
                              margin: orientation == Orientation.portrait? EdgeInsets.only(bottom: 30): EdgeInsets.only(right: 30),
                              width: 50.0,
                              height: 50.0,
                              decoration: new BoxDecoration(
                                  color: Colors.transparent,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: Colors.white, width: 2)),
                              child: Icon(
                                Icons.circle,
                                size: 45,
                                color: Colors.white,
                              ),
                            ))),
                  ),
                  Positioned.fill(
                    child: Align(
                      alignment: orientation == Orientation.portrait? Alignment.bottomLeft: Alignment.bottomRight,
                      child: GestureDetector(
                          onTap: () {
                            setState(() {
                              currentCamera = currentCamera == 0 ? 1 : 0;
                              controller = CameraController(
                                  cameras[currentCamera], ResolutionPreset.max);
                            });
                          },
                          child: Container(
                            margin:  orientation == Orientation.portrait? EdgeInsets.only(bottom: 20, left: 20): EdgeInsets.only(bottom: 20, right: 20),
                            width: 40.0,
                            height: 40.0,
                            decoration: new BoxDecoration(
                              color: Colors.black45,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.autorenew_rounded,
                              color: Colors.white,
                              size: 35,
                            ),
                          )),
                    ),
                  ),
                ],
              ),
            ));
          } else
            return Center(
              child: CircularProgressIndicator(),
            );
        },
      );
    });
  }


  Widget _getAppBar(Orientation orientation){
    if(orientation == Orientation.portrait) {
      return Container(
          width: MediaQuery
              .of(context)
              .size
              .width,
          color: Color(0x44000000),
          padding: EdgeInsets.only(top: 30),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Container(
                  child: _getAppBarLead()
                ),
                Expanded(
                    child: Padding(
                      padding:
                      const EdgeInsets.only(left: 12),
                      child: _getAppBarTitle()
                    ))
              ],
            ),
          ));
    }else {
      return Container(
          height: MediaQuery
              .of(context)
              .size
              .height,
          margin: EdgeInsets.only(top: 24, left: 5),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Container(
                  child:_getAppBarLead()
                ),
                Expanded(
                    child: RotatedBox(
                        quarterTurns: -1,
                        child: Padding(
                      padding:
                      const EdgeInsets.only(right: 12),
                      child: _getAppBarTitle(),
                    )))
              ],
            ),
          ));
    }
  }

  Widget _getAppBarLead(){
    return  GestureDetector(
      onTap: (){
        Navigator.of(context).pop();
      },
      child: Icon(
        Icons.arrow_back_ios,
        color: Colors.white,
      ),
    );
  }

  Widget _getAppBarTitle(){
    return Text(
      "make photo",
      style: TextStyle(
          color: Colors.white,
          fontSize: 18),
    );
  }

}
