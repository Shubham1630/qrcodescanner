
import 'package:barcode_widget/barcode_widget.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Classes.dart';
import '../storage_helper.dart';

class ShowGeneratedQrCode extends StatefulWidget {

  String barcodeData;
  bool shouldSave = true;
  @override
  _ShowGeneratedQrCodeState createState() => _ShowGeneratedQrCodeState();

  ShowGeneratedQrCode(this.barcodeData, this.shouldSave);
}

class _ShowGeneratedQrCodeState extends State<ShowGeneratedQrCode> {


  List<QRCode> saved_images = [];



  Future<void> _openInBrowser() async {
    if (await canLaunch(widget.barcodeData)) {
    await launch(widget.barcodeData);
    } else {
    throw 'Could not launch ';
    }
  }
  Future<void>   _saveData() async {
    String date;
    var currentDate = DateTime.now();
    var newDate = DateFormat.yMMMEd().format(currentDate);

    date = "Scanned:"+" "+  newDate;
    print(newDate);

    try {
     QRCode qrCode = new QRCode();
      saved_images = await StorageHelper.read("savedQRCodes");
      if(saved_images == null){
        saved_images = [];
      }
      if(saved_images.isNotEmpty) {
        for (int i = 0; i < saved_images.length; i++) {
          if (saved_images[i].qrCodeData.contains(widget.barcodeData)) {
            return;
          }
        }
      }


     qrCode.qrCodeData = widget.barcodeData;
     qrCode.currentdate = date;
      saved_images.add(qrCode);
      StorageHelper.save("savedQRCodes", saved_images);


    } catch(Exception){
      print(Exception);
    }



  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("GeneratedQrCode")),
      body: Builder(builder: (BuildContext context) {
        return Container
          (
            alignment: Alignment.center,
            child: Flex(
                direction: Axis.vertical,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  BarcodeWidget(
                    barcode: Barcode.qrCode(), // Barcode type and settings
                    data: widget.barcodeData, // Content
                    width: 150,
                    height: 150,
                  ),
                  SizedBox(height: 10,),
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(' ${widget.barcodeData}\n',
                        style: TextStyle(fontSize: 20)),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                         mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(icon: Icon(Icons.open_in_browser), onPressed: (){
                            _openInBrowser();
                          }),
                          Text("Open")
                        ],
                         
                      ),
                      Column(
                        children: [
                          IconButton(icon: Icon(Icons.share), onPressed: (){
                            Share.share(widget.barcodeData, subject: 'shared from barcode scan');
                          }),
                          Text("Share")
                        ],
                      ),
                      Column(
                        children: [IconButton(icon: Icon(Icons.copy), onPressed: (){
                          FlutterClipboard.copy(widget.barcodeData);
                          Scaffold.of(context).showSnackBar(new SnackBar(
                            content: new Text('Copied to clipboard'+" "+widget.barcodeData),
                          ));
                        },
                        ),
                          Text("Copy")
                        ],
                      ),
                    ],
                  ),
                  widget.shouldSave?
                  ElevatedButton(
                    child: Text("SAVE"),
                    onPressed: (){
                      _saveData();


                    },
                  ): Text("")


                ]));
      }
      )

    );
  }


}


