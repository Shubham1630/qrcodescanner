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
  List<QRCode> saved_scanned_barcodes = [];
  int _selectedIndex = 0;
   List<Widget> _widgetOptions = <Widget>[
     ScanBarcode(),
     CreateBarcode(),
     ShowBarcodeHistory(),
     Setting()
  ];

   List<Widget> _appBar = <Widget>[
     Text('Barcode scan'),
     Text("Generate Scan"),
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
      QRCode qrCode = new QRCode();
      saved_scanned_barcodes = await StorageHelper.read("barcode");
      if(saved_scanned_barcodes == null){
        saved_scanned_barcodes = [];
      }
      if(saved_scanned_barcodes.isNotEmpty) {
        for (int i = 0; i < saved_scanned_barcodes.length; i++) {
          if (saved_scanned_barcodes[i].qrCodeData.contains(_scanBarcode)) {
            return;
          }
        }
      }


      qrCode.qrCodeData = _scanBarcode;
      qrCode.currentdate = date;
      saved_scanned_barcodes.add(qrCode);
      StorageHelper.save("barcode", saved_scanned_barcodes);


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
            leading:_selectedIndex == 1 ?
            IconButton(icon: Icon(Icons.add), onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => QRCodeGeneratorTab()),
              );
            }): Text(""),
            centerTitle: true,),
            body: Builder(builder: (BuildContext context) {
              return _widgetOptions[_selectedIndex];
            }
            )
        )
    );
  }
}
