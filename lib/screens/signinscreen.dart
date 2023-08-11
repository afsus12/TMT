import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:tmt_mobile/controllers/ResetPasswordController.dart';
import 'package:tmt_mobile/controllers/globalcontroller.dart';
import 'package:tmt_mobile/controllers/menucontroller.dart';
import 'package:tmt_mobile/controllers/signincontroller.dart';
import 'package:tmt_mobile/models/userdata.dart';
import 'package:tmt_mobile/screens/MenuScreen.dart';
import 'package:tmt_mobile/screens/codeValidationScreen.dart';
import 'package:tmt_mobile/screens/resetPassword.dart';

import 'package:tmt_mobile/screens/signupscreen.dart';
import 'package:tmt_mobile/utils/utils.dart';
import 'package:tmt_mobile/widgets/buttonwithicon.dart';

import '../utils/myColors.dart';
import '../widgets/big_text.dart';
import '../widgets/inputfield.dart';

class SignInScreen extends GetView<SignInController> {
  const SignInScreen({Key? key}) : super(key: key);
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    GlobalController globalController = Get.find<GlobalController>();
    Get.put(SignInController(globalController));
    Future signin() async {
      bool valid = controller.SignInKey.currentState!.validate();
      if (valid) {
        userLogin user = new userLogin(
            email: controller.email.value.text,
            password: controller.password.value.text);
        var checklog = await controller.onSubmit(user);
        if (checklog == 1 &&
            globalController.appuser.value.isvalidated == true) {
          await Get.putAsync<Menucontroller>(() async => Menucontroller(),
              permanent: true);
          Menucontroller menuController = Get.find<Menucontroller>();
          menuController.screenindex.value = 1;
          Get.offAll(MenuScreen());
        } else if (checklog == 2 &&
            globalController.appuser.value.isvalidated == false) {
          Get.offAll(CodeValidationScreen());
        }
      }
    }

    return Scaffold(
        resizeToAvoidBottomInset:
            globalController.devType.value == "tablet" ? true : false,
        backgroundColor: Color(0xffffffff),
        body: globalController.devType.value == "tablet"
            ? signinscreenTablet(
                screenHeight, screenWidth, globalController, signin)
            : signinScreenAndroid(
                screenWidth, screenHeight, globalController, signin));
  }

  Padding signinScreenAndroid(double screenWidth, double screenHeight,
      GlobalController globalController, Future<dynamic> signin()) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * .05),
      child: Obx(
        () => SingleChildScrollView(
          child: Form(
            key: controller.SignInKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: screenHeight * .13,
                ),
                BigText(
                  text: globalController.lang.value == "fr"
                      ? "Accéder au compte"
                      : "Sign in",
                  color: Colors.black,
                  textAlign: TextAlign.left,
                  size: screenHeight * 0.038,
                ),
                SizedBox(
                  height: screenHeight * 0.04,
                ),
                SizedBox(
                    width: screenWidth * 0.90,
                    child: Myinput(
                      labelText: "email",
                      controller: controller.email.value,
                      icon: Icons.mail,
                      validate: (v) => v != null && !EmailValidator.validate(v)
                          ? 'entrer un email valide'
                          : null,
                    )),
                SizedBox(
                  height: screenWidth * 0.03,
                ),
                SizedBox(
                    width: screenWidth * 0.90,
                    child: Myinput(
                      labelText: globalController.lang.value == "fr"
                          ? "mot de passe"
                          : "password",
                      controller: controller.password.value,
                      obscureText: controller.passwtogg2.value,
                      icon: Icons.lock,
                      Suffixicon: Icons.visibility,
                      validate: (v) => controller.validateThese(v!),
                      Suffixiconoff: Icons.visibility_off,
                      suffixiconfun: () {
                        controller.passwtogg2.value =
                            !controller.passwtogg2.value;
                      },
                    )),
                SizedBox(
                  height: screenHeight * 0.02,
                ),
                Visibility(
                  visible: controller.showError.value,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                        child: Text(
                      controller.errormsg.value,
                      style: TextStyle(color: Colors.red, fontSize: 16),
                    )),
                  ),
                ),
                controller.loading.value == false
                    ? ButtonWithIcon(
                        onPressed: () async {
                          await signin();
                        },
                        text: globalController.lang.value == "fr"
                            ? "Se connecter"
                            : "Connect",
                        mainColor: MyColors.MainRedBig,
                        fontSize: 18,
                        textcolor: Colors.white,
                        width: screenWidth * 0.90,
                        height: screenHeight * 0.065,
                      )
                    : Center(
                        child: CircularProgressIndicator(
                        color: MyColors.thirdColor,
                      )),
                SizedBox(
                  height: screenWidth * 0.03,
                ),
                Center(
                    child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                            children: [
                              TextSpan(
                                text: globalController.lang.value == "fr"
                                    ? "Mot de passe oublié ?"
                                    : "Forgot password ?",
                                style: TextStyle(
                                  color: MyColors.BordersGrey,
                                ),
                              ),
                              TextSpan(
                                  recognizer: new TapGestureRecognizer()
                                    ..onTap = () {
                                      Get.to(ResetPasswordScreen());
                                    },
                                  text: globalController.lang.value == "fr"
                                      ? "Réinitialiser le mot de passe"
                                      : "Reset password",
                                  style: TextStyle(
                                      color: MyColors.thirdColor,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline)),
                            ]))),
                SizedBox(
                  height: screenWidth * 0.05,
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
                  Text(
                    globalController.lang.value == "fr" ? "ou" : "or",
                    style: TextStyle(fontSize: 18),
                  ),
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
                Center(
                  child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                          children: [
                            TextSpan(
                              text: globalController.lang.value == "fr"
                                  ? "Vous n'avez pas de compte?"
                                  : "Don't have an account?",
                              style: TextStyle(color: MyColors.BordersGrey),
                            ),
                            TextSpan(
                                recognizer: new TapGestureRecognizer()
                                  ..onTap = () => {Get.offAll(SignupScreen())},
                                text: globalController.lang.value == "fr"
                                    ? 'Inscrivez-vous.'
                                    : "Sign up",
                                style: TextStyle(color: MyColors.thirdColor)),
                          ])),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  SafeArea signinscreenTablet(double screenHeight, double screenWidth,
      GlobalController globalController, Future<dynamic> signin()) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Center(
          child: Obx(() => SingleChildScrollView(
                child: Form(
                    key: controller.SignInKey,
                    child: Container(
                        height: screenHeight * 0.6,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                          child: Center(
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                  color: MyColors.Strokecolor.withOpacity(0.2),
                                  indent: 10, //spacing at the start of divider
                                  endIndent: 10,
                                ),
                                SizedBox(width: screenWidth * 0.08),
                                SizedBox(
                                  width: screenWidth * 0.4,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: screenHeight * .04,
                                      ),
                                      BigText(
                                        text:
                                            globalController.lang.value == "fr"
                                                ? "Accéder au compte"
                                                : "Sign in",
                                        color: Colors.black,
                                        textAlign: TextAlign.left,
                                        size: screenHeight * 0.038,
                                      ),
                                      SizedBox(
                                        height: screenHeight * 0.03,
                                      ),
                                      SizedBox(
                                          width: screenWidth * 0.90,
                                          child: Myinput(
                                            labelText: "email",
                                            controller: controller.email.value,
                                            icon: Icons.mail,
                                            validate: (v) => v != null &&
                                                    !EmailValidator.validate(v)
                                                ? 'entrer un email valide'
                                                : null,
                                          )),
                                      SizedBox(
                                        height: screenHeight * 0.02,
                                      ),
                                      SizedBox(
                                          width: screenWidth * 0.90,
                                          child: Myinput(
                                            labelText:
                                                globalController.lang.value ==
                                                        "fr"
                                                    ? "mot de passe"
                                                    : "password",
                                            controller:
                                                controller.password.value,
                                            obscureText:
                                                controller.passwtogg2.value,
                                            icon: Icons.lock,
                                            Suffixicon: Icons.visibility,
                                            validate: (v) =>
                                                controller.validateThese(v!),
                                            Suffixiconoff: Icons.visibility_off,
                                            suffixiconfun: () {
                                              controller.passwtogg2.value =
                                                  !controller.passwtogg2.value;
                                            },
                                          )),
                                      SizedBox(
                                        height: screenHeight * 0.02,
                                      ),
                                      Visibility(
                                        visible: controller.showError.value,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Center(
                                              child: Text(
                                            controller.errormsg.value,
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 16),
                                          )),
                                        ),
                                      ),
                                      controller.loading == false
                                          ? ButtonWithIcon(
                                              onPressed: () async {
                                                await signin();
                                              },
                                              text:
                                                  globalController.lang.value ==
                                                          "fr"
                                                      ? "Se connecter"
                                                      : "Connect",
                                              mainColor: MyColors.MainRedBig,
                                              fontSize: 18,
                                              textcolor: Colors.white,
                                              width: screenWidth * 0.90,
                                              height: screenHeight * 0.065,
                                            )
                                          : Center(
                                              child: CircularProgressIndicator(
                                              color: MyColors.thirdColor,
                                            )),
                                      SizedBox(
                                        height: screenHeight * 0.02,
                                      ),
                                      Center(
                                          child: RichText(
                                              textAlign: TextAlign.center,
                                              text: TextSpan(
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16,
                                                  ),
                                                  children: [
                                                    TextSpan(
                                                      text: globalController
                                                                  .lang.value ==
                                                              "fr"
                                                          ? "Mot de passe oublié ?"
                                                          : "Forgot password ?",
                                                      style: TextStyle(
                                                        color: MyColors
                                                            .BordersGrey,
                                                      ),
                                                    ),
                                                    TextSpan(
                                                        recognizer:
                                                            new TapGestureRecognizer()
                                                              ..onTap = () =>
                                                                  Get.to(
                                                                      ResetPasswordScreen()),
                                                        text: globalController
                                                                    .lang
                                                                    .value ==
                                                                "fr"
                                                            ? "Réinitialiser le mot de passe"
                                                            : "Reset password",
                                                        style: TextStyle(
                                                            color: MyColors
                                                                .thirdColor,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            decoration:
                                                                TextDecoration
                                                                    .underline)),
                                                  ]))),
                                      SizedBox(
                                        height: screenHeight * 0.02,
                                      ),
                                      Row(children: <Widget>[
                                        Expanded(
                                            child: Divider(
                                          color:
                                              MyColors.Strokecolor.withOpacity(
                                                  0.5), //color of divider
                                          height: 5, //height spacing of divider
                                          thickness:
                                              2, //thickness of divier line
                                          indent:
                                              25, //spacing at the start of divider
                                          endIndent:
                                              25, //spacing at the end of divider
                                        )),
                                        Text(
                                          globalController.lang.value == "fr"
                                              ? "ou"
                                              : "or",
                                          style: TextStyle(fontSize: 18),
                                        ),
                                        Expanded(
                                            child: Divider(
                                          color:
                                              MyColors.Strokecolor.withOpacity(
                                                  0.5), //color of divider
                                          height: 5, //height spacing of divider
                                          thickness:
                                              2, //thickness of divier line
                                          indent:
                                              25, //spacing at the start of divider
                                          endIndent:
                                              25, //spacing at the end of divider
                                        )),
                                      ]),
                                      SizedBox(
                                        height: screenHeight * 0.02,
                                      ),
                                      Center(
                                        child: RichText(
                                            textAlign: TextAlign.center,
                                            text: TextSpan(
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                ),
                                                children: [
                                                  TextSpan(
                                                    text: globalController
                                                                .lang.value ==
                                                            "fr"
                                                        ? "Vous n'avez pas de compte?"
                                                        : "Don't have an account?",
                                                    style: TextStyle(
                                                        color: MyColors
                                                            .BordersGrey),
                                                  ),
                                                  TextSpan(
                                                      recognizer:
                                                          new TapGestureRecognizer()
                                                            ..onTap = () => {
                                                                  Get.offAll(
                                                                      SignupScreen())
                                                                },
                                                      text: globalController
                                                                  .lang.value ==
                                                              "fr"
                                                          ? 'Inscrivez-vous.'
                                                          : "Sign up",
                                                      style: TextStyle(
                                                          color: MyColors
                                                              .thirdColor)),
                                                ])),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ))),
              )),
        ),
      ),
    );
  }
}
