


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qr_barcode_scanner/ui/showGeneratedCode.dart';

class TextQr extends StatefulWidget {
  @override
  _TextQrState createState() => _TextQrState();
}

class _TextQrState extends State<TextQr> {
  TextEditingController txtController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Padding(
            padding: EdgeInsets.all(15),
            child: ListView(
              children: [Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(15),
                    child: TextField(
                      controller: txtController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter text Here',
                      ),
                    ),
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:[ RaisedButton(
                        textColor: Colors.white,
                        color: Colors.blue,
                        child: Text('Generate'),
                        onPressed: (){
                          txtController.text.isNotEmpty?
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ShowGeneratedQrCode(txtController.text,true)),
                          ): SnackBar(content: Text("Enter Text"));
                        },
                      )]
                  )
                ],
              )],
               
            )
        )
    );
  }
}