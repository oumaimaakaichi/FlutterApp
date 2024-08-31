import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthhub/Screens/Login-Signup/provider.dart';
import 'package:healthhub/Screens/Login-Signup/updateProfileScreen.dart';
import 'package:healthhub/Screens/Widgets/profile_list.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import 'SettingPatient.dart';
import 'login.dart';

class Profile_screen extends StatefulWidget {
  const Profile_screen({Key? key}) : super(key: key);

  @override
  _Profile_screenState createState() => _Profile_screenState();
}

class _Profile_screenState extends State<Profile_screen> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  String? _imageURL;

  @override
  void initState() {
    super.initState();
    // Retrieve the information of the logged-in user from Firestore
    _fetchPatientInfo();
  }

  void _fetchPatientInfo() async {
    // Retrieve the ID of the logged-in user
    String userId = FirebaseAuth.instance.currentUser!.uid;

    // Retrieve the user information from Firestore
    DocumentSnapshot userSnapshot =
    await FirebaseFirestore.instance.collection('patient').doc(userId).get();
    print(userSnapshot);
    // Extract the user information
    String name = userSnapshot['fullname'];
    String email = userSnapshot['email'];
    int phone = userSnapshot['phone'];
    String imageURL = userSnapshot['imageURL']; // Add this line to retrieve the image URL

    // Update the controllers with the retrieved values
    setState(() {
      _nameController.text = name;
      _emailController.text = email;
      _phoneController.text = phone.toString();
      _imageURL = imageURL; // Store the image URL in a variable
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 116, 180, 234),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            Center(
              child: Stack(
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      border: Border.all(width: 4, color: Colors.white),
                      boxShadow: [
                        BoxShadow(
                          spreadRadius: 2,
                          blurRadius: 10,
                          color: Colors.black.withOpacity(0.1),
                        ),
                      ],
                      shape: BoxShape.circle,
                      image: _imageURL != null
                          ? DecorationImage(
                        image: NetworkImage(_imageURL!), // Use NetworkImage to load image from URL
                        fit: BoxFit.cover,
                      )
                          : null,
                    ),
                    child: _imageURL == null
                        ? Icon(
                      Icons.account_circle,
                      size: 50,
                      color: Colors.grey[400],
                    )
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(width: 1, color: Colors.white),
                        color: Colors.white,
                        image: DecorationImage(
                          image: AssetImage("lib/icons/camra.png"),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _nameController.text,
                  style: GoogleFonts.poppins(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start, // Align children at the start vertically
              children: [
                Expanded(
                  flex: 2, // Adjust the flex value to change width proportion
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          LineAwesomeIcons.mail_bulk,
                          color: Colors.white,
                          size: 18,
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _emailController.text,
                            style: GoogleFonts.poppins(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  flex: 1, // Adjust the flex value to change width proportion
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          LineAwesomeIcons.phone,
                          color: Colors.white,
                          size: 18,
                        ),
                        SizedBox(width: 8),
                        Text(
                          _phoneController.text,
                          style: GoogleFonts.poppins(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),



            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Container(
              height: 550,
              width: double.infinity,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30))),
              child: Column(children: [
                SizedBox(
                  height: 50,
                ),
                profile_list(
                  icon: LineAwesomeIcons.cog,

                  title: Provider.of<UiProvider>(context)
                      .getLocale()
                      .keys[Provider.of<UiProvider>(context).language]?["3"] ?? "Settings",
                  textColor: Colors.black87,
                  onPress: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SettingPatient()),
                    );
                  },
                ),


                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                  child: Divider(),
                ),
                profile_list(
                  icon: LineAwesomeIcons.user,
                  title: Provider.of<UiProvider>(context)
                      .getLocale()
                      .keys[Provider.of<UiProvider>(context).language]?["39"] ?? "Update profile",
                  textColor: Colors.black87,
                  onPress: () {
                    // Navigate to the other page here
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UpdateProfileScreen()),
                    );
                  },
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                  child: Divider(),
                ),
                profile_list(
                  icon: LineAwesomeIcons.alternate_sign_out,
                  title: Provider.of<UiProvider>(context)
                      .getLocale()
                      .keys[Provider.of<UiProvider>(context).language]?["9"] ??"Log out",
                  onPress: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title:  Text(Provider.of<UiProvider>(context)
                            .getLocale()
                            .keys[Provider.of<UiProvider>(context).language]?["9"] ?? 'LOGOUT'),
                        content:  Text(Provider.of<UiProvider>(context)
                            .getLocale()
                            .keys[Provider.of<UiProvider>(context).language]?["40"] ?? 'Are you sure you want to logout?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child:  Text(Provider.of<UiProvider>(context)
                                .getLocale()
                                .keys[Provider.of<UiProvider>(context).language]?["42"] ??'No'),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              try {
                                await FirebaseAuth.instance.signOut();
                                // Navigate to the login screen or any other screen after logout
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => login()), // Replace LoginScreen with your login screen widget
                                );
                              } catch (e) {
                                print("Error signing out: $e");
                                // Handle sign-out error
                              }
                            },
                            child:  Text(Provider.of<UiProvider>(context)
                                .getLocale()
                                .keys[Provider.of<UiProvider>(context).language]?["41"] ??'Yes'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
