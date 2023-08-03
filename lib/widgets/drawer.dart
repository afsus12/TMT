import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:tmt_mobile/controllers/globalcontroller.dart';
import 'package:tmt_mobile/controllers/homepagecontroller.dart';
import 'package:tmt_mobile/controllers/menucontroller.dart';
import 'package:tmt_mobile/controllers/myorganisationcontroller.dart';
import 'package:tmt_mobile/controllers/sidemenucontroller.dart';
import 'package:tmt_mobile/models/userdata.dart';
import 'package:tmt_mobile/screens/landingScreen.dart';
import 'package:tmt_mobile/utils/myColors.dart';
import 'package:tmt_mobile/utils/userPrefrences.dart';
import 'package:tmt_mobile/widgets/big_text.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SideMenu extends GetView<SideMenuController> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    bool _customTileExpanded = false;
    MyOrganisationController orgCon = Get.find<MyOrganisationController>();
    GlobalController global = Get.find<GlobalController>();
    Menucontroller mController = Get.find<Menucontroller>();

    return SafeArea(
        child: Container(
            child: ListTileTheme(
      textColor: Colors.white,
      iconColor: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
              width: 128.0,
              height: 128.0,
              margin: const EdgeInsets.only(
                top: 24.0,
                bottom: 20,
              ),
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: Colors.black26,
                shape: BoxShape.circle,
              ),
              child: SvgPicture.asset(
                "assets/logotmt.svg",
                fit: BoxFit.fill,
              )),
          BigText(
            text: "TMT/Track",
          ),
          SizedBox(
            height: screenHeight * 0.03,
          ),
          Divider(
            color: MyColors.inputcolorfill.withOpacity(0.4),
            indent: 40,
            endIndent: 40,
            thickness: 1,
            height: 0.6,
          ),
          SizedBox(
            height: screenHeight * 0.01,
          ),
          Obx(() => orgCon.orglist.isNotEmpty && orgCon.selectedOrgIndex != -1
              ? ListTile(
                  trailing: Icon(
                    Icons.circle,
                    color: Colors.green,
                    size: 18,
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 50),
                  title: Text(
                    "${orgCon.orglist[orgCon.selectedOrgIndex.value].name.toString()}",
                    style: TextStyle(
                        fontFamily: "aileron",
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                )
              : SizedBox.shrink()),
          Expanded(
            flex: 4,
            child: ListView(
              children: [
                ListTile(
                  onTap: () {
                    if (UserPrefrences.getCureentOrg() != "" &&
                        UserPrefrences.getCureentOrg() != null) {
                      mController.screenindex.value = 0;
                    } else {
                      Get.snackbar(
                        '',
                        '',
                        titleText: BigText(
                          text: global.lang.value == "fr"
                              ? "Non Autorisé"
                              : "UNAUTHORIZED",
                          size: 18,
                          color: MyColors.blackbackground2,
                        ),
                        messageText: Text(
                          global.lang.value == "fr"
                              ? "Vous devez d'abord choisir une organisation"
                              : "You need to choose an organisation first",
                          style: TextStyle(
                            fontSize: 17,
                          ),
                        ),
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: MyColors.BordersGrey.withOpacity(0.4),
                        overlayBlur: 1.5,
                      );
                    }
                  },
                  leading: Icon(Icons.view_timeline_rounded),
                  title: Text(
                      global.lang == "fr" ? "Saisie de temps" : 'Timesheet'),
                ),
                ListTile(
                  onTap: () {
                    mController.screenindex.value = 1;
                  },
                  leading: Icon(Icons.workspaces_rounded),
                  title: Text(global.lang == "fr"
                      ? "Mes Organisations"
                      : 'My Organisations'),
                ),
                ListTile(
                  onTap: () async {
                    final storage = new FlutterSecureStorage();
                    await storage.delete(key: "jwt");
                    await UserPrefrences.deleteAll();

                    await Get.deleteAll();
                    Get.lazyPut(() => GlobalController());
                    Get.offAll(LandingScreen());
                  },
                  leading: Icon(Icons.logout),
                  title: Text(global.lang == "fr" ? 'Déconnecter' : 'Log out'),
                ),
              ],
            ),
          ),
          Spacer(),
          DefaultTextStyle(
            style: TextStyle(
              fontSize: 12,
              color: Colors.white54,
            ),
            child: Container(
              margin: const EdgeInsets.symmetric(
                vertical: 16.0,
              ),
              child: Text('Terms of Service | Privacy Policy'),
            ),
          ),
        ],
      ),
    )));
  }
}
