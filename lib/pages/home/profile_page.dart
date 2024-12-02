import 'dart:io';
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:potato_apps/configuration/controllers/device_controller.dart';
import 'package:potato_apps/configuration/controllers/person_controller.dart';
import 'package:potato_apps/model/user_model.dart';
import 'package:potato_apps/theme.dart';
import 'package:potato_apps/widget/button_green.dart';
import 'package:potato_apps/widget/button_logout.dart';
import 'package:potato_apps/widget/formfield_profile.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  // userdata
  late UserModel? userdata;

  // image URL
  String imageURL = "";

  // fileImage
  File? _imageFile;

  // loading updateimage
  bool isLoading = false;

  Future<void> _pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);

      if (image == null) return;

      final imageTemporary = File(image.path);
      setState(() {
        _imageFile = imageTemporary;
      });

      updateProfileImage(imageTemporary);
    } on PlatformException catch (e) {
      Fluttertoast.showToast(msg: 'failed pick image $e');
    }
  }

  Future<void> confirmLogout(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure to logout?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // Navigator.of(context).pop();
                PersonController.signOutUser(context);
              },
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  // Fungsi untuk menampilkan dialog loading
  void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(12)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // loading indicator
                const CircularProgressIndicator(),
                // Title of the dialog
                const SizedBox(height: 20,),
                Text(
                  'Please Wait...',
                  style:
                      blackTextStyle.copyWith(fontSize: 12, fontWeight: bold),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Fungsi untuk update profile image
  Future<void> updateProfileImage(File imageFile) async {
    // Tampilkan loading dialog
    showLoadingDialog(context);

    // Proses update foto profil
    var result = await PersonController.updateProfilePhoto(imageFile);

    // Tutup dialog loading
    Navigator.of(context).pop();

    if (result) {
      Fluttertoast.showToast(msg: "Update Profile Photo Success");
    } else {
      Fluttertoast.showToast(msg: "Failed to update profile photo");
    }
  }

  Future<UserModel?> getUserInfo() {
    return PersonController.getUserData();
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
                    child: imageURL == ''
                        ? Image.asset(
                            'assets/icon_profile.png',
                            height: 120,
                            width: 120,
                            fit: BoxFit.cover,
                          )
                        : Image.network(
                            imageURL,
                            height: 120,
                            width: 120,
                            fit: BoxFit.cover,
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
            hintxt: "",
            labelField: "Nama",
          ),
          const SizedBox(
            height: 16,
          ),
          FormFieldProfile(
            controller: _emailController,
            icon: null,
            keyType: TextInputType.emailAddress,
            hintxt: "",
            labelField: "Email",
          ),
          const SizedBox(
            height: 16,
          ),
          FormFieldProfile(
            controller: _cityController,
            icon: null,
            keyType: TextInputType.text,
            hintxt: "(kota asal belum diatur)",
            labelField: "Kota Asal",
          ),
          const SizedBox(
            height: 16,
          ),
          FormFieldProfile(
            controller: _workController,
            icon: null,
            keyType: TextInputType.text,
            hintxt: "(pekerjaan belum diatur)",
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
                      confirmLogout(context);
                    }),
                ButtonGreen(
                    title: 'Save',
                    ontap: () async {
                      String fullName = _nameController.text;
                      String work = _workController.text;
                      String city = _cityController.text;

                      // Prepare updated data
                      Map<String, dynamic> updatedData = {
                        'fullname': fullName, // Get this from your input field
                        'work': work,
                        'city': city,
                      };

                      // Call the update method
                      await PersonController.updateUserData(updatedData);

                      Fluttertoast.showToast(
                          msg: 'User data updated successfully');
                    }),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Colors.white,
          body: Expanded(
            child: FutureBuilder<UserModel?>(
                future: getUserInfo(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else if (snapshot.hasData && snapshot.data != null) {
                    final userData = snapshot.data!;

                    // Populate your controllers or variables here if needed
                    _nameController.text = userData.fullName;
                    _emailController.text = userData.email;
                    _cityController.text = userData.city;
                    _workController.text = userData.work;
                    imageURL = userData.profilePhoto;

                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [content()],
                      ),
                    );
                  } else {
                    return const Center(child: Text("No data available"));
                  }
                }),
          )),
    );
  }
}
