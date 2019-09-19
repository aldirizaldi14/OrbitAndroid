import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class ProductionOutputAddClass extends StatelessWidget {
  final String title = 'Production Output Add';
  static final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Column(
        children: <Widget>[
          formField(context, formKey),
          SizedBox(
            width: double.infinity,
            child: RaisedButton(
              color: Colors.blue,
              onPressed: () {
                if(formKey.currentState.validate()){
                  Navigator.pop(context);
                }
              },
              child: Text('Save', style: TextStyle(color: Colors.white),),
            ),
          ),
        ],
      )
    );
  }
}

Expanded formField(BuildContext context, GlobalKey formKey){
  return Expanded(
    child: SingleChildScrollView(
      padding: EdgeInsets.all(5),
      child: FormBuilder(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/barcode'),
              child: FormBuilderDropdown(
                attribute: "product_id",
                decoration: InputDecoration(labelText: "Product"),
                validators: [
                 FormBuilderValidators.required()
                ],
                readOnly: true,
                icon: Icon(FontAwesomeIcons.barcode),
                iconSize: 30,
                items: ['Product A', 'Product B', 'Product C']
                   .map((item) => DropdownMenuItem(
                   value: item,
                   child: Text(item.toString())
                )).toList(),
              ),
            ),
            FormBuilderDropdown(
              attribute: "line_id",
              decoration: InputDecoration(labelText: "Line"),
              validators: [
                FormBuilderValidators.required()
              ],
              items: ['Line 1', 'Line 2', 'Line 3']
                  .map((item) => DropdownMenuItem(
                  value: item,
                  child: Text(item.toString())
              )).toList(),
            ),
            FormBuilderDropdown(
              attribute: "shift",
              decoration: InputDecoration(labelText: "Shift"),
              validators: [
                FormBuilderValidators.required()
              ],
              items: ['A', 'B', 'C']
                  .map((item) => DropdownMenuItem(
                  value: item,
                  child: Text(item.toString())
              )).toList(),
            ),
            FormBuilderDropdown(
              attribute: "batch",
              decoration: InputDecoration(labelText: "Batch Time"),
              validators: [
                FormBuilderValidators.required()
              ],
              items: ['Hour to 1', 'Hour to 2', 'Hour to 3', 'Hour to 4', 'Hour to 5']
                  .map((item) => DropdownMenuItem(
                  value: item,
                  child: Text(item.toString())
              )).toList(),
            ),
            FormBuilderTextField(
              attribute: "quantity",
              decoration: InputDecoration(labelText: "Quantity"),
              keyboardType: TextInputType.number,
              validators: [
                FormBuilderValidators.required(),
                FormBuilderValidators.numeric()
              ],
            ),
          ],
        )
      ),
    ),
  );
}