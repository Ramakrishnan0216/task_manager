import 'package:flutter/material.dart';

class InputFieldBox extends StatefulWidget {
  final hintText;
  final keyboardType;
  final _controller;
  final TextAlign textAlign;
  final bool enableLabel;
  final int? maxLength;
  final Icon? prefixIcon;
  final bool isPassword;

  const InputFieldBox(
    this._controller, {
    Key? key,
    this.hintText,
    this.keyboardType,
    this.textAlign = TextAlign.start,
    this.enableLabel = false,
    this.maxLength,
    this.prefixIcon,
    this.isPassword = false,
  }) : super(key: key);

  @override
  _InputFieldBoxState createState() => _InputFieldBoxState();
}

class _InputFieldBoxState extends State<InputFieldBox> {
  FocusNode _focusNode = new FocusNode();
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
    _focused = _focusNode.hasFocus;
  }

  void _onFocusChange() {
    print("Focus: " + _focusNode.hasFocus.toString());
    setState(() {
      _focused = _focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(0),
      decoration: BoxDecoration(
        color: _focused ? Colors.green[50] : Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(4)),
        border: _focused ? focuseBorder() : focuseBorder(),
      ),
      child: TextField(
        obscureText: widget.isPassword,
        maxLength: widget.maxLength,
        textAlign: widget.textAlign,
        controller: widget._controller,
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        keyboardType: widget.keyboardType != null
            ? widget.keyboardType
            : TextInputType.text,
        focusNode: _focusNode,
        decoration: InputDecoration(
          prefixIcon: widget.prefixIcon,
          counterText: "",
          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          hintText: widget.enableLabel
              ? null
              : _focused
                  ? null
                  : widget.hintText,
          hintStyle: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.normal,
            fontSize: 20,
          ),
          labelText: widget.enableLabel ? widget.hintText : null,
          labelStyle: _focused
              ? TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                )
              : TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.normal,
                  fontSize: 12,
                ),
          filled: false,
          border: InputBorder.none,
          //fillColor: _focused ? Colors.white : Colors.grey,
          focusColor: Colors.amber,
        ),
      ),
    );
  }

  BoxBorder focuseBorder() {
    return Border.all(
      color: Colors.green,
    );
  }

  BoxBorder noFocusBorder() {
    return Border.all(
      color: Colors.grey.shade300,
    );
  }
}
