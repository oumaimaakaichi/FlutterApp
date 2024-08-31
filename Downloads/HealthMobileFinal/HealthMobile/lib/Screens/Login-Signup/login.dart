import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthhub/Screens/Login-Signup/forgot_pass.dart';
import 'package:healthhub/Screens/Login-Signup/login_signupClient.dart';
import 'package:healthhub/Screens/Login-Signup/login_signupD.dart';
import 'package:healthhub/Screens/Login-Signup/provider.dart';
import 'package:healthhub/Screens/Login-Signup/register.dart';
import 'package:healthhub/Screens/Views/Homepage.dart';
import 'package:healthhub/Screens/Widgets/Auth_text_field.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../Views/Dashboard_screen.dart';

class login extends StatefulWidget {
  const login({Key? key}) : super(key: key);

  @override
  State<login> createState() => _LoginState();
}

class _LoginState extends State<login> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController useremailcontroller = TextEditingController();
  TextEditingController userpasswordcontroller = TextEditingController();

  // Validateur pour l'email
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    // Vérifie si l'email a un format valide
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  // Validateur pour le mot de passe
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    // Vérifie si le mot de passe a une longueur minimale
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  userLogin(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      // Vérifier le rôle de l'utilisateur dans Firestore
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('patient')
          .doc(userCredential.user!.uid)
          .get();
      if (userSnapshot.exists &&
          (userSnapshot.data() as Map<String, dynamic>)['role'] == 'Patient') {

        // Rediriger vers la page d'accueil ou une autre page appropriée
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Homepage()));
      }} catch (e) {
      String errorMessage = 'Login failed';
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
        leading: IconButton(
          icon: Container(
              height: MediaQuery.of(context).size.height * 0.06,
              width: MediaQuery.of(context).size.width * 0.06,
              child: Image.asset("lib/icons/back2.png")),
          onPressed: () {
            Navigator.push(
                context,
                PageTransition(
                    type: PageTransitionType.leftToRight,
                    child: login_signupC()));
          },
        ),
        centerTitle: true,
        title: Text(
          "${Provider.of<UiProvider>(context).getLocale().keys[Provider.of<UiProvider>(context).language]?["18"] ?? "Login"}",
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center, // Align children in the center
              children: [
                SizedBox(height: 20),
                // Image
                Image.asset(
                  'images/doctorr.png',
                  height: 250,
                  width: 250,
                ),
                SizedBox(height: 20),
                // Champ de texte pour l'email avec le validateur
                Auth_text_field(
                  text: "${Provider.of<UiProvider>(context).getLocale().keys[Provider.of<UiProvider>(context).language]?["19"] ?? "Enter your email"}",
                  icon: "lib/icons/email.png",
                  controller: useremailcontroller,
                  validator: validateEmail,
                ),
                SizedBox(height: 20), // Increase spacing for better readability
                // Champ de texte pour le mot de passe avec le validateur
                Auth_text_field(
                  obscureText: true,
                  text: "${Provider.of<UiProvider>(context).getLocale().keys[Provider.of<UiProvider>(context).language]?["20"] ?? "Enter your password"}",
                  icon: "lib/icons/lock.png",
                  controller: userpasswordcontroller,
                  validator: validatePassword,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.bottomToTop,
                            child: forgot_pass(),
                          ),
                        );
                      },
                      child: Text(
                        "${Provider.of<UiProvider>(context).getLocale().keys[Provider.of<UiProvider>(context).language]?["21"] ?? "Forgot your password?"}",
                        style: GoogleFonts.poppins(
                          fontSize: 15.sp,
                          color: const Color.fromARGB(255, 116, 180, 234),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20), // Increase spacing for better readability
                Container(
                  height: 50, // Fix height of the button
                  width: double.infinity, // Make button full width
                  child: ElevatedButton(
                      onPressed: () async {
                        // Valider le formulaire avant de procéder
                        if (_formKey.currentState!.validate()) {
                          try {
                            // Effectuer la connexion
                            await userLogin(
                              useremailcontroller.text,
                              userpasswordcontroller.text,
                            );
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
                      },

                      style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 116, 180, 234),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      "${Provider.of<UiProvider>(context).getLocale().keys[Provider.of<UiProvider>(context).language]?["18"] ?? "Login"}",
                      style: GoogleFonts.poppins(
                        fontSize: 18.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${Provider.of<UiProvider>(context).getLocale().keys[Provider.of<UiProvider>(context).language]?["22"] ?? "Don't have an account? "}",
                      style: GoogleFonts.poppins(
                        fontSize: 15.sp,
                        color: Colors.black87,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.rightToLeft,
                            child: register(),
                          ),
                        );
                      },
                      child: Text(
                        "${Provider.of<UiProvider>(context).getLocale().keys[Provider.of<UiProvider>(context).language]?["23"] ?? "Sign up "}",
                        style: GoogleFonts.poppins(
                          fontSize: 15.sp,
                          color: const Color.fromARGB(255, 116, 180, 234),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
