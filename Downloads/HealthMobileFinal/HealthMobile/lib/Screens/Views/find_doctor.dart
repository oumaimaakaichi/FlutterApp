import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthhub/Screens/Views/doctor_details_screen.dart';
import 'package:healthhub/Screens/Widgets/doctorList.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../Login-Signup/provider.dart';

class find_doctor extends StatefulWidget {
  const find_doctor({Key? key}) : super(key: key);

  @override
  _FindDoctorState createState() => _FindDoctorState();
}

class _FindDoctorState extends State<find_doctor> {
  List<Map<String, dynamic>> searchResults = [];
  List<Map<String, dynamic>> recentDoctors = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(LineAwesomeIcons.backspace),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.white,
        title: Text(
          Provider.of<UiProvider>(context)
              .getLocale()
              .keys[Provider.of<UiProvider>(context).language]?["60"] ??"Find Doctor",
          style: GoogleFonts.inter(
            color: Color.fromARGB(255, 51, 47, 47),
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            letterSpacing: 1,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                onChanged: _searchDoctor,
                decoration: InputDecoration(
                  prefixIcon: Icon(LineAwesomeIcons.search),
                  labelText: Provider.of<UiProvider>(context)
                      .getLocale()
                      .keys[Provider.of<UiProvider>(context).language]?["48"] ??"Search doctor, drugs, articles...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Text(
                    Provider.of<UiProvider>(context)
                        .getLocale()
                        .keys[Provider.of<UiProvider>(context).language]?["57"] ??"Top Doctor",
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: Color.fromARGB(255, 46, 46, 46),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            // Display search results
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    // Handle tap on search result
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DoctorDetails(doctorData: searchResults[index],),
                      ),
                    );
                  },
                  child: doctorList(
                    maintext: searchResults[index]['username'],
                    numRating: "",
                    image: '',
                    subtext: '',
                    adresse: '',
                  ),
                );
              },
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Text(
                    Provider.of<UiProvider>(context)
                        .getLocale()
                        .keys[Provider.of<UiProvider>(context).language]?["61"] ??"Recommended Doctors",
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: Color.fromARGB(255, 46, 46, 46),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.rightToLeft,
                    child: DoctorDetails(doctorData: {},),
                  ),
                );
              },
              child: doctorList(
                image: "https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.vecteezy.com%2Ffree-photos%2Findian-doctor&psig=AOvVaw0a_R2qxpPhFWhqD7sXOD10&ust=1715444913136000&source=images&cd=vfe&opi=89978449&ved=0CBIQjRxqFwoTCPj18bnAg4YDFQAAAAAdAAAAABAE",
                maintext: "Marcus Horizon",
                numRating: "4.7",
                subtext: "Cardiologist", adresse: 'Tunis',
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Text(
                    "Your Recent Doctors",
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: Color.fromARGB(255, 46, 46, 46),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Column(
              children: recentDoctors.map((result) {
                print(result['username']);
                final imagePath = result['imageURL'];
                final name = result['username'];
                if (imagePath != null && name != null) {
                  return DoctorListItem(
                    imageURL: imagePath,
                    name: name,
                  );
                } else {
                  // Gérer le cas où imagePath ou name est null
                  return SizedBox(); // Ou tout autre widget de remplacement approprié
                }
              }).toList(),
            ),

          ],
        ),
      ),
    );
  }

  void _searchDoctor(String query) {
    // Convert the search string to lowercase for case-insensitive matching
    String searchQuery = query.toLowerCase();
    print(searchQuery);
    // Perform search only if search string is not empty
    if (searchQuery.isNotEmpty) {
      // Reset search results
      setState(() {
        searchResults.clear();
      });
      // Firestore query to retrieve doctors matching the search
      FirebaseFirestore.instance
          .collection('Doctor')
          .get()
          .then((querySnapshot) {
        // Process search results
        querySnapshot.docs.forEach((doc) {
          String username = doc['username'].toLowerCase();
          String imageURL = doc['imageURL']; // Récupérer l'URL de l'image du médecin
          // Check if doctor's name matches exact or partial search
          RegExp regExp = RegExp(searchQuery);
          if (regExp.hasMatch(username)) {
            // Add search results to the list of results
            setState(() {
              searchResults.add({
                'username': doc['username'],
                'imageURL': imageURL, // Ajouter l'URL de l'image aux résultats de recherche
              });
            });
          }
        });

        if (searchResults.isEmpty) {
          // No results found
          print('No doctors found for search: $searchQuery');
        }
      }).catchError((error) {
        // Handle any errors that occur while executing the search
        print('Error searching for doctors: $error');
      });
    } else {
      // If search string is empty, clear previous results
      setState(() {
        recentDoctors.addAll(searchResults);
        searchResults.clear();
      });
    }
  }

}

class DoctorListItem extends StatelessWidget {
  final String imageURL; // Changer imagePath en imageURL
  final String name;

  const DoctorListItem({
    Key? key,
    required this.imageURL, // Changer imagePath en imageURL
    required this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.14,
      width: MediaQuery.of(context).size.width * 0.29,
      child: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width * 0.19,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: NetworkImage(imageURL), // Utiliser imageURL au lieu de imagePath
                fit: BoxFit.contain,
              ),
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Dr. "+ name),
            ],
          ),
        ],
      ),
    );
  }
}

