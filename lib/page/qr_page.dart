import 'package:flutter/material.dart';

import 'package:qr_flutter/qr_flutter.dart';

class QrPage extends StatefulWidget {
  const QrPage({Key? key}) : super(key: key);
  @override
  _QrPage createState() => _QrPage();
}

class _QrPage extends State<QrPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PigPlan'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Text('Qr scan',)
        ],
      ),
    );

  }




}