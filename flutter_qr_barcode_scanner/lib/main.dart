import 'dart:async';


import 'package:barcode/barcode.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_qr_barcode_scanner/showBarodeHistory.dart';
import 'package:flutter_qr_barcode_scanner/storage_helper.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';

import 'Classes.dart';
import 'create_barcode.dart';

void main() => runApp(MaterialApp(home: MyApp() ,));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _scanBarcode = 'Unknown';
  List<DirectoryOS> saved_images = [];

  @override
  void initState() {
    super.initState();
  }

  // Future<void> generateBarcode() async {
  //   buildBarcode(
  //     Barcode.code39(),
  //     'CODE 39',
  //   );
  // }

  Future<void>   _saveData() async {
    // List<String> monthNames = ["Jan","Feb","Mar","April","May","June","July","Aug","Sep","Oct","Nov","Dec"];
    String date;
    var currentDate = DateTime.now();
    var newDate = DateFormat.yMMMEd().format(currentDate);
    // date = monthNames[currentDate.month -1]+" "+ currentDate.day.toString()+ " "+ currentDate.year.toString() +" " + "" +"at" + " "+
    //     currentDate.hour.toString()+":" + currentDate.minute.toString();
    date = "Scanned:"+" "+  newDate;
    print(newDate);

    try {
      DirectoryOS directoryOS = new DirectoryOS();
      saved_images = await StorageHelper.read("image");
      if(saved_images == null){
        saved_images = [];
      }
      if(saved_images.isNotEmpty) {
        for (int i = 0; i < saved_images.length; i++) {
          if (saved_images[i].dirName.contains(_scanBarcode)) {
            return;
          }
        }
      }


      directoryOS.dirName = _scanBarcode;
      directoryOS.currentdate = date;
      saved_images.add(directoryOS);
      StorageHelper.save("image", saved_images);


    } catch(Exception){
      print(Exception);
    }



  }

  // File buildBarcode(
  //     Barcode bc,
  //     String data, {
  //       String filename,
  //       double width,
  //       double height,
  //       double fontHeight,
  //     }) {
  //   /// Create the Barcode
  //   final svg = bc.toSvg(
  //     data,
  //     width: width ?? 200,
  //     height: height ?? 80,
  //     fontHeight: fontHeight,
  //   );
  //   print(svg);
  //
  //   // Save the image
  //   filename ??= bc.name.replaceAll(RegExp(r'\s'), '-').toLowerCase();
  //    File('$filename.svg').writeAsStringSync(svg);
  // }

  // Future<void> scanQR() async {
  //   String barcodeScanRes;
  //   // Platform messages may fail, so we use a try/catch PlatformException.
  //   try {
  //     barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
  //         '#ff6666', 'Cancel', true, ScanMode.QR);
  //     _saveData();
  //     print(barcodeScanRes);
  //   } on PlatformException {
  //     barcodeScanRes = 'Failed to get platform version.';
  //   }
  //
  //   // If the widget was removed from the tree while the asynchronous platform
  //   // message was in flight, we want to discard the reply rather than calling
  //   // setState to update our non-existent appearance.
  //   if (!mounted) return;
  //
  //   setState(() {
  //     _scanBarcode = barcodeScanRes;
  //
  //   });
  // }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      _saveData();
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
          bottomNavigationBar: BottomNavigationBar(
            items: [
              BottomNavigationBarItem(
                label: "Camera",
                icon: IconButton(icon: Icon(Icons.camera), onPressed: (){
                  scanBarcodeNormal();
                  
                })
              ),
              BottomNavigationBarItem(
                label: "Create",
                  icon: IconButton(icon: Icon(Icons.create), onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CreateBarcode()),
                    );

                  })
              ),
              BottomNavigationBarItem(
                label: "History",
                  icon: IconButton(icon: Icon(Icons.history), onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ShowBarcodeHistory()),
                    );

                  })
              )
            ],
          ),
            appBar: AppBar(title: const Text('Barcode scan'),
            actions: [IconButton(icon: Icon(Icons.share), onPressed: (){
              Share.share(_scanBarcode, subject: 'shared from barcode scan');
            })],),
            body: Builder(builder: (BuildContext context) {
              return Container(
                  alignment: Alignment.center,
                  child: Flex(
                      direction: Axis.vertical,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        BarcodeWidget(
                          barcode: Barcode.qrCode(), // Barcode type and settings
                          data: _scanBarcode, // Content
                          width: 200,
                          height: 200,
                        ),

                        Text('Scan result : $_scanBarcode\n',
                            style: TextStyle(fontSize: 20))

                      ]));
            }
            )
        )
    );
  }
}
