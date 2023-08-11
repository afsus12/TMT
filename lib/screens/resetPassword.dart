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
import 'package:tmt_mobile/screens/landingScreen.dart';

import 'package:tmt_mobile/screens/signupscreen.dart';
import 'package:tmt_mobile/utils/userServices.dart';
import 'package:tmt_mobile/utils/utils.dart';
import 'package:tmt_mobile/widgets/buttonwithicon.dart';

import '../utils/myColors.dart';
import '../widgets/big_text.dart';
import '../widgets/inputfield.dart';

class ResetPasswordScreen extends GetView<ResetPasswordController> {
  const ResetPasswordScreen({Key? key}) : super(key: key);

  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    GlobalController globalController = Get.find<GlobalController>();
    Get.put(ResetPasswordController());

    return Scaffold(
        backgroundColor: Color(0xffffffff),
        body: globalController.devType.value == "tablet"
            ? restPasswordScreenTablet(
                screenHeight, screenWidth, globalController)
            : resetPasswordScreenAndroid(
                screenWidth, screenHeight, globalController));
  }

  Padding resetPasswordScreenAndroid(double screenWidth, double screenHeight,
      GlobalController globalController) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * .05),
      child: SingleChildScrollView(
        child: Obx(
          () => Form(
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
                      ? "Réinitialiser mot de passe"
                      : "Reset password",
                  color: Colors.black,
                  textAlign: TextAlign.left,
                  size: screenHeight * 0.038,
                ),
                SizedBox(
                  height: screenHeight * 0.04,
                ),
                Visibility(
                  visible: controller.EmailSent.value == false,
                  child: SizedBox(
                      width: screenWidth * 0.90,
                      child: Myinput(
                        labelText: "email",
                        controller: controller.email.value,
                        icon: Icons.mail,
                        validate: (v) =>
                            v != null && !EmailValidator.validate(v)
                                ? 'entrer un email valide'
                                : null,
                      )),
                ),
                Visibility(
                  visible: controller.EmailSent.value == true,
                  child: SizedBox(
                      width: screenWidth * 0.90,
                      child: Myinput(
                        labelText: globalController.lang.value == "fr"
                            ? "Code de validation"
                            : "validation number",
                        controller: controller.Codevalidation.value,
                        validate: (v) => v == ""
                            ? 'Code de validation est obligatoire'
                            : null,
                        icon: Icons.person,
                      )),
                ),
                SizedBox(
                  height: screenWidth * 0.03,
                ),
                Visibility(
                  visible: controller.EmailSent.value == true,
                  child: SizedBox(
                      width: screenWidth * 0.90,
                      child: Myinput(
                        labelText: globalController.lang.value == "fr"
                            ? "mot de passe"
                            : "Password",
                        controller: controller.password.value,
                        validate: (v) => controller.validatePasswordlen(v!),
                        obscureText: controller.passwtoggl.value,
                        icon: Icons.lock,
                        Suffixicon: Icons.visibility,
                        Suffixiconoff: Icons.visibility_off,
                        suffixiconfun: () {
                          controller.passwtoggl.value =
                              !controller.passwtoggl.value;
                        },
                      )),
                ),
                SizedBox(
                  height: screenWidth * 0.02,
                ),
                Visibility(
                  visible: controller.EmailSent.value == true,
                  child: SizedBox(
                      width: screenWidth * 0.90,
                      child: Myinput(
                        obscureText: controller.passwtogg2.value,
                        labelText: globalController.lang.value == "fr"
                            ? "confirmer le mot de passe"
                            : "Confirm password",
                        controller: controller.confirmpaswword.value,
                        validate: (v) => controller.validatePassword(
                            controller.password.value.text, v!),
                        icon: Icons.lock,
                        Suffixicon: Icons.visibility,
                        Suffixiconoff: Icons.visibility_off,
                        suffixiconfun: () {
                          controller.passwtogg2.value =
                              !controller.passwtogg2.value;
                        },
                      )),
                ),
                /*    SizedBox(
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
                              onChanged: (value) {
                                controller.showError.value = false;
                                final val = TextSelection.collapsed(
                                    offset: controller
                                        .password.value.text.length);
                                controller.password.value.selection = val;
                              },
                            )), */
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
                          bool valid =
                              controller.SignInKey.currentState!.validate();
                          if (valid) {
                            if (controller.EmailSent.value == false) {
                              await controller.sendResetPassword(
                                  controller.email.value.text);
                            } else {
                              await controller.changePassword(
                                  controller.email.value.text,
                                  controller.Codevalidation.value.text,
                                  controller.password.value.text);
                            }
                          }
                        },
                        text: controller.EmailSent.value == false
                            ? globalController.lang.value == "fr"
                                ? "Envoyer code de Recuperation"
                                : "Send Reset code"
                            : globalController.lang.value == "fr"
                                ? "changer mot de passe"
                                : "Change password",
                        mainColor: MyColors.MainRedBig,
                        fontSize: 18,
                        textcolor: Colors.white,
                        width: screenWidth * 0.90,
                        height: screenHeight * 0.065,
                      )
                    : Center(
                        child: CircularProgressIndicator(
                        color: MyColors.MainRedBig,
                      )),
                Visibility(
                  visible: controller.EmailSent.value == true,
                  child: TextButton(
                    onPressed: () async {
                      if (controller.loading == false) {
                        await controller
                            .sendResetPassword(controller.email.value.text);
                      }
                    },
                    child: Text(
                      globalController.lang.value == "fr"
                          ? "Renvoyer le code"
                          : "Resend the Code",
                      style: TextStyle(
                        fontSize: 17,
                        fontFamily: "aileron",
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.03,
                ),
                SizedBox(
                  height: screenHeight * 0.05,
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
                              text: globalController.lang.value == "fr"
                                  ? "Vous n'avez pas de compte?"
                                  : "Don't have an account?",
                              style: TextStyle(color: MyColors.BordersGrey),
                            ),
                            TextSpan(
                                recognizer: new TapGestureRecognizer()
                                  ..onTap = () => {Get.offAll(LandingScreen())},
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

  SafeArea restPasswordScreenTablet(double screenHeight, double screenWidth,
      GlobalController globalController) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Center(
          child: Obx(() => SingleChildScrollView(
                child: Form(
                    key: controller.SignInKey,
                    child: Container(
                        height: screenHeight * 0.8,
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
                                                ? "Réinitialiser mot de passe"
                                                : "Reset password",
                                        color: Colors.black,
                                        textAlign: TextAlign.left,
                                        size: screenHeight * 0.038,
                                      ),
                                      SizedBox(
                                        height: screenHeight * 0.03,
                                      ),
                                      Visibility(
                                        visible:
                                            controller.EmailSent.value == false,
                                        child: SizedBox(
                                            width: screenWidth * 0.90,
                                            child: Myinput(
                                              labelText: "email",
                                              controller:
                                                  controller.email.value,
                                              icon: Icons.mail,
                                              validate: (v) => v != null &&
                                                      !EmailValidator.validate(
                                                          v)
                                                  ? 'entrer un email valide'
                                                  : null,
                                            )),
                                      ),
                                      Visibility(
                                        visible:
                                            controller.EmailSent.value == false,
                                        child: SizedBox(
                                          height: screenHeight * 0.02,
                                        ),
                                      ),
                                      Visibility(
                                        visible:
                                            controller.EmailSent.value == true,
                                        child: SizedBox(
                                            width: screenWidth * 0.90,
                                            child: Myinput(
                                              labelText:
                                                  globalController.lang.value ==
                                                          "fr"
                                                      ? "Code de validation"
                                                      : "validation number",
                                              controller: controller
                                                  .Codevalidation.value,
                                              validate: (v) => v == ""
                                                  ? 'Code de validation est obligatoire'
                                                  : null,
                                              icon: Icons.person,
                                            )),
                                      ),
                                      Visibility(
                                        visible:
                                            controller.EmailSent.value == true,
                                        child: SizedBox(
                                          height: screenHeight * 0.02,
                                        ),
                                      ),
                                      Visibility(
                                        visible:
                                            controller.EmailSent.value == true,
                                        child: SizedBox(
                                            width: screenWidth * 0.90,
                                            child: Myinput(
                                              labelText:
                                                  globalController.lang.value ==
                                                          "fr"
                                                      ? "mot de passe"
                                                      : "Password",
                                              controller:
                                                  controller.password.value,
                                              validate: (v) => controller
                                                  .validatePasswordlen(v!),
                                              obscureText:
                                                  controller.passwtoggl.value,
                                              icon: Icons.lock,
                                              Suffixicon: Icons.visibility,
                                              Suffixiconoff:
                                                  Icons.visibility_off,
                                              suffixiconfun: () {
                                                controller.passwtoggl.value =
                                                    !controller
                                                        .passwtoggl.value;
                                              },
                                            )),
                                      ),
                                      Visibility(
                                        visible:
                                            controller.EmailSent.value == true,
                                        child: SizedBox(
                                          height: screenHeight * 0.02,
                                        ),
                                      ),
                                      Visibility(
                                        visible:
                                            controller.EmailSent.value == true,
                                        child: SizedBox(
                                            width: screenWidth * 0.90,
                                            child: Myinput(
                                              obscureText:
                                                  controller.passwtogg2.value,
                                              labelText: globalController
                                                          .lang.value ==
                                                      "fr"
                                                  ? "confirmer le mot de passe"
                                                  : "Confirm password",
                                              controller: controller
                                                  .confirmpaswword.value,
                                              validate: (v) =>
                                                  controller.validatePassword(
                                                      controller
                                                          .password.value.text,
                                                      v!),
                                              icon: Icons.lock,
                                              Suffixicon: Icons.visibility,
                                              Suffixiconoff:
                                                  Icons.visibility_off,
                                              suffixiconfun: () {
                                                controller.passwtogg2.value =
                                                    !controller
                                                        .passwtogg2.value;
                                              },
                                            )),
                                      ),
                                      Visibility(
                                        visible:
                                            controller.EmailSent.value == true,
                                        child: SizedBox(
                                          height: screenHeight * 0.02,
                                        ),
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
                                      Visibility(
                                        visible: controller.showError.value,
                                        child: SizedBox(
                                          height: screenHeight * 0.02,
                                        ),
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
                                      controller.loading.value == false
                                          ? ButtonWithIcon(
                                              onPressed: () async {
                                                bool valid = controller
                                                    .SignInKey.currentState!
                                                    .validate();
                                                if (valid) {
                                                  if (controller
                                                          .EmailSent.value ==
                                                      false) {
                                                    await controller
                                                        .sendResetPassword(
                                                            controller.email
                                                                .value.text);
                                                  } else {
                                                    await controller
                                                        .changePassword(
                                                            controller.email
                                                                .value.text,
                                                            controller
                                                                .Codevalidation
                                                                .value
                                                                .text,
                                                            controller.password
                                                                .value.text);
                                                  }
                                                }
                                              },
                                              text: controller
                                                          .EmailSent.value ==
                                                      false
                                                  ? globalController
                                                              .lang.value ==
                                                          "fr"
                                                      ? "Envoyer code de Recuperation"
                                                      : "Send Reset code"
                                                  : globalController
                                                              .lang.value ==
                                                          "fr"
                                                      ? "changer mot de passe"
                                                      : "Change password",
                                              mainColor: MyColors.MainRedBig,
                                              fontSize: 18,
                                              textcolor: Colors.white,
                                              width: screenWidth * 0.90,
                                              height: screenHeight * 0.065,
                                            )
                                          : Center(
                                              child: CircularProgressIndicator(
                                              color: MyColors.MainRedBig,
                                            )),
                                      Visibility(
                                        visible:
                                            controller.EmailSent.value == true,
                                        child: Center(
                                          child: TextButton(
                                            onPressed: () async {
                                              if (controller.loading == false) {
                                                await controller
                                                    .sendResetPassword(
                                                        controller
                                                            .email.value.text);
                                              }
                                            },
                                            child: Text(
                                              globalController.lang.value ==
                                                      "fr"
                                                  ? "Renvoyer le code"
                                                  : "Resend the Code",
                                              style: TextStyle(
                                                fontSize: 17,
                                                fontFamily: "aileron",
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: screenWidth * 0.03,
                                      ),
                                      Row(children: <Widget>[
                                        Expanded(
                                            child: Divider(
                                          color: MyColors
                                              .Strokecolor, //color of divider
                                          height: 5, //height spacing of divider
                                          thickness:
                                              3, //thickness of divier line
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
                                          color: MyColors
                                              .Strokecolor, //color of divider
                                          height: 5, //height spacing of divider
                                          thickness:
                                              3, //thickness of divier line
                                          indent:
                                              25, //spacing at the start of divider
                                          endIndent:
                                              25, //spacing at the end of divider
                                        )),
                                      ]),
                                      SizedBox(
                                        height: screenHeight * 0.01,
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
                                                                      LandingScreen())
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
