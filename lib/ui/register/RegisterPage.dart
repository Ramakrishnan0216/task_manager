import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:path_provider/path_provider.dart';
import 'package:string_validator/string_validator.dart';
import 'package:task_manager/gen/assets.gen.dart';
import 'package:task_manager/models/user.dart';
import 'package:task_manager/services/DatabaseService.dart';
import 'package:task_manager/widgets/SubmitButton.dart';
import 'package:task_manager/widgets/buttons.dart';
import 'package:task_manager/widgets/input_fields.dart';
import 'package:uuid/uuid.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _cPasswordController = TextEditingController();
  final StreamController<bool> _enableStreamController =
      StreamController<bool>();
  final DatabaseService _databaseService = DatabaseService();
  final Uuid _uuid = Uuid();
  File? _selectedProfile;
  @override
  void initState() {
    super.initState();
    _nameController.addListener(() {
      _enableStreamController.add(_checkFields());
    });
    _emailController.addListener(() {
      _enableStreamController.add(_checkFields());
    });
    _passwordController.addListener(() {
      _enableStreamController.add(_checkFields());
    });

    _cPasswordController.addListener(() {
      _enableStreamController.add(_checkFields());
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _cPasswordController.dispose();
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
                Align(alignment: Alignment.topLeft, child: _backButton()),
                SizedBox(height: 40),
                Center(child: _profileLogo(context)),
                SizedBox(height: 16),
                _title(context),
                SizedBox(height: 10),
                _subTitle(context),
                SizedBox(height: 20),
                _nameInput(context),
                SizedBox(height: 20),
                _emailInput(context),
                SizedBox(height: 20),
                _passInput(context),
                SizedBox(height: 20),
                _cPassInput(context),
                SizedBox(height: 40),
                _registerButton(context),
                SizedBox(height: 40),
                _createNewAccount(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _backButton() {
    return BackArrowButton();
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
                child: _selectedProfile != null
                    ? Image.file(
                        _selectedProfile!,
                        fit: BoxFit.cover,
                      )
                    : Assets.images.user.image(),
              ),
            ),
          ),
          _photoUpload(context)
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

  Widget _title(BuildContext context) {
    return Text(
      "Register",
      style: Theme.of(context).textTheme.headline4,
    );
  }

  Widget _nameInput(BuildContext context) {
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

  Widget _emailInput(BuildContext context) {
    return InputFieldBox(
      _emailController,
      hintText: "Email",
      keyboardType: TextInputType.emailAddress,
      enableLabel: true,
      prefixIcon: Icon(
        Icons.mail,
        color: Theme.of(context).iconTheme.color,
      ),
    );
  }

  Widget _passInput(BuildContext context) {
    return InputFieldBox(
      _passwordController,
      hintText: "Password",
      keyboardType: TextInputType.text,
      enableLabel: true,
      prefixIcon: Icon(
        Icons.lock,
        color: Theme.of(context).iconTheme.color,
      ),
      isPassword: true,
    );
  }

  Widget _cPassInput(BuildContext context) {
    return InputFieldBox(
      _cPasswordController,
      hintText: "Confirm Password",
      keyboardType: TextInputType.text,
      enableLabel: true,
      prefixIcon: Icon(
        Icons.lock,
        color: Theme.of(context).iconTheme.color,
      ),
      isPassword: true,
    );
  }

  Widget _subTitle(BuildContext context) {
    return Text(
      "Create a new Account",
      style: Theme.of(context).textTheme.subtitle1,
    );
  }

  Widget _registerButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: SubmitElevatedButton(
        buttonText: "Create Account",
        onClicked: () {
          _onRegisterClicked(context);
        },
        enableStream: _enableStreamController.stream,
      ),
    );
  }

  Widget _createNewAccount(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: "Already have a account? ",
        style: Theme.of(context).textTheme.bodyText1,
        children: <TextSpan>[
          TextSpan(
              recognizer: TapGestureRecognizer()
                ..onTap = () => _onLoginClicked(),
              text: 'Login',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green,
              )),
        ],
      ),
    );
  }

  // _pickImage() async {
  //   final ImagePicker _picker = ImagePicker();
  //   // Pick an image
  //   final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
  //   if (image != null) {
  //     print("Image file not nulll");
  //     setState(() {
  //       _selectedProfile = image;
  //     });
  //   } else {
  //     print("image null");
  //   }
  // }

  _pickImageWithFilePicker() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null) {
      print("file seleceted");
      print(result.count);
      File file = File(result.files.single.path!);
      setState(() {
        _selectedProfile = file;
      });
    } else {
      // User canceled the picker
      print("file Canceled");
    }
  }

  _onLoginClicked() {
    _goToLoginPage();
  }

  _goToLoginPage() async {
    Navigator.pop(context);
  }

  _onRegisterClicked(BuildContext context) async {
    if (_selectedProfile == null) {
      showAlertDialog(context, "Profile Missing", "Please upload your photo");
      return;
    }
    final progress = ProgressHUD.of(context);
    progress?.show();
    var isUserExits =
        await _databaseService.isUserExitsByEmail(_emailController.text.trim());
    if (!isUserExits) {
      progress?.show();
      var uid = _uuid.v1();
      var profilePath = await _getProfilePath(uid);
      var isRegisterSuccess = await _databaseService.insertUser(
        TaskUser(
          uid: uid,
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
          createdAt: DateTime.now().millisecondsSinceEpoch,
          modifiedAt: DateTime.now().millisecondsSinceEpoch,
          profile: profilePath,
        ),
      );
      if (isRegisterSuccess) {
        progress?.dismiss();
        _goToLoginPage();
      } else {
        progress?.dismiss();
        showAlertDialog(
            context, "Registration Failed", "Unable register try again later");
      }
    } else {
      progress?.dismiss();
      showAlertDialog(context, "User email already exists",
          "User email already exists please try login with current email or register with new email");
    }
  }

  Future<String> _getProfilePath(String uid) async {
    // getting a directory path for saving
    final Directory directory = await getApplicationDocumentsDirectory();
    var directoryPath = directory.path;
    //var byteData = await rootBundle.load(Assets.images.user.path);
    var profilePath = Assets.images.user.path;
    if (_selectedProfile != null) {
      // copy the file to a new directorypath
      final File newImage =
          await _selectedProfile!.copy('$directoryPath/$uid.png');
      profilePath = newImage.path;
    }

    return profilePath;
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

  _onUploadClicked() {
    _pickImageWithFilePicker();
  }

  bool _checkFields() {
    return _emailController.text.isNotEmpty &&
        isEmail(_emailController.text.trim()) &&
        _passwordController.text.isNotEmpty &&
        _cPasswordController.text.isNotEmpty &&
        _passwordController.text.length > 6 &&
        _cPasswordController.text.trim() == _passwordController.text.trim();
  }
}
