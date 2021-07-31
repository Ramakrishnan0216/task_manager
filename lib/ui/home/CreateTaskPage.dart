import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/models/task.dart';
import 'package:task_manager/services/NotificationService.dart';
import 'package:task_manager/services/DatabaseService.dart';
import 'package:task_manager/services/SharedPrefService.dart';
import 'package:task_manager/widgets/SubmitButton.dart';
import 'package:task_manager/widgets/buttons.dart';
import 'package:task_manager/widgets/input_fields.dart';

class CreateTaskPage extends StatefulWidget {
  const CreateTaskPage({Key? key}) : super(key: key);

  @override
  _CreateTaskPageState createState() => _CreateTaskPageState();
}

class _CreateTaskPageState extends State<CreateTaskPage> {
  final DatabaseService _taskService = DatabaseService();
  final NotificationService _notificationService = NotificationService();
  final SharedPrefService _prefService = SharedPrefService();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final StreamController<bool> _enableStreamController =
      StreamController<bool>();

  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;

  // create some values
  Color pickerColor = Color(0xff443a49);
  Color currentColor = Color(0xff443a49);

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _selectedTime = TimeOfDay(
        hour: _selectedDate.hour + 1, minute: _selectedDate.minute + 1);
    _titleController.addListener(() {
      _enableStreamController.add(_checkFieldsNotEmpty());
    });
    _descController.addListener(() {
      _enableStreamController.add(_checkFieldsNotEmpty());
    });
  }

  bool _checkFieldsNotEmpty() {
    return _titleController.text.isNotEmpty && _descController.text.isNotEmpty;
  }

  String _getFormatedDate(DateTime dateTime) {
    final DateFormat formatter = DateFormat('EEEE dd, MMMM yyyy');
    final String formatted = formatter.format(dateTime);
    return formatted;
  }

  String _getFormatedTime(TimeOfDay timeOfDay) {
    final timeToFormat = DateTime(_selectedDate.year, _selectedDate.month,
        _selectedDate.day, timeOfDay.hour, timeOfDay.minute);
    final DateFormat formatter = DateFormat('jm');
    final String formatted = formatter.format(timeToFormat);
    return formatted;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      backgroundColor: Theme.of(context).primaryColor,
      child: Builder(
        builder: (context) => _ui(context),
      ),
    );
  }

  Widget _ui(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        maintainBottomViewPadding: true,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Align(alignment: Alignment.topLeft, child: BackArrowButton()),
                SizedBox(height: 40),
                _title(context),
                SizedBox(height: 40),
                _taskTitleInput(context),
                SizedBox(height: 20),
                _taskDiscInput(context),
                SizedBox(height: 20),
                _dateAndTimeReminder(context),
                SizedBox(height: 50),
                _createTaskButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _title(BuildContext context) {
    return Text(
      "Create New Task",
      style: Theme.of(context).textTheme.headline4,
    );
  }

  Widget _taskTitleInput(BuildContext context) {
    return InputFieldBox(
      _titleController,
      hintText: "Task Title",
      keyboardType: TextInputType.text,
      enableLabel: true,
    );
  }

  Widget _taskDiscInput(BuildContext context) {
    return InputFieldBox(
      _descController,
      hintText: "Description",
      keyboardType: TextInputType.multiline,
      enableLabel: true,
      maxLines: null,
    );
  }

  Widget _dateAndTimeReminder(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          child: _pickDate(context),
          onTap: () {
            _datePicker();
          },
        ),
        GestureDetector(
          child: _pickTime(context),
          onTap: () {
            _timePicker();
          },
        ),
      ],
    );
  }

  Widget _pickDate(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Material(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10)),
            child: Container(
              child: Icon(Icons.calendar_today),
              padding: EdgeInsets.all(10),
            ),
            elevation: 10,
            shadowColor: Colors.white,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              _getFormatedDate(_selectedDate),
              style: Theme.of(context).textTheme.subtitle2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _pickTime(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Material(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10)),
            child: Container(
              child: Icon(Icons.alarm),
              padding: EdgeInsets.all(10),
            ),
            elevation: 10,
            shadowColor: Colors.white,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              _getFormatedTime(_selectedTime),
              style: Theme.of(context).textTheme.subtitle2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _createTaskButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: SubmitElevatedButton(
        buttonText: "Create Task",
        onClicked: () {
          _onCreateClicked(context);
        },
        enableStream: _enableStreamController.stream,
      ),
    );
  }

  _datePicker() async {
    var current = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      initialDatePickerMode: DatePickerMode.day,
      firstDate: current,
      lastDate: DateTime(current.year + 1),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  _timePicker() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null)
      setState(() {
        _selectedTime = picked;
      });
  }

  showAlertDialog(BuildContext context, String title, String content) {
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          child: Text("OK"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  _onCreateClicked(BuildContext context) async {
    final progress = ProgressHUD.of(context);
    progress?.show();
    if (Platform.isIOS) {
      var isGranted = await NotificationService().requestPermissions();
      if (isGranted == null || !isGranted) {
        showAlertDialog(context, "Permission not granted",
            "Please enable permission for notification");
        return;
      }
    }
    var task = Task(
      id: 0,
      userId: _prefService.getCurrentUserId(),
      title: _titleController.text,
      desc: _descController.text,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      modifiedAt: DateTime.now().millisecondsSinceEpoch,
    );

    await _taskService.insertTask(task);
    await _notificationService.sheduleNotification(task,
        _getReminderTimeInMillis() - DateTime.now().millisecondsSinceEpoch);

    progress?.dismiss();
    print("Done Insert");
    Navigator.pop(context);
  }

  int _getReminderTimeInMillis() {
    var reminderTime = DateTime(_selectedDate.year, _selectedDate.month,
        _selectedDate.day, _selectedTime.hour, _selectedTime.minute);

    return reminderTime.millisecondsSinceEpoch;
  }
}
