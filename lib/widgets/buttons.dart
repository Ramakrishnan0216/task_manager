import 'package:flutter/material.dart';

class BackArrowButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      constraints: const BoxConstraints(minWidth: 0, minHeight: 0),
      padding: EdgeInsets.all(10),
      onPressed: () {
        Navigator.pop(context);
      },
      fillColor: Colors.green[50],
      child: Icon(
        Icons.arrow_back_rounded,
        size: 15,
      ),
      shape: CircleBorder(),
      elevation: 0,
    );
  }
}
