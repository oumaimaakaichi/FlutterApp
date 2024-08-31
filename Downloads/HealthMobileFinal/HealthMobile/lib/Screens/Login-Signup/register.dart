import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healthhub/Screens/Login-Signup/provider.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'login.dart';

class register extends StatefulWidget {
  const register({Key? key}) : super(key: key);

  @override
  State<register> createState() => _RegisterState();
}

class _RegisterState extends State<register> {
  late String email;
  late String password;
  late String fullname;
  late int phone;
  File? selectedImage;

  final _formKey = GlobalKey<FormState>();

  void pickImage() async {
    FilePickerResult? result =
    await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null) {
      File file = File(result.files.single.path!);
      Reference imageRef = FirebaseStorage.instance.ref().child('images').child('${DateTime.now().millisecondsSinceEpoch}.jpg');
      await imageRef.putFile(file);
      String imageURL = await imageRef.getDownloadURL();

      setState(() {
        selectedImage = file;
      });
    }
  }

  void registration(String email, String password, String fullname, int phone) async {
    try {
      if (selectedImage == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text("Please select an image", style: TextStyle(fontSize: 16)),
        ));
        return; // Exit registration if no image is selected
      }

      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      DateTime createdAt = DateTime.now();
      String imageURL;

      Reference imageRef = FirebaseStorage.instance.ref().child('user_images').child('${userCredential.user!.uid}.jpg');
      await imageRef.putFile(selectedImage!);
      imageURL = await imageRef.getDownloadURL();

      await FirebaseFirestore.instance.collection('patient').doc(userCredential.user!.uid).set({
        'email': email,
        'fullname': fullname,
        'phone': phone,
        'role': 'Patient',
        'createdAt': createdAt,
        'imageURL': imageURL, // Add the imageURL to the document
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.green,
        content: Text("Registered Successfully", style: TextStyle(fontSize: 16)),
      ));

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => login()));
    } catch (e) {
      String errorMessage = 'Registration failed';
      if (e is FirebaseAuthException) {
        errorMessage = e.message!;
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text(errorMessage, style: TextStyle(fontSize: 16)),
      ));
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: Container(
              height: MediaQuery.of(context).size.height * 0.06,
              width: MediaQuery.of(context).size.width * 0.06,
              child: Image.asset("lib/icons/back2.png")),
          onPressed: () {
            Navigator.push(
                context,
                PageTransition(
                    type: PageTransitionType.leftToRight, child: login()));
          },
        ),
        title: Text(
          Provider.of<UiProvider>(context)
              .getLocale()
              .keys[Provider.of<UiProvider>(context).language]?["23"] ??"Sign up",
          style: GoogleFonts.inter(
              color: Colors.black87,
              fontSize: 22.sp,
              fontWeight: FontWeight.w700,
              letterSpacing: 0),
        ),
        toolbarHeight: 110,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: GestureDetector(
                    onTap: pickImage,
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.grey[200],
                      backgroundImage: selectedImage != null ? FileImage(selectedImage!) : Image.asset('images/user.png').image,
                      child: selectedImage == null ? Icon(LineAwesomeIcons.photo_video, size: 40, color: Colors.grey[400]) : null,
                    ),
                  ),
                ),


                SizedBox(height: 60),
                TextFormField(
                  decoration: InputDecoration(
                    labelText:  Provider.of<UiProvider>(context)
                        .getLocale()
                        .keys[Provider.of<UiProvider>(context).language]?["62"] ??'Email',
                    focusColor: Colors.black26,
                    fillColor: Color.fromARGB(255, 247, 247, 247),
                    filled: true,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    prefixIcon: Icon(LineAwesomeIcons.envelope), // cette icone va etre à gauche de textfield

                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      email = value;
                    });
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(
                    labelText:  Provider.of<UiProvider>(context)
                        .getLocale()
                        .keys[Provider.of<UiProvider>(context).language]?["13"] ??'Full Name',
                    focusColor: Colors.black26,
                    fillColor: Color.fromARGB(255, 247, 247, 247),
                    filled: true,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    prefixIcon: Icon(LineAwesomeIcons.user), // cette icone va etre à gauche de textfield

                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return  Provider.of<UiProvider>(context)
                          .getLocale()
                          .keys[Provider.of<UiProvider>(context).language]?["27"] ??'Please enter your full name';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      fullname = value;
                    });
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(
                    labelText:  Provider.of<UiProvider>(context)
                        .getLocale()
                        .keys[Provider.of<UiProvider>(context).language]?["12"] ??'Phone Number',
                    focusColor: Colors.black26,
                    fillColor: Color.fromARGB(255, 247, 247, 247),
                    filled: true,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    prefixIcon: Icon(LineAwesomeIcons.phone),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return   Provider.of<UiProvider>(context)
                          .getLocale()
                          .keys[Provider.of<UiProvider>(context).language]?["24"] ?? 'Enter your Phone';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      phone = int.tryParse(value) ?? 0;
                    });
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Password',
                    focusColor: Colors.black26,
                    fillColor: Color.fromARGB(255, 247, 247, 247),
                    filled: true,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    prefixIcon: Icon(LineAwesomeIcons.lock),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      password = value;
                    });
                  },
                ),
                SizedBox(height: 20),
                Container(
                  height: MediaQuery.of(context).size.height * 0.05,
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        registration(email, password, fullname, phone);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 116, 180, 234),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      "Create Account",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 18.sp,
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account? ",
                      style:
                      GoogleFonts.poppins(fontSize: 14.sp, color: Colors.black87),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.bottomToTop,
                                child: login()));
                      },
                      child: Text(
                        "Sign in",
                        style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          color:const Color.fromARGB(255, 116, 180, 234),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
