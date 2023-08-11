import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:email_validator/email_validator.dart';

import 'package:flutter/material.dart';
import 'package:tmt_mobile/controllers/globalcontroller.dart';
import 'package:tmt_mobile/controllers/signupcontroller.dart';
import 'package:tmt_mobile/models/userdata.dart';
import 'package:tmt_mobile/screens/codeValidationScreen.dart';
import 'package:tmt_mobile/screens/signinscreen.dart';
import 'package:tmt_mobile/utils/utils.dart';
import 'package:tmt_mobile/widgets/big_text.dart';
import 'package:tmt_mobile/widgets/inputfield.dart';

import '../utils/myColors.dart';
import '../widgets/buttonwithicon.dart';

class SignupScreen extends GetView<SignUpController> {
  const SignupScreen({Key? key}) : super(key: key);

  validateForm() async {}

  @override
  Widget build(BuildContext context) {
    double screenWidht = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    GlobalController globalController = Get.find<GlobalController>();
    Future signup() async {
      print(controller.email.value.text);
      bool isValidate = controller.SignUpKey.currentState!.validate();

      if (isValidate) {
        var user = new userRegistration(
            email: controller.email.value.text,
            firstname: controller.nom.value.text,
            lastname: controller.prenom.value.text,
            password: controller.password.value.text);
        var checkReg = await controller.onSubmit(user);
        if (checkReg == true) {
          Get.offAll(CodeValidationScreen());
        }
      }
    }

    Get.put(SignUpController(globalController));
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      body: globalController.devType.value == "tablet"
          ? signupscreenTablet(
              screenHeight, screenWidht, globalController, signup)
          : signupscreenAndroid(
              screenWidht, screenHeight, globalController, signup),
    );
  }

  SafeArea signupscreenAndroid(double screenWidht, double screenHeight,
      GlobalController globalController, Future<dynamic> signup()) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidht * .05),
        child: SingleChildScrollView(
            child: Obx(
          () => Form(
            key: controller.SignUpKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: screenHeight * .14,
                ),
                BigText(
                  text: globalController.lang.value == "fr"
                      ? "créer un compte"
                      : "create an account",
                  color: Colors.black,
                  textAlign: TextAlign.left,
                  size: screenHeight * 0.038,
                ),
                SizedBox(
                  height: screenWidht * 0.06,
                ),
                SizedBox(
                  height: screenWidht * 0.02,
                ),
                SizedBox(
                    width: screenWidht * 0.90,
                    child: Myinput(
                      labelText: globalController.lang.value == "fr"
                          ? "Nom"
                          : "First Name",
                      controller: controller.nom.value,
                      validate: (v) => v == null ? 'nom est obligatoire' : null,
                      icon: Icons.person,
                    )),
                SizedBox(
                  height: screenWidht * 0.02,
                ),
                SizedBox(
                    width: screenWidht * 0.90,
                    child: Myinput(
                      labelText: globalController.lang.value == "fr"
                          ? "Prénom"
                          : "Last Name",
                      controller: controller.prenom.value,
                      validate: (v) =>
                          v == null ? 'prénom est obligatoire' : null,
                      icon: Icons.person,
                    )),
                SizedBox(
                  height: screenWidht * 0.02,
                ),
                SizedBox(
                    width: screenWidht * 0.90,
                    child: Myinput(
                      labelText: "Email",
                      controller: controller.email.value,
                      validate: (v) => v != null && !EmailValidator.validate(v)
                          ? 'Enter a valid email'
                          : null,
                      icon: Icons.mail,
                    )),
                SizedBox(
                  height: screenWidht * 0.02,
                ),
                SizedBox(
                    width: screenWidht * 0.90,
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
                SizedBox(
                  height: screenWidht * 0.02,
                ),
                SizedBox(
                    width: screenWidht * 0.90,
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
                SizedBox(
                  height: screenWidht * 0.04,
                ),
                controller.loading == false
                    ? ButtonWithIcon(
                        onPressed: () async {
                          await signup();
                        },
                        text: globalController.lang.value == "fr"
                            ? "S'inscrire"
                            : "Sign in",
                        mainColor: MyColors.MainRedBig,
                        fontSize: 18,
                        textcolor: Colors.white,
                        height: screenHeight * 0.065,
                      )
                    : Center(
                        child: CircularProgressIndicator(
                          color: MyColors.thirdColor,
                        ),
                      ),
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
                SizedBox(
                  height: screenHeight * 0.01,
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
                Center(
                  child: TextButton(
                      onPressed: () {
                        Get.offAll(SignInScreen());
                      },
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
                                      ? "Vous avez déjà un compte ?"
                                      : "Already have an account ?",
                                  style: TextStyle(color: MyColors.BordersGrey),
                                ),
                                TextSpan(
                                    text: globalController.lang.value == "fr"
                                        ? ' Connectez-vous.'
                                        : "Sign in",
                                    style:
                                        TextStyle(color: MyColors.thirdColor)),
                              ]))),
                )
              ],
            ),
          ),
        )),
      ),
    );
  }

  Center signupscreenTablet(double screenHeight, double screenWidht,
      GlobalController globalController, Future<dynamic> signup()) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
              height: screenHeight * 0.8,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: screenWidht * 0.4,
                      decoration: BoxDecoration(
                          color: Color(0xffffffff),
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: screenHeight * 0.06,
                          ),
                          SvgPicture.asset(
                            "assets/logotmt.svg",
                            fit: BoxFit.cover,
                            width: screenWidht * 0.30,
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
                    SizedBox(width: screenWidht * 0.03),
                    VerticalDivider(
                      width: 7,
                      thickness: 2,
                      color: MyColors.Strokecolor.withOpacity(0.3),
                      indent: 10, //spacing at the start of divider
                      endIndent: 10,
                    ),
                    SizedBox(width: screenWidht * 0.08),
                    Obx(
                      () => Form(
                        key: controller.SignUpKey,
                        child: Container(
                          width: screenWidht * 0.35,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: screenHeight * 0.01,
                              ),
                              BigText(
                                text: globalController.lang.value == "fr"
                                    ? "créer un compte"
                                    : "create an account",
                                color: Colors.black,
                                textAlign: TextAlign.left,
                                size: screenHeight * 0.038,
                              ),
                              SizedBox(
                                height: screenHeight * 0.02,
                              ),
                              SizedBox(
                                  width: screenWidht * 0.90,
                                  child: Myinput(
                                    labelText:
                                        globalController.lang.value == "fr"
                                            ? "Nom"
                                            : "First Name",
                                    controller: controller.nom.value,
                                    validate: (v) =>
                                        v == "" ? 'nom est obligatoire' : null,
                                    icon: Icons.person,
                                  )),
                              SizedBox(
                                height: screenWidht * 0.01,
                              ),
                              SizedBox(
                                  width: screenWidht * 0.90,
                                  child: Myinput(
                                    labelText:
                                        globalController.lang.value == "fr"
                                            ? "Prénom"
                                            : "Last Name",
                                    controller: controller.prenom.value,
                                    validate: (v) => v == ""
                                        ? 'prénom est obligatoire'
                                        : null,
                                    icon: Icons.person,
                                  )),
                              SizedBox(
                                height: screenWidht * 0.01,
                              ),
                              SizedBox(
                                  width: screenWidht * 0.90,
                                  child: Myinput(
                                    labelText: "Email",
                                    controller: controller.email.value,
                                    validate: (v) =>
                                        v != null && !EmailValidator.validate(v)
                                            ? 'Enter a valid email'
                                            : null,
                                    icon: Icons.mail,
                                  )),
                              SizedBox(
                                height: screenWidht * 0.01,
                              ),
                              SizedBox(
                                  width: screenWidht * 0.90,
                                  child: Myinput(
                                    labelText:
                                        globalController.lang.value == "fr"
                                            ? "mot de passe"
                                            : "Password",
                                    controller: controller.password.value,
                                    validate: (v) =>
                                        controller.validatePasswordlen(v!),
                                    obscureText: controller.passwtoggl.value,
                                    icon: Icons.lock,
                                    Suffixicon: Icons.visibility,
                                    Suffixiconoff: Icons.visibility_off,
                                    suffixiconfun: () {
                                      controller.passwtoggl.value =
                                          !controller.passwtoggl.value;
                                    },
                                  )),
                              SizedBox(
                                height: screenWidht * 0.01,
                              ),
                              SizedBox(
                                  width: screenWidht * 0.90,
                                  child: Myinput(
                                    obscureText: controller.passwtogg2.value,
                                    labelText:
                                        globalController.lang.value == "fr"
                                            ? "confirmer le mot de passe"
                                            : "Confirm password",
                                    controller:
                                        controller.confirmpaswword.value,
                                    validate: (v) =>
                                        controller.validatePassword(
                                            controller.password.value.text, v!),
                                    icon: Icons.lock,
                                    Suffixicon: Icons.visibility,
                                    Suffixiconoff: Icons.visibility_off,
                                    suffixiconfun: () {
                                      controller.passwtogg2.value =
                                          !controller.passwtogg2.value;
                                    },
                                  )),
                              SizedBox(
                                height: screenWidht * 0.01,
                              ),
                              controller.loading == false
                                  ? ButtonWithIcon(
                                      onPressed: () async => await signup(),
                                      text: globalController.lang.value == "fr"
                                          ? "S'inscrire"
                                          : "Sign in",
                                      mainColor: MyColors.MainRedBig,
                                      fontSize: 18,
                                      textcolor: Colors.white,
                                      height: screenHeight * 0.065,
                                    )
                                  : Center(
                                      child: CircularProgressIndicator(
                                          color: MyColors.thirdColor),
                                    ),
                              SizedBox(
                                height: screenHeight * 0.01,
                              ),
                              Row(children: <Widget>[
                                Expanded(
                                    child: Divider(
                                  color: MyColors.Strokecolor.withOpacity(
                                      0.3), //color of divider
                                  height: 5, //height spacing of divider
                                  thickness: 2, //thickness of divier line
                                  indent: 25, //spacing at the start of divider
                                  endIndent: 25, //spacing at the end of divider
                                )),
                                Text(
                                  globalController.lang.value == "fr"
                                      ? "ou"
                                      : "or",
                                  style: TextStyle(fontSize: 18),
                                ),
                                Expanded(
                                    child: Divider(
                                  color: MyColors.Strokecolor.withOpacity(
                                      0.3), //color of divider
                                  height: 5, //height spacing of divider
                                  thickness: 2, //thickness of divier line
                                  indent: 25, //spacing at the start of divider
                                  endIndent: 25, //spacing at the end of divider
                                )),
                              ]),
                              Center(
                                child: TextButton(
                                    onPressed: () {
                                      Get.offAll(SignInScreen());
                                    },
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
                                                    ? "Vous avez déjà un compte ?"
                                                    : "Already have an account ?",
                                                style: TextStyle(
                                                    color:
                                                        MyColors.BordersGrey),
                                              ),
                                              TextSpan(
                                                  text: globalController
                                                              .lang.value ==
                                                          "fr"
                                                      ? ' Connectez-vous.'
                                                      : "Sign in",
                                                  style: TextStyle(
                                                      color:
                                                          MyColors.thirdColor)),
                                            ]))),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
