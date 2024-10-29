import 'dart:io';
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:potato_apps/configuration/controller.dart';
import 'package:potato_apps/widget/button_green.dart';
import 'package:potato_apps/widget/button_logout.dart';
import 'package:potato_apps/widget/formfield_profile.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // controller nama
  TextEditingController _nameController = TextEditingController();

  // email controller
  TextEditingController _emailController = TextEditingController();

  // city controller
  TextEditingController _cityController = TextEditingController();

  // work controller
  TextEditingController _workController = TextEditingController();

  // fileImage
  File? _imageFile;

  Future<void> _pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);

      if (image == null) return;

      final imageTemporary = File(image.path);
      setState(() {
        _imageFile = imageTemporary;
      });
    } on PlatformException catch (e) {
      Fluttertoast.showToast(msg: 'failed pick image $e');
    }
  }

  Widget profileImage() {
    return Container(
      margin: EdgeInsets.only(top: 30, bottom: 24),
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(children: [
            _imageFile != null
                ? ClipOval(
                    child: Image.file(
                      _imageFile!,
                      height: 120,
                      width: 120,
                      fit: BoxFit.cover,
                    ),
                  )
                : ClipOval(
                    child: Image.asset(
                    'assets/icon_profile.png',
                    height: 120,
                    width: 120,
                  )),
            Positioned(
              right: -2,
              bottom: -2,
              child: IconButton(
                  iconSize: 30,
                  padding: EdgeInsets.all(0),
                  splashRadius: 15,
                  onPressed: _pickImage,
                  icon: Container(
                      padding: EdgeInsets.all(4),
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(179, 186, 186, 186),
                          shape: BoxShape.circle),
                      child: Icon(
                        Icons.edit,
                      ))),
            )
          ]),
        ],
      ),
    );
  }

  Widget content() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          profileImage(),
          FormFieldProfile(
            controller: _nameController,
            icon: null,
            keyType: TextInputType.name,
            hintxt: "John Doe",
            labelField: "Nama",
          ),
          const SizedBox(
            height: 16,
          ),
          FormFieldProfile(
            controller: _emailController,
            icon: null,
            keyType: TextInputType.emailAddress,
            hintxt: "john.doe97@gmail.com",
            labelField: "Email",
          ),
          const SizedBox(
            height: 16,
          ),
          FormFieldProfile(
            controller: _cityController,
            icon: null,
            keyType: TextInputType.text,
            hintxt: "Surabaya",
            labelField: "Kota Asal",
          ),
          const SizedBox(
            height: 16,
          ),
          FormFieldProfile(
            controller: _workController,
            icon: null,
            keyType: TextInputType.text,
            hintxt: "Petani Kentang",
            labelField: "Pekerjaan",
          ),
          const SizedBox(
            height: 16,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ButtonLogout(
                    title: 'Logout',
                    ontap: () {
                      PersonController.signOutUser(context);
                    }),
                ButtonGreen(
                    title: 'Save',
                    ontap: () {
                      Fluttertoast.showToast(msg: 'Profile Saved!');
                    }),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget signOutButton() {
    return TextButton(
        onPressed: () {
          PersonController.signOutUser(context);
        },
        child: Text('Logout Cuy'));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Colors.white,
          body: Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [content()],
              ),
            ),
          )),
    );
  }
}
