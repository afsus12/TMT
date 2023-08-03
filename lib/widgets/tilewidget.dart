import 'package:flutter/cupertino.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';

class TileWidget extends StatelessWidget {
  final IconData? icon;
  final String name;
  final double? Iconsize;
  final double? Fontsize;
  final Function()? onPressed;
  const TileWidget(
      {Key? key,
      this.icon,
      this.name = "",
      this.Fontsize,
      this.Iconsize,
      this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPressed,
      contentPadding: EdgeInsets.all(0),
      horizontalTitleGap: 0,
      visualDensity: VisualDensity(horizontal: 0, vertical: -4),
      leading: Icon(
        icon,
        size: Iconsize,
        color: Colors.black87,
      ),
      title: Text(
        name,
        style: TextStyle(fontWeight: FontWeight.w500, fontSize: Fontsize),
      ),
      trailing: Icon(
        Icons.navigate_next_outlined,
        size: Iconsize,
        color: Colors.black87,
      ),
    );
  }
}
