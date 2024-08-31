import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SheduleScreen extends StatefulWidget {
  const SheduleScreen({Key? key}) : super(key: key);

  @override
  _SheduleScreenState createState() => _SheduleScreenState();
}

class _SheduleScreenState extends State<SheduleScreen> with SingleTickerProviderStateMixin {
  late TabController tabController;
  String userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Appointments",
          style: GoogleFonts.poppins(color: Colors.black, fontSize: 25.sp),
        ),
        centerTitle: false,
        elevation: 0,
        toolbarHeight: 100,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 00),
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        width: MediaQuery.of(context).size.height,
                        decoration: BoxDecoration(
                          border: Border.all(color: Color.fromARGB(255, 235, 235, 235)),
                          color: Color.fromARGB(255, 241, 241, 241),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(5),
                              child: TabBar(
                                indicator: BoxDecoration(
                                  color: Color.fromARGB(255, 116, 180, 234),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                indicatorColor: const Color.fromARGB(255, 241, 241, 241),
                                unselectedLabelColor: const Color.fromARGB(255, 32, 32, 32),
                                labelColor: Color.fromARGB(255, 255, 255, 255),
                                controller: tabController,
                                tabs: const [
                                  Tab(text: "Appoiements"),
                                  Tab(text: "Upcoming"),
                                  Tab(text: "Completed"),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: buildTabView(),
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

  Widget buildTabView() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('AppointmentPatient')
          .where('userId', isEqualTo: userId) // Filtrer par userId
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        List<DocumentSnapshot> userAppointments = snapshot.data!.docs;

        if (userAppointments.isEmpty) {
          return Center(child: Text('No appointments found'));
        }

        return TabBarView(
          controller: tabController,
          children: [
            buildAppointmentList(userAppointments, "all"),
            buildAppointmentList(userAppointments, "upcoming"),
            buildAppointmentList(userAppointments, "completed"),
          ],
        );
      },
    );
  }


  Widget buildAppointmentList(List<DocumentSnapshot> appointments, String status) {
    switch (status) {
      case "upcoming":
        return buildUpcomingAppointments(appointments);
      case "completed":
        return buildCompletedAppointments(appointments);
      case "all":
        return buildAllAppointments(appointments);
      default:
        return buildAllAppointments(appointments);
    }
  }

  Widget buildUpcomingAppointments(List<DocumentSnapshot> appointments) {
    DateTime currentDate = DateTime.now();
    List<DocumentSnapshot> filteredAppointments = [];

    appointments.forEach((DocumentSnapshot document) {
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
      String? dateString = data['date'];

      if (dateString != null) {
        List<String> dateParts = dateString.split('-');
        print(dateParts);
        if (dateParts.length == 3) {
          try {
            int year = int.parse(dateParts[0]);
            int month = int.parse(dateParts[1]);
            int day = int.parse(dateParts[2]);

            // Vérifier si la date est valide
            if (month >= 1 && month <= 12 && day >= 1 && day <= 31) {
              DateTime appointmentDate = DateTime(year, month, day);
              print(currentDate.isBefore(appointmentDate));
              if (currentDate.isBefore(appointmentDate)) {
                filteredAppointments.add(document);
              }
            } else {
              print("Invalid date format: $dateString");
            }
          } catch (e) {
            print("Invalid date format: $dateString");
          }
        } else {
          print("Invalid date format: $dateString");
        }
      } else {
        print("Invalid date format: $dateString");
      }
    });

    return buildAppointmentListView(filteredAppointments);
  }


  Widget buildCompletedAppointments(List<DocumentSnapshot> appointments) {
    DateTime currentDate = DateTime.now();
    List<DocumentSnapshot> filteredAppointments = [];

    appointments.forEach((DocumentSnapshot document) {
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
      String? dateString = data['date'];

      if (dateString != null) {
        List<String> dateParts = dateString.split('-');
        print(dateParts);
        if (dateParts.length == 3) {
          try {
            int year = int.parse(dateParts[0]);
            int month = int.parse(dateParts[1]);
            int day = int.parse(dateParts[2]);

            // Vérifier si la date est valide
            if (month >= 1 && month <= 12 && day >= 1 && day <= 31) {
              DateTime appointmentDate = DateTime(year, month, day);
              print(currentDate.isAfter(appointmentDate));
              if (currentDate.isAfter(appointmentDate)) {
                filteredAppointments.add(document);
              }
            } else {
              print("Invalid date format: $dateString");
            }
          } catch (e) {
            print("Invalid date format: $dateString");
          }
        } else {
          print("Invalid date format: $dateString");
        }
      } else {
        print("Invalid date format: $dateString");
      }
    });

    return buildAppointmentListView(filteredAppointments);
  }

  Widget buildAllAppointments(List<DocumentSnapshot> appointments) {
    return buildAppointmentListView(appointments);
  }

  Widget buildAppointmentListView(List<DocumentSnapshot> filteredAppointments) {
    if (filteredAppointments.isEmpty) {
      return Center(child: Text('No appointments found'));
    }

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: Future.wait(filteredAppointments.map((DocumentSnapshot document) async {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        String? doctorEmail = data['email'];

        // Récupération des données du médecin de manière asynchrone
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Doctor')
            .where('email', isEqualTo: doctorEmail)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          // Si des documents correspondent au filtre, retournez les données du premier document
          DocumentSnapshot doc = querySnapshot.docs.first;
          return doc.data() as Map<String, dynamic>;
        } else {
          // Aucun document trouvé avec cet e-mail
          return {'username': 'Not available', 'specialite': 'Not available'};
        }
      }).toList()),
      builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        List<Map<String, dynamic>> doctorDataList = snapshot.data ?? [];

        return ListView.builder(
          itemCount: filteredAppointments.length,
          itemBuilder: (context, index) {
            Map<String, dynamic> data = filteredAppointments[index].data() as Map<String, dynamic>;
            Map<String, dynamic> doctorData = doctorDataList[index];

            return Card(
              elevation: 3,
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: ListTile(
                contentPadding: EdgeInsets.all(16),
                leading: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(doctorData['imageURL']), // Remplacez par le chemin de l'image du médecin
                    ),
                  ),
                ),
                title: Text(
                  data['date'],
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),
                    Text('Doctor: ${doctorData['username'] ?? 'Not available'}', style: TextStyle(fontSize: 14)),
                    SizedBox(height: 5),
                    Text('Specialty: ${doctorData['specialite'] ?? 'Not available'}', style: TextStyle(fontSize: 14)),
                    SizedBox(height: 5),
                    Text('Email: ${data['email'] ?? 'Not available'}', style: TextStyle(fontSize: 14)),
                    // Add other appointment details here if needed
                  ],
                ),
                // You can display other appointment details here
              ),
            );
          },
        );
      },
    );


  }


  Future<DocumentSnapshot> getDoctorDetails(String? doctorEmail) async {
    if (doctorEmail == null) {
      return Future.error('Doctor email is null');
    }

    return await FirebaseFirestore.instance.collection('Docteur').doc(doctorEmail).get();
  }
}
