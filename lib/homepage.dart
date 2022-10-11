import 'package:ads_firebase/ads_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  final AdController _adController = Get.put(AdController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              _adController.getAdsData();
            },
            child: Text("Add"),
          )
        ],
      ),
    );
  }
}
