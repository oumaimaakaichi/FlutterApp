import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:healthhub/Screens/Login-Signup/Homme.dart';
import 'package:healthhub/Screens/Login-Signup/login_signupD.dart';
import 'package:healthhub/Screens/Login-Signup/login_signupClient.dart';
import 'package:healthhub/Screens/Views/Homepage.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var auth = FirebaseAuth.instance;
  var isDoctorLoggedIn = false;
  var isPatientLoggedIn= false ;
  // Méthode pour vérifier si le médecin est connecté
  checkDoctorLoggedIn() async {
    auth.authStateChanges().listen((User? user) {
      if (user != null) {
        setState(() {
          isDoctorLoggedIn = true;
        });
      }
    });
  }

  // Méthode pour vérifier si le médecin est connecté
  checkPatientLoggedIn() async {
    auth.authStateChanges().listen((User? user) {
      if (user != null) {
        setState(() {
          isPatientLoggedIn = true;
        });
      }
    });
  }

  @override
  void initState() {
    checkDoctorLoggedIn();
    checkPatientLoggedIn();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (isPatientLoggedIn) {
                        // Si le médecin est connecté, naviguer vers la page d'accueil des médecins
                        // Remplacez login_signup() par la page d'accueil des médecins
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Homepage()),
                        );
                      } else {
                        // Sinon, naviguer vers la page de connexion des médecins
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => login_signupC()),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                      backgroundColor: Color.fromARGB(255, 116, 180, 234),
                    ),
                    child: Text(
                      'Patient',
                      style: TextStyle(fontSize: 22, color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 20),
                  Image.asset(
                    'images/patient.jfif',
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.width * 0.9,
                  ),
                ],
              ),
            ),
            VerticalDivider(
              color: Colors.black,
              thickness: 1,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (isDoctorLoggedIn) {
                        // Si le médecin est connecté, naviguer vers la page d'accueil des médecins
                        // Remplacez login_signup() par la page d'accueil des médecins
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage1()),
                        );
                      } else {
                        // Sinon, naviguer vers la page de connexion des médecins
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => login_signupD()),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                      backgroundColor: Color.fromARGB(255, 116, 180, 234),
                    ),
                    child: Text(
                      'Doctor',
                      style: TextStyle(fontSize: 22, color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 20),
                  Image.asset(
                    'images/login1.png',
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.width * 0.9,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
