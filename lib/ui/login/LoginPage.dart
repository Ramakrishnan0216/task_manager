import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:string_validator/string_validator.dart';
import 'package:task_manager/gen/assets.gen.dart';
import 'package:task_manager/services/DatabaseService.dart';
import 'package:task_manager/services/SharedPrefService.dart';
import 'package:task_manager/ui/MainPage.dart';
import 'package:task_manager/ui/home/HomePage.dart';
import 'package:task_manager/ui/register/RegisterPage.dart';
import 'package:task_manager/widgets/SubmitButton.dart';
import 'package:task_manager/widgets/input_fields.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final StreamController<bool> _enableStreamController =
      StreamController<bool>();

  final DatabaseService _databaseService = DatabaseService();
  final SharedPrefService _prefService = SharedPrefService();

  @override
  void initState() {
    super.initState();
    _emailController.addListener(() {
      _enableStreamController.add(_checkFields());
    });
    _passwordController.addListener(() {
      _enableStreamController.add(_checkFields());
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
                SizedBox(height: 40),
                Center(child: _profileLogo(context)),
                SizedBox(height: 16),
                _title(context),
                SizedBox(height: 10),
                _subTitle(context),
                SizedBox(height: 20),
                InputFieldBox(
                  _emailController,
                  hintText: "Email",
                  keyboardType: TextInputType.emailAddress,
                  enableLabel: true,
                  prefixIcon: Icon(
                    Icons.mail,
                    color: Theme.of(context).iconTheme.color,
                  ),
                ),
                SizedBox(height: 20),
                InputFieldBox(
                  _passwordController,
                  hintText: "Password",
                  keyboardType: TextInputType.text,
                  enableLabel: true,
                  prefixIcon: Icon(
                    Icons.lock,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  isPassword: true,
                ),
                SizedBox(height: 40),
                _loginButton(context),
                SizedBox(height: 40),
                _createNewAccount(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _profileLogo(BuildContext context) {
    return SizedBox(
      width: 90,
      height: 90,
      child: Container(
        color: Colors.white,
        child: Assets.images.tasks.image(),
      ),
    );
  }

  Widget _title(BuildContext context) {
    return Text(
      "Welcome back",
      style: Theme.of(context).textTheme.headline4,
    );
  }

  Widget _subTitle(BuildContext context) {
    return Text(
      "Sign to continue",
      style: Theme.of(context).textTheme.subtitle1,
    );
  }

  Widget _loginButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: SubmitElevatedButton(
        buttonText: "LOGIN",
        onClicked: () {
          _onLoginClicked(context);
        },
        enableStream: _enableStreamController.stream,
      ),
    );
  }

  Widget _createNewAccount(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: "Don't have account? ",
        style: Theme.of(context).textTheme.bodyText1,
        children: <TextSpan>[
          TextSpan(
              recognizer: TapGestureRecognizer()
                ..onTap = () => _onRegisterClicked(),
              text: 'Register',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green,
              )),
        ],
      ),
    );
  }

  _onRegisterClicked() {
    _goToRegisterPage();
  }

  _onLoginClicked(BuildContext context) async {
    final progress = ProgressHUD.of(context);
    progress?.show();
    var isUserExits =
        await _databaseService.isUserExitsByEmail(_emailController.text.trim());
    if (isUserExits) {
      progress?.show();
      var user = await _databaseService.loginUser(
          _emailController.text.trim(), _passwordController.text.trim());
      if (user != null) {
        progress?.dismiss();
        await _prefService.setCurrentUserId(user.uid);
        await _prefService.setUserLoggedIn(true);
        _goToMainPage();
      } else {
        progress?.dismiss();
        showAlertDialog(context, "Login Failed", "Credential Miss match");
      }
    } else {
      progress?.dismiss();
      showAlertDialog(context, "Email not registerd",
          "The Email is not registered yet please register before login");
    }
  }

  _goToRegisterPage() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegisterPage()),
    );
  }

  _goToMainPage() async {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => HomePage()),
    // );

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => MainPage()),
    );
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

  bool _checkFields() {
    return _emailController.text.isNotEmpty &&
        isEmail(_emailController.text.trim()) &&
        _passwordController.text.isNotEmpty &&
        _passwordController.text.length > 6;
  }
}
