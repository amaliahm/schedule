import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:schedule/addTaskBar.dart';
import 'package:schedule/task.dart';
import 'package:schedule/task_controller.dart';
import 'package:schedule/task_tile.dart';
import 'package:schedule/widgets/button.dart';

import 'main.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class themeService {
  final _box = GetStorage();
  final key = 'dark';
  _saveThemeToBox(bool dark) => _box.write(key, dark);
  bool _loadThemeFromBox() => _box.read(key) ?? false;
  ThemeMode get _theme =>
      _loadThemeFromBox() ? ThemeMode.dark : ThemeMode.light;
  void switchTheme() {
    Get.changeThemeMode(_loadThemeFromBox() ? ThemeMode.light : ThemeMode.dark);
    _saveThemeToBox(!_loadThemeFromBox());
  }
}

class _SchedulePageState extends State<SchedulePage> {
  DateTime _selectedDate = DateTime.now();
  final _taskController = Get.put(TaskController());
  final theme = themeService();

  @override
  void initState() {
    super.initState();
    _taskController.getTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _addTaskBar(),
            _addDateBar(),
            const SizedBox(
              height: 10,
            ),
            _showTasks(),
          ],
        ),
      ),
    );
  }

  _showTasks() {
    return Expanded(child: Obx(() {
      return ListView.builder(
          itemCount: _taskController.taskList.length,
          itemBuilder: (_, index) {
            Task task = _taskController.taskList[index];
            if (task.repeat == 'Daily') {
              return AnimationConfiguration.staggeredList(
                position: index,
                child: SlideAnimation(
                  child: FadeInAnimation(
                    child: GestureDetector(
                      onTap: () {
                        _showBottomSheet(context, task);
                      },
                      child: TaskTile(task),
                    ),
                  ),
                ),
              );
            }
            if (task.date == DateFormat.yMd().format(_selectedDate)) {
              return AnimationConfiguration.staggeredList(
                position: index,
                child: SlideAnimation(
                  child: FadeInAnimation(
                    child: GestureDetector(
                      onTap: () {
                        _showBottomSheet(context, task);
                      },
                      child: TaskTile(task),
                    ),
                  ),
                ),
              );
            } else {
              return Container();
            }
          });
    }));
  }

  _showBottomSheet(BuildContext context, Task task) {
    Get.bottomSheet(Container(
      padding: const EdgeInsets.only(top: 4),
      height: task.isCompleted == 1
          ? MediaQuery.of(context).size.height * 0.24
          : MediaQuery.of(context).size.height * 0.32,
      color: Get.isDarkMode ? darkGreyClr : Colors.white,
      child: Column(
        children: [
          Container(
            height: 6,
            width: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[300],
            ),
          ),
          const Spacer(),
          task.isCompleted == 1
              ? Container()
              : _bottomSheetButton(
                  label: "Task Completed",
                  onTap: () {
                    _taskController.markTaskCompleted(task.id!);
                    _taskController.getTasks();
                    Get.back();
                  },
                  clr: primaryClr,
                  context: context,
                ),
          _bottomSheetButton(
            label: "Delete task",
            onTap: () {
              TaskController.delete(task);
              _taskController.getTasks();
              Get.back();
            },
            clr: Colors.red[300]!,
            context: context,
          ),
          const SizedBox(
            height: 20,
          ),
          _bottomSheetButton(
            label: "Close",
            onTap: () {
              Get.back();
            },
            clr: Colors.red[300]!,
            isClose: true,
            context: context,
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    ));
  }

  _bottomSheetButton(
      {required String label,
      required Function()? onTap,
      required Color clr,
      bool isClose = false,
      required BuildContext context}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 55,
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          color: isClose ? Colors.transparent : clr,
          border: Border.all(
            width: 2,
            color: isClose
                ? Get.isDarkMode
                    ? Colors.grey[600]!
                    : Colors.grey[300]!
                : clr,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            label,
            style:
                isClose ? titleStyle : titleStyle.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }

  TextStyle get subHeadingStyle {
    return GoogleFonts.lato(
        textStyle: const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ));
  }

  TextStyle get headingStyle {
    return GoogleFonts.lato(
        textStyle: const TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Colors.grey,
    ));
  }

  TextStyle get titleStyle {
    return GoogleFonts.lato(
      textStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: Get.isDarkMode ? Colors.white : Colors.black,
      ),
    );
  }

  _addTaskBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              DateFormat.yMMMEd().format(DateTime.now()).toString(),
              style: subHeadingStyle,
            ),
            Text(
              'Today',
              style: headingStyle,
            ),
          ],
        ),
        MyButton(
            label: "+ add task",
            onTap: () async => await Get.to(const AddTaskPage())),
      ],
    );
  }

  _addDateBar() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: DatePicker(
        DateTime.now(),
        height: 100,
        width: 80,
        initialSelectedDate: DateTime.now(),
        selectionColor: primaryClr,
        selectedTextColor: Colors.white,
        dateTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        monthTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        dayTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        onDateChange: (date) {
          setState(() {
            _selectedDate = date;
          });
        },
      ),
    );
  }

  _appBar() {
    return AppBar(
      leading: GestureDetector(
        onTap: () {
          setState(() {
            themeService().switchTheme();
          });
        },
        child: Icon(
          themeService()._theme == ThemeMode.light
              ? Icons.nightlight_round
              : Icons.sunny,
        ),
      ),
    );
  }
}
