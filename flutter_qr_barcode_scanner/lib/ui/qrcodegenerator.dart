

import 'package:flutter/material.dart';
import 'package:flutter_qr_barcode_scanner/url_barcode_generate.dart';
import 'package:flutter_qr_barcode_scanner/ui/textQrcodeGenerate.dart';


class QRCodeGeneratorTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: () { Navigator.pop(context); },),
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.textsms_outlined),
                text: "URL",),
                Tab(icon: Icon(Icons.text_fields),
                  text: "Text",
                ),
              ],
            ),
            title: Text('QR Code Generator'),
          ),
          body: TabBarView(
            children: [
             URLBarcode(),
              TextQr(),

            ],
          ),
        ),
      ),
    );
  }
}
