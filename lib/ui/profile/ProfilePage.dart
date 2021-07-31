import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:path_provider/path_provider.dart';
import 'package:task_manager/gen/assets.gen.dart';
import 'package:task_manager/models/user.dart';
import 'package:task_manager/services/DatabaseService.dart';
import 'package:task_manager/services/SharedPrefService.dart';
import 'package:task_manager/ui/login/LoginPage.dart';
import 'package:task_manager/widgets/input_fields.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  DatabaseService _databaseService = DatabaseService();
  SharedPrefService _prefService = SharedPrefService();
  final _nameController = TextEditingController();
  bool _onEditMode = false;
  TaskUser? _currentUser;
  File? _userProfile;
  File? _tempSelected;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      this._getUser();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();

    super.dispose();
  }

  _getUser() async {
    var currentUserId = _prefService.getCurrentUserId();
    var taskUser = await _databaseService.getUserById(currentUserId);
    if (taskUser != null) {
      print(taskUser);
      setState(() {
        _currentUser = taskUser;
        _userProfile = File(taskUser.profile);
      });
    }
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
                Align(
                  alignment: Alignment.topRight,
                  child: editButton(context),
                ),
                SizedBox(height: 25),
                _title(context),
                SizedBox(height: 10),
                Center(child: _profileLogo(context)),
                SizedBox(height: 16),
                _name(
                  context,
                  "Name",
                  _currentUser != null ? _currentUser!.name : "name",
                  Icons.person,
                ),
                SizedBox(height: 20),
                _profileItem(
                  context,
                  "Email",
                  _currentUser != null ? _currentUser!.email : "email",
                  Icons.email,
                ),
                SizedBox(height: 20),
                TextButton(
                    onPressed: () {
                      _signOut(context);
                    },
                    child: Text("Sign Out"))
                // SizedBox(height: 20),
                // _emailInput(context),
                // SizedBox(height: 20),
                // _passInput(context),
                // SizedBox(height: 20),
                // _cPassInput(context),
                // SizedBox(height: 40),
                // _registerButton(context),
                // SizedBox(height: 40),
                // _createNewAccount(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget editButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!_onEditMode) {
          _nameController.text = _currentUser != null ? _currentUser!.name : "";
          setState(() {
            _onEditMode = true;
          });
        } else {
          _updateUser(context);
        }
      },
      child: Material(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(
            _onEditMode ? Icons.done : Icons.edit,
            size: 15,
          ),
        ),
        elevation: 8,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  _updateUser(BuildContext context) async {
    final progress = ProgressHUD.of(context);
    progress?.show();
    var currentUserId = _prefService.getCurrentUserId();
    String path = await _getProfilePath(currentUserId);
    var taskUser = TaskUser(
      uid: currentUserId,
      name: _nameController.text,
      email: _currentUser!.email,
      password: _currentUser!.password,
      createdAt: _currentUser!.createdAt,
      modifiedAt: DateTime.now().millisecondsSinceEpoch,
      profile: path,
    );

    await _databaseService.updateUser(taskUser);
    var updatedUser = await _databaseService.getUserById(currentUserId);

    if (updatedUser != null) {
      setState(() {
        _currentUser = updatedUser;
        _userProfile = null;
        _tempSelected = null;
      });
    } else {
      setState(() {
        _tempSelected = null;
        _onEditMode = false;
      });
    }
    Future.delayed(Duration(seconds: 2), () {
      progress?.dismiss();
      setState(() {
        _onEditMode = false;
        _userProfile = File(_currentUser!.profile);
      });
    });
  }

  Widget _title(BuildContext context) {
    return Text(
      "Profile",
      style: Theme.of(context).textTheme.headline4,
    );
  }

  Widget _getCurrentUserPhoto(BuildContext context) {
    return _userProfile != null
        ? Image.file(
            _userProfile!,
            fit: BoxFit.cover,
          )
        : Assets.images.user.image();
  }

  Widget _getTempUserPhoto(BuildContext context) {
    return _tempSelected != null
        ? Image.file(_tempSelected!)
        : _getCurrentUserPhoto(context);
  }

  Widget _profileLogo(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 50,
            child: ClipOval(
              child: AspectRatio(
                aspectRatio: 1 / 1,
                child: _onEditMode
                    ? _getTempUserPhoto(context)
                    : _getCurrentUserPhoto(context),
              ),
            ),
          ),
          _onEditMode
              ? _photoUpload(context)
              : Container(
                  height: 2,
                  width: 1,
                ),
        ],
      ),
    );
  }

  Widget _photoUpload(BuildContext context) {
    return Positioned(
      bottom: 1,
      right: 1,
      child: GestureDetector(
        onTap: () {
          _onUploadClicked();
        },
        child: Container(
          height: 30,
          width: 30,
          padding: EdgeInsets.all(1),
          child: Icon(
            Icons.add_a_photo,
            color: Colors.white,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
        ),
      ),
    );
  }

  Widget _name(
    BuildContext context,
    String title,
    String value,
    IconData icon,
  ) {
    return _onEditMode
        ? _nameInput(context)
        : _profileItem(context, title, value, icon);
  }

  Widget _nameInput(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return InputFieldBox(
      _nameController,
      hintText: "Name",
      keyboardType: TextInputType.name,
      enableLabel: true,
      prefixIcon: Icon(
        Icons.person,
        color: Theme.of(context).iconTheme.color,
      ),
    );
  }

  Widget _profileItem(
      BuildContext context, String title, String value, IconData icon) {
    return Row(
      children: [
        ClipOval(
          child: Material(
            shadowColor: Colors.black,
            color: Colors.white,
            elevation: 8,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                icon,
                color: Theme.of(context).primaryColor,
                size: 20,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  _onUploadClicked() {
    _pickImageWithFilePicker();
  }

  _pickImageWithFilePicker() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null) {
      print("file seleceted");
      print(result.count);
      File file = File(result.files.single.path!);
      setState(() {
        _tempSelected = file;
      });
    } else {
      // User canceled the picker
      print("file Canceled");
    }
  }

  Future<String> _getProfilePath(String uid) async {
    // getting a directory path for saving
    final Directory directory = await getApplicationDocumentsDirectory();
    var directoryPath = directory.path;
    var profilePath = _currentUser!.profile;
    if (_tempSelected != null) {
      // First delete current photo
      await File(_currentUser!.profile).delete();
      // copy the file to a new directorypath
      final File newImage =
          await _tempSelected!.copy('$directoryPath/$uid.png');
      profilePath = newImage.path;
    }

    return profilePath;
  }

  void _signOut(BuildContext context) async {
    final progress = ProgressHUD.of(context);
    progress?.show();
    await _prefService.clearUser();
    progress?.dismiss();
    _goToLoginPage();
  }

  _goToLoginPage() async {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }
}
