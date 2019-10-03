import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ProductionTransferDetail extends StatelessWidget {
  final String title = 'Production Transfer Detail';
  @override
  Widget build(BuildContext context) {
    final List args = ModalRoute.of(context).settings.arguments;
    print(args);
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: Center(
          child: QrImage(
            data: args[0].toString(),
            version: QrVersions.auto,
            size: 300.0,
          ),
        )
    );
  }
}