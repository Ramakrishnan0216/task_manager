import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:task_manager/gen/assets.gen.dart';
import 'package:task_manager/models/task.dart';
import 'package:task_manager/services/DatabaseService.dart';
import 'package:task_manager/services/SharedPrefService.dart';
import 'package:task_manager/ui/home/CreateTaskPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DatabaseService _taskService = DatabaseService();
  final SharedPrefService _prefService = SharedPrefService();

  List<Task> _tasks = <Task>[];
  @override
  void initState() {
    super.initState();
    _getTaskList();
  }

  _getTaskList() async {
    print("Task list");
    final dbTasks =
        await _taskService.getAllTasks(_prefService.getCurrentUserId());
    _tasks.clear();
    _tasks.addAll(dbTasks);
    print(_tasks);
    setState(() {});
  }

  _dropTable() async {
    print("Droping table ");
    await _taskService.dropTableIfExistsThenReCreate();
    print("Done");
  }

  @override
  Widget build(BuildContext context) {
    return _ui(context);
  }

  Widget _ui(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _goToCreateTaskPage();
        },
        child: Icon(Icons.add),
      ),
      body: SafeArea(
        maintainBottomViewPadding: true,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 40),
                _title(context),
                SizedBox(height: 40),
                _tasks.length > 0
                    ? _taskList(context)
                    : Center(
                        child: Container(
                            width: 200,
                            height: 200,
                            child: Assets.images.notask.image())),
                SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _title(BuildContext context) {
    return Text(
      "Tasks",
      style: Theme.of(context).textTheme.headline4,
    );
  }

  Widget _taskList(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _tasks.length,
      itemBuilder: (context, index) {
        return taskItem(_tasks[index]);
      },
    );
  }

  Widget taskItem(Task task) {
    return Container(
      child: CheckboxListTile(
        title: Text(
          task.title,
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w700,
            decoration: task.finished
                ? TextDecoration.lineThrough
                : TextDecoration.none,
          ),
        ),
        subtitle: Text(
          task.desc,
          style: TextStyle(
            decoration: task.finished
                ? TextDecoration.lineThrough
                : TextDecoration.none,
          ),
        ),
        value: task.finished,
        onChanged: (bool? value) {
          setState(() {
            _updateTask(Task(
              id: task.id,
              userId: task.userId,
              title: task.title,
              desc: task.desc,
              createdAt: task.createdAt,
              modifiedAt: task.modifiedAt,
              finished: value != null ? value : false,
            ));
          });
        },
      ),
    );
  }

  _updateTask(Task task) async {
    print("Task list");

    await _taskService.updateTask(task);
    _getTaskList();
  }

  _goToCreateTaskPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreateTaskPage()),
    ).then((value) => _getTaskList());
  }
}
