import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:healthhub/Screens/Login-Signup/Profil.dart';
import 'package:healthhub/Screens/Login-Signup/Setting.dart';
import 'package:healthhub/Screens/Login-Signup/about.dart';
import 'package:healthhub/Screens/Login-Signup/loginDoctor.dart';
import 'package:healthhub/Screens/Views/Homepage.dart';
import 'package:page_transition/page_transition.dart';

class Dashboard extends StatelessWidget {
  var height, width;
  List imgData = [
    "images/rende.png",
    "images/calend.png",
    "images/pf.png",
    "images/set.png",
    "images/about.png"
  ];
  List titles = ["Appointment", "Calendar", "Profile", "Setting", "About"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Container(
            height: MediaQuery.of(context).size.height * 0.04,
            width: MediaQuery.of(context).size.width * 0.06,
            child: Image.asset("lib/icons/back2.png"),
          ),
          onPressed: () {
            Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.leftToRight,
                child: loginDoctor(),
              ),
            );
          },
        ),
        backgroundColor: Color.fromARGB(255, 3, 190, 150),
      ),
      body: Container(
        color: Color.fromARGB(255, 3, 190, 150),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            double height = constraints.maxHeight;
            double width = constraints.maxWidth;
            return Column(
              children: [
                Container(
                  height: height * 0.15,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Doctor Space",
                          style: TextStyle(
                            fontSize: 35,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(height * 0.1),
                        topRight: Radius.circular(height * 0.1),
                      ),
                    ),
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: width < 600 ? 2 : 4,
                        childAspectRatio: width < 600 ? 1.5 : 1.1,
                        mainAxisSpacing: width * 0.04,
                        crossAxisSpacing: width * 0.04,
                      ),
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: imgData.length,
                      itemBuilder: (context, index) {
                        return Center(
                          child: InkWell(
                            onTap: () {
                              // Navigation vers la page du profil lorsque l'élément "Profile" est cliqué
                              if (titles[index] == "Profile") {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProfilePage(),
                                  ),
                                );
                              }
                              else if (titles[index] == "About") {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AboutPage(), // Navigation vers la page AboutPage
                                  ),
                                );
                              }
                              else if (titles[index] == "Setting") {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SettingPage(), // Navigation vers la page AboutPage
                                  ),
                                );
                              }
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: height * 0.05),
                              width: width * 0.4, // Largeur du conteneur
                              height: width * 0.5, // Hauteur du conteneur
                              decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.circular(height * 0.03),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    spreadRadius: 1,
                                    blurRadius: 6,
                                  )
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                                children: [
                                  Image.asset(
                                    imgData[index],
                                    width: 80,
                                    height: 80,
                                  ),
                                  Text(
                                    titles[index],
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}






