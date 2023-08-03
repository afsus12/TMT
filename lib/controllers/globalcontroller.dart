import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

import 'package:get/get.dart';
import 'package:tmt_mobile/models/userdata.dart';
import 'package:tmt_mobile/utils/userPrefrences.dart';
import 'package:tmt_mobile/utils/utils.dart';

class GlobalController extends GetxController {
  var appuser = new appUser().obs;

  @override
  void onInit() async {
    devType.value = getDeviceType();
    if (UserPrefrences.getUserEmail() != "") {
      appuser.value.email = UserPrefrences.getUserEmail();
      appuser.value.guid = UserPrefrences.getUserGuid();
      appuser.value.isvalidated = UserPrefrences.getCureentIsValid();
      appuser.value.organisation = UserPrefrences.getCureentOrg();
    }
    super.onInit();
  }

  RxString devType = "phone".obs;
  var lang = "fr".obs;
}
