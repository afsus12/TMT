import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:tmt_mobile/models/project.dart';
import 'package:tmt_mobile/models/projectLot.dart';
import 'package:tmt_mobile/models/projetTasks.dart';
import 'package:tmt_mobile/utils/myColors.dart';

class MyDropDown extends StatefulWidget {
  final List<Project>? project;
  final List<ProjectLot>? projectLot;
  final List<ProjectTasks>? projecttasks;
  final String labelText;
  final String hint;
  final bool? aligncenter;
  final Function()? ontap;
  final bool enabled;
  final IconData? icon;
  final IconData? Suffixicon;
  final IconData? Suffixiconoff;
  final Function()? suffixiconfun;
  final int lines;
  final String? what;
  final Iterable<String>? AutofillHints;
  final void Function(Project?)? onChangedProject;
  final void Function(ProjectTasks?)? onChangedProjecttask;
  final void Function(ProjectLot?)? onChangedProjectlot;
  final String? Function(String?)? validate;
  final Function(String)? onSubmitted;
  final Project? projectcontroller;
  final ProjectLot? projectlotscontroller;
  final ProjectTasks? projecttaskscontroller;
  final String? errorText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool autoFocus;
  final bool obscureText;
  final FocusNode? focusNode;
  final Color? color;
  final double fontsize;

  const MyDropDown({
    required this.labelText,
    this.project,
    this.projectcontroller,
    this.projectlotscontroller,
    this.projecttaskscontroller,
    this.onChangedProjectlot,
    this.onChangedProjecttask,
    this.projectLot,
    this.projecttasks,
    this.color,
    this.aligncenter,
    this.onChangedProject,
    this.Suffixiconoff,
    this.Suffixicon,
    this.suffixiconfun,
    this.AutofillHints,
    this.onSubmitted,
    this.focusNode,
    this.errorText,
    this.keyboardType = TextInputType.multiline,
    this.textInputAction = TextInputAction.next,
    this.autoFocus = false,
    this.obscureText = false,
    this.lines = 1,
    this.ontap,
    this.fontsize = 15,
    Key? key,
    this.enabled = true,
    this.icon,
    this.hint = '',
    this.validate,
    this.what,
  }) : super(key: key);

  @override
  State<MyDropDown> createState() => _MyDropDownState();
}

class _MyDropDownState extends State<MyDropDown> {
  late FocusNode focusNode;

  @override
  void initState() {
    focusNode = widget.focusNode ?? FocusNode();
    focusNode.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.project != null
        ? DropdownButtonFormField<Project>(
            iconSize: 0.0,
            items: widget.project!.map((Project category) {
              return new DropdownMenuItem(
                  value: category,
                  child: Text(
                    category.name,
                    style: TextStyle(
                      fontSize: widget.fontsize,
                      fontFamily: "Roboto-Light",
                    ),
                  ));
            }).toList(),
            autofocus: widget.autoFocus,
            focusNode: focusNode,
            onChanged: widget.onChangedProject,
            value: widget.projectcontroller,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              prefixIcon: Icon(
                widget.icon,
                color: focusNode.hasFocus
                    ? MyColors.MainRedSecond
                    : MyColors.Strokecolor,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  widget.Suffixicon,
                  size: 30,
                  color: focusNode.hasFocus
                      ? MyColors.MainRedSecond
                      : MyColors.Strokecolor,
                ),
                onPressed: widget.suffixiconfun,
              ),
              border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(17)),
              filled: true,
              fillColor: focusNode.hasFocus
                  ? MyColors.MainRedSecond.withOpacity(.1)
                  : widget.color == null
                      ? MyColors.Strokecolor.withOpacity(.1)
                      : widget.color,
              hintStyle: TextStyle(
                color: focusNode.hasFocus
                    ? MyColors.MainRedSecond
                    : MyColors.Strokecolor,
                fontFamily: "Roboto-Light",
                fontSize: 10,
                fontWeight: FontWeight.normal,
              ),
              focusColor: MyColors.MainRedSecond,
              focusedBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: MyColors.MainRedSecond, width: 2.0),
                  borderRadius: BorderRadius.circular(14)),
            ),
          )
        : widget.projectLot != null
            ? DropdownButtonFormField<ProjectLot>(
                iconSize: 0.0,
                items: widget.projectLot?.map((ProjectLot category) {
                  return new DropdownMenuItem(
                      value: category,
                      child: Text(
                        category.name,
                        style: TextStyle(
                          fontSize: widget.fontsize,
                          fontFamily: "Roboto-Light",
                        ),
                      ));
                }).toList(),
                autofocus: widget.autoFocus,
                focusNode: focusNode,
                onChanged: widget.onChangedProjectlot,
                value: widget.projectlotscontroller,
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  prefixIcon: Icon(
                    widget.icon,
                    color: focusNode.hasFocus
                        ? MyColors.MainRedSecond
                        : MyColors.Strokecolor,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      widget.Suffixicon,
                      size: 30,
                      color: focusNode.hasFocus
                          ? MyColors.MainRedSecond
                          : MyColors.Strokecolor,
                    ),
                    onPressed: widget.suffixiconfun,
                  ),
                  border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(17)),
                  filled: true,
                  fillColor: focusNode.hasFocus
                      ? MyColors.MainRedSecond.withOpacity(.1)
                      : widget.color == null
                          ? MyColors.Strokecolor.withOpacity(.1)
                          : widget.color,
                  hintStyle: TextStyle(
                    color: focusNode.hasFocus
                        ? MyColors.MainRedSecond
                        : MyColors.Strokecolor,
                    fontFamily: "Roboto-Light",
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                  ),
                  focusColor: MyColors.MainRedSecond,
                  focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: MyColors.MainRedSecond, width: 2.0),
                      borderRadius: BorderRadius.circular(14)),
                ),
              )
            : DropdownButtonFormField<ProjectTasks>(
                iconSize: 0.0,
                items: widget.projecttasks?.map((ProjectTasks category) {
                  return new DropdownMenuItem(
                      value: category,
                      child: Text(
                        category.name,
                        style: TextStyle(
                          fontSize: widget.fontsize,
                          fontFamily: "Roboto-Light",
                        ),
                      ));
                }).toList(),
                autofocus: widget.autoFocus,
                focusNode: focusNode,
                onChanged: widget.onChangedProjecttask,
                value: widget.projecttaskscontroller,
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  prefixIcon: Icon(
                    widget.icon,
                    color: focusNode.hasFocus
                        ? MyColors.MainRedSecond
                        : MyColors.Strokecolor,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      widget.Suffixicon,
                      size: 30,
                      color: focusNode.hasFocus
                          ? MyColors.MainRedSecond
                          : MyColors.Strokecolor,
                    ),
                    onPressed: widget.suffixiconfun,
                  ),
                  border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(17)),
                  filled: true,
                  fillColor: focusNode.hasFocus
                      ? MyColors.MainRedSecond.withOpacity(.1)
                      : widget.color == null
                          ? MyColors.Strokecolor.withOpacity(.1)
                          : widget.color,
                  hintStyle: TextStyle(
                    color: focusNode.hasFocus
                        ? MyColors.MainRedSecond
                        : MyColors.Strokecolor,
                    fontFamily: "Roboto-Light",
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                  ),
                  focusColor: MyColors.MainRedSecond,
                  focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: MyColors.MainRedSecond, width: 2.0),
                      borderRadius: BorderRadius.circular(14)),
                ),
              );
  }
}
