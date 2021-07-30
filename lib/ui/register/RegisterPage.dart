import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/gen/assets.gen.dart';
import 'package:task_manager/widgets/SubmitButton.dart';
import 'package:task_manager/widgets/buttons.dart';
import 'package:task_manager/widgets/input_fields.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _ui(context);
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
            backgroundColor: Theme.of(context).primaryColor,
            child: ClipOval(
              child: Assets.images.profile.image(),
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
      _emailController,
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
      _passwordController,
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
        onClicked: _onRegisterClicked(),
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

  _onLoginClicked() async {
    Navigator.pop(context);
  }

  _onRegisterClicked() async {}
}
