import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:tmt_mobile/controllers/globalcontroller.dart';
import 'package:tmt_mobile/models/userdata.dart';
import 'package:tmt_mobile/utils/userServices.dart';

class SignUpController extends GetxController {
  final GlobalController global;
  SignUpController(this.global);
  var SignUpKey = GlobalKey<FormState>();
  var context = UserServices();
  var showError = false.obs;
  var errormsg = "Bad Credentials".obs;
  var email = new TextEditingController().obs;
  var password = new TextEditingController().obs;
  var nom = new TextEditingController().obs;
  var prenom = new TextEditingController().obs;
  var passwtoggl = true.obs;
  var passwtogg2 = true.obs;
  var loading = false.obs;
  var confirmpaswword = new TextEditingController().obs;
  String? validateThese(String c1) {
    if (c1.isEmpty || c1 == null) {
      return "This field can't be empty";
    }
    return null;
  }

  Future<bool> onSubmit(userRegistration data) async {
    loading.value = true;

    var response = await context.registration(data);
    if (response.statusCode == 200) {
      var temp = json.decode(response.body);
      print(temp);
      global.appuser.value.email = temp["email"];
      global.appuser.value.token = temp["token"];
      global.appuser.value.isvalidated = false;
      global.appuser.value.guid = temp["guid"];

      final storage = new FlutterSecureStorage();
      await storage.write(
          key: 'valid', value: global.appuser.value.isvalidated.toString());
      await storage.write(key: 'jwt', value: global.appuser.value.token);
// Write value

      return true;
    } else {
      loading.value = false;

      showError.value = true;
      errormsg.value = response.body.toString();
      return false;
    }
  }

  @override
  void onInit() {
    passwtoggl.value = true;
    passwtogg2.value = true;

    super.onInit();
  }

  String? validateEmail(String c1) {
    if (c1.isEmpty || c1 == null) {
      return "This field can't be empty";
    } else if (c1.contains("@") == false) {
      return "Verify email field";
    }
    return null;
  }

  String? validatePasswordlen(String c1) {
    if (c1.isEmpty || c1 == null) {
      return "mot de passe est obiligatoire";
    } else if (c1.length < 6) {
      return "minimum 6";
    }
    return null;
  }

  String? validatePassword(String c1, c2) {
    if (c2.isEmpty || c2 == null) {
      return "Confirmation mot de passe est obiligatoire";
    } else if (c1 != c2) {
      return "Les mots de passe ne correspondent pas";
    }
    return null;
  }

  String? validatePhone(String c1) {
    if (!c1.isPhoneNumber) {
      return "Incorrect format";
    }
    return null;
  }
}
