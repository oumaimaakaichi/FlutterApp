import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthhub/Screens/Login-Signup/proff.dart';
import 'package:healthhub/Screens/Login-Signup/provider.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  TextEditingController _aboutController = TextEditingController();
  String? _defaultAbout;

  @override
  void initState() {
    super.initState();
    _fetchPatientInfo();
  }

  void _fetchPatientInfo() async {
    // Retrieve the ID of the logged-in user
    String userId = FirebaseAuth.instance.currentUser!.uid;

    // Retrieve the user information from Firestore
    DocumentSnapshot userSnapshot =
    await FirebaseFirestore.instance.collection('Doctor').doc(userId).get();

    // Extract the user information
    Map<String, dynamic> userData =
        userSnapshot.data() as Map<String, dynamic>? ?? {};
    String? about = userData['about'] as String?;

    // Update the controller with the retrieved value
    setState(() {
      _aboutController.text = about ?? ''; // Use '' as default value if about is null
    });
  }

  void _saveAboutInformation() async {
    // Retrieve the ID of the logged-in user
    String userId = FirebaseAuth.instance.currentUser!.uid;

    // Reference to the doctor's document in Firestore
    DocumentReference userRef =
    FirebaseFirestore.instance.collection('Doctor').doc(userId);

    // Update the doctor's data in Firestore with the "about" information
    await userRef.update({
      'about': _aboutController.text,
    });

    // Show a success message
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.green,
      content: Text("About information updated successfully"),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    child: Profile_screen()));
          },
        ),
        centerTitle: true,
        title: Text(
          "${Provider.of<UiProvider>(context).getLocale().keys[Provider.of<UiProvider>(context).language]?["2"] ?? "About"}",
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
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset(
                'images/dactour.png',
                height: 200,
                width: 300,
                fit: BoxFit.contain,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _aboutController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: '${Provider.of<UiProvider>(context).getLocale().keys[Provider.of<UiProvider>(context).language]?["65"] }',
                ),
              ),
              SizedBox(height: 20),
              Container(
                height: MediaQuery.of(context).size.height * 0.06,
                width: MediaQuery.of(context).size.width * 0.9,
                child: ElevatedButton(
                  onPressed: () {
                    _saveAboutInformation();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 195, 220, 243),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    "${Provider.of<UiProvider>(context).getLocale().keys[Provider.of<UiProvider>(context).language]?["10"] ?? "Update"}",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
