import '../utils/myColors.dart';
import 'package:flutter/material.dart';

class ButtonWithIcon extends StatelessWidget {
  final String text;
  final Color mainColor;
  final String urlimage;
  final Color? textcolor;
  final double? fontSize;
  final Function? onPressed;
  final double? width;
  final double? height;
  const ButtonWithIcon(
      {this.text = "",
      this.onPressed,
      this.height,
      this.width,
      this.urlimage = "",
      this.textcolor = const Color(0xff5449FF),
      this.mainColor = const Color(0xff5449FF),
      Key? key,
      this.fontSize = 18})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidht = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return InkWell(
        onTap: onPressed as void Function()?,
        child: Container(
          padding: EdgeInsets.all(8.0),
          decoration: urlimage != ""
              ? BoxDecoration(
                  borderRadius: BorderRadius.circular(13),
                  border: Border.all(
                    color: MyColors.BordersGrey,
                    width: 0.8,
                  ),
                  color: mainColor)
              : BoxDecoration(
                  borderRadius: BorderRadius.circular(13),
                  color: mainColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
          width: width, //screenWidht * 0.86,
          height: height, //screenWidht * 0.15,
          child: urlimage != ""
              ? Center(
                  child: Text(text,
                      style: TextStyle(
                          fontSize: fontSize,
                          color: textcolor,
                          fontFamily: "Roboto",
                          fontWeight: FontWeight.bold)),
                )
              : Center(
                  child: Text(
                  text,
                  style: TextStyle(
                      fontSize: fontSize,
                      color: textcolor,
                      fontFamily: "Roboto",
                      fontWeight: FontWeight.bold),
                )),
        ));
  }
}
