import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_qr_barcode_scanner/showBarodeHistory.dart';
import 'package:flutter_qr_barcode_scanner/storage_helper.dart';
import 'package:flutter_qr_barcode_scanner/ui/qrcodegenerator.dart';
import 'package:flutter_qr_barcode_scanner/ui/scanBarcode.dart';
import 'package:flutter_qr_barcode_scanner/ui/setting.dart';
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
  int _selectedIndex = 0;
   List<Widget> _widgetOptions = <Widget>[
     ScanBarcode(),
     CreateBarcode(),
     ShowBarcodeHistory(),
     Setting()
  ];

   List<Widget> _appBar = <Widget>[
     Text('Barcode scan'),
     Text("GeneratedQrCodes"),
     Text("History"),
     Text("Setting")
   ];


  @override
  void initState() {
    super.initState();
  }

  Future<void>   _saveData() async {
    String date;
    var currentDate = DateTime.now();
    var newDate = DateFormat.yMMMEd().format(currentDate);
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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            onTap: _onItemTapped,
            currentIndex: _selectedIndex ,
            items: [
              BottomNavigationBarItem(
                label: "Scan",
                icon:  Icon(Icons.camera)
              ),
              BottomNavigationBarItem(
                label: "Create",
                  icon:  Icon(Icons.create)
              ),
              BottomNavigationBarItem(
                label: "History",
                  icon: Icon(Icons.history),
              ),
              BottomNavigationBarItem(
                label: "Setting",
                icon: Icon(Icons.settings),
              )
            ],
          ),
            appBar: AppBar(title: _appBar[_selectedIndex],
            actions: [_selectedIndex == 1 ?
                IconButton(icon: Icon(Icons.add), onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => QRCodeGeneratorTab()),
          );
        }): Text("")],
            centerTitle: true,),
            body: Builder(builder: (BuildContext context) {
              return _widgetOptions[_selectedIndex];
            }
            )
        )
    );
  }
}
