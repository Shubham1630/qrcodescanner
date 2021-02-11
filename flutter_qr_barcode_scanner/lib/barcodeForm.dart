// Create a Form widget.






import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qr_barcode_scanner/ui/showGeneratedCode.dart';

class MyCustomForm extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class MyCustomFormState extends State<MyCustomForm> {
  bool generateBarcode = false;
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  TextEditingController controller =  TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(padding: EdgeInsets.all(15),
          child: TextFormField(
            controller: controller ,
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          ),
            ElevatedButton(
              onPressed: () {
                // Validate returns true if the form is valid, or false
                // otherwise.
                if (_formKey.currentState.validate()) {
                 setState(() {
                   Navigator.push(
                     context,
                     MaterialPageRoute(builder: (context) => ShowGeneratedQrCode(controller.text ,true)),
                   );
                 });
                }
              },
              child: Text('Generate'),
            ),


    //           Expanded(
    //
    //             child:
    //             generateBarcode?
    // BarcodeWidget(
    // barcode: Barcode.qrCode(), // Barcode type and settings
    // data: 'https://pub.dev/packages/barcode_widget', // Content
    // width: 200,
    // height: 200,
    // ): Text(""),
    //           )

        ],
      ),
    );
  }
}