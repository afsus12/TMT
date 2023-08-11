import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tmt_mobile/controllers/globalcontroller.dart';
import 'package:tmt_mobile/controllers/myorganisationcontroller.dart';
import 'package:tmt_mobile/utils/myColors.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:tmt_mobile/widgets/drawer.dart';

import '../controllers/menucontroller.dart';

class MenuScreen extends GetView<Menucontroller> {
  const MenuScreen({Key? key}) : super(key: key);
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    double screenWidht = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final _advancedDrawerController = AdvancedDrawerController();

    GlobalController globalController = Get.find<GlobalController>();
    Get.put(MyOrganisationController(globalController));

    void _handleMenuButtonPressed() {
      // NOTICE: Manage Advanced Drawer state through the Controller.
      // _advancedDrawerController.value = AdvancedDrawerValue.visible();
      _advancedDrawerController.showDrawer();
    }

    return AdvancedDrawer(
      openRatio: globalController.devType == "tablet" ? 0.26 : 0.55,
      backdrop: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [MyColors.MainRedBig, MyColors.MainRedBig.withOpacity(0.8)],
          ),
        ),
      ),
      drawer: SideMenu(),
      controller: _advancedDrawerController,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 300),
      animateChildDecoration: true,
      rtlOpening: false,
      // openScale: 1.0,
      disabledGestures: false,
      childDecoration: const BoxDecoration(
          // NOTICE: Uncomment if you want to add shadow behind the page.
          // Keep in mind that it may cause animation jerks.
          // boxShadow: <BoxShadow>[
          //   BoxShadow(
          //     color: Colors.black12,
          //     blurRadius: 0.0,
          //   ),
          // ],
          borderRadius: const BorderRadius.all(Radius.circular(16))),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          actions: <Widget>[
            PopupMenuButton<String>(
              icon: Icon(
                Icons.language,
                color: Colors.white,
              ),
              onSelected: (String choice) {},
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem<String>(
                    value: "fr",
                    child: Text(
                      globalController.lang.value == "fr"
                          ? "Francais"
                          : "Frensh",
                      style: globalController.lang.value == "fr"
                          ? TextStyle(
                              fontWeight: FontWeight.bold,
                              color: MyColors.thirdColor)
                          : TextStyle(
                              fontWeight: FontWeight.normal,
                            ),
                    ),
                    onTap: () => globalController.lang.value = "fr",
                  ),
                  PopupMenuItem<String>(
                    value: "en",
                    child: Text(
                      globalController.lang.value == "fr"
                          ? "Anglais"
                          : "English",
                      style: globalController.lang.value == "en"
                          ? TextStyle(
                              fontWeight: FontWeight.bold,
                              color: MyColors.thirdColor)
                          : TextStyle(
                              fontWeight: FontWeight.normal,
                            ),
                    ),
                    onTap: () => globalController.lang.value = "en",
                  ),
                  // Add more menu items as needed
                ];
              },

              // do something
            )
          ],
          centerTitle: true,
          title: Obx(() => Text(controller.screenindex == 1
              ? globalController.lang == "fr"
                  ? "Mes Organisations"
                  : "My Organisations"
              : globalController.lang == "fr"
                  ? "Saisie de temps"
                  : "Timesheet")),
          backgroundColor: MyColors.MainRedBig,
          leading: IconButton(
            onPressed: _handleMenuButtonPressed,
            icon: ValueListenableBuilder<AdvancedDrawerValue>(
              valueListenable: _advancedDrawerController,
              builder: (_, value, __) {
                return AnimatedSwitcher(
                  duration: Duration(milliseconds: 250),
                  child: Icon(
                    value.visible ? Icons.clear : Icons.menu,
                    key: ValueKey<bool>(value.visible),
                  ),
                );
              },
            ),
          ),
        ),
        drawer: SideMenu(),
        body: Obx(() => Stack(
              children: [
                controller.Screens[controller.screenindex.value],
              ],
            )),
      ),
    );
  }
}
/* 
class BNBCustonPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    Path path = Path()..moveTo(0, 20);
    path.quadraticBezierTo(size.width * 0.20, 0, size.width * 0.35, 0);
    path.quadraticBezierTo(size.width * 0.40, 0, size.width * 0.40, 20);
    path.arcToPoint(Offset(size.width * 0.60, 20),
        radius: const Radius.circular(10.0), clockwise: false);
    path.quadraticBezierTo(size.width * 0.60, 0, size.width * 0.65, 0);
    path.quadraticBezierTo(size.width * 0.80, 0, size.width, 20);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawShadow(path, Colors.black, 8, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(BNBCustonPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(BNBCustonPainter oldDelegate) => false;
}
 */