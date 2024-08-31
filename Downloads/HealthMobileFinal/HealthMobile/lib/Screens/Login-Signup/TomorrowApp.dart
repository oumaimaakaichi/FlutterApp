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

class TomorrowAppointment extends StatefulWidget {
  @override
  _TomorrowAppointmentState createState() => _TomorrowAppointmentState();
}

class _TomorrowAppointmentState extends State<TomorrowAppointment> {
  List<String> _appointments = [];

  @override
  void initState() {
    super.initState();
    _fetchAppointmentsFromFirestore();
  }

  Future<void> _fetchAppointmentsFromFirestore() async {
    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;
      final snapshot = await FirebaseFirestore.instance
          .collection('Doctor')
          .doc(userId)
          .get();

      if (snapshot.exists) {
        final appointments = snapshot.data()!['appointments'];

        if (appointments != null) {
          final now = DateTime.now();
          final selectedDay = '${now.year}-${now.month}-${now.day + 1}';
          if (appointments.containsKey(selectedDay)) {
            setState(() {
              _appointments = List<String>.from(appointments[selectedDay]);
            });
          }
        }
      }
    } catch (e) {
      print('Failed to fetch appointments: $e');
    }
  }

  Future<void> _deleteAppointment(String appointmentTime) async {
    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;
      final snapshot = await FirebaseFirestore.instance
          .collection('Doctor')
          .doc(userId)
          .get();

      if (snapshot.exists) {
        final appointments = snapshot.data()!['appointments'];

        if (appointments != null) {
          final now = DateTime.now();
          final selectedDay = '${now.year}-${now.month}-${now.day + 1}';
          if (appointments.containsKey(selectedDay)) {
            List<String> updatedAppointments =
            List<String>.from(appointments[selectedDay]);
            updatedAppointments.remove(appointmentTime);
            await FirebaseFirestore.instance
                .collection('Doctor')
                .doc(userId)
                .update({
              'appointments.$selectedDay': updatedAppointments,
            });

            setState(() {
              _appointments.remove(appointmentTime);
            });

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Appointment deleted successfully'),
                duration: Duration(seconds: 2),
              ),
            );
          }
        }
      }
    } catch (e) {
      print('Failed to delete appointment: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete appointment'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Container(
            height: MediaQuery.of(context).size.height * 0.06,
            width: MediaQuery.of(context).size.width * 0.06,
            child: Image.asset("lib/icons/back2.png"),
          ),
          onPressed: () {
            Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.leftToRight,
                child: DoctorCalendarPage(),
              ),
            );
          },
        ),
        centerTitle: true,
        title: Text(
          "${Provider.of<UiProvider>(context).getLocale().keys[Provider.of<UiProvider>(context).language]?["33"] ?? "Tomorrow availability"}",
          style: GoogleFonts.inter(
            color: Colors.black87,
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            letterSpacing: 0,
          ),
        ),
        toolbarHeight: 110,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: _appointments.isEmpty
          ? Center(
        child: Text('No appointments for tomorrow'),
      )
          : ListView.builder(
        itemCount: _appointments.length,
        itemBuilder: (context, index) {
          return _buildAppointmentListItem(
              context, _appointments[index]);
        },
      ),
    );
  }

  Widget _buildAppointmentListItem(
      BuildContext context, String appointmentTime) {
    return Card(
      color: Color.fromARGB(255, 145, 184, 217),
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
        trailing: IconButton(
          icon: Icon(LineAwesomeIcons.trash),
          color: Colors.white,
          onPressed: () {
            _deleteAppointment(appointmentTime);
          },
        ),
      ),
    );
  }
}
