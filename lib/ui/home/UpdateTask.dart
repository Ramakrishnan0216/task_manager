import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:task_manager/models/task.dart';
import 'package:task_manager/services/DatabaseService.dart';
import 'package:task_manager/services/NotificationService.dart';
import 'package:task_manager/services/SharedPrefService.dart';
import 'package:task_manager/widgets/SubmitButton.dart';
import 'package:task_manager/widgets/buttons.dart';
import 'package:task_manager/widgets/input_fields.dart';

class UpdateTaskPage extends StatefulWidget {
  final Task task;
  const UpdateTaskPage({Key? key, required this.task}) : super(key: key);

  @override
  _UpdateTaskPageState createState() => _UpdateTaskPageState();
}

class _UpdateTaskPageState extends State<UpdateTaskPage> {
  final DatabaseService _taskService = DatabaseService();
  final NotificationService _notificationService = NotificationService();
  final SharedPrefService _prefService = SharedPrefService();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final StreamController<bool> _enableStreamController =
      StreamController<bool>();

  @override
  void initState() {
    super.initState();
    _titleController.addListener(() {
      _enableStreamController.add(_checkFieldsNotEmpty());
    });
    _descController.addListener(() {
      _enableStreamController.add(_checkFieldsNotEmpty());
    });

    _titleController.text = widget.task.title;
    _descController.text = widget.task.desc;
  }

  bool _checkFieldsNotEmpty() {
    return _titleController.text.isNotEmpty && _descController.text.isNotEmpty;
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
                SizedBox(height: 50),
                _updateTaskButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _title(BuildContext context) {
    return Text(
      "Update Task",
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

  Widget _updateTaskButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: SubmitElevatedButton(
        buttonText: "Update Task",
        onClicked: () {
          _onUpdateClicked(context);
        },
        enableStream: _enableStreamController.stream,
      ),
    );
  }

  _onUpdateClicked(BuildContext context) async {
    final progress = ProgressHUD.of(context);
    progress?.show();
    var oldTask = widget.task;
    var task = Task(
      id: oldTask.id,
      userId: oldTask.userId,
      title: _titleController.text,
      desc: _descController.text,
      createdAt: oldTask.createdAt,
      modifiedAt: DateTime.now().millisecondsSinceEpoch,
    );

    await _taskService.updateTask(task);

    progress?.dismiss();
    print("Done Update");
    Navigator.pop(context);
  }
}
