import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthhub/Screens/Login-Signup/CustomDrawer.dart';
import 'package:healthhub/Screens/Login-Signup/dashboard.dart';
import 'package:page_transition/page_transition.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:flutter/material.dart';





class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _adresseController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  String? _imageURL;
  @override
  void initState() {
    super.initState();
    // Récupérer les informations du médecin connecté depuis Firestore
    fetchDoctorInfo();
  }

  // Fonction pour récupérer les informations du médecin connecté
  void fetchDoctorInfo() async {
    // Récupérer l'ID de l'utilisateur connecté
    String userId = FirebaseAuth.instance.currentUser!.uid;

    // Récupérer les informations du médecin à partir de Firestore
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('Doctor').doc(userId).get();

    // Extraire les informations du médecin
    String username = userSnapshot['username'];
    String adress = userSnapshot['adress'];
    String phone = userSnapshot['phone'];
    String imageURL = userSnapshot['imageURL']; // Add this line to retrieve the image URL

    // Mettre à jour les contrôleurs avec les valeurs récupérées
    setState(() {
      _usernameController.text = username;
  _adresseController.text=adress;
      _phoneController.text = phone;
      _imageURL=imageURL;
    });
  }

  // Fonction pour mettre à jour les informations dans Firestore
  void updateDoctorInfo() async {
    // Récupérer l'ID de l'utilisateur connecté
    String userId = FirebaseAuth.instance.currentUser!.uid;

    // Référence au document du médecin dans Firestore
    DocumentReference userRef = FirebaseFirestore.instance.collection('Doctor').doc(userId);

    // Mettre à jour les données du médecin dans Firestore
    await userRef.update({
      'username': _usernameController.text,
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
      appBar: AppBar(
        title: Text('Profil' , style: TextStyle(
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
        backgroundColor: Color.fromARGB(255, 3, 190, 150),
      ),

      drawer: CustomDrawer(),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Image centrée
            Container(
              width: 180,
              height: 180,
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

            SizedBox(height:40),
            // Champs d'entrée pour l'email
            TextFormField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'FullName',
              ),
            ),
            SizedBox(height: 20),
            // Champs d'entrée pour l'adresse
            TextFormField(
              controller: _adresseController,
              decoration: InputDecoration(
                labelText: 'Address',
              ),
            ),
            SizedBox(height: 20),
            // Champs d'entrée pour la spécialité
            TextFormField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: 'Phone',
              ),
            ),
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
                  backgroundColor: Color.fromARGB(255, 3, 190, 150),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  "Update",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0,

                  ),

                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
