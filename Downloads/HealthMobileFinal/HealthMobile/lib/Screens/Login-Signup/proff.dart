import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthhub/Screens/Login-Signup/CustomDrawer.dart';
import 'package:healthhub/Screens/Login-Signup/loginDoctor.dart';
import 'package:healthhub/Screens/Login-Signup/provider.dart';
import 'package:healthhub/Screens/Widgets/profilList.dart';


import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';


import 'AboutDooctor.dart';
import 'login.dart';



class Profile_screen extends StatefulWidget {
  const Profile_screen({Key? key}) : super(key: key);

  @override
  _Profile_screenState createState() => _Profile_screenState();
}

class _Profile_screenState extends State<Profile_screen> {
  TextEditingController _nameController = TextEditingController();
  String? _imageURL;
  TextEditingController _adresseController= TextEditingController();
  TextEditingController _phoneController= TextEditingController();

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
    await FirebaseFirestore.instance.collection('Doctor').doc(userId).get();

    // Extract the user information
    String name = userSnapshot['username'];
    String adress =userSnapshot['adress'];
    String phone =userSnapshot['phone'];
    String imageURL = userSnapshot['imageURL']; // Add this line to retrieve the image URL

    // Update the controller with the retrieved value
    setState(() {
      _nameController.text = name;
      _phoneController.text=phone;
      _adresseController.text=adress;
      _imageURL = imageURL; // Store the image URL in a variable
    });
  }
  void updateDoctorInfo() async {
    // Récupérer l'ID de l'utilisateur connecté
    String userId = FirebaseAuth.instance.currentUser!.uid;

    // Référence au document du médecin dans Firestore
    DocumentReference userRef = FirebaseFirestore.instance.collection('Doctor').doc(userId);

    // Mettre à jour les données du médecin dans Firestore
    await userRef.update({
      'username': _nameController.text,
      'adress':_adresseController.text,
      'phone': _phoneController.text,
    });

    // Afficher un message de succès
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.green,
      content: Text("Profile Updated Successfully"),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Color.fromARGB(255, 195, 220, 243),
      appBar: AppBar(
        title: Text("${Provider.of<UiProvider>(context).getLocale().keys[Provider.of<UiProvider>(context).language]?["6"] ?? "Profil"}" , style: TextStyle(
          color: Colors.white, // Couleur du texte en blanc
        ),),
        leading: Builder(
          builder: (BuildContext context) {
            return GestureDetector(
              onTap: () {
                Scaffold.of(context).openDrawer();
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                    'lib/icons/men.png', // Remplacez par le chemin de votre image
                    color: Colors.white
                ),
              ),
            );
          },
        ),
        backgroundColor:  Color.fromARGB(255, 195, 220, 243),
      ),

      drawer: CustomDrawer(),
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
                    width: 150,
                    height: 150,
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
            SizedBox(
              height: 30,
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


                Container(
                  padding: EdgeInsets.only(left: 20.0, right:20.0), // Ajoutez le padding ici
                  child: TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText:  "${Provider.of<UiProvider>(context).getLocale().keys[Provider.of<UiProvider>(context).language]?["13"] ?? "Full Name"}",
                    ),
                  ),
                ),

                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.only(left: 20.0 , right:20.0),
                  child: TextFormField(
                    controller: _adresseController,
                    decoration: InputDecoration(
                      labelText:  "${Provider.of<UiProvider>(context).getLocale().keys[Provider.of<UiProvider>(context).language]?["11"] ?? "Address"}",
                    ),
                  ),
                ),
                SizedBox(height: 20),
                // Champs d'entrée pour la spécialité
                Container(
                  padding: EdgeInsets.only(left: 20.0 , right:20.0),
                  child:TextFormField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                      labelText:  "${Provider.of<UiProvider>(context).getLocale().keys[Provider.of<UiProvider>(context).language]?["12"] ?? "Phone"}",
                    ),


                  ),),
                SizedBox(height: 40),
                // Bouton de mise à jour
                Container(
                  height: MediaQuery.of(context).size.height * 0.06,
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: ElevatedButton(
                    onPressed: () {
                      updateDoctorInfo();
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
                SizedBox(
                  height: 20,
                ),
                profilelist(
                  icon: LineAwesomeIcons.alternate_sign_out,
                  title: ("${Provider.of<UiProvider>(context).getLocale().keys[Provider.of<UiProvider>(context).language]?["9"] ?? "Logout"}"),
                  onPress: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('LOGOUT'),
                        content: const Text('Are you sure you want to logout?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('No'),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              try {
                                await FirebaseAuth.instance.signOut();
                                // Navigate to the login screen or any other screen after logout
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => loginDoctor()), // Replace LoginScreen with your login screen widget
                                );
                              } catch (e) {
                                print("Error signing out: $e");
                                // Handle sign-out error
                              }
                            },
                            child: const Text('Yes'),
                          ),
                        ],
                      ),
                    );
                  },
                ),

                profilelist(
                  icon: LineAwesomeIcons.alternate_sign_out,
                  title: ("${Provider.of<UiProvider>(context).getLocale().keys[Provider.of<UiProvider>(context).language]?["2"] ?? "About"}"),
                  onPress: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AboutPage()),
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