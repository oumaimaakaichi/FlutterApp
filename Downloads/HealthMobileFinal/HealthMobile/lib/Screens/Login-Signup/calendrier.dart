import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthhub/Screens/Login-Signup/CustomDrawer.dart';
import 'package:healthhub/Screens/Login-Signup/DoctorAppointment.dart';
import 'package:healthhub/Screens/Login-Signup/TomorrowApp.dart';
import 'package:healthhub/Screens/Login-Signup/provider.dart';
import 'package:healthhub/Screens/Widgets/profilList.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
class DoctorCalendarPage extends StatefulWidget {
  @override
  _DoctorCalendarPageState createState() => _DoctorCalendarPageState();
}

class _DoctorCalendarPageState extends State<DoctorCalendarPage>
{
  late CalendarFormat _calendarFormat;
  late DateTime _focusedDay;
  late DateTime _selectedDay;
  late List<String> _availableHours;
  List<String> _selectedHours = [];

  @override
  void initState() {
    super.initState();
    _calendarFormat = CalendarFormat.month;
    _focusedDay = DateTime.now();
    _selectedDay = DateTime.now();
    _availableHours = ['8:00', '9:00', '10:00', '11:00', '12:00', '13:00', '14:00', '15:00' , '16:00' ,'17:00' , '18:00'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text("${Provider.of<UiProvider>(context).getLocale().keys[Provider.of<UiProvider>(context).language]?["7"] ?? "Availability"}" , style: TextStyle(
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
        backgroundColor: Color.fromARGB(255, 116, 180, 234),
      ),
      drawer: CustomDrawer(), //
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.all(20.0), // Ajoutez les marges désirées ici
              child: TableCalendar(
                calendarFormat: _calendarFormat,
                focusedDay: _focusedDay,
                firstDay: DateTime(2022),
                lastDay: DateTime(2030),
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                  });
                  _showAppointmentForm(context);
                },
                headerStyle: HeaderStyle(
                  leftChevronIcon: Icon(LineAwesomeIcons.chevron_left),
                  rightChevronIcon: Icon(LineAwesomeIcons.chevron_right),
                ),
              ),
            ),
            profilelist(
              icon: LineAwesomeIcons.clock,
              title: "${Provider.of<UiProvider>(context).getLocale().keys[Provider.of<UiProvider>(context).language]?["14"] ?? "Today availablity"}",
              onPress: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AppointmentListPage()),
                );

              },
            ),
            profilelist(
              icon: LineAwesomeIcons.clock,
              title: "${Provider.of<UiProvider>(context).getLocale().keys[Provider.of<UiProvider>(context).language]?["33"] ?? "Tomorrow availablity"}",
              onPress: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TomorrowAppointment()),
                );

              },
            ),

          ],
        ),
      ),
    );
  }

  void _showAppointmentForm(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("${Provider.of<UiProvider>(context).getLocale().keys[Provider.of<UiProvider>(context).language]?["14"] ?? "Add Appointment"}"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('${Provider.of<UiProvider>(context).getLocale().keys[Provider.of<UiProvider>(context).language]?["17"] ?? "Selected Day"}: $_selectedDay'),
                  TextFormField(
                    initialValue: _selectedHours.join(', '), // Afficher les heures sélectionnées dans l'input
                    decoration: InputDecoration(labelText: '${Provider.of<UiProvider>(context).getLocale().keys[Provider.of<UiProvider>(context).language]?["16"] ?? "Selected Hours"}'),
                    readOnly: true,
                  ),
                  Wrap(
                    children: _availableHours.map((hour) {
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.0),
                        child: FilterChip(
                          label: Text(hour),
                          selected: _selectedHours.contains(hour),
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                _selectedHours.add(hour);
                              } else {
                                _selectedHours.remove(hour);
                              }
                            });
                          },
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 50),
                  ElevatedButton(
                    onPressed: () async {
                      await _saveAppointmentsToFirestore();
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 116, 180, 234), // Définir la couleur de fond du bouton en vert
                    ),
                    child: Text(
                        "${Provider.of<UiProvider>(context).getLocale().keys[Provider.of<UiProvider>(context).language]?["14"] ?? "Add Appointment"}",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        color: Colors.white, // Définir la couleur du texte en blanc
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0,
                      ),
                    ),
                  ),

                ],

              ),
            );
          },
        );

      },
    );
  }

  Future<void> _saveAppointmentsToFirestore() async {
    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;
      final selectedDateString = '${_selectedDay.year}-${_selectedDay.month}-${_selectedDay.day}';
      // Enregistrer les rendez-vous avec la date au format "année-mois-jour"
      await FirebaseFirestore.instance.collection('Doctor').doc(userId).set({
        'appointments': {
          selectedDateString: _selectedHours,
        },
      }, SetOptions(merge: true));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Appointments saved successfully' ,style: TextStyle(fontSize: 16 , color: Colors.green)),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save appointments'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

}
