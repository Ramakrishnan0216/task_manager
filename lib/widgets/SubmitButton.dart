import 'package:flutter/material.dart';

class SubmitElevatedButton extends StatefulWidget {
  final String? buttonText;
  final Function? onClicked;
  final Stream<bool>? enableStream;

  const SubmitElevatedButton(
      {Key? key, this.buttonText, this.onClicked, this.enableStream})
      : super(key: key);

  @override
  _SubmitElevatedButtonState createState() => _SubmitElevatedButtonState();
}

class _SubmitElevatedButtonState extends State<SubmitElevatedButton> {
  bool _isEnabled = false;

  @override
  void initState() {
    super.initState();
    if (widget.enableStream != null) {
      widget.enableStream!.listen((enable) {
        _setIsEnabled(enable);
      });
    } else {
      _isEnabled = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.disabled)) {
              return Colors.white;
            }
            return Colors.white; // Use the component's default.
          },
        ),
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.disabled))
              return Color(0xffC4C4C4);
            return Theme.of(context)
                .primaryColor; // Use the component's default.
          },
        ),
        textStyle: MaterialStateProperty.resolveWith<TextStyle>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.disabled)) {
              return TextStyle(
                color: Colors.white,
              );
            }
            return TextStyle(
              color: Colors.amber,
            ); // Use the component's default.
          },
        ),
      ),
      onPressed: _isEnabled ? _onPressed : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 16,
        ),
        child:
            widget.buttonText != null ? Text(widget.buttonText!) : Text("Next"),
      ),
    );
  }

  _onPressed() {
    if (widget.onClicked != null) {
      widget.onClicked!();
    }
  }

  void _setIsEnabled(bool enable) {
    print("Setting Enable : $enable");
    setState(() {
      _isEnabled = enable;
    });
  }
}
