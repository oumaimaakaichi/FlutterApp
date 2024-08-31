import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../Login-Signup/provider.dart';
import '../Widgets/date_select.dart';
import '../Widgets/doctorList.dart';
import '../Widgets/time_select.dart';

class DoctorDetails extends StatefulWidget {
  final Map<String, dynamic> doctorData;

  const DoctorDetails({Key? key, required this.doctorData}) : super(key: key);

  @override
  _DoctorDetailsState createState() => _DoctorDetailsState();
}

class _DoctorDetailsState extends State<DoctorDetails> {
  bool showExtendedText = false;
  bool isSelected = false;
  late String selectedTime = "";
  late String selectedDate;
  late String selectedMonth;
  List<String> availableTimes = [];

  @override
  void initState() {
    super.initState();
    // Initialize selectedDate to the first available date
    selectedMonth = DateTime.now().toString().split('-')[1]; // Current month
    selectedDate = widget.doctorData["appointments"].keys.first;
    // Fetch available times for the initially selected date
    updateAvailableTimes();
  }

  void toggleTextVisibility() {
    setState(() {
      showExtendedText = !showExtendedText;
    });
  }

  String extractDayOfWeek(int dayOfWeek) {
    return _getDayOfWeek(dayOfWeek);
  }

  DateTime parseDate(String dateString) {
    List<String> parts = dateString.split('-');

    if (parts.length != 3) {
      throw FormatException('Invalid date format');
    }

    int year = int.parse(parts[0]);
    int month = int.parse(parts[1]);
    int day = int.parse(parts[2]);

    return DateTime(year, month, day);
  }

  String _getDayOfWeek(int day) {
    switch (day) {
      case DateTime.monday:
        return 'Mon';
      case DateTime.tuesday:
        return 'Tue';
      case DateTime.wednesday:
        return 'Wed';
      case DateTime.thursday:
        return 'Thu';
      case DateTime.friday:
        return 'Fri';
      case DateTime.saturday:
        return 'Sat';
      case DateTime.sunday:
        return 'Sun';
      default:
        return '';
    }
  }

  void updateAvailableTimes() {
    setState(() {
      availableTimes =
          widget.doctorData["appointments"][selectedDate].cast<String>();
    });
  }

  // Function to store the selected appointment data
  void selectAppointment(String time, String date) {
    setState(() {
      selectedTime = time;
      selectedDate = date;
    });
  }

  void bookAppointment() {
    // Check if selectedTime is null
    if (selectedTime == null) {
      // Show an error message to the user
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Error"),
          content: Text(
              "Please select a time before booking the appointment."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        ),
      );
      return; // Exit the function
    }
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String userId = user.uid;
      // Check if an appointment already exists for the selected date
      FirebaseFirestore.instance
          .collection("AppointmentPatient")
          .where("userId", isEqualTo: userId)
          .where("date", isEqualTo: selectedDate)
          .get()
          .then((QuerySnapshot querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          // An appointment already exists for this date, show an error message to the user
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text("Error"),
              content: Text(
                  "You have already booked an appointment for this date."),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("OK"),
                ),
              ],
            ),
          );
        } else {
          // No existing appointment for this date, allow the user to book the appointment
          String email = widget.doctorData["email"];
          String userId = user.uid;

          // Generate a unique ID for the appointment
          String appointmentId = FirebaseFirestore.instance
              .collection("AppointmentPatient")
              .doc()
              .id;

          // Save the appointment in Firestore
          FirebaseFirestore.instance
              .collection("AppointmentPatient")
              .doc(appointmentId)
              .set({
            "userId": userId,
            "email": email,
            "date": selectedDate,
            "time": selectedTime,
          });

          // Remove the booked time from the doctor's available times list
          List<String> availableTimes =
          widget.doctorData["appointments"][selectedDate].cast<String>();
          availableTimes.remove(selectedTime);
          FirebaseFirestore.instance
              .collection("Doctor")
              .where("email", isEqualTo: widget.doctorData["email"])
              .get()
              .then((querySnapshot) {
            if (querySnapshot.docs.isNotEmpty) {
              // Found the doctor with the specified email
              String doctorId = querySnapshot.docs.first.id;
              // Update the doctor's appointments in Firestore
              FirebaseFirestore.instance
                  .collection("Doctor")
                  .doc(doctorId)
                  .update({
                "appointments.$selectedDate": availableTimes,
              }).then((_) {
                // Successfully updated the doctor's appointments
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text("Appointment Booked"),
                    content: Text(
                        "Your appointment has been successfully booked for $selectedDate at $selectedTime."),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("OK"),
                      ),
                    ],
                  ),
                );
              }).catchError((error) {
                // Handle errors when updating the doctor's appointments
                print("Failed to update doctor's appointments: $error");
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text("Error"),
                    content: Text(
                        "Failed to update doctor's appointments. Please try again later."),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("OK"),
                      ),
                    ],
                  ),
                );
              });
            } else {
              // No doctor found with the specified email
              print("No doctor found with the specified email.");
              // Show an error message to the user if necessary
            }
          }).catchError((error) {
            // Handle errors when searching for the doctor in Firestore
            print("Failed to search for doctor: $error");
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text("Error"),
                content: Text(
                    "Failed to search for doctor. Please try again later."),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("OK"),
                  ),
                ],
              ),
            );
          });
        }
      }).catchError((error) {
        // Handle errors when retrieving existing appointments from Firestore
        print("Failed to check existing appointments: $error");
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Error"),
            content: Text(
                "Failed to check existing appointments. Please try again later."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK"),
              ),
            ],
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determine if the button should be disabled
    bool isButtonDisabled = selectedTime.isEmpty;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Container(
            height: 10,
            width: 10,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("lib/icons/back1.png"),
              ),
            ),
          ),
        ),
        title: Text(
          Provider.of<UiProvider>(context)
              .getLocale()
              .keys[Provider.of<UiProvider>(context).language]?["57"] ?? "Top Doctors",
          style: GoogleFonts.poppins(
              color: Colors.black, fontSize: 18.sp),
        ),
        centerTitle: true,
        elevation: 0,
        toolbarHeight: 100,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              height: 10,
              width: 10,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("lib/icons/more.png"),
                ),
              ),
            ),
          ),
        ],
        backgroundColor: Colors.white,
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Column(
              children: [
                SizedBox(
                  height: 5,
                ),
                doctorList(
                  image: widget.doctorData["imageURL"],
                  maintext: widget.doctorData["username"],
                  numRating: "4.7",
                  subtext: widget.doctorData["specialite"],
                  adresse: widget.doctorData["adress"],
                ),
                SizedBox(
                  height: 15,
                ),
                GestureDetector(
                  onTap: toggleTextVisibility,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          Provider.of<UiProvider>(context)
                              .getLocale()
                              .keys[Provider.of<UiProvider>(context).language]?["2"] ?? "About",
                          style: GoogleFonts.poppins(
                              fontSize: 15.sp, fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                         widget.doctorData['about']
                        ),
                        SizedBox(
                          height: 5,
                        ),

                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 1),
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.11,
                          child: ListView.builder(
                            physics: BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemCount: (widget.doctorData["appointments"]
                            as Map<String, dynamic>)
                                .length,
                            itemBuilder: (context, index) {
                              String date = (widget.doctorData["appointments"]
                              as Map<String, dynamic>)
                                  .keys
                                  .toList()[index];
                              DateTime dateTime = parseDate(date);
                              String dayOfMonth = dateTime.day.toString();
                              String dayOfWeek =
                              extractDayOfWeek(dateTime.weekday);

                              return GestureDetector(
                                child: DateSelect(
                                  date: dayOfMonth,
                                  maintext: dayOfWeek,
                                  onTap: () {
                                    setState(() {
                                      selectedDate = date;
                                    });
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                        // Display available times for selected date
                        if (selectedDate != null)
                          Wrap(
                            children: (widget.doctorData["appointments"]
                            as Map<String, dynamic>)[selectedDate]
                                .map<Widget>((time) {
                              return Padding(
                                padding:
                                const EdgeInsets.symmetric(horizontal: 11.0),
                                child:   TimeSelect(
                                mainText: time,
                                isSelected: selectedTime == time, // Détermine si cette heure est sélectionnée
                                onTap: () {
                                  // Met à jour l'état de sélection lorsque l'utilisateur sélectionne cette heure
                                  setState(() {
                                    selectedTime = time; // Met à jour l'heure sélectionnée
                                  });
                                  selectAppointment(time, selectedDate);
                                },
                              ),
                              );
                            }).toList() ??
                                [],
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 80,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 40,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: isButtonDisabled ? null : bookAppointment,
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.06,
                      width: MediaQuery.of(context).size.width * 0.6300,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 116, 180, 234),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            Provider.of<UiProvider>(context)
                                .getLocale()
                                .keys[Provider.of<UiProvider>(context).language]?["59"] ??"Book Appointment",
                            style: GoogleFonts.poppins(
                                fontSize: 15.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
