import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class list_doctor1 extends StatelessWidget {
  final Map<String, dynamic> doctorData;

  list_doctor1({required this.doctorData, required image, required maintext, required subtext , required adress});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Color.fromARGB(134, 228, 227, 227)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 15,
            ),
            Center(
              child: Container(
                alignment: Alignment.topCenter,
                height: 80,
                width: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  image: DecorationImage(
                    image: NetworkImage(doctorData['imageURL']),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),


            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  //Main text
                  Text(
                   "Dr. "+ doctorData['username'],
                    style: GoogleFonts.poppins(
                        fontSize: 13.sp, fontWeight: FontWeight.bold),
                  ),
                  //Sub text
                  Text(
                    doctorData['specialite'],
                    style: GoogleFonts.poppins(
                        fontSize: 11.sp,
                        color: Colors.black45,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  //Rating star container start from here!!
                  Row(
                    children: [

                      Container(
                        height: MediaQuery.of(context).size.height * 0.01500,
                        width: MediaQuery.of(context).size.width * 0.03,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(
                                "lib/icons/Location.png",
                              ),
                              filterQuality: FilterQuality.high),
                        ),
                      ),
                      Text(
                        doctorData['adress'],
                        style: GoogleFonts.poppins(
                            fontSize: 11.sp,
                            color: Color.fromARGB(255, 133, 133, 133),
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
