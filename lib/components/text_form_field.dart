import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TextFormField extends StatelessWidget {
  String fieldName;
  String fieldTextHint;

  TextFormField(this.fieldName, this.fieldTextHint);

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: fieldTextHint,
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blueGrey, width: 1.0),
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blueGrey, width: 2.0),
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
        ),
      ),
      onChanged: (value) {
        fieldName = value;
      },
    );
  }
}
