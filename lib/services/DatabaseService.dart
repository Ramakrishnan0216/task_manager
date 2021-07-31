import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:task_manager/models/task.dart';
import 'package:task_manager/models/user.dart';

class DatabaseService {
  static final DatabaseService _singleton = DatabaseService._internal();
  DatabaseService._internal();
  factory DatabaseService() {
    return _singleton;
  }

  Future<Database> _openDatabase() async {
    print("Open Database");
    var databasesPath = await getDatabasesPath();
    print("databasesPath: $databasesPath");
    String path = join(databasesPath, 'task_database.db');
    print("path: $databasesPath");
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        return _createTables(db);
      },
    );
  }

  _createTables(Database database) async {
    await database.execute(
      Task.createTableComment,
    );
    await database.execute(
      TaskUser.createTableComment,
    );
    return;
  }

  Future<void> insertTask(Task task) async {
    // Get a reference to the database.

    final db = await _openDatabase();
    await db.insert(
      Task.tableName,
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    await db.close();
  }

  Future<bool> isUserExitsByEmail(String email) async {
    final db = await _openDatabase();
    var queryResult = await db.query(
      TaskUser.tableName,
      where: 'email = ?',
      whereArgs: [email],
    );
    await db.close();
    return queryResult.isNotEmpty ? true : false;
  }

  Future<TaskUser?> getUserById(String userId) async {
    final db = await _openDatabase();
    var queryResult = await db.query(
      TaskUser.tableName,
      where: 'uid = ?',
      whereArgs: [userId],
    );
    await db.close();
    if (queryResult.isNotEmpty) {
      return TaskUser.fromMap(queryResult.first);
    } else {
      return null;
    }
  }

  Future<TaskUser?> loginUser(String email, String password) async {
    final db = await _openDatabase();
    var queryResult = await db.query(
      TaskUser.tableName,
      where: 'email = ?',
      whereArgs: [email],
    );
    await db.close();
    if (queryResult.isNotEmpty) {
      var user = TaskUser.fromMap(queryResult.first);
      return user.email == email && user.password == password ? user : null;
    } else {
      return null;
    }
  }

  Future<bool> insertUser(TaskUser user) async {
    // Get a reference to the database.

    final db = await _openDatabase();
    await db.insert(
      TaskUser.tableName,
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    await db.close();
    return true;
  }

  Future<List<Task>> getAllTasks(String userId) async {
    // Get a reference to the database.
    final db = await _openDatabase();

    final List<Map<String, dynamic>> maps = await db.query(
      Task.tableName,
      where: 'userid = ?',
      whereArgs: [userId],
    );
    await db.close();
    return List.generate(maps.length, (i) {
      return Task.fromMap(maps[i]);
      // return Task(
      //   id: maps[i]['id'],
      //   userId: maps[i]['userid'],
      //   title: maps[i]['title'],
      //   desc: maps[i]['desc'],
      //   color: maps[i]['color'],
      //   status: maps[i]['status'],
      //   createdAt: maps[i]['created'],
      //   modifiedAt: maps[i]['modified'],
      //   finished: (maps[i]['finished']) == 0 ? false : true,
      // );
    });
  }

  Future<void> updateTask(Task task) async {
    // Get a reference to the database.
    final db = await _openDatabase();

    await db.update(
      Task.tableName,
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
    db.close();
  }

  Future<bool> updateUser(TaskUser user) async {
    // Get a reference to the database.

    final db = await _openDatabase();
    await db.update(
      TaskUser.tableName,
      user.toMap(),
      where: 'uid = ?',
      whereArgs: [user.uid],
    );
    await db.close();
    return true;
  }

  Future<void> dropTableIfExistsThenReCreate() async {
    Database db = await _openDatabase();

    //here we execute a query to drop the table if exists which is called "tableName"
    //and could be given as method's input parameter too
    await db.execute("DROP TABLE IF EXISTS ${Task.tableName}");
    await db.execute("DROP TABLE IF EXISTS ${TaskUser.tableName}");

    //and finally here we recreate our beloved "tableName" again which needs
    //some columns initialization
    await db.execute(Task.createTableComment);
    await db.execute(TaskUser.createTableComment);
  }
}
