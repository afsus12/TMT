import 'dart:convert';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:tmt_mobile/controllers/globalcontroller.dart';
import 'package:tmt_mobile/models/userdata.dart';
import 'package:tmt_mobile/utils/userPrefrences.dart';
import 'package:tmt_mobile/utils/userServices.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SignInController extends GetxController {
  final GlobalController global;
  SignInController(this.global);
  var SignInKey = GlobalKey<FormState>();
  var email = new TextEditingController().obs;
  var password = new TextEditingController().obs;
  var showError = false.obs;
  var errormsg = "Bad Credentials".obs;
  var passwtogg2 = true.obs;
  var loading = false.obs;
  var context = UserServices();
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

  Future<int> onSubmit(userLogin data) async {
    loading.value = true;
    var response = await context.login(data);
    if (response.statusCode == 200) {
      var temp = json.decode(response.body);
      global.appuser.value.email = temp["email"];
      global.appuser.value.token = temp["token"];
      global.appuser.value.isvalidated = true;
      global.appuser.value.guid = temp["guid"];
      print(temp);
      print(global.appuser.value.email);
      print(global.appuser.value.token);
      final storage = new FlutterSecureStorage();
      UserPrefrences.setUserEmail(global.appuser.value.email!);
      UserPrefrences.setUserGuid(global.appuser.value.guid!);
      UserPrefrences.setCureentOrg("");
      UserPrefrences.setCureentIsValid(global.appuser.value.isvalidated!);
      await storage.write(key: 'jwt', value: global.appuser.value.token);
// Write value

      return 1;
    } else if (response.statusCode == 402) {
      global.appuser.value.isvalidated = false;

      global.appuser.value.email = data.email;
      return 2;
    } else {
      loading.value = false;
     print(response.body );
      showError.value = true;
      errormsg.value = response.body.toString();
      return 0;
    }
  }

  String? validateThese(String c1) {
    if (c1.isEmpty || c1 == null) {
      return "le mot de passe est obligatoire";
    }
    return null;
  }

  @override
  void onInit() {
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

  @override
  // TODO: implement onDelete
  InternalFinalCallback<void> get onDelete => super.onDelete;
}
