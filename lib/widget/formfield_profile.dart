import 'package:flutter/material.dart';
import 'package:potato_apps/theme.dart';

class FormFieldProfile extends StatelessWidget {
  const FormFieldProfile(
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              width: 8,
            ),
            Expanded(
                child: Text(
              labelField,
              style: blackTextStyle.copyWith(fontWeight: bold),
            )),
          ],
        ),
        TextFormField(
          controller: controller, // use the controller to fill the text field
          keyboardType: keyType,
          decoration: InputDecoration(
            hintText: hintxt,
            hintStyle: secondaryTextStyle,
            floatingLabelBehavior: FloatingLabelBehavior.always,
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
        ),
      ],
    );
  }
}