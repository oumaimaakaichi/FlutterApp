import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:healthhub/Screens/Login-Signup/provider.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';

import 'CustomDrawer.dart';

class AllR extends StatefulWidget {
  @override
  _AllRState createState() => _AllRState();
}

class _AllRState extends State<AllR> {
  late String _doctorEmail;

  @override
  void initState() {
    super.initState();
    // Récupérer l'e-mail du docteur connecté
    _doctorEmail = FirebaseAuth.instance.currentUser!.email!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${Provider.of<UiProvider>(context).getLocale().keys[Provider.of<UiProvider>(context).language]?["8"] ?? "All Appointment"}",
          style: TextStyle(
            color: Colors.white, // Couleur du texte en blanc
          ),
        ),
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
                  color: Colors.white,
                ),
              ),
            );
          },
        ),
        backgroundColor: Color.fromARGB(255, 116, 180, 234),
      ),
      drawer: CustomDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 8.0),

          ),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('AppointmentPatient')
                  .where('email', isEqualTo: _doctorEmail)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Une erreur est survenue'));
                }
                if (snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('Aucun rendez-vous trouvé'));
                }
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final doc = snapshot.data!.docs[index];
                    final date = doc['date'];
                    final time = doc['time'];
                    final userId = doc['userId'];

                    return FutureBuilder(
                      future: FirebaseFirestore.instance.collection('patient').doc(userId).get(),
                      builder: (context, AsyncSnapshot<DocumentSnapshot> patientSnapshot) {
                        if (patientSnapshot.connectionState == ConnectionState.waiting) {
                          return ListTile(
                            title: Text('Date: $date, Heure: $time'),
                            subtitle: Text('Chargement des informations du patient...'),
                          );
                        }
                        if (patientSnapshot.hasError || !patientSnapshot.hasData) {
                          return ListTile(
                            title: Text('Date: $date, Heure: $time'),
                            subtitle: Text('Informations du patient introuvables'),
                          );
                        }
                        final patientData = patientSnapshot.data!;
                        final patientFullName = patientData['fullname'];
                        final patientEmail = patientData['email'];
                        final patientPhone = patientData['phone'];

                        return Card(
                          child: ListTile(
                            leading: Image.asset('images/calend.png'), // Affichage de l'image logo
                            title: Text('${Provider.of<UiProvider>(context).getLocale().keys[Provider.of<UiProvider>(context).language]?["34"] ?? "Date"}: $date, ${Provider.of<UiProvider>(context).getLocale().keys[Provider.of<UiProvider>(context).language]?["35"] ?? "Hour"}: $time', style: TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 7),
                                Row(
                                  children: [
                                    Icon(LineAwesomeIcons.user),
                                    SizedBox(width: 4),
                                    Text('${Provider.of<UiProvider>(context).getLocale().keys[Provider.of<UiProvider>(context).language]?["36"] ?? "Patient's full name"}: $patientFullName'),
                                  ],
                                ),
                                SizedBox(height: 5),
                                Row(
                                  children: [
                                    Icon(LineAwesomeIcons.envelope),
                                    SizedBox(width: 4),
                                    Text('${Provider.of<UiProvider>(context).getLocale().keys[Provider.of<UiProvider>(context).language]?["37"] ?? "Patient Email"}: $patientEmail'),
                                  ],
                                ),
                                SizedBox(height: 5),
                                Row(
                                  children: [
                                    Icon(LineAwesomeIcons.phone),
                                    SizedBox(width: 4),
                                    Text('${Provider.of<UiProvider>(context).getLocale().keys[Provider.of<UiProvider>(context).language]?["38"] ?? "Patient phone"}: $patientPhone'),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
