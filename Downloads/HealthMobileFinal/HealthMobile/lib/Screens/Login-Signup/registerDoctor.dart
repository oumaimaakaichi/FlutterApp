import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healthhub/Screens/Login-Signup/loginDoctor.dart';
import 'package:healthhub/Screens/Login-Signup/provider.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'login.dart';

class registerDoctor extends StatefulWidget {
  const registerDoctor({Key? key}) : super(key: key);

  @override
  State<registerDoctor> createState() => _RegisterState();
}

class _RegisterState extends State<registerDoctor> {
  late String email;
  late String password;
  late String fullname;
  late String specialite;
  late String adress;
  File? selectedImage;
  late String tel;

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

  void registration(String email, String password, String fullname, String specialite , String tel) async {
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

      Reference imageRef = FirebaseStorage.instance.ref().child('Doctor_images').child('${userCredential.user!.uid}.jpg');
      await imageRef.putFile(selectedImage!);
      imageURL = await imageRef.getDownloadURL();

      await FirebaseFirestore.instance.collection('Doctor').doc(userCredential.user!.uid).set({
        'email': email,
        'username': fullname,
        'adress':adress,
        'specialite': specialite,
        'role': 'Docteur',
        'createdAt': createdAt,
        'phone':tel,
        'imageURL': imageURL, // Add the imageURL to the document
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.green,
        content: Text("Registered Successfully", style: TextStyle(fontSize: 16)),
      ));

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => loginDoctor()));
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
                    type: PageTransitionType.leftToRight, child: loginDoctor()));
          },
        ),
        title: Text(
          "${Provider.of<UiProvider>(context).getLocale().keys[Provider.of<UiProvider>(context).language]?["29"] ?? "Create Account"}",
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
                    labelText:"${Provider.of<UiProvider>(context).getLocale().keys[Provider.of<UiProvider>(context).language]?["19"] ?? "Enter your email"}",
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
                    labelText: '${Provider.of<UiProvider>(context).getLocale().keys[Provider.of<UiProvider>(context).language]?["27"] ?? "Enter your Full name"}',
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
                      return 'Please enter your full name';
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
                    labelText: '${Provider.of<UiProvider>(context).getLocale().keys[Provider.of<UiProvider>(context).language]?["25"] ?? "Enter your address"}',
                    focusColor: Colors.black26,
                    fillColor: Color.fromARGB(255, 247, 247, 247),
                    filled: true,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    prefixIcon: Icon(LineAwesomeIcons.home), // cette icone va etre à gauche de textfield

                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your adress';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      adress = value;
                    });
                  },
                ),

                SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: '${Provider.of<UiProvider>(context).getLocale().keys[Provider.of<UiProvider>(context).language]?["24"] ?? "Enter your phone"}',
                    focusColor: Colors.black26,
                    fillColor: Color.fromARGB(255, 247, 247, 247),
                    filled: true,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    prefixIcon: Icon(LineAwesomeIcons.phone), // cette icone va etre à gauche de textfield

                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your Phone';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      tel = value;
                    });
                  },
                ),

                SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: '${Provider.of<UiProvider>(context).getLocale().keys[Provider.of<UiProvider>(context).language]?["26"] ?? "Enter your speciality"}',
                    focusColor: Colors.black26,
                    fillColor: Color.fromARGB(255, 247, 247, 247),
                    filled: true,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    prefixIcon: Icon(LineAwesomeIcons.phone),
                  ),
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your speciality ';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      specialite = value;
                    });
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: '${Provider.of<UiProvider>(context).getLocale().keys[Provider.of<UiProvider>(context).language]?["20"] ?? "Enter your password"}',
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
                        registration(email, password, fullname, specialite , tel);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 116, 180, 234),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      "${Provider.of<UiProvider>(context).getLocale().keys[Provider.of<UiProvider>(context).language]?["29"] ?? "Create Account"}",
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
                      "${Provider.of<UiProvider>(context).getLocale().keys[Provider.of<UiProvider>(context).language]?["28"] ?? "Already have an account?"} ",
                      style:
                      GoogleFonts.poppins(fontSize: 14.sp, color: Colors.black87),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.bottomToTop,
                                child: loginDoctor()));
                      },
                      child: Text(
                        "${Provider.of<UiProvider>(context).getLocale().keys[Provider.of<UiProvider>(context).language]?["18"] ?? "Login"}",
                        style: GoogleFonts.poppins(
                          fontSize: 15.sp,
                          color: const Color.fromARGB(255, 116, 180, 234),
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
