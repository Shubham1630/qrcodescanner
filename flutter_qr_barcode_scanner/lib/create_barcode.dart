
import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_qr_barcode_scanner/Classes.dart';

import 'package:flutter_qr_barcode_scanner/storage_helper.dart';
import 'package:flutter_qr_barcode_scanner/ui/showGeneratedCode.dart';
import 'package:intl/intl.dart';

class CreateBarcode extends StatefulWidget {
  @override
  _CreateBarcodeState createState() => _CreateBarcodeState();
}

class _CreateBarcodeState extends State<CreateBarcode> {
  List<QRCode> created_saved_qr_codes = [];
  List<QRCode>  saved_barcodes = [];

  @override
  void initState() {
    super.initState();
   getSavedQRCodes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: 
      Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          created_saved_qr_codes != null?
          Expanded(
            child: ListView.builder
              (itemCount: created_saved_qr_codes.length,
                itemBuilder: (context,index){
                  return GestureDetector(
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ShowGeneratedQrCode(created_saved_qr_codes[index].qrCodeData,false))
                      );
                    },
                    child: Card(
                      margin: EdgeInsets.all(7),
                      child:
                      ListTile(
                        contentPadding: EdgeInsets.all(7),
                        leading: BarcodeWidget(
                          barcode: Barcode.qrCode(), // Barcode type and settings
                          data:created_saved_qr_codes[index].qrCodeData , // Content
                          width: 50,
                          height: 50,
                        ),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start ,
                          mainAxisAlignment: MainAxisAlignment.start ,
                          children: [
                            Text(created_saved_qr_codes[index].qrCodeData,
                              style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),
                            ),
                            SizedBox(height: 5,),
                            Text(created_saved_qr_codes[index].currentdate,
                                style: TextStyle(fontWeight: FontWeight.w300,fontSize: 15)),
                          ],
                        )
                        ,
                      ),
                    ),
                  );
                }),
          ):Expanded(
            child: ListView(
              children: [],
            ),
          ),


        ],
      )
    );
  }

  Future<void>   _saveData(String _scanBarcode) async {
    String date;
    var currentDate = DateTime.now();
    var newDate = DateFormat.yMMMEd().format(currentDate);
    date = "Scanned:"+" "+  newDate;
    print(newDate);

    try {
      QRCode qrCode = new QRCode();
      saved_barcodes = await StorageHelper.read("barcode");
      if(saved_barcodes == null){
        saved_barcodes = [];
      }
      if(saved_barcodes.isNotEmpty) {
        for (int i = 0; i < saved_barcodes.length; i++) {
          if (saved_barcodes[i].qrCodeData.contains(_scanBarcode)) {
            return;
          }
        }
      }


      qrCode.qrCodeData = _scanBarcode;
      qrCode.currentdate = date;
      saved_barcodes.add(qrCode);
      StorageHelper.save("barcode", saved_barcodes);


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
      if(barcodeScanRes.contains("-1")){
        return;
      }
      _saveData(barcodeScanRes);
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

  }
  
  
  Future<void> getSavedQRCodes() async {
     created_saved_qr_codes = await StorageHelper.read("savedQRCodes");
     print(created_saved_qr_codes);
     setState(() {

     });
  }
}
