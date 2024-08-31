import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthhub/Screens/Login-Signup/CustomDrawer.dart';
import 'package:healthhub/Screens/Login-Signup/calendrier.dart';
import 'package:healthhub/Screens/Login-Signup/provider.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AppointmentListPage extends StatelessWidget {
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
                    child: DoctorCalendarPage()));
          },
        ),
        centerTitle: true,
        title: Text(
            "${Provider.of<UiProvider>(context).getLocale().keys[Provider.of<UiProvider>(context).language]?["14"] ?? "Today availablity"}",
          style: GoogleFonts.inter(
              color: Colors.black87,
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              letterSpacing: 0),
        ),
        toolbarHeight: 110,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: FutureBuilder(
        future: _fetchAppointmentsFromFirestore(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          List<String> appointments = snapshot.data as List<String>;
          return appointments.isEmpty
              ? Center(
            child: Text('No appointments for today'),
          )
              : ListView.builder(
            itemCount: appointments.length,
            itemBuilder: (context, index) {
              return _buildAppointmentListItem(appointments[index]);
            },
          );
        },
      ),

    );
  }

  Widget _buildAppointmentListItem(String appointmentTime) {
    return Card(
      color: Color.fromARGB(255, 116, 180, 234),

      elevation: 4,
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: Icon(
          LineAwesomeIcons.clock,
          color: Colors.white,
        ),
        title: Text(
          appointmentTime,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Future<List<String>> _fetchAppointmentsFromFirestore() async {
    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;
      final snapshot =
      await FirebaseFirestore.instance.collection('Doctor').doc(userId).get();

      if (snapshot.exists) {
        final appointments = snapshot.data()!['appointments'];

        if (appointments != null) {
          final now = DateTime.now();
          final selectedDay = '${now.year}-${now.month}-${now.day}';
          if (appointments.containsKey(selectedDay)) {
            return List<String>.from(appointments[selectedDay]);
          }
        }
      }
      return [];
    } catch (e) {
      throw 'Failed to fetch appointments: $e';
    }
  }
  Future<List<String>> _fetchTomorrowAppointmentsFromFirestore() async {
    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;
      final snapshot =
      await FirebaseFirestore.instance.collection('Doctor').doc(userId).get();

      if (snapshot.exists) {
        final appointments = snapshot.data()!['appointments'];

        if (appointments != null) {
          final now = DateTime.now();
          final selectedDay = '${now.year}-${now.month}-${now.day+1}';
          if (appointments.containsKey(selectedDay)) {
            return List<String>.from(appointments[selectedDay]);
          }
        }
      }
      return [];
    } catch (e) {
      throw 'Failed to fetch appointments: $e';
    }
  }
}


