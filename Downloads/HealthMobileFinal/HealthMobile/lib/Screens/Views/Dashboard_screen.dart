import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthhub/Screens/Views/doctor_details_screen.dart';
import 'package:healthhub/Screens/Views/doctor_search.dart';
import 'package:healthhub/Screens/Views/find_doctor.dart';
import 'package:healthhub/Screens/Widgets/banner.dart';
import 'package:healthhub/Screens/Widgets/list_doctor1.dart';
import 'package:healthhub/Screens/Widgets/listicons.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../Login-Signup/provider.dart';

class Dashboard extends StatelessWidget {
  Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),

          ),
        ],
        title: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            Text(
              Provider.of<UiProvider>(context)
                  .getLocale()
                  .keys[Provider.of<UiProvider>(context).language]?["47"] ?? "Find your desire\nhealth solution",
              style: GoogleFonts.inter(
                  color: Color.fromARGB(255, 51, 47, 47),
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1),
            ),
          ],
        ),
        toolbarHeight: 130,
        elevation: 0,
      ),
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Center(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.06,
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(),
                child: TextField(
                  onTap: () {
                    Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.rightToLeft,
                            child: find_doctor()));
                  },
                  textAlign: TextAlign.start,
                  textInputAction: TextInputAction.none,
                  autofocus: false,
                  obscureText: false,
                  keyboardType: TextInputType.emailAddress,
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    focusColor: Colors.black26,
                    fillColor: Color.fromARGB(255, 247, 247, 247),
                    filled: true,
                    prefixIcon: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      child: Container(
                        height: 10,
                        width: 10,
                        child: Image.asset(
                          "lib/icons/search.png",
                          filterQuality: FilterQuality.high,
                        ),
                      ),
                    ),
                    prefixIconColor: const Color.fromARGB(255, 3, 190, 150),
                    labelText:Provider.of<UiProvider>(context)
                        .getLocale()
                        .keys[Provider.of<UiProvider>(context).language]?["48"] ?? "Search doctor, drugs, articles...",
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      // Action à effectuer lors du clic sur l'icône
                      // Par exemple, navigation vers une nouvelle page
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => doctor_search(specialty: 'General',)),
                      );
                    },
                    child: listIcons(Icon: "lib/icons/Doctor.png", text: Provider.of<UiProvider>(context)
                        .getLocale()
                        .keys[Provider.of<UiProvider>(context).language]?["49"] ??"General"),
                  ),
                  GestureDetector(
                    onTap: () {

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => doctor_search(specialty: 'Lungs Prob',)),
                      );
                    },
                    child:  listIcons(Icon: "lib/icons/Lungs.png", text: Provider.of<UiProvider>(context)
                        .getLocale()
                        .keys[Provider.of<UiProvider>(context).language]?["50"] ??"Lungs Prob"),
                  ),
                  GestureDetector(
                    onTap: () {

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => doctor_search(specialty: 'Dentist',)),
                      );
                    },
                    child: listIcons(Icon: "lib/icons/Dentist.png", text: Provider.of<UiProvider>(context)
                        .getLocale()
                        .keys[Provider.of<UiProvider>(context).language]?["51"] ?? "Dentist"),
                  ),
                  GestureDetector(
                    onTap: () {

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => doctor_search(specialty: 'Psychiatrist',)),
                      );
                    },
                    child: listIcons(Icon: "lib/icons/psychology.png", text: Provider.of<UiProvider>(context)
                        .getLocale()
                        .keys[Provider.of<UiProvider>(context).language]?["52"] ?? "Psychiatrist"),
                  ),
                  GestureDetector(
                    onTap: () {

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => doctor_search(specialty: 'Covid',)),
                      );
                    },
                    child: listIcons(Icon: "lib/icons/covid.png", text: Provider.of<UiProvider>(context)
                        .getLocale()
                        .keys[Provider.of<UiProvider>(context).language]?["53"] ??"Covid"),
                  ),
                  GestureDetector(
                    onTap: () {

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => doctor_search(specialty: 'Cardiologist',)),
                      );
                    },
                    child: listIcons(Icon: "lib/icons/cardiologist.png", text: Provider.of<UiProvider>(context)
                        .getLocale()
                        .keys[Provider.of<UiProvider>(context).language]?["54"] ?? "Cardiologist"),
                  ),
                ],
              ),
            ),

            SizedBox(
              height: 10,
            ),
            banner(),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    Provider.of<UiProvider>(context)
                        .getLocale()
                        .keys[Provider.of<UiProvider>(context).language]?["57"] ?? "Top Doctor",
                    style: GoogleFonts.inter(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: Color.fromARGB(255, 46, 46, 46),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          PageTransition(
                              type: PageTransitionType.rightToLeft,
                              child: doctor_search(specialty: '',)));
                    },
                    child: Text(
                      Provider.of<UiProvider>(context)
                          .getLocale()
                          .keys[Provider.of<UiProvider>(context).language]?["58"] ?? "See all",
                      style: GoogleFonts.inter(
                        fontSize: 16.sp,
                        color: const Color.fromARGB(255, 116, 180, 234),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  height: 180,
                  width: 400,
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance.collection('Doctor').snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Center(child: Text('Une erreur s\'est produite'));
                      }
                      if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
                        return Center(child: Text('Aucun médecin trouvé'));
                      }
                      return ListView.builder(
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          var doctor = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DoctorDetails(doctorData: doctor


                                  ),
                                ),
                              );
                            },
                            child: list_doctor1(
                              doctorData: doctor,
                              image:doctor['imageURL'],
                              maintext: doctor['username'] ?? 'No name', // Assuming 'name' is the doctor's name
                              subtext: doctor['specialite'] ?? 'no specialite', // Assuming 'specialization' is the doctor's specialization
                              adress: doctor['adress'] ?? 'no adress',
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ),


            SizedBox(
              height: 40,
            ),

          ],
        ),
      ),
    );
  }
}