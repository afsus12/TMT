import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tmt_mobile/controllers/signincontroller.dart';
import 'package:tmt_mobile/models/imputation.dart';
import 'package:tmt_mobile/models/project.dart';
import 'package:tmt_mobile/models/projectLot.dart';
import 'package:tmt_mobile/models/projetTasks.dart';
import 'package:tmt_mobile/screens/landingScreen.dart';
import 'package:tmt_mobile/utils/myColors.dart';
import 'package:tmt_mobile/utils/userServices.dart';
import 'package:tmt_mobile/widgets/big_text.dart';

class HomePageController extends GetxController {
  var hidden = true.obs;
  var homeKey = GlobalKey<FormState>();
  var context = UserServices();
  var listviewload = false.obs;
  var loadproject = false.obs;
  var loadlots = false.obs;
  var loadtasks = false.obs;
  var toggleHide = false.obs;
  DateTime a = DateTime.now();
  var toggleController = 0.obs;
  Future onChangeProject(int id) async {
    loadlots.value = true;
    loadtasks.value = true;
    listphase.clear();
    listtache.clear();

    await getProjectlots(id);
    listphase.refresh();
    loadlots.value = false;
    facetController.value = listphase.isNotEmpty
        ? listphase[0] as ProjectLot
        : new ProjectLot(id: -1, idprojet: -1, name: "");
    facetController.refresh();

    await getProjecttasks(facetController.value.id);
    listtache.refresh();

    tacheController.value = listtache.isNotEmpty
        ? listtache[0] as ProjectTasks
        : new ProjectTasks(id: -1, idprojetlot: -1, name: "");
    tacheController.refresh();
    loadtasks.value = false;
  }

  Future onChangeProjectlot(int id) async {
    listtache.clear();
    loadtasks.value = true;

    await getProjecttasks(
        id); // Fetch project tasks for the selected project lot ID

    // Check if listtache is not empty before assigning to tacheController
    if (listtache.isNotEmpty) {
      // Assign the first item from the listtache to tacheController
      tacheController.value = listtache[0];
    } else {
      // If listtache is empty, create a default ProjectTasks object and assign it to tacheController
      tacheController.value = ProjectTasks(id: -1, idprojetlot: -1, name: "");
    }

    loadtasks.value = false;
  }

  Future getProjecttasks(int projectlotid) async {
    var response = await context.getProjectsTasks(projectlotid);
    print(response.statusCode);
    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        var temp = json.decode(response.body);
        for (var element in temp) {
          var a = new ProjectTasks(
              id: element["id"],
              idprojetlot: element["projectLotId"],
              name: element["name"]);
          listtache.add(a);
        }
      } else {
        print("clear");
        print("yyyyyyyyyyyy");
        listtache.value = [];
      }
    } /* else {
      Get.offAll(LandingScreen());
    } */
  }

  Future deleteTimesheet(int id) async {
    await context.deleteTimesheet(id);
  }

  Future getProjectlots(int projectid) async {
    print(projectid);
    var response = await context.getProjectslots(projectid);
    print("response " + response.statusCode.toString());
    print(response.statusCode);
    if (response.statusCode == 200) {
      var temp = json.decode(response.body);

      for (var element in temp) {
        var a = new ProjectLot(
            id: element["id"],
            idprojet: element["projectId"],
            name: element["name"]);
        listphase.add(a);
      }
    } /* else {
      Get.offAll(LandingScreen());
    } */
  }

  Future getProjects() async {
    var response = await context.getProjects();
    print(response.statusCode);
    if (response.statusCode == 200 && response.body.isNotEmpty) {
      var temp = json.decode(response.body);

      for (var element in temp) {
        var a = new Project(id: element["id"], name: element["name"]);
        listproject.add(a);
      }

      projetController.value = listproject[0];
      await getProjectlots(projetController.value.id);

      facetController.value = listphase.isNotEmpty
          ? listphase[0] as ProjectLot
          : new ProjectLot(id: -1, idprojet: -1, name: "");
      await getProjecttasks(facetController.value.id);

      tacheController.value = listtache.isNotEmpty
          ? listtache[0] as ProjectTasks
          : new ProjectTasks(id: -1, idprojetlot: -1, name: "");
    } /* else {
      Get.offAll(LandingScreen());
    } */
  }

  Future getTimesheets(DateTime date) async {
    listviewload.value = true;
    var response = await context.getTimesheet(date);
    print(response.statusCode);
    if (response.statusCode == 200) {
      imputationlist.clear();
      var temp = json.decode(response.body);
      if (temp != [] && response.body.isNotEmpty) {
        for (var element in temp) {
          var a = new Imputation(
              id: element["id"],
              date: DateTime.parse(element["date"]),
              projet: element["projectname"],
              phase: element["projectlots"],
              tache: element["projecttasks"],
              hours: double.parse(element["tsvalue"].toString()));

          imputationlist.add(a);
        }
      }
    } else {
      print(response.body);
    }
    listviewload.value = false;
  }

  Future getRecentTimesheet() async {
    listviewload.value = true;
    var response = await context.getRecentTimeSheets();

    print(response.statusCode);
    if (response.statusCode == 200) {
      imputationlist.clear();
      var temp = json.decode(response.body);
      if (temp != [] && temp.isNotEmpty) {
        var c = "";
        for (var element in temp) {
          c = element["date"];
          var a = new Imputation(
              id: element["id"],
              date: DateTime.parse(element["date"]),
              projet: element["projectname"],
              phase: element["projectlots"],
              tache: element["projecttasks"],
              hours: double.parse(element["tsvalue"].toString()));

          imputationlist.add(a);
        }
        var date = DateFormat("yyyy-MM-dd").format(DateTime.parse(c));
        birthdate.value.text = date;
      }
      listviewload.value = false;
    } /* else {
      Get.offAll(LandingScreen());
    } */
  }

  Future copyLasttimesheet() async {
    var response = await context.copyLastTimeSheet();
    print(response.statusCode);
    if (response.statusCode == 200) {
      var temp = json.decode(response.body);
      if (temp != [] && response.body.isNotEmpty) {
        print(temp);
        projetController.value =
            listproject.where((p) => p.id == temp["idProjet"]).first;
        projetController.refresh();

        print(projetController.value.id);
        projetController.value =
            listproject.where((p) => p.id == temp["idProjet"]).first;
        await onChangeProject(projetController.value.id);

        facetController.value =
            listphase.where((p) => p.id == temp["idProjetLot"]).first;
        facetController.refresh();
        await onChangeProjectlot(facetController.value.id);
        tacheController.value =
            listtache.where((p) => p.id == temp["idProjetTask"]).first;

        tacheController.refresh();
        quantiteController.value.text = temp["value"].toString();
        quantiteController.refresh();
      }
    } /* else {
      Get.offAll(LandingScreen());
    } */
  }

/*   var b = DateFormat("yyyy-MM-dd").format(a); */
  @override
  void onInit() async {
    Get.delete<SignInController>();

    toggleController.value = 0;

    quantiteController.value.text = 0.toString();
    birthdate.value.text = DateFormat("yyyy-MM-dd").format(DateTime.now());
    DateTime dt1 = DateTime.parse(birthdate.value.text);
    var connected = await context.connected();
    if (connected == 1) {
      await getTimesheets(a);
      await getProjects();
    } else if (connected == 0) {
      Get.snackbar(
        '',
        '',
        titleText: BigText(
          text: "Oops! It seems like you've lost connection to the server",
          size: 18,
          color: Colors.green,
        ),
        messageText: Text(
          "consider logging in again to re-establish your connection.",
          style: TextStyle(
            fontSize: 17,
          ),
        ),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: MyColors.BordersGrey.withOpacity(0.4),
        duration: const Duration(seconds: 1),
        overlayBlur: 0.7,
      );

      Get.offAll(LandingScreen());
    }

    super.onInit();
  }

  RxList<Imputation> imputationlist = <Imputation>[].obs;
  var listproject = <Project>[].obs;
  var listphase = <ProjectLot>[].obs;
  var listtache = <ProjectTasks>[].obs;

  var quantiteController = TextEditingController().obs;
  var projetController = new Project(id: -1, name: "").obs;
  var tacheController = new ProjectTasks(id: -1, idprojetlot: -1, name: "").obs;
  var facetController = new ProjectLot(id: -1, idprojet: -1, name: "").obs;
  var togglelist = ["Jour sélectionné", "Dernier imputation"].obs;

  var birthdate = new TextEditingController().obs;
  String? validateThese(String c1) {
    if (c1.isEmpty || c1 == null) {
      return "This field can't be empty";
    }
    return null;
  }

  String? validateThese2(String c1) {
    var qt = double.parse(c1);

    if (c1.isEmpty) {
      return "This field can't be empty";
    } else if (qt <= 0) {
      return "This field must be > 0";
    }
    return null;
  }
}
