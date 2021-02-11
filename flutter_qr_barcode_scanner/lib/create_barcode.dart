
import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qr_barcode_scanner/Classes.dart';
import 'package:flutter_qr_barcode_scanner/barcodeForm.dart';
import 'package:flutter_qr_barcode_scanner/storage_helper.dart';
import 'package:flutter_qr_barcode_scanner/ui/qrcodegenerator.dart';
import 'package:flutter_qr_barcode_scanner/ui/showGeneratedCode.dart';

class CreateBarcode extends StatefulWidget {
  @override
  _CreateBarcodeState createState() => _CreateBarcodeState();
}

class _CreateBarcodeState extends State<CreateBarcode> {
  List<DirectoryOS> saved_images = [];

  @override
  void initState() {
    super.initState();
   getSavedQRCodes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: saved_images != null ?
      Container(
        child:
        ListView.builder
          (itemCount: saved_images.length,
            itemBuilder: (context,index){
              return GestureDetector(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ShowGeneratedQrCode(saved_images[index].dirName,false))
                  );
                },

                child: Card(
                  margin: EdgeInsets.all(7),
                  child:
                  ListTile(
                    contentPadding: EdgeInsets.all(7),
                    leading: BarcodeWidget(
                      barcode: Barcode.qrCode(), // Barcode type and settings
                      data:saved_images[index].dirName , // Content
                      width: 50,
                      height: 50,
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start ,
                      mainAxisAlignment: MainAxisAlignment.start ,
                      children: [
                        Text(saved_images[index].dirName,
                          style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: Colors.blue),
                        ),
                        Text(saved_images[index].currentdate,
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
     saved_images = await StorageHelper.read("savedQRCodes");
     print(saved_images);
     setState(() {

     });
  }
}
