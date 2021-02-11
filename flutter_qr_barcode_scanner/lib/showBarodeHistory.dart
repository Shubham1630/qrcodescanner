

import 'package:barcode/barcode.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qr_barcode_scanner/Classes.dart';
import 'package:flutter_qr_barcode_scanner/storage_helper.dart';
import 'package:flutter_qr_barcode_scanner/ui/showGeneratedCode.dart';

class ShowBarcodeHistory extends StatefulWidget {


  @override
  _ShowBarcodeHistoryState createState() => _ShowBarcodeHistoryState();


}


class _ShowBarcodeHistoryState extends State<ShowBarcodeHistory> {
  List<DirectoryOS> barcodeData = [];


  @override
  void initState() {
    super.initState();
    getBarcodeData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          body: barcodeData != null?
          ListView.builder
            (
              itemCount: barcodeData.length,
              itemBuilder: (context,index){
                return
                  GestureDetector(
                    onTap: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ShowGeneratedQrCode(barcodeData[index].dirName,false))
                      );
                    },
                    child: Card(
                      margin: EdgeInsets.all(7),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(7),
                      leading: BarcodeWidget(
                        barcode: Barcode.qrCode(), // Barcode type and settings
                        data:barcodeData[index].dirName , // Content
                        width: 50,
                        height: 50,
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start ,
                        mainAxisAlignment: MainAxisAlignment.start ,
                        children: [
                          Text(barcodeData[index].dirName,
                              style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18 ,color: Colors.blue),
                          ),
                          Text(barcodeData[index].currentdate,
                              style: TextStyle(fontWeight: FontWeight.w300,fontSize: 15)),
                        ],
                      )
                      ,
                ),
                    ),
                  );
              }): Container(),

    );
  }



  Future<void> getBarcodeData()  async {
    barcodeData =  await StorageHelper.read("image");
    print(barcodeData.toString());
    setState(() {

    });
  }
}
