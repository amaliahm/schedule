import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:schedule/main.dart';
import 'package:schedule/task.dart';
import 'package:schedule/task_controller.dart';
import 'package:schedule/widgets/button.dart';
import 'package:schedule/widgets/input_field.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  DateTime _selectedDate = DateTime.now();
  String _endTime = "9:30";
  String _startTime = DateFormat('hh:mm').format(DateTime.now()).toString();
  int _selectedRemind = 5;
  List<int> remindList = [5, 10, 15, 20];
  String _selectedRepeat = "None";
  List<String> repeatList = ["None", "Daily", "Weekly", "Monthly"];
  int _selectedColor = 0;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final TaskController _taskController = Get.put(TaskController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Add Task",
                style: headingStyle,
              ),
              MyInputField(
                title: 'Title',
                hint: 'Enter your title',
                controller: _titleController,
              ),
              MyInputField(
                title: 'Note',
                hint: 'Enter your note',
                controller: _noteController,
              ),
              MyInputField(
                title: 'Date',
                hint: DateFormat.yMd().format(_selectedDate),
                widget: IconButton(
                  onPressed: () {
                    _getDateFromUser();
                  },
                  icon: const Icon(
                    Icons.calendar_today_outlined,
                    color: Colors.grey,
                  ),
                ),
              ),
              _startAndEndTime(),
              remind(reminder: true),
              remind(reminder: false),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _colorPalette(),
                  MyButton(
                      label: "Create task",
                      onTap: () {
                        _validateDate();
                        _taskController.getTasks();
                      }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _appBar(BuildContext context) {
    return AppBar(
      leading: GestureDetector(
        onTap: () {
          Get.back();
        },
        child: const Icon(Icons.arrow_back),
      ),
    );
  }

  TextStyle get headingStyle {
    return GoogleFonts.lato(
        textStyle: const TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
    ));
  }

  _getDateFromUser() async {
    DateTime? _pickerDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime(2121),
    );
    if (_pickerDate != null) {
      setState(() {
        _selectedDate = _pickerDate;
      });
    }
  }

  _getTimeFromUser({required bool isStartTime}) async {
    var pickedTime = await _showTimePicker();
    // ignore: no_leading_underscores_for_local_identifiers
    String _formatedTime = pickedTime.format(context);
    if (pickedTime == null) {
    } else if (isStartTime == true) {
      setState(() {
        _startTime = _formatedTime;
      });
    } else if (isStartTime == false) {
      setState(() {
        _endTime = _formatedTime;
      });
    }
  }

  _showTimePicker() {
    return showTimePicker(
      initialEntryMode: TimePickerEntryMode.input,
      context: context,
      initialTime: TimeOfDay(
        hour: int.parse(_startTime.split(':')[0]),
        minute: int.parse(_startTime.split(':')[1].split(' ')[0]),
      ),
    );
  }

  _startAndEndTime() {
    return Row(
      children: [
        Expanded(
          child: MyInputField(
            title: "Start date",
            hint: _startTime,
            widget: IconButton(
              onPressed: () {
                _getTimeFromUser(isStartTime: true);
              },
              icon: const Icon(
                Icons.access_time_rounded,
                color: Colors.grey,
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 12,
        ),
        Expanded(
          child: MyInputField(
            title: "End date",
            hint: _endTime,
            widget: IconButton(
              onPressed: () {
                _getTimeFromUser(isStartTime: false);
              },
              icon: const Icon(
                Icons.access_time_rounded,
                color: Colors.grey,
              ),
            ),
          ),
        ),
      ],
    );
  }

  TextStyle get subTitleStyle {
    return GoogleFonts.lato(
      textStyle: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Get.isDarkMode ? Colors.grey[100] : Colors.grey[400],
      ),
    );
  }

  remind({required bool reminder}) {
    return MyInputField(
      title: reminder ? "Remind" : "Repeat",
      hint: reminder ? "$_selectedRemind minutes early" : "$_selectedRepeat ",
      widget: DropdownButton(
        icon: const Icon(
          Icons.keyboard_arrow_down,
          color: Colors.grey,
        ),
        iconSize: 32,
        elevation: 4,
        underline: Container(
          height: 0,
        ),
        style: subTitleStyle,
        items: reminder
            ? remindList.map<DropdownMenuItem<String>>((int value) {
                return DropdownMenuItem<String>(
                  value: value.toString(),
                  child: Text(value.toString()),
                );
              }).toList()
            : repeatList.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                );
              }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            reminder
                ? _selectedRemind = int.parse(newValue!)
                : _selectedRepeat = newValue!;
          });
        },
      ),
    );
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

  _colorPalette() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Color",
          style: titleStyle,
        ),
        const SizedBox(height: 8),
        Wrap(
          children: List<Widget>.generate(
            3,
            (int index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedColor = index;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: CircleAvatar(
                    radius: 14,
                    backgroundColor: index == 0
                        ? primaryClr
                        : index == 1
                            ? pinkClr
                            : yellowClr,
                    child: _selectedColor == index
                        ? const Icon(
                            Icons.done,
                            color: Colors.white,
                            size: 16,
                          )
                        : Container(),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  _validateDate() {
    if (_titleController.text.isNotEmpty & _noteController.text.isNotEmpty) {
      _addTaskToDb();
      Get.back();
    } else if (_titleController.text.isEmpty || _noteController.text.isEmpty) {
      Get.snackbar(
        "Required",
        "All fields are required",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        colorText: pinkClr,
        icon: const Icon(
          Icons.warning_amber_outlined,
          color: Colors.red,
        ),
      );
    }
  }

  _addTaskToDb() async {
    var value = await _taskController.addTask(
      task: Task(
        note: _noteController.text,
        title: _titleController.text,
        date: DateFormat.yMd().format(_selectedDate),
        startTime: _startTime,
        endTime: _endTime,
        remind: _selectedRemind,
        repeat: _selectedRepeat,
        color: _selectedColor,
        isCompleted: 0,
      ),
    );
  }
}
