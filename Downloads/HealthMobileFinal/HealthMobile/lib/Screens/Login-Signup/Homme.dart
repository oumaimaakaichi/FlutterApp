import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:healthhub/Screens/Login-Signup/provider.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';

import 'CustomDrawer.dart';

class HomePage1 extends StatefulWidget {
  @override
  _HomePage1State createState() => _HomePage1State();
}

class _HomePage1State extends State<HomePage1> {
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
          "${Provider.of<UiProvider>(context).getLocale().keys[Provider.of<UiProvider>(context).language]?["1"] ?? "Home"}",
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
      body: StreamBuilder(
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

          // Récupérer la date actuelle (année, mois, jour)
          final now = DateTime.now();
          final currentDate = DateTime(now.year, now.month, now.day);

          // Filtrer les rendez-vous pour afficher uniquement ceux d'aujourd'hui
          final todayAppointments = snapshot.data!.docs.where((doc) {
            final date = doc['date'];
            final formattedDate = _formatDate(date);
            final dateDateTime = DateTime.parse(formattedDate);
            return dateDateTime.year == currentDate.year &&
                dateDateTime.month == currentDate.month &&
                dateDateTime.day == currentDate.day;
          }).toList();

          if (todayAppointments.isEmpty) {
            return Center(child: Text('Aucun rendez-vous trouvé pour aujourd\'hui'));
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 8.0), // Ajout de marginTop
                child: Text(
                  '${Provider.of<UiProvider>(context).getLocale().keys[Provider.of<UiProvider>(context).language]?["39"] ?? "Today Appointments"}',
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey
                  ),
                ),
              ),

              Expanded(
                child: ListView.separated(
                  separatorBuilder: (context, index) => Divider(color: Colors.grey),
                  itemCount: todayAppointments.length,
                  itemBuilder: (context, index) {
                    final doc = todayAppointments[index];
                    final date = doc['date'];

                    final formattedDate = _formatDate(date);
                    final dateDateTime = DateTime.parse(formattedDate);

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
                        return ListTile(
                          leading: Image.asset('images/calend.png'), // Affichage de l'image logo
                          title: RichText(
                            text: TextSpan(
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                              children: [
                                TextSpan(text: '${Provider.of<UiProvider>(context).getLocale().keys[Provider.of<UiProvider>(context).language]?["34"] ?? "Date"}: $date, '),
                                TextSpan(
                                  text: '${Provider.of<UiProvider>(context).getLocale().keys[Provider.of<UiProvider>(context).language]?["35"] ?? "Hour"}: ',

                                ),
                                TextSpan(
                                  text: '$time',
                                  style: TextStyle(color: Colors.blue),
                                ),
                              ],
                            ),
                          ),

                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 5),
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
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // Fonction pour formater la date en format 'yyyy-MM-dd'
  String _formatDate(String date) {
    final parts = date.split('-');
    final year = parts[0];
    final month = parts[1].length == 1 ? '0${parts[1]}' : parts[1];
    final day = parts[2].length == 1 ? '0${parts[2]}' : parts[2];
    return '$year-$month-$day';
  }
}
