




import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ShowBarcode extends StatelessWidget {
  File _barcodeFile;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("GeneratedBarcode"),

      ),
      body: Image.file(_barcodeFile),
    );
  }

  ShowBarcode(this._barcodeFile);
}
