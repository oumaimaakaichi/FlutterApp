import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:healthhub/Screens/Login-Signup/DoctorAppointment.dart';

import 'package:healthhub/Screens/Login-Signup/Homme.dart';
import 'package:healthhub/Screens/Login-Signup/Profil.dart';
import 'package:healthhub/Screens/Login-Signup/Setting.dart';
import 'package:healthhub/Screens/Login-Signup/about.dart';
import 'package:healthhub/Screens/Login-Signup/calendrier.dart';
import 'package:healthhub/Screens/Login-Signup/loginDoctor.dart';
import 'package:healthhub/Screens/Login-Signup/proff.dart';
import 'package:healthhub/Screens/Login-Signup/provider.dart';
import 'package:healthhub/Screens/Login-Signup/rendez-vous.dart';
import 'package:provider/provider.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
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
    String email = userSnapshot['email'];
    String adress = userSnapshot['adress'];
    String specialite = userSnapshot['specialite'];
    String imageURL = userSnapshot['imageURL']; // Add this line to retrieve the image URL

    // Mettre à jour l'état avec les valeurs récupérées
    setState(() {
      _imageURL = imageURL;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: fetchUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Afficher un indicateur de chargement si les données ne sont pas encore disponibles
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // Gérer les erreurs si elles se produisent
          return Text('Error: ${snapshot.error}');
        } else {
          // Récupérer le nom de l'utilisateur depuis les données Firestore
          String username = snapshot.data!['username'];

          return Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 3, 190, 150),
                    image: DecorationImage(
                      image: AssetImage("images/d2.jpg"), // Remplacez le chemin par votre propre image
                      fit: BoxFit.cover, // Ajuster l'image pour couvrir tout l'espace disponible
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [

                      SizedBox(width: 120), // Ajouter un espacement entre l'image et le texte
                      Text(
                        '$username',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                        ),
                      ),
                    ],
                  ),
                ),

                ListTile(
                  title:Text("${Provider.of<UiProvider>(context).getLocale().keys[Provider.of<UiProvider>(context).language]?["1"] ?? "Home"}"),
                  leading: ImageIcon(
                    AssetImage("lib/icons/home.png"),
                    color: Color.fromARGB(255, 116, 180, 234), // Couleur de l'icône
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>HomePage1()),
                    );
                  },
                ),
                ListTile(
                  title: Text("${Provider.of<UiProvider>(context).getLocale().keys[Provider.of<UiProvider>(context).language]?["6"] ?? "Profil"}"),
                  leading: ImageIcon(
                    AssetImage("lib/icons/person.png"),
                    color: Color.fromARGB(255, 116, 180, 234), // Couleur de l'icône
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Profile_screen()),
                    );
                  },
                ),
                ListTile(
                  title:Text("${Provider.of<UiProvider>(context).getLocale().keys[Provider.of<UiProvider>(context).language]?["7"] ?? "Availability"}"),
                  leading: ImageIcon(
                    AssetImage("lib/icons/availability.png"),
                    color: Color.fromARGB(255, 116, 180, 234), // Couleur de l'icône
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DoctorCalendarPage()),
                    );
                  },
                ),
                ListTile(
                  title: Text("${Provider.of<UiProvider>(context).getLocale().keys[Provider.of<UiProvider>(context).language]?["8"] ?? "All Appointment"}"),
                  leading: ImageIcon(
                    AssetImage("lib/icons/appointment.png"),
                    color: Color.fromARGB(255, 116, 180, 234), // Couleur de l'icône
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AllR()),
                    );
                  },
                ),
                ListTile(
                  title: Text("${Provider.of<UiProvider>(context).getLocale().keys[Provider.of<UiProvider>(context).language]?["3"] ?? "Settings"}"),
                  leading: ImageIcon(
                    AssetImage("lib/icons/setting.png"),
                    color:Color.fromARGB(255, 116, 180, 234), // Couleur de l'icône
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SettingPage()),
                    );
                  },
                ),

                ListTile(
                  title: Text("${Provider.of<UiProvider>(context).getLocale().keys[Provider.of<UiProvider>(context).language]?["2"] ?? "About"}"),
                  leading: ImageIcon(
                    AssetImage("lib/icons/information.png"),
                    color: Color.fromARGB(255, 116, 180, 234), // Couleur de l'icône
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AboutPage()),
                    );
                  },
                ),
                ListTile(
                  title: Text("${Provider.of<UiProvider>(context).getLocale().keys[Provider.of<UiProvider>(context).language]?["9"] ?? "Logout"}"),
                  leading: ImageIcon(
                    AssetImage("lib/icons/exit.png"),
                    color: Color.fromARGB(255, 116, 180, 234), // Couleur de l'icône
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => loginDoctor()),
                    );
                  },
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Future<DocumentSnapshot> fetchUserData() async {
    // Récupérer l'ID de l'utilisateur connecté
    String userId = FirebaseAuth.instance.currentUser!.uid;
    // Récupérer les informations de l'utilisateur depuis Firestore
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('Doctor').doc(userId).get();
    return userSnapshot;
  }
}
