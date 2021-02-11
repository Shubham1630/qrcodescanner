// Create a Form widget.






import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qr_barcode_scanner/ui/showGeneratedCode.dart';

class URLBarcode extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}


class MyCustomFormState extends State<URLBarcode> {
  bool generateBarcode = false;

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
          Padding(padding: EdgeInsets.all(25),
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

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
                  child:
                  Text('Generate'),
                ),
              ],

            ),


        ],
      ),
    );
  }
}