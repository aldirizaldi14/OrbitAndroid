import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ProductionTransferDetail extends StatelessWidget {
  final String title = 'Production Transfer Detail';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: Center(
          child: QrImage(
            data: "HelloWorld",
            version: QrVersions.auto,
            size: 200.0,
          ),
        )
    );
  }
}