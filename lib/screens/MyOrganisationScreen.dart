import 'package:flutter/material.dart';
import 'package:tmt_mobile/controllers/globalcontroller.dart';
import 'package:tmt_mobile/controllers/menucontroller.dart';
import 'package:tmt_mobile/controllers/myorganisationcontroller.dart';
import 'package:get/get.dart';
import 'package:tmt_mobile/widgets/orgContainer.dart';

class MyOrganisationScreen extends StatelessWidget {
  const MyOrganisationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    GlobalController global = Get.find<GlobalController>();
    Get.put(MyOrganisationController(global));
    MyOrganisationController controller = Get.find<MyOrganisationController>();
    return global.devType.value == "tablet"
        ? organisationScreenTablet(controller, global)
        : organisationScreenAndroid(controller, global);
  }

  Padding organisationScreenAndroid(
      MyOrganisationController controller, GlobalController global) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Obx(() => controller.orglist.isNotEmpty
          ? GridView.builder(
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
              itemBuilder: (context, index) => Obx(
                () => OrgContainer(
                    name: controller.orglist[index].name.toString(),
                    clicked: index == controller.selectedOrgIndex.value,
                    clickme: () async {
                      var name = controller.orglist[index].guid.toString();
                      await controller.selectedOrg(name, index);
                    }),
              ),
              itemCount: controller.orglist.length,
            )
          : SizedBox(
              child: Text(
                global.lang == "fr"
                    ? "Vous n’appartenez à aucune organisation, veuillez contacter votre organisation"
                    : "You dont belong to any organistation please contact your organisation",
              ),
            )),
    );
  }

  Padding organisationScreenTablet(
      MyOrganisationController controller, GlobalController global) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Obx(() => controller.orglist.isNotEmpty
          ? GridView.builder(
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7),
              itemBuilder: (context, index) => Obx(
                () => OrgContainer(
                    name: controller.orglist[index].name.toString(),
                    clicked: index == controller.selectedOrgIndex.value,
                    clickme: () async {
                      var name = controller.orglist[index].guid.toString();
                      await controller.selectedOrg(name, index);
                    }),
              ),
              itemCount: controller.orglist.length,
            )
          : Center(
              child: Text(
                global.lang == "fr"
                    ? "Vous n’appartenez à aucune organisation, veuillez contacter votre organisation"
                    : "You dont belong to any organistation please contact your organisation",
                style: TextStyle(color: Colors.black, fontSize: 25),
              ),
            )),
    );
  }
}
