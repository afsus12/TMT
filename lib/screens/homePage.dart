import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tmt_mobile/controllers/globalcontroller.dart';
import 'package:tmt_mobile/controllers/homepagecontroller.dart';
import 'package:tmt_mobile/controllers/menucontroller.dart';
import 'package:tmt_mobile/controllers/myorganisationcontroller.dart';
import 'package:tmt_mobile/models/imputation.dart';
import 'package:tmt_mobile/models/project.dart';
import 'package:tmt_mobile/models/projectLot.dart';
import 'package:tmt_mobile/utils/myColors.dart';
import 'package:tmt_mobile/widgets/big_text.dart';

import 'package:tmt_mobile/widgets/buttonwithicon.dart';
import 'package:tmt_mobile/widgets/dropdown.dart';
import 'package:tmt_mobile/widgets/inputfield.dart';
import 'package:toggle_switch/toggle_switch.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    Get.put(HomePageController());

    GlobalController globalController = Get.find<GlobalController>();

    HomePageController homeController = Get.find<HomePageController>();

    void onAddQuantity() {
      var stringQuantity = homeController.quantiteController.value.text;
      var numericQuantity = double.parse(stringQuantity) + 1;
      homeController.quantiteController.value.text = numericQuantity.toString();
    }

    Future addImput() async {
      var response = await homeController.context.addTimesheet(
          homeController.projetController.value.id.toInt(),
          homeController.facetController.value.id.toInt(),
          homeController.tacheController.value.id.toInt(),
          DateTime.parse(homeController.birthdate.value.text),
          double.parse(homeController.quantiteController.value.text));
      print(response.body);
      if (response.statusCode == 200) {
        print("done");
        await homeController
            .getTimesheets(DateTime.parse(homeController.birthdate.value.text));
      } else {
        print("erreurr" + response.statusCode.toString());
      }
    }

    Future addTimesheet() async {
      bool isValidate = homeController.homeKey.currentState!.validate();

      if (isValidate) {
        await addImput();
        Get.snackbar(
          '',
          '',
          titleText: BigText(
            text: globalController.lang.value == "fr" ? "Succès" : "Success",
            size: 18,
            color: Colors.green,
          ),
          messageText: Text(
            globalController.lang.value == "fr"
                ? " Feuille de temps ajoutée avec succès"
                : "Timesheet Added Successfully!",
            style: TextStyle(
              fontSize: 17,
            ),
          ),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: MyColors.BordersGrey.withOpacity(0.4),
          duration: const Duration(seconds: 1),
          overlayBlur: 0.7,
        );
      }
    }

    Future addDay() async {
      print(homeController.birthdate.value.text);
      DateTime dt1 = DateTime.parse(homeController.birthdate.value.text);

      DateTime dt2 = dt1.add(Duration(days: 1));

      homeController.birthdate.value.text =
          DateFormat("yyyy-MM-dd").format(dt2);
      await homeController
          .getTimesheets(DateTime.parse(homeController.birthdate.value.text));
    }

    Future subtractDay() async {
      print(homeController.birthdate.value.text);
      DateTime dt1 = DateTime.parse(homeController.birthdate.value.text);

      DateTime dt2 = dt1.subtract(Duration(days: 1));

      homeController.birthdate.value.text =
          DateFormat("yyyy-MM-dd").format(dt2);
      await homeController
          .getTimesheets(DateTime.parse(homeController.birthdate.value.text));
    }

    void onMinusQuantity() {
      var stringQuantity = homeController.quantiteController.value.text;
      var numericQuantity = double.parse(stringQuantity) - 1;
      homeController.quantiteController.value.text = numericQuantity.toString();
    }

    return globalController.devType.value == "tablet"
        ? homePageTablet(
            homeController,
            screenWidth,
            screenHeight,
            subtractDay,
            context,
            addDay,
            onMinusQuantity,
            globalController,
            onAddQuantity,
            addTimesheet)
        : homePageAndroid(
            homeController,
            screenHeight,
            screenWidth,
            subtractDay,
            context,
            addDay,
            onMinusQuantity,
            globalController,
            onAddQuantity,
            addTimesheet);
  }

  Container homePageAndroid(
      HomePageController homeController,
      double screenHeight,
      double screenWidth,
      Future<dynamic> subtractDay(),
      BuildContext context,
      Future<dynamic> addDay(),
      void onMinusQuantity(),
      GlobalController globalController,
      void onAddQuantity(),
      Future<dynamic> addTimesheet()) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: homeController.homeKey,
          child: Container(
            height: screenHeight * 0.9,
            child: Column(children: [
              Obx(() => Container(
                    width: screenWidth * 0.90,
                    height: screenHeight * 0.07,
                    decoration: BoxDecoration(
                        color: MyColors.inputcolorfill,
                        borderRadius: BorderRadius.circular(13)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(Icons.arrow_back),
                            onPressed: () async {
                              if (homeController.listviewload == false) {
                                await subtractDay();
                              }
                            },
                          ),
                          SizedBox(
                            width: screenWidth * 0.60,
                            child: GestureDetector(
                              onTap: () async {
                                DateTime? pickdate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.parse(
                                        homeController.birthdate.value.text),
                                    firstDate: DateTime(1920),
                                    lastDate: DateTime(2060));
                                if (pickdate != null) {
                                  homeController.birthdate.value.text =
                                      DateFormat("yyyy-MM-dd").format(pickdate);

                                  await homeController.getTimesheets(
                                      DateTime.parse(
                                          homeController.birthdate.value.text));
                                }
                              },
                              child: Myinput(
                                fontsize: 16,
                                aligncenter: true,
                                color: MyColors.inputcolorfill,
                                enabled: false,
                                controller: homeController.birthdate.value,
                                validate: (v) =>
                                    homeController.validateThese(v!),
                                labelText: "today",
                                icon: Icons.calendar_month,
                                keyboardType: TextInputType.datetime,
                              ),
                            ),
                          ),
                          IconButton(
                              icon: Icon(Icons.arrow_forward),
                              onPressed: () async {
                                if (homeController.listviewload.value ==
                                    false) {
                                  await addDay();
                                }
                              }),
                        ],
                      ),
                    ),
                  )),
              Obx(() => Visibility(
                    visible: homeController.toggleHide.isFalse,
                    child: SizedBox(
                      height: screenHeight * 0.01,
                    ),
                  )),
              Obx(() => Visibility(
                    visible: homeController.toggleHide.isFalse,
                    child: SizedBox(
                      child: SizedBox(
                          height: screenHeight * 0.07,
                          width: screenWidth * 0.9,
                          child: MyDropDown(
                              fontsize: 14,
                              aligncenter: true,
                              projectcontroller:
                                  homeController.projetController.value,
                              icon: Icons.folder_copy,
                              labelText: "dddf",
                              project: homeController.listproject,
                              Suffixicon: Icons.arrow_drop_down,
                              onChangedProject: (Project? p) async {
                                await homeController.onChangeProject(p!.id);
                                homeController.projetController.value = p;
                              })),
                    ),
                  )),
              Obx(() => Visibility(
                  visible: homeController.toggleHide.isFalse,
                  child: SizedBox(
                    height: screenHeight * 0.01,
                  ))),
              Obx(() => homeController.loadlots.value == false
                  ? Visibility(
                      visible: homeController.toggleHide.isFalse,
                      child: SizedBox(
                        child: SizedBox(
                            height: screenHeight * 0.07,
                            width: screenWidth * 0.90,
                            child: MyDropDown(
                                fontsize: 14,
                                projectlotscontroller:
                                    homeController.facetController.value,
                                icon: Icons.work,
                                labelText: "dddf",
                                projectLot: homeController.listphase,
                                Suffixicon: Icons.arrow_drop_down,
                                onChangedProjectlot: (dd) async {
                                  await homeController
                                      .onChangeProjectlot(dd!.id);
                                  homeController.facetController.value = dd;
                                })),
                      ),
                    )
                  : CircularProgressIndicator(
                      color: MyColors.thirdColor,
                    )),
              Obx(() => Visibility(
                    visible: homeController.toggleHide.isFalse,
                    child: SizedBox(
                      height: screenHeight * 0.01,
                    ),
                  )),
              Obx(() => homeController.loadtasks == false
                  ? Visibility(
                      visible: homeController.toggleHide.isFalse,
                      child: SizedBox(
                        child: SizedBox(
                            height: screenHeight * 0.07,
                            width: screenWidth * 0.90,
                            child: MyDropDown(
                                projecttaskscontroller:
                                    homeController.tacheController.value,
                                icon: Icons.task,
                                labelText: "dddf",
                                fontsize: 14,
                                projecttasks: homeController.listtache,
                                Suffixicon: Icons.arrow_drop_down,
                                onChangedProjecttask: (dd) => {
                                      homeController.tacheController.value =
                                          dd!,
                                      print(
                                          homeController.tacheController.value)
                                    })),
                      ),
                    )
                  : CircularProgressIndicator(
                      color: MyColors.thirdColor,
                    )),
              Obx(() => Visibility(
                    visible: homeController.toggleHide.isFalse,
                    child: SizedBox(
                      height: screenHeight * 0.01,
                    ),
                  )),
              Obx(() => Visibility(
                    visible: homeController.toggleHide.isFalse,
                    child: SizedBox(
                        height: screenHeight * 0.07,
                        width: screenWidth * 0.90,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            IconButton(
                                onPressed: onMinusQuantity,
                                icon: Icon(Icons.remove_circle)),
                            SizedBox(
                              height: screenHeight * 0.07,
                              width: screenWidth * 0.60,
                              child: Myinput(
                                fontsize: 13,
                                labelText: globalController.lang.value == "fr"
                                    ? "Quantité"
                                    : "Quantity",
                                textInputAction: TextInputAction.go,
                                keyboardType: TextInputType.number,
                                aligncenter: true,
                                controller:
                                    homeController.quantiteController.value,
                                icon: Icons.hourglass_bottom,
                                validate: (v) =>
                                    homeController.validateThese2(v!),
                              ),
                            ),
                            IconButton(
                                onPressed: onAddQuantity,
                                icon: Icon(Icons.add_circle)),
                          ],
                        )),
                  )),
              Obx(() => Visibility(
                    visible: homeController.toggleHide.isFalse,
                    child: SizedBox(
                      height: screenHeight * 0.01,
                    ),
                  )),
              Obx(() => Visibility(
                    visible: homeController.toggleHide.isFalse,
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ButtonWithIcon(
                            onPressed: () async {
                              await homeController.copyLasttimesheet();
                            },
                            width: screenWidth * 0.56,
                            height: screenHeight * 0.062,
                            mainColor: MyColors.thirdColor,
                            textcolor: Colors.white,
                            fontSize: 14,
                            text: globalController.lang.value == "fr"
                                ? "Copier la Dernière Entrée"
                                : "Copy Latest Entry",
                          ),
                          ButtonWithIcon(
                            onPressed: () async {
                              await addTimesheet();
                            },
                            text: globalController.lang.value == "fr"
                                ? "Ajouter"
                                : "Add",
                            mainColor: Colors.white,
                            urlimage: "assets/google.png",
                            fontSize: 14,
                            width: screenWidth * 0.3,
                            height: screenHeight * 0.062,
                          )
                        ],
                      ),
                    ),
                  )),
              Obx(() => Visibility(
                    visible: homeController.toggleHide.isFalse,
                    child: SizedBox(
                      height: screenHeight * 0.01,
                    ),
                  )),
              /* Container(
                      width: screenWidth * 0.46,
                      height: screenHeight * 0.06,
                      decoration: BoxDecoration(
                          color: homeController.hidden.value == true
                              ? Colors.yellow
                              : MyColors.inputcolorfill,
                          borderRadius: BorderRadius.circular(30)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Aujourdhui",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: "roboto",
                                    fontWeight:
                                        homeController.hidden.value == true
                                            ? FontWeight.bold
                                            : FontWeight.normal),
                              ),
                              IconButton(
                                  onPressed: () => {
                                        homeController.hidden.value =
                                            !homeController.hidden.value
                                      },
                                  icon: Icon(
                                    color: homeController.hidden.value == true
                                        ? MyColors.BordersGrey
                                        : MyColors.thirdColor,
                                    homeController.hidden.value == true
                                        ? Icons.arrow_drop_up
                                        : Icons.arrow_drop_down,
                                    size: 30,
                                  ))
                            ]),
                      ),
                    ), */
              Obx(() => TextButton(
                    onPressed: () async {
                      homeController.toggleHide.value =
                          !homeController.toggleHide.value;
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          globalController.lang.value == "fr"
                              ? "Afficher / Masquer la Liste Complète"
                              : "Show Full List/Hide Full List",
                          style: TextStyle(fontSize: 15),
                        ),
                        SizedBox(
                          width: screenWidth * 0.02,
                        ),
                        Icon(
                          homeController.toggleHide.value == false
                              ? Icons.arrow_upward
                              : Icons.arrow_downward,
                          size: 20,
                        )
                      ],
                    ),
                  )),
              Obx(() => InkWell(
                    child: ToggleSwitch(
                      fontSize: 15,
                      minHeight: screenHeight * 0.058,
                      minWidth: screenWidth * 0.90,
                      initialLabelIndex: homeController.toggleController.value,
                      cornerRadius: 20.0,
                      activeFgColor: MyColors.inputcolorfill,
                      inactiveBgColor: MyColors.NotCompletedStepText,
                      inactiveFgColor: MyColors.inputcolorfill,
                      totalSwitches: 2,
                      labels: globalController.lang.value == "fr"
                          ? ["Jour Sélectionné", "la Dernière Entrée"]
                          : ["Selected Day", "Latest Entry"],
                      icons: [Icons.today, Icons.history],
                      activeBgColors: [
                        [MyColors.MainRedSecond],
                        [MyColors.MainRedSecond]
                      ],
                      onToggle: (index) async {
                        homeController.toggleController.value = index!;
                        if (homeController.toggleController.value == 1) {
                          await homeController.getRecentTimesheet();
                        } else {
                          var date =
                              DateFormat("yyyy-MM-dd").format(DateTime.now());
                          homeController.birthdate.value.text = date;
                          await homeController
                              .getTimesheets(DateTime.parse(date));
                        }
                      },
                    ),
                  )),
              Obx(() => Flexible(
                    child: SizedBox(
                        height: homeController.toggleHide.isFalse
                            ? screenHeight * 0.5
                            : screenHeight * 0.7,
                        child: homeController.listviewload == false
                            ? homeController.imputationlist.isNotEmpty
                                ? ListView.builder(
                                    itemCount:
                                        homeController.imputationlist.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Dismissible(
                                        key: Key(homeController
                                            .imputationlist[index].id
                                            .toString()),
                                        direction: homeController
                                                    .imputationlist[index]
                                                    .isValidated ==
                                                false
                                            ? DismissDirection.startToEnd
                                            : DismissDirection.none,
                                        onDismissed: (direction) async {
                                          if (homeController
                                                  .imputationlist[index]
                                                  .isValidated ==
                                              false) {
                                            await homeController
                                                .deleteTimesheet(homeController
                                                    .imputationlist[index].id!);
                                            await homeController.getTimesheets(
                                                DateTime.parse(homeController
                                                    .birthdate.value.text));
                                            homeController.imputationlist
                                                .refresh();
                                            Get.snackbar(
                                              '',
                                              '',
                                              titleText: BigText(
                                                text: globalController.lang ==
                                                        "fr"
                                                    ? "Succées"
                                                    : "Success",
                                                size: 18,
                                                color: Colors.green,
                                              ),
                                              messageText: Text(
                                                globalController.lang.value ==
                                                        "fr"
                                                    ? "Feuille de temps supprimée avec succès!"
                                                    : "Timesheet Removed Successfully!",
                                                style: TextStyle(
                                                  fontSize: 17,
                                                ),
                                              ),
                                              snackPosition:
                                                  SnackPosition.BOTTOM,
                                              backgroundColor: MyColors
                                                  .BordersGrey.withOpacity(0.4),
                                              overlayBlur: 1.5,
                                            );
                                          }
                                        },
                                        background: Container(
                                          width: 20,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Icon(
                                                Icons.double_arrow,
                                                size: 30,
                                                color: MyColors.MainRedSecond,
                                              ),
                                              Text(
                                                globalController.lang.value ==
                                                        "fr"
                                                    ? "Glisser pour Supprimer"
                                                    : "Drag to Delete",
                                                style: TextStyle(fontSize: 15),
                                              ),
                                              Icon(
                                                Icons.double_arrow,
                                                size: 30,
                                                color: MyColors.MainRedSecond,
                                              ),
                                            ],
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                          ),
                                        ),
                                        child: Card(
                                          child: Container(
                                              height: screenHeight * 0.13,
                                              child: ListTile(
                                                title: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      vertical: 10,
                                                      horizontal: 2),
                                                  child: SizedBox(
                                                    height: screenHeight * 0.8,
                                                    child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          RichText(
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              text: TextSpan(
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        12,
                                                                  ),
                                                                  children: [
                                                                    TextSpan(
                                                                      text: globalController.lang ==
                                                                              "fr"
                                                                          ? "Projet  : "
                                                                          : "Project : ",
                                                                      style: TextStyle(
                                                                          fontFamily:
                                                                              "roboto",
                                                                          fontSize:
                                                                              15,
                                                                          color:
                                                                              MyColors.blackbackground2),
                                                                    ),
                                                                    TextSpan(
                                                                        text: homeController
                                                                            .imputationlist[
                                                                                index]
                                                                            .projet,
                                                                        style: TextStyle(
                                                                            fontFamily:
                                                                                "aileron",
                                                                            fontSize:
                                                                                16,
                                                                            color:
                                                                                MyColors.blackbackground2,
                                                                            fontWeight: FontWeight.bold)),
                                                                  ])),
                                                          SizedBox(
                                                            height:
                                                                screenHeight *
                                                                    0.003,
                                                          ),
                                                          RichText(
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              text: TextSpan(
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        18,
                                                                  ),
                                                                  children: [
                                                                    TextSpan(
                                                                      text: globalController.lang ==
                                                                              "fr"
                                                                          ? "Phase/lot : "
                                                                          : "Phase  : ",
                                                                      style: TextStyle(
                                                                          fontFamily:
                                                                              "roboto",
                                                                          fontSize:
                                                                              15,
                                                                          color:
                                                                              MyColors.blackbackground2),
                                                                    ),
                                                                    TextSpan(
                                                                        text: homeController
                                                                            .imputationlist[
                                                                                index]
                                                                            .phase,
                                                                        style: TextStyle(
                                                                            fontFamily:
                                                                                "aileron",
                                                                            fontSize:
                                                                                16,
                                                                            color:
                                                                                MyColors.blackbackground2,
                                                                            fontWeight: FontWeight.bold)),
                                                                  ])),
                                                          SizedBox(
                                                            height:
                                                                screenHeight *
                                                                    0.003,
                                                          ),
                                                          RichText(
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              text: TextSpan(
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        15,
                                                                  ),
                                                                  children: [
                                                                    TextSpan(
                                                                      text: globalController.lang ==
                                                                              "fr"
                                                                          ? "Tache  : "
                                                                          : "Task : ",
                                                                      style: TextStyle(
                                                                          fontFamily:
                                                                              "roboto",
                                                                          fontSize:
                                                                              15,
                                                                          color:
                                                                              MyColors.blackbackground2),
                                                                    ),
                                                                    TextSpan(
                                                                        text: homeController
                                                                            .imputationlist[
                                                                                index]
                                                                            .tache,
                                                                        style: TextStyle(
                                                                            fontFamily:
                                                                                "aileron",
                                                                            fontSize:
                                                                                16,
                                                                            color:
                                                                                MyColors.blackbackground2,
                                                                            fontWeight: FontWeight.bold)),
                                                                  ])),
                                                        ]),
                                                  ),
                                                ),
                                                leading: Padding(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  child: Icon(
                                                    Icons.document_scanner,
                                                    size: 28,
                                                    color: MyColors.thirdColor,
                                                  ),
                                                ),
                                                trailing: SizedBox(
                                                  height: screenHeight * 0.08,
                                                  width: screenWidth * 0.2,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Align(
                                                        alignment:
                                                            Alignment.topRight,
                                                        child: Icon(
                                                            Icons.circle,
                                                            color: homeController
                                                                    .imputationlist[
                                                                        index]
                                                                    .isValidated
                                                                ? Colors.green
                                                                : Colors.orange,
                                                            size: 12),
                                                      ),
                                                      Text(
                                                        homeController
                                                            .imputationlist[
                                                                index]
                                                            .hours
                                                            .toString(),
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )),
                                        ),
                                      );
                                    })
                                : Padding(
                                    padding: const EdgeInsets.all(30),
                                    child: Text(
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "aileron"),
                                        globalController.lang.value == "fr"
                                            ? "Il semblerait qu'il n'y ait pas de feuilles de temps disponibles pour cette journée."
                                            : "It looks like there are no timesheets available for this day."),
                                  )
                            : Container(
                                child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Center(
                                    child: Column(
                                  children: [
                                    Text("Loading..."),
                                    SizedBox(
                                      height: 25,
                                    ),
                                    CircularProgressIndicator(
                                        color: MyColors.thirdColor),
                                  ],
                                )),
                              ))),
                  ))
            ]),
          ),
        ),
      ),
    );
  }

  Container homePageTablet(
      HomePageController homeController,
      double screenWidth,
      double screenHeight,
      Future<dynamic> subtractDay(),
      BuildContext context,
      Future<dynamic> addDay(),
      void onMinusQuantity(),
      GlobalController globalController,
      void onAddQuantity(),
      Future<dynamic> addTimesheet()) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: homeController.homeKey,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                width: screenWidth * 0.35,
                child: Column(children: [
                  Container(
                    width: screenWidth * 0.9,
                    height: screenHeight * 0.06,
                    decoration: BoxDecoration(
                        color: MyColors.Strokecolor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(17)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: Icon(Icons.arrow_back),
                            onPressed: () async {
                              if (homeController.listviewload == false) {
                                await subtractDay();
                              }
                            },
                          ),
                          SizedBox(
                            width: screenWidth * 0.2,
                            child: GestureDetector(
                              onTap: () async {
                                DateTime? pickdate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.parse(
                                        homeController.birthdate.value.text),
                                    firstDate: DateTime(1920),
                                    lastDate: DateTime(2060));
                                if (pickdate != null) {
                                  homeController.birthdate.value.text =
                                      DateFormat("yyyy-MM-dd").format(pickdate);

                                  await homeController.getTimesheets(
                                      DateTime.parse(
                                          homeController.birthdate.value.text));
                                }
                              },
                              child: Myinput(
                                aligncenter: true,
                                color: Colors.transparent,
                                enabled: false,
                                controller: homeController.birthdate.value,
                                validate: (v) =>
                                    homeController.validateThese(v!),
                                labelText: "today",
                                icon: Icons.calendar_month,
                                keyboardType: TextInputType.datetime,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.arrow_forward),
                            onPressed: () async {
                              if (homeController.listviewload.value == false) {
                                await addDay();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.01,
                  ),
                  Obx(() => homeController.loadproject.value == false
                      ? SizedBox(
                          child: SizedBox(
                              height: screenHeight * 0.068,
                              width: screenWidth * 0.9,
                              child: MyDropDown(
                                  aligncenter: true,
                                  projectcontroller:
                                      homeController.projetController.value,
                                  icon: Icons.folder_copy,
                                  labelText: "dddf",
                                  project: homeController.listproject,
                                  Suffixicon: Icons.arrow_drop_down,
                                  onChangedProject: (Project? p) async {
                                    await homeController.onChangeProject(p!.id);
                                    homeController.projetController.value = p;
                                  })),
                        )
                      : CircularProgressIndicator(
                          color: MyColors.thirdColor,
                        )),
                  SizedBox(
                    height: screenHeight * 0.01,
                  ),
                  Obx(() => homeController.loadlots.value == false
                      ? SizedBox(
                          height: screenHeight * 0.068,
                          width: screenWidth * 0.9,
                          child: MyDropDown(
                              projectlotscontroller:
                                  homeController.facetController.value,
                              icon: Icons.work,
                              labelText: "dddf",
                              projectLot: homeController.listphase,
                              Suffixicon: Icons.arrow_drop_down,
                              onChangedProjectlot: (dd) async {
                                await homeController.onChangeProjectlot(dd!.id);
                                homeController.facetController.value = dd;
                              }))
                      : CircularProgressIndicator(
                          color: MyColors.thirdColor,
                        )),
                  SizedBox(
                    height: screenHeight * 0.01,
                  ),
                  Obx(() => homeController.loadtasks.value == false
                      ? SizedBox(
                          child: SizedBox(
                              height: screenHeight * 0.068,
                              width: screenWidth * 0.4,
                              child: MyDropDown(
                                  projecttaskscontroller:
                                      homeController.tacheController.value,
                                  icon: Icons.task,
                                  labelText: "dddf",
                                  projecttasks: homeController.listtache,
                                  Suffixicon: Icons.arrow_drop_down,
                                  onChangedProjecttask: (dd) => {
                                        homeController.tacheController.value =
                                            dd!,
                                        print(homeController
                                            .tacheController.value)
                                      })),
                        )
                      : CircularProgressIndicator(
                          color: MyColors.thirdColor,
                        )),
                  SizedBox(
                    height: screenHeight * 0.01,
                  ),
                  Container(
                      width: screenWidth * 0.4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(17),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton(
                              onPressed: onMinusQuantity,
                              icon: Icon(Icons.remove_circle)),
                          SizedBox(
                            width: screenWidth * 0.2,
                            child: Myinput(
                              labelText: globalController.lang.value == "fr"
                                  ? "Quantity"
                                  : "password",
                              textInputAction: TextInputAction.go,
                              keyboardType: TextInputType.number,
                              aligncenter: true,
                              controller:
                                  homeController.quantiteController.value,
                              icon: Icons.hourglass_bottom,
                              validate: (v) =>
                                  homeController.validateThese2(v!),
                              onChanged: (value) {
                                final val = TextSelection.collapsed(
                                    offset: homeController
                                        .quantiteController.value.text.length);
                                homeController
                                    .quantiteController.value.selection = val;
                              },
                            ),
                          ),
                          IconButton(
                              onPressed: onAddQuantity,
                              icon: Icon(Icons.add_circle)),
                        ],
                      )),
                  SizedBox(
                    height: screenHeight * 0.02,
                  ),
                  SizedBox(
                    width: screenWidth * 0.9,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Obx(() => ButtonWithIcon(
                              onPressed: () async {
                                await homeController.copyLasttimesheet();
                              },
                              width: screenWidth * 0.18,
                              height: screenHeight * 0.068,
                              mainColor: MyColors.thirdColor,
                              textcolor: Colors.white,
                              fontSize: 14,
                              text: globalController.lang.value == "fr"
                                  ? "Copier la Dernière Entrée"
                                  : "Copy Latest Entry",
                            )),
                        Obx(() => homeController.listviewload == false
                            ? ButtonWithIcon(
                                onPressed: () async {
                                  if (homeController.listviewload == false) {
                                    await addTimesheet();
                                  }
                                },
                                text: globalController.lang.value == "fr"
                                    ? "Ajouter"
                                    : "Add",
                                mainColor: Colors.white,
                                urlimage: "assets/google.png",
                                fontSize: 14,
                                width: screenWidth * 0.10,
                                height: screenHeight * 0.068,
                              )
                            : CircularProgressIndicator(
                                color: MyColors.thirdColor,
                              ))
                      ],
                    ),
                  ),

                  /* Container(
                          width: screenWidth * 0.46,
                          height: screenHeight * 0.06,
                          decoration: BoxDecoration(
                              color: homeController.hidden.value == true
                                  ? Colors.yellow
                                  : MyColors.inputcolorfill,
                              borderRadius: BorderRadius.circular(30)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Aujourdhui",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: "roboto",
                                        fontWeight:
                                            homeController.hidden.value == true
                                                ? FontWeight.bold
                                                : FontWeight.normal),
                                  ),
                                  IconButton(
                                      onPressed: () => {
                                            homeController.hidden.value =
                                                !homeController.hidden.value
                                          },
                                      icon: Icon(
                                        color: homeController.hidden.value == true
                                            ? MyColors.BordersGrey
                                            : MyColors.thirdColor,
                                        homeController.hidden.value == true
                                            ? Icons.arrow_drop_up
                                            : Icons.arrow_drop_down,
                                        size: 30,
                                      ))
                                ]),
                          ),
                        ), */
                ]),
              ),
              VerticalDivider(
                width: 7,
                thickness: 2,
                color: MyColors.Strokecolor.withOpacity(0.2),
                indent: 5, //spacing at the start of divider
                endIndent: 55,
              ),
              SizedBox(
                width: screenWidth * 0.5,
                child: Column(
                  children: [
                    Obx(() => ToggleSwitch(
                          fontSize: 15,
                          minHeight: screenHeight * 0.065,
                          minWidth: screenWidth * 0.24,
                          initialLabelIndex:
                              homeController.toggleController.value,
                          cornerRadius: 20.0,
                          activeFgColor: MyColors.inputcolorfill,
                          inactiveBgColor: MyColors.NotCompletedStepText,
                          inactiveFgColor: MyColors.inputcolorfill,
                          totalSwitches: 2,
                          labels: globalController.lang.value == "fr"
                              ? ["Jour Sélectionné", "la Dernière Entrée"]
                              : ["Selected Day", "Latest Entry"],
                          icons: [Icons.today, Icons.history],
                          activeBgColors: [
                            [MyColors.MainRedSecond],
                            [MyColors.MainRedSecond]
                          ],
                          onToggle: (index) async {
                            homeController.toggleController.value = index!;
                            if (homeController.toggleController.value == 1) {
                              await homeController.getRecentTimesheet();
                            } else {
                              var date = DateFormat("yyyy-MM-dd")
                                  .format(DateTime.now());
                              homeController.birthdate.value.text = date;
                              await homeController
                                  .getTimesheets(DateTime.parse(date));
                            }
                          },
                        )),
                    SizedBox(
                      height: screenHeight * 0.02,
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: SizedBox(
                            height: screenHeight * 0.7,
                            child: Obx(() =>
                                homeController.listviewload == false
                                    ? homeController.imputationlist.isNotEmpty
                                        ? ListView.builder(
                                            padding: EdgeInsets.only(
                                                bottom: 15, top: 10),
                                            itemCount: homeController
                                                .imputationlist.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return Dismissible(
                                                key: Key(homeController
                                                    .imputationlist[index].id
                                                    .toString()),
                                                direction: homeController
                                                            .imputationlist[
                                                                index]
                                                            .isValidated ==
                                                        false
                                                    ? DismissDirection
                                                        .startToEnd
                                                    : DismissDirection.none,
                                                onDismissed: (direction) async {
                                                  if (homeController
                                                          .imputationlist[index]
                                                          .isValidated ==
                                                      false) {
                                                    await homeController
                                                        .deleteTimesheet(
                                                            homeController
                                                                .imputationlist[
                                                                    index]
                                                                .id!);
                                                    await homeController
                                                        .getTimesheets(
                                                            DateTime.parse(
                                                                homeController
                                                                    .birthdate
                                                                    .value
                                                                    .text));
                                                    homeController
                                                        .imputationlist
                                                        .refresh();
                                                    Get.snackbar(
                                                      '',
                                                      '',
                                                      titleText: BigText(
                                                        text: globalController
                                                                    .lang ==
                                                                "fr"
                                                            ? "Succées"
                                                            : "Success",
                                                        size: 18,
                                                        color: Colors.green,
                                                      ),
                                                      messageText: Text(
                                                        globalController.lang
                                                                    .value ==
                                                                "fr"
                                                            ? "Feuille de temps supprimée avec succès!"
                                                            : "Timesheet Removed Successfully!",
                                                        style: TextStyle(
                                                          fontSize: 17,
                                                        ),
                                                      ),
                                                      snackPosition:
                                                          SnackPosition.BOTTOM,
                                                      backgroundColor:
                                                          MyColors.BordersGrey
                                                              .withOpacity(0.4),
                                                      overlayBlur: 1.5,
                                                    );
                                                  }
                                                },
                                                background: homeController
                                                            .imputationlist[
                                                                index]
                                                            .isValidated ==
                                                        false
                                                    ? Container(
                                                        width: 20,
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                          children: [
                                                            Icon(
                                                              Icons
                                                                  .double_arrow,
                                                              size: 30,
                                                              color: MyColors
                                                                  .MainRedSecond,
                                                            ),
                                                            Text(
                                                              globalController
                                                                          .lang
                                                                          .value ==
                                                                      "fr"
                                                                  ? "Glisser pour Supprimer"
                                                                  : "Drag to Delete",
                                                              style: TextStyle(
                                                                  fontSize: 18),
                                                            ),
                                                            Icon(
                                                              Icons
                                                                  .double_arrow,
                                                              size: 30,
                                                              color: MyColors
                                                                  .MainRedSecond,
                                                            ),
                                                          ],
                                                        ),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                        ),
                                                      )
                                                    : SizedBox.shrink(),
                                                child: Card(
                                                  child: Container(
                                                      height:
                                                          screenHeight * 0.12,
                                                      child: ListTile(
                                                        title: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      20,
                                                                  vertical: 10),
                                                          child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Obx(() => RichText(
                                                                    textAlign: TextAlign.left,
                                                                    text: TextSpan(
                                                                        style: TextStyle(
                                                                          color:
                                                                              Colors.black,
                                                                          fontSize:
                                                                              12,
                                                                        ),
                                                                        children: [
                                                                          TextSpan(
                                                                            text: globalController.lang == "fr"
                                                                                ? "Projet  : "
                                                                                : "Project : ",
                                                                            style: TextStyle(
                                                                                fontFamily: "aileron",
                                                                                fontSize: 18,
                                                                                color: MyColors.blackbackground2),
                                                                          ),
                                                                          TextSpan(
                                                                              text: homeController.imputationlist[index].projet,
                                                                              style: TextStyle(fontFamily: "aileron", fontSize: 18, color: MyColors.blackbackground2, fontWeight: FontWeight.bold)),
                                                                        ]))),
                                                                SizedBox(
                                                                  height:
                                                                      screenHeight *
                                                                          0.002,
                                                                ),
                                                                Obx(() => RichText(
                                                                    textAlign: TextAlign.left,
                                                                    text: TextSpan(
                                                                        style: TextStyle(
                                                                          color:
                                                                              Colors.black,
                                                                          fontSize:
                                                                              18,
                                                                        ),
                                                                        children: [
                                                                          TextSpan(
                                                                            text: globalController.lang == "fr"
                                                                                ? "Phase/lot : "
                                                                                : "Phase  : ",
                                                                            style: TextStyle(
                                                                                fontFamily: "aileron",
                                                                                fontSize: 18,
                                                                                color: MyColors.blackbackground2),
                                                                          ),
                                                                          TextSpan(
                                                                              text: homeController.imputationlist[index].phase,
                                                                              style: TextStyle(fontFamily: "aileron", fontSize: 18, color: MyColors.blackbackground2, fontWeight: FontWeight.bold)),
                                                                        ]))),
                                                                SizedBox(
                                                                  height:
                                                                      screenHeight *
                                                                          0.002,
                                                                ),
                                                                Obx(() => RichText(
                                                                    textAlign: TextAlign.left,
                                                                    text: TextSpan(
                                                                        style: TextStyle(
                                                                          color:
                                                                              Colors.black,
                                                                          fontSize:
                                                                              18,
                                                                        ),
                                                                        children: [
                                                                          TextSpan(
                                                                            text: globalController.lang == "fr"
                                                                                ? "Tache  : "
                                                                                : "Task : ",
                                                                            style: TextStyle(
                                                                                fontFamily: "aileron",
                                                                                fontSize: 18,
                                                                                color: MyColors.blackbackground2),
                                                                          ),
                                                                          TextSpan(
                                                                              text: homeController.imputationlist[index].tache,
                                                                              style: TextStyle(fontFamily: "aileron", fontSize: 18, color: MyColors.blackbackground2, fontWeight: FontWeight.bold)),
                                                                        ]))),
                                                              ]),
                                                        ),
                                                        leading: Icon(
                                                          Icons
                                                              .document_scanner,
                                                          size: 35,
                                                          color: MyColors
                                                              .thirdColor,
                                                        ),
                                                        trailing: SizedBox(
                                                          width: screenWidth *
                                                              0.178,
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Align(
                                                                alignment:
                                                                    Alignment
                                                                        .topRight,
                                                                child: Icon(
                                                                  Icons.circle,
                                                                  color: homeController
                                                                              .imputationlist[
                                                                                  index]
                                                                              .isValidated ==
                                                                          false
                                                                      ? Colors
                                                                          .orange
                                                                      : Colors
                                                                          .green,
                                                                  size: 18,
                                                                ),
                                                              ),
                                                              Text(
                                                                homeController
                                                                    .imputationlist[
                                                                        index]
                                                                    .hours
                                                                    .toString(),
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        20,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      )),
                                                ),
                                              );
                                            })
                                        : Padding(
                                            padding: const EdgeInsets.all(30),
                                            child: Text(
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: "aileron"),
                                                globalController.lang.value ==
                                                        "fr"
                                                    ? "Il semblerait qu'il n'y ait pas de feuilles de temps disponibles pour cette journée."
                                                    : "It looks like there are no timesheets available for this day."),
                                          )
                                    : Container(
                                        child: Center(
                                            child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Loading...",
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontFamily: "aileron"),
                                          ),
                                          SizedBox(
                                            height: 25,
                                          ),
                                          CircularProgressIndicator(
                                              color: MyColors.thirdColor),
                                        ],
                                      ))))),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
