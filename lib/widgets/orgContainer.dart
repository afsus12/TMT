import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:tmt_mobile/utils/myColors.dart';
import 'package:tmt_mobile/widgets/big_text.dart';

class OrgContainer extends StatelessWidget {
  final String name;
  final bool? clicked;
  final void Function()? clickme;
  const OrgContainer({Key? key, required this.name, this.clicked, this.clickme})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: clickme,
      child: Card(
        color: clicked == true ? MyColors.BordersGrey : Colors.white,
        elevation: 16,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(
                  color: clicked == true
                      ? MyColors.MainRedBig.withOpacity(0.8)
                      : Colors.transparent,
                  width: 2.5,
                  strokeAlign: BorderSide.strokeAlignCenter),
              borderRadius: BorderRadius.circular(20)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                child: Icon(
                  Icons.corporate_fare_rounded,
                  size: 40,
                ),
              ),
              SizedBox(
                height: screenHeight * 0.05,
              ),
              Text(
                name,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
