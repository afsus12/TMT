import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:tmt_mobile/controllers/globalcontroller.dart';
import 'package:tmt_mobile/utils/myColors.dart';
import 'package:tmt_mobile/utils/userServices.dart';
import 'package:tmt_mobile/widgets/big_text.dart';

class CodeValidationController extends GetxController {
  final GlobalController global;
  CodeValidationController(this.global);
  var validCodeKey = GlobalKey<FormState>();
  var code = new TextEditingController().obs;
  var errormsg = "Bad Credentials".obs;
  var context = UserServices();
  var showError = false.obs;
  var loading = false.obs;
  String? validateThese(String c1) {
    if (c1.isEmpty || c1 == null) {
      return "This field can't be empty";
    }
    return null;
  }

  Future sendValidationCode(String email) async {
    loading.value = true;
    var response = await context.sendValidationCode(email);
    if (response.statusCode == 200) {
      Get.snackbar(
        '',
        '',
        titleText: BigText(
          text: global.lang.value == "fr" ? "Succès" : "Success",
          size: 18,
          color: Colors.green,
        ),
        messageText: Text(
          global.lang.value == "fr"
              ? " code de validation envoyé avec succès"
              : "validation code sent Successfully!",
          style: TextStyle(
            fontSize: 17,
          ),
        ),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: MyColors.BordersGrey.withOpacity(0.4),
        duration: const Duration(seconds: 1),
        overlayBlur: 0.7,
      );
      loading.value = false;
    }
  }

  Future<bool> onSubmit(String email, String code) async {
    loading.value = true;
    var response = await context.confirmation(email, code);
    if (response.statusCode == 200) {
      var temp = json.decode(response.body);
      global.appuser.value.email = temp["email"];
      global.appuser.value.token = temp["token"];
      global.appuser.value.isvalidated = true;
      global.appuser.value.guid = temp["guid"];
      final storage = new FlutterSecureStorage();
      await storage.write(key: 'jwt', value: global.appuser.value.token);
      return true;
    } else {
      errormsg.value = response.body;
      showError.value = true;
      return false;
    }
  }
}
