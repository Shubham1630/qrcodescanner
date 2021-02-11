import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_qr_barcode_scanner/ui/showGeneratedCode.dart';
import 'package:intl/intl.dart';

import '../Classes.dart';
import '../storage_helper.dart';





class ScanBarcode extends StatefulWidget {
  @override
  _ScanBarcodeState createState() => _ScanBarcodeState();
}


class _ScanBarcodeState extends State<ScanBarcode> {

  List<DirectoryOS> saved_images = [];
  String _scanBarcode;


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

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      _saveData();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ShowGeneratedQrCode(barcodeScanRes,false)),
      );
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
  void initState() {
    super.initState();
    scanBarcodeNormal();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
