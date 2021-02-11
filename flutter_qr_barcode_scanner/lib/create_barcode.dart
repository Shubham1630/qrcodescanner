
import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qr_barcode_scanner/Classes.dart';
import 'package:flutter_qr_barcode_scanner/url_barcode_generate.dart';
import 'package:flutter_qr_barcode_scanner/storage_helper.dart';
import 'package:flutter_qr_barcode_scanner/ui/qrcodegenerator.dart';
import 'package:flutter_qr_barcode_scanner/ui/showGeneratedCode.dart';

class CreateBarcode extends StatefulWidget {
  @override
  _CreateBarcodeState createState() => _CreateBarcodeState();
}

class _CreateBarcodeState extends State<CreateBarcode> {
  List<QRCode> saved_qr_codes = [];

  @override
  void initState() {
    super.initState();
   getSavedQRCodes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: saved_qr_codes != null ?
      Container(
        child:
        ListView.builder
          (itemCount: saved_qr_codes.length,
            itemBuilder: (context,index){
              return GestureDetector(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ShowGeneratedQrCode(saved_qr_codes[index].qrCodeData,false))
                  );
                },
                child: Card(
                  margin: EdgeInsets.all(7),
                  child:
                  ListTile(
                    contentPadding: EdgeInsets.all(7),
                    leading: BarcodeWidget(
                      barcode: Barcode.qrCode(), // Barcode type and settings
                      data:saved_qr_codes[index].qrCodeData , // Content
                      width: 50,
                      height: 50,
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start ,
                      mainAxisAlignment: MainAxisAlignment.start ,
                      children: [
                        Text(saved_qr_codes[index].qrCodeData,
                          style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),
                        ),
                        Text(saved_qr_codes[index].currentdate,
                            style: TextStyle(fontWeight: FontWeight.w300,fontSize: 15)),
                      ],
                    )
                    ,
                  ),
                ),
              );
            })

      ) : Container(
        child: Center(
          child: IconButton(icon: Icon(Icons.add), onPressed: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => QRCodeGeneratorTab()),
            );
          },
          iconSize: 55,),
        ),
      )
    );
  }

  Future<void> getSavedQRCodes() async {
     saved_qr_codes = await StorageHelper.read("savedQRCodes");
     print(saved_qr_codes);
     setState(() {

     });
  }
}
