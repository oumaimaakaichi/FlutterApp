import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthhub/Screens/Login-Signup/provider.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'login.dart';

class forgot_pass extends StatefulWidget {
  const forgot_pass({Key? key}) : super(key: key);

  @override
  _ForgotPassState createState() => _ForgotPassState();
}

class _ForgotPassState extends State<forgot_pass> with SingleTickerProviderStateMixin {
  late TabController tabController;
  TextEditingController _emailController = new TextEditingController();
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 1, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    _emailController.dispose();
    super.dispose();
  }
  Future resetPassword() async {
    String email = _emailController.text.trim();

    if (email.isEmpty) {
      // Show error dialog if email is empty
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text(Provider.of<UiProvider>(context)
                .getLocale()
                .keys[Provider.of<UiProvider>(context).language]?["19"] ??"Please enter your email."),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
      return; // Exit function if email is empty
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      // Show success dialog if email is sent successfully
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Success"),
            content: Text("Password reset link sent! Check your email."),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  // Reset email field after success dialog is dismissed
                  _emailController.clear();
                  Navigator.of(context).pop();
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        // Show error dialog if user is not found
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Error"),
              content: Text("No user found with this email."),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("OK"),
                ),
              ],
            );
          },
        );
      } else {
        // Show error dialog for other Firebase Auth exceptions
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Error"),
              content: Text(e.message.toString()),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("OK"),
                ),
              ],
            );
          },
        );
      }
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
                    type: PageTransitionType.topToBottom, child: login()));
          },
        ),
        backgroundColor: Colors.white,
        toolbarHeight: 80,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    Provider.of<UiProvider>(context)
                        .getLocale()
                        .keys[Provider.of<UiProvider>(context).language]?["21"] ?? "Forgot your password?",
                    style: GoogleFonts.poppins(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    Provider.of<UiProvider>(context)
                        .getLocale()
                        .keys[Provider.of<UiProvider>(context).language]?["63"] ?? "Enter your email, we will send you a confirmation link",
                    style: GoogleFonts.poppins(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.black54),
                  )
                ],
              ),
              Container(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        // height: 50,
                        width: MediaQuery.of(context).size.height,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Color.fromARGB(255, 235, 235, 235)),
                          color: Color.fromARGB(255, 241, 241, 241),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(5),
                              child: TabBar(
                                indicator: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                indicatorColor:
                                const Color.fromARGB(255, 241, 241, 241),
                                unselectedLabelColor: Colors.grey,
                                labelColor:
                                const   Color.fromARGB(255, 116, 180, 234),
                                controller: tabController,
                                tabs: [
                                  Tab(
                                    text: Provider.of<UiProvider>(context)
                                        .getLocale()
                                        .keys[Provider.of<UiProvider>(context).language]?["62"] ??"Email",
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: tabController,
                        children: [
                          Column(children: [
                            SizedBox(
                              height: 40,
                            ),
                            Center(
                              child: Container(
                                height:
                                MediaQuery.of(context).size.height * 0.1,
                                width:
                                MediaQuery.of(context).size.width * 0.9,
                                child: TextField(
                                  controller: _emailController,
                                  textAlign: TextAlign.start,
                                  textInputAction: TextInputAction.none,
                                  obscureText: false,
                                  keyboardType: TextInputType.emailAddress,
                                  textAlignVertical: TextAlignVertical.center,
                                  decoration: InputDecoration(
                                      focusColor: Colors.black26,
                                      fillColor: Color.fromARGB(
                                          255, 247, 247, 247),
                                      filled: true,
                                      prefixIcon: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                        ),
                                        child: Container(
                                          child: Image.asset(
                                              "lib/icons/email.png"),
                                        ),
                                      ),
                                      prefixIconColor:
                                      const Color.fromARGB(
                                          255, 3, 190, 150),
                                      label: Text(Provider.of<UiProvider>(context)
                                          .getLocale()
                                          .keys[Provider.of<UiProvider>(context).language]?["19"] ??"Enter your email"),
                                      floatingLabelBehavior:
                                      FloatingLabelBehavior.never,
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.circular(30),
                                      )),
                                ),
                              ),
                            ),
                            Container(
                              height:
                              MediaQuery.of(context).size.height * 0.05,
                              width: MediaQuery.of(context).size.width * 01,
                              child: ElevatedButton(
                                onPressed: resetPassword,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color.fromARGB(255, 116, 180, 234),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                child: Text(
                                  Provider.of<UiProvider>(context)
                                      .getLocale()
                                      .keys[Provider.of<UiProvider>(context).language]?["30"] ?? "Reset Password",
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
                          ]),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
