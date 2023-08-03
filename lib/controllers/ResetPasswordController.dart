import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:tmt_mobile/screens/landingScreen.dart';
import 'package:tmt_mobile/utils/userServices.dart';

class ResetPasswordController extends GetxController {
  var SignInKey = GlobalKey<FormState>();

  var email = new TextEditingController().obs;
  var password = new TextEditingController().obs;
  var confirmpassword = new TextEditingController().obs;
  var showError = false.obs;
  var EmailSent = false.obs;
  var Codevalidation = new TextEditingController().obs;
  var confirmpaswword = new TextEditingController().obs;
  var errormsg = "Bad Credentials".obs;
  var passwtoggl = true.obs;

  var passwtogg2 = true.obs;
  var loading = false.obs;
  var context = UserServices();
  Future sendResetPassword(String email) async {
    loading.value = true;
    var response = await context.sendResetCode(email);
    if (response.statusCode == 200) {
      EmailSent.value = true;
    } else {
      errormsg.value = "email n'existe pas";
      showError.value = true;
    }
    loading.value = false;
  }

  Future changePassword(String email, String code, String passwrod) async {
    loading.value = true;
    var response = await context.changepassword(email, code, passwrod);
    if (response.statusCode == 200) {
      Get.offAll(LandingScreen());
    } else {
      errormsg.value = "code validation est incorrect ou expiré";
      showError.value = true;
    }
    loading.value = false;
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

  String? validateEmail(String c1) {
    if (c1.isEmpty || c1 == null) {
      return "This field can't be empty";
    } else if (c1.contains("@") == false) {
      return "Verify email field";
    }
    return null;
  }
}
