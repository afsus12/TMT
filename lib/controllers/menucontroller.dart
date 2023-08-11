import 'package:get/get.dart';
import 'package:tmt_mobile/controllers/globalcontroller.dart';
import 'package:tmt_mobile/controllers/myorganisationcontroller.dart';
import 'package:tmt_mobile/screens/MyOrganisationScreen.dart';
import 'package:tmt_mobile/screens/homePage.dart';

class Menucontroller extends GetxController {
  var Screens = [HomePage(), MyOrganisationScreen()].obs;
  var screenindex = 0.obs;

  @override
  void onInit() async {
    super.onInit();
  }
}
