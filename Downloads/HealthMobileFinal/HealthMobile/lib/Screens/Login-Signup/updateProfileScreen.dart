import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:healthhub/Screens/Login-Signup/provider.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import  'package:intl/intl.dart' ;
import 'package:provider/provider.dart';

import 'login.dart';
class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({Key? key}) : super(key: key);

  @override
  _UpdateProfileScreenState createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {

  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _createdController = TextEditingController();
  String? _profileImageUrl; // Variable pour stocker l'URL de l'image de profil

  @override
  void initState() {
    super.initState();
    // Retrieve the information of the logged-in user from Firestore
    _fetchPatientInfo();
  }


  void _fetchPatientInfo() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('patient').doc(userId).get();
    String name = userSnapshot['fullname'];
    String phone = userSnapshot['phone'].toString();
    String email = userSnapshot['email'];
    _profileImageUrl = userSnapshot['imageURL']; // Mettre à jour l'URL de l'image de profil
    Timestamp createdAtTimestamp = userSnapshot['createdAt'];
    DateTime createdAtDate = createdAtTimestamp.toDate();
    String created = DateFormat.yMMMMd().format(createdAtDate);
    setState(() {
      _nameController.text = name;
      _emailController.text = email;
      _phoneController.text = phone;
      _createdController.text = created;
    });
  }

  void updatePatientInfo() async {

    // Check if any of the fields are empty
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _phoneController.text.isEmpty ) {
      // Show an error message indicating that all fields are required
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text("All fields are required"),
      ));
      return; // Exit the method early
    }
    // Retrieve the ID of the logged-in user
    String userId = FirebaseAuth.instance.currentUser!.uid;

    // Check if the email is valid
    if (!EmailValidator.validate(_emailController.text)) {
      // Show an error message indicating that the email is invalid
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text("Invalid email format"),
      ));
      return; // Exit the method early
    }

    // Retrieve the current email of the user
    String currentEmail = FirebaseAuth.instance.currentUser!.email!;

    // Check if the email has been changed
    if (_emailController.text != currentEmail) {
      // Check if the new email already exists in the database
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('patient')
          .where('email', isEqualTo: _emailController.text)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // If the email already exists, show an error message
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text("This email is already in use. Please choose a different email."),
        ));
        return; // Exit the method without updating the profile
      }
    }

    // Reference to the user document in Firestore
    DocumentReference userRef = FirebaseFirestore.instance.collection('patient').doc(userId);

    // Update the user's information in Firestore
    await userRef.update({
      'email': _emailController.text,
      'fullname': _nameController.text,
      'phone': _phoneController.text,
      'imageURL': _profileImageUrl,
    });

    // Show a success message
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.green,
      content: Text("Profile Updated Successfully"),
    ));
  }

  void deleteAccount() async {
    // Show a confirmation dialog to confirm deletion
    bool confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Account'),
        content: Text('Are you sure you want to delete your account? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false), // Return false if canceled
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true), // Return true if confirmed
            child: Text('Delete'),
          ),
        ],
      ),
    );

    // Check if the user confirmed the deletion
    if (confirm != null && confirm) {
      try {
        // Delete the user document from the Firestore collection
        String userId = FirebaseAuth.instance.currentUser!.uid;
        await FirebaseFirestore.instance.collection('patient').doc(userId).delete();
        // Delete the user account
        await FirebaseAuth.instance.currentUser!.delete();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.green,
          content: Text("Your account is succesfully deleted"),
        ));

        // Navigate to the login screen or any other screen after successful deletion
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => login()),
        );
      } catch (error) {
        // Show an error message if deletion fails
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text("Failed to delete account: $error"),
        ));
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(LineAwesomeIcons.angle_left),
        ),
        title: Text(Provider.of<UiProvider>(context)
            .getLocale()
            .keys[Provider.of<UiProvider>(context).language]?["43"] ??'Edit Profile', style: Theme.of(context).textTheme.headline4),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                SizedBox(
                  width: 120,
                  height: 120,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: _profileImageUrl != null
                        ? Image.network(_profileImageUrl!) // Utiliser l'URL de l'image de profil s'il est disponible
                        : Image.asset('assets/profile_image.png'), // Utiliser l'image par défaut si l'URL de l'image de profil n'est pas disponible
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () {
                      // Logique pour changer l'image de profil
                      // Appeler la fonction pour mettre à jour la photo de profil
                    },
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Color.fromARGB(255, 116, 180, 234), // Ajuster la couleur si nécessaire
                      ),
                      child: const Icon(LineAwesomeIcons.camera, color: Colors.black, size: 20),
                    ),
                  ),
                ),
              ],
            ),


            const SizedBox(height: 50),

            // -- Form Fields
            Form(
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration:  InputDecoration(
                      labelText: Provider.of<UiProvider>(context)
                          .getLocale()
                          .keys[Provider.of<UiProvider>(context).language]?["13"] ??'Full Name',
                      prefixIcon: Icon(LineAwesomeIcons.user),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _emailController,
                    decoration:  InputDecoration(
                      labelText: Provider.of<UiProvider>(context)
                          .getLocale()
                          .keys[Provider.of<UiProvider>(context).language]?["19"] ??'Email',
                      prefixIcon: Icon(LineAwesomeIcons.envelope_1),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _phoneController,
                    decoration:  InputDecoration(
                      labelText: Provider.of<UiProvider>(context)
                          .getLocale()
                          .keys[Provider.of<UiProvider>(context).language]?["24"] ??'Phone Number',
                      prefixIcon: Icon(LineAwesomeIcons.phone),
                    ),
                  ),
                  SizedBox(height: 20),



                  // Form Submit Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        updatePatientInfo();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 116, 180, 234), // Adjust color as needed
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child:  Text(Provider.of<UiProvider>(context)
                          .getLocale()
                          .keys[Provider.of<UiProvider>(context).language]?["45"] ??'Save Changes', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  SizedBox(height: 20),

                  // Created Date and Delete Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        Provider.of<UiProvider>(context)
                            .getLocale()
                            .keys[Provider.of<UiProvider>(context).language]!["44"]!   + ' '+ _createdController.text,
                        style: TextStyle(fontSize: 12),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          deleteAccount();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent.withOpacity(0.1),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text(
                          Provider.of<UiProvider>(context)
                              .getLocale()
                              .keys[Provider.of<UiProvider>(context).language]?["46"] ?? 'Delete Account',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}
