import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tmt_mobile/controllers/codevalidationcontroller.dart';
import 'package:tmt_mobile/controllers/globalcontroller.dart';
import 'package:tmt_mobile/controllers/menucontroller.dart';
import 'package:tmt_mobile/screens/MenuScreen.dart';
import 'package:tmt_mobile/screens/homePage.dart';
import 'package:tmt_mobile/utils/myColors.dart';
import 'package:tmt_mobile/widgets/buttonwithicon.dart';
import 'package:tmt_mobile/widgets/inputfield.dart';

class CodeValidationScreen extends StatelessWidget {
  const CodeValidationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    GlobalController globalController = Get.find<GlobalController>();
    Get.put(CodeValidationController(globalController));
    CodeValidationController controller = Get.find<CodeValidationController>();
    return Scaffold(
        appBar: AppBar(
          backgroundColor: MyColors.MainRedBig,
          centerTitle: true,
          title: Text("Validation"),
        ),
        backgroundColor: Color(0xffffffff),
        body: globalController.devType.value == "tablet"
            ? SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(50.0),
                  child: Center(
                    child: SizedBox(
                      width: screenWidth * 0.5,
                      child: Column(
                        children: [
                          SizedBox(
                            height: screenHeight * 0.060,
                          ),
                          Text(
                            globalController.lang.value == "fr"
                                ? "e-mail a été envoyé à ${globalController.appuser.value.email}"
                                : "Email was Sent to  ${globalController.appuser.value.email} ",
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: "aileron",
                            ),
                          ),
                          SizedBox(
                            height: screenHeight * 0.02,
                          ),
                          Text(
                            globalController.lang.value == "fr"
                                ? "Veuillez saisir le code de validation ci-dessous "
                                : "Please enter the validation code below ",
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: "aileron",
                            ),
                          ),
                          SizedBox(
                            height: screenHeight * 0.06,
                          ),
                          Myinput(
                              controller: controller.code.value,
                              validate: (v) => controller.validateThese(v!),
                              labelText: globalController.lang.value == "fr"
                                  ? "Code de Validation"
                                  : "Validation Code "),
                          SizedBox(
                            height: screenHeight * 0.04,
                          ),
                          Form(
                            key: controller.validCodeKey,
                            child: ButtonWithIcon(
                              mainColor: MyColors.MainRedBig,
                              fontSize: 18,
                              textcolor: Colors.white,
                              width: screenWidth * 0.90,
                              height: screenHeight * 0.065,
                              text: globalController.lang.value == "fr"
                                  ? "Valider"
                                  : "Validate",
                              onPressed: () async {
                                bool isValidate = controller
                                    .validCodeKey.currentState!
                                    .validate();
                                if (isValidate) {
                                  var checksub = await controller.onSubmit(
                                      globalController.appuser.value.email
                                          .toString(),
                                      controller.code.value.text);
                                  if (checksub == true) {
                                    await Get.putAsync<Menucontroller>(
                                        () async => Menucontroller(),
                                        permanent: true);
                                    Menucontroller menuController =
                                        Get.find<Menucontroller>();
                                    menuController.screenindex.value = 1;
                                    Get.offAll(MenuScreen());
                                  }
                                }
                              },
                            ),
                          ),
                          SizedBox(
                            height: screenHeight * 0.02,
                          ),
                          Visibility(
                              visible: controller.showError.value,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
                                child: Text(
                                  controller.errormsg.value,
                                  style: TextStyle(
                                      color: MyColors.MainRedBig, fontSize: 18),
                                ),
                              )),
                          TextButton(
                            onPressed: () async {
                              if (controller.loading == false) {
                                await controller.sendValidationCode(
                                    globalController.appuser.value.email!);
                              }
                            },
                            child: Text(
                              globalController.lang.value == "fr"
                                  ? "Renvoyer le code"
                                  : "Resend the Code",
                              style: TextStyle(
                                fontSize: 20,
                                fontFamily: "aileron",
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: screenHeight * 0.060,
                    ),
                    Text(
                      globalController.lang.value == "fr"
                          ? "e-mail a été envoyé ${globalController.appuser.value.email}"
                          : "Email was Sent to  ${globalController.appuser.value.email} ",
                      style: TextStyle(
                        fontSize: 17,
                        fontFamily: "aileron",
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.02,
                    ),
                    Text(
                      globalController.lang.value == "fr"
                          ? "Veuillez saisir le code de validation ci-dessous "
                          : "Please enter the validation code below ",
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: "aileron",
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.06,
                    ),
                    Myinput(
                        controller: controller.code.value,
                        validate: (v) => controller.validateThese(v!),
                        labelText: globalController.lang.value == "fr"
                            ? "Code de Validation"
                            : "Validation Code "),
                    SizedBox(
                      height: screenHeight * 0.04,
                    ),
                    Form(
                      key: controller.validCodeKey,
                      child: ButtonWithIcon(
                        mainColor: MyColors.MainRedBig,
                        fontSize: 18,
                        textcolor: Colors.white,
                        width: screenWidth * 0.90,
                        height: screenHeight * 0.065,
                        text: globalController.lang.value == "fr"
                            ? "Valider"
                            : "Validate",
                        onPressed: () async {
                          bool isValidate =
                              controller.validCodeKey.currentState!.validate();
                          if (isValidate) {
                            var checksub = await controller.onSubmit(
                                globalController.appuser.value.email.toString(),
                                controller.code.value.text);
                            if (checksub == true) {
                              await Get.putAsync<Menucontroller>(
                                  () async => Menucontroller(),
                                  permanent: true);
                              Menucontroller menuController =
                                  Get.find<Menucontroller>();
                              menuController.screenindex.value = 1;
                              Get.offAll(MenuScreen());
                            }
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.02,
                    ),
                    Visibility(
                        visible: controller.showError.value,
                        child: Text(controller.errormsg.value)),
                    TextButton(
                      onPressed: () async {
                        if (controller.loading == false) {
                          await controller.sendValidationCode(
                              globalController.appuser.value.email!);
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
                    )
                  ],
                ),
              ));
  }
}
