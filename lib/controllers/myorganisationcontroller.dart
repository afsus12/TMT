import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:tmt_mobile/controllers/globalcontroller.dart';
import 'package:tmt_mobile/controllers/homepagecontroller.dart';
import 'package:tmt_mobile/models/userdata.dart';
import 'package:tmt_mobile/screens/landingScreen.dart';
import 'package:tmt_mobile/utils/userPrefrences.dart';
import 'package:tmt_mobile/utils/userServices.dart';

class MyOrganisationController extends GetxController {
  final GlobalController global;
  MyOrganisationController(this.global);

  RxInt selectedOrgIndex = (-1).obs;
  RxList<organisation> orglist = <organisation>[].obs;
  var context = UserServices();
  Future getUserOrg() async {
    var response =
        await context.getAllOrgs(global.appuser.value.email.toString());
    if (response.statusCode == 200) {
      var temp = json.decode(response.body);

      var index = 0;
      if (temp != null && temp != []) {
        for (var a in temp) {
          print(a);

          if (a["guid"] == global.appuser.value.organisation) {
            selectedOrgIndex.value = index;
          }

          orglist.add(new organisation(
            guid: a["guid"],
            name: a["name"],
          ));
          index++;
        }
      }
    } else {
      orglist.clear();
      orglist.refresh();
    }
  }

  Future selectedOrg(String guid, int index) async {
    if (index != selectedOrgIndex.value) {
      var response = await context.getOneOrg(guid);
      if (response.statusCode == 200) {
        var temp = json.decode(response.body);
        global.appuser.value.guid = temp["guid"];
        global.appuser.value.organisation = guid;
        global.appuser.value.token = temp["token"];
        final storage = new FlutterSecureStorage();
        UserPrefrences.setUserEmail(global.appuser.value.email!);
        UserPrefrences.setUserGuid(global.appuser.value.guid!);
        UserPrefrences.setCureentOrg(guid);
        await storage.write(key: 'jwt', value: temp["token"]);

        selectedOrgIndex.value = index;
        Get.delete<HomePageController>();
        await Get.putAsync<HomePageController>(
          () async => HomePageController(),
        );
        selectedOrgIndex.refresh();
      } else if (response.statusCode == 400 ||
          response.statusCode == 401 ||
          response.statusCode == 500) {
        Get.offAll(LandingScreen());
      }
    }
  }

  @override
  void onInit() async {
    await getUserOrg();
    super.onInit();
  }
}
