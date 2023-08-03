import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:tmt_mobile/controllers/globalcontroller.dart';
import 'package:tmt_mobile/screens/signinscreen.dart';
import 'package:tmt_mobile/screens/signupscreen.dart';

import 'package:tmt_mobile/utils/myColors.dart';
import 'package:tmt_mobile/utils/utils.dart';
import 'package:tmt_mobile/widgets/big_text.dart';
import 'package:tmt_mobile/widgets/buttonwithicon.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    Get.put(GlobalController());
    GlobalController globalController = Get.find<GlobalController>();
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: globalController.devType.value == "tablet"
            ? Center(
                child: Container(
                  height: screenHeight * 0.6,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: screenWidth * 0.4,
                          decoration: BoxDecoration(
                              color: Color(0xffffffff),
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                "assets/logotmt.svg",
                                fit: BoxFit.cover,
                                width: screenWidth * 0.30,
                              ),
                              SizedBox(
                                height: screenHeight * 0.03,
                              ),
                              BigText(
                                text: "TM/T Software ",
                                color: Colors.black,
                                size: 40,
                              ),
                              SizedBox(
                                height: screenHeight * 0.01,
                              ),
                              Center(
                                child: Text(
                                  "PILOTEZ VOS PROJETS AVEC LES BONS INDICATEURS  ",
                                  style: TextStyle(fontSize: 17),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.03),
                        VerticalDivider(
                          width: 7,
                          thickness: 2,
                          color: MyColors.Strokecolor.withOpacity(0.3),
                          indent: 10, //spacing at the start of divider
                          endIndent: 10,
                        ),
                        SizedBox(width: screenWidth * 0.08),
                        Container(
                          width: screenWidth * 0.35,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Obx(() => ButtonWithIcon(
                                      onPressed: () {
                                        Get.to(SignupScreen());
                                      },
                                      text: globalController.lang.value == "fr"
                                          ? "créer un compte"
                                          : "create an account",
                                      mainColor: Colors.white,
                                      urlimage: "assets/google.png",
                                      fontSize: 18,
                                      width: screenWidth * 0.90,
                                      height: screenHeight * 0.074,
                                    )),
                                SizedBox(
                                  height: screenHeight * 0.02,
                                ),
                                Row(children: <Widget>[
                                  Expanded(
                                      child: Divider(
                                    color: MyColors.Strokecolor.withOpacity(
                                        0.5), //color of divider
                                    height: 5, //height spacing of divider
                                    thickness: 1, //thickness of divier line
                                    indent:
                                        25, //spacing at the start of divider
                                    endIndent:
                                        25, //spacing at the end of divider
                                  )),
                                  Obx(() => Text(
                                        globalController.lang.value == "fr"
                                            ? "ou"
                                            : "or",
                                        style: TextStyle(fontSize: 18),
                                      )),
                                  Expanded(
                                      child: Divider(
                                    color: MyColors.Strokecolor.withOpacity(
                                        0.5), //color of divider
                                    height: 5, //height spacing of divider
                                    thickness: 1, //thickness of divier line
                                    indent:
                                        25, //spacing at the start of divider
                                    endIndent:
                                        25, //spacing at the end of divider
                                  )),
                                ]),
                                SizedBox(
                                  height: screenHeight * 0.02,
                                ),
                                Obx(() => ButtonWithIcon(
                                      onPressed: () {
                                        Get.to(SignInScreen());
                                      },
                                      text: globalController.lang.value == "fr"
                                          ? "se connecter"
                                          : "log in",
                                      mainColor: MyColors.MainRedBig,
                                      fontSize: 18,
                                      textcolor: Colors.white,
                                      width: screenWidth * 0.90,
                                      height: screenHeight * 0.074,
                                    )),
                                SizedBox(
                                  height: screenHeight * 0.03,
                                ),
                                Container(
                                  height: screenHeight * 0.05,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: (() => {
                                              globalController.lang.value =
                                                  "fr",
                                              print(
                                                  globalController.lang.value),
                                            }),
                                        child: CircleAvatar(
                                          child:
                                              Image.asset("assets/france.png"),
                                        ),
                                      ),
                                      SizedBox(
                                        width: screenWidth * 0.01,
                                      ),
                                      GestureDetector(
                                        onTap: () => {
                                          // ignore: avoid_print

                                          globalController.lang.value = "en",
                                          print(globalController.lang.value),
                                        },
                                        child: CircleAvatar(
                                          child: Image.asset(
                                              "assets/united-kingdom.png"),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ]),
                        )
                      ],
                    ),
                  ),
                ),
              )
            : Column(
                children: [
                  SizedBox(
                    height: screenHeight * 0.2,
                  ),
                  Image.asset(
                    "assets/logobig.jpg",
                    height: screenHeight * 0.29,
                  ),

                  /*  BigText(
              text: "TM/Track",
              color: Colors.black,
              size: screenHeight * 0.06,
            ), */

                  SizedBox(
                    height: screenHeight * 0.12,
                  ),
                  Obx(() => ButtonWithIcon(
                        onPressed: () {
                          Get.to(SignupScreen());
                        },
                        text: globalController.lang.value == "fr"
                            ? "créer un compte"
                            : "create an account",
                        mainColor: Colors.white,
                        urlimage: "assets/google.png",
                        fontSize: 18,
                        width: screenWidth * 0.90,
                        height: screenHeight * 0.074,
                      )),
                  SizedBox(
                    height: screenWidth * 0.02,
                  ),
                  Row(children: <Widget>[
                    Expanded(
                        child: Divider(
                      color: MyColors.Strokecolor, //color of divider
                      height: 5, //height spacing of divider
                      thickness: 3, //thickness of divier line
                      indent: 25, //spacing at the start of divider
                      endIndent: 25, //spacing at the end of divider
                    )),
                    Obx(() => Text(
                          globalController.lang.value == "fr" ? "ou" : "or",
                          style: TextStyle(fontSize: 18),
                        )),
                    Expanded(
                        child: Divider(
                      color: MyColors.Strokecolor, //color of divider
                      height: 5, //height spacing of divider
                      thickness: 3, //thickness of divier line
                      indent: 25, //spacing at the start of divider
                      endIndent: 25, //spacing at the end of divider
                    )),
                  ]),
                  SizedBox(
                    height: screenWidth * 0.02,
                  ),
                  Obx(() => ButtonWithIcon(
                        onPressed: () {
                          Get.to(SignInScreen());
                        },
                        text: globalController.lang.value == "fr"
                            ? "se connecter"
                            : "log in",
                        mainColor: MyColors.MainRedBig,
                        fontSize: 18,
                        textcolor: Colors.white,
                        width: screenWidth * 0.90,
                        height: screenHeight * 0.074,
                      )),
                  SizedBox(
                    height: screenWidth * 0.06,
                  ),
                  Container(
                    height: screenHeight * 0.05,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: (() => {
                                globalController.lang.value = "fr",
                                print(globalController.lang.value),
                              }),
                          child: CircleAvatar(
                            child: Image.asset("assets/france.png"),
                          ),
                        ),
                        SizedBox(
                          width: screenWidth * 0.02,
                        ),
                        GestureDetector(
                          onTap: () => {
                            // ignore: avoid_print

                            globalController.lang.value = "en",
                            print(globalController.lang.value),
                          },
                          child: CircleAvatar(
                            child: Image.asset("assets/united-kingdom.png"),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
