import 'package:flutter/material.dart';
import 'package:potato_apps/theme.dart';

class FieldFilter extends StatelessWidget {
  const FieldFilter(
      {super.key,
      required this.controller,
      required this.icon,
      required this.keyType,
      required this.labelField,
      required this.hintxt});

  final TextEditingController controller;
  final icon;
  final TextInputType keyType;
  final String labelField;
  final String hintxt;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller, // use the controller to fill the text field
      keyboardType: keyType,
      enabled: false,
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
        hintText: hintxt,
        hintStyle: blackTextStyle.copyWith(fontSize: 12, fontWeight: medium),
        labelText: labelField,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        floatingLabelAlignment: FloatingLabelAlignment.center,
        labelStyle: blackTextStyle.copyWith(fontSize: 16, fontWeight: bold),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        suffixIcon: icon,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color:
                primaryColor, // Default color when the field is enabled but not focused
            style: BorderStyle.solid,
            width: 1,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color:
                primaryColor, // Default color when the field is enabled but not focused
            style: BorderStyle.solid,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color:
                primaryColor, // Default color when the field is enabled but not focused
            style: BorderStyle.solid,
            width: 2,
          ),
        ),
      ),
    );
  }
}
