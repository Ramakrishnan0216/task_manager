import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/gen/assets.gen.dart';
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
                  keyboardType: TextInputType.emailAddress,
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
        child: Assets.images.user.image(),
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
                ..onTap = () => _onCreateAccountClicked(),
              text: 'create a new account',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green,
              )),
        ],
      ),
    );
  }

  _onCreateAccountClicked() {}
}
