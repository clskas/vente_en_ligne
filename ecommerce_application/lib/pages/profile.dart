import 'dart:io';

import 'package:ecommerce_application/pages/onboarding.dart';
import 'package:ecommerce_application/pages/services/auth.dart';
import 'package:ecommerce_application/pages/services/shared_pref.dart';
import 'package:ecommerce_application/pages/widget/widget_support.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final ImagePicker _picker = ImagePicker();
  File? selectedImage;
  String? name, email, image;

  getthesharedpref() async {
    name = await SharedPreferenceHelper().getUserName();
    email = await SharedPreferenceHelper().getUserEmail();
    image = await SharedPreferenceHelper().getUserImage();
    setState(() {});
  }

  @override
  void initState() {
    getthesharedpref();
    super.initState();
  }

  Future getImage() async {
    var image = await _picker.pickImage(source: ImageSource.gallery);
    selectedImage = File(image!.path);
    uploadItem();
    setState(() {});
  }

  uploadItem() async {
    if (selectedImage != null) {
      String addId = randomAlphaNumeric(10);
      Reference firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child("blogImage")
          .child(addId);
      final UploadTask task = firebaseStorageRef.putFile(selectedImage!);
      var downloadUrl = await (await task).ref.getDownloadURL();
      await SharedPreferenceHelper().saveUserImage(downloadUrl);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff2f2f2),
      appBar: AppBar(
        backgroundColor: Color(0xfff2f2f2),
        title: Text("Profile", style: Appwidget.boldTextFieldStyle()),
        centerTitle: true,
      ),
      body: name == null
          ? Center(child: CircularProgressIndicator())
          : Container(
              child: Column(
                //children: [Image.network(image!, height: 90.0, width: 90.0)],
                children: [
                  selectedImage != null
                      ? Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(60.0),
                            child: Image.file(
                              selectedImage!,
                              height: 90,
                              width: 90,
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      : GestureDetector(
                          onTap: () {
                            getImage();
                          },
                          child: Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(60.0),
                              child: Image.network(
                                image!,
                                height: 90,
                                width: 90,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                  SizedBox(height: 20.0),
                  Container(
                    margin: EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Material(
                      elevation: 3.0,
                      borderRadius: BorderRadius.circular(10.0),
                      child: Container(
                        padding: EdgeInsets.only(left: 10.0, right: 10.0),
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          children: [
                            Icon(Icons.person_outline, size: 35.0),
                            SizedBox(width: 10.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Name",
                                  style: Appwidget.lightTextFieldStyle(),
                                ),
                                Text(
                                  name!,
                                  style: Appwidget.semiboldTextFieldStyle(),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Container(
                    margin: EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Material(
                      elevation: 3.0,
                      borderRadius: BorderRadius.circular(10.0),
                      child: Container(
                        padding: EdgeInsets.only(left: 10.0, right: 10.0),
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          children: [
                            Icon(Icons.mail_outline, size: 35.0),
                            SizedBox(width: 10.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Email",
                                  style: Appwidget.lightTextFieldStyle(),
                                ),
                                Text(
                                  email!,
                                  style: Appwidget.semiboldTextFieldStyle(),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  GestureDetector(
                    onTap: () async {
                      await AuthMethods().signOut().then((value) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => Onboarding()),
                        );
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Material(
                        elevation: 3.0,
                        borderRadius: BorderRadius.circular(10.0),
                        child: Container(
                          padding: EdgeInsets.only(left: 10.0, right: 10.0),
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            children: [
                              Icon(Icons.logout_sharp, size: 35.0),
                              SizedBox(width: 10.0),
                              Text(
                                "LogOut",
                                style: Appwidget.semiboldTextFieldStyle(),
                              ),
                              Spacer(),
                              Icon(Icons.arrow_forward_ios_outlined),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  GestureDetector(
                    onTap: () async {
                      await AuthMethods().deleteUser().then((value) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => Onboarding()),
                        );
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Material(
                        elevation: 3.0,
                        borderRadius: BorderRadius.circular(10.0),
                        child: Container(
                          padding: EdgeInsets.only(left: 10.0, right: 10.0),
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            children: [
                              Icon(Icons.delete, size: 35.0),
                              SizedBox(width: 10.0),
                              Text(
                                "Delete Account",
                                style: Appwidget.semiboldTextFieldStyle(),
                              ),
                              Spacer(),
                              Icon(Icons.arrow_forward_ios_outlined),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
