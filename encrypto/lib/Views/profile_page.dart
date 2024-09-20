import 'package:app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: CyberpunkColors.oxfordBlue,
      body: Container(
        height: screenHeight,
        width: screenWidth,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 100,
              width: 200,
              decoration: const BoxDecoration(
                  color: CyberpunkColors.fluorescentCyan,
                  shape: BoxShape.circle),
            ),
            const SizedBox(
              height: 3,
            ),
            Text(
              'Dhruv Jain',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w900),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              "dhruvjainz",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [Text('500',style: TextStyle(color: Colors.white, fontSize: 18,fontWeight: FontWeight.w600)), Text('Connextions',style: TextStyle(color: Colors.white, fontSize: 18,fontWeight: FontWeight.w600))],
                ),
                const SizedBox(width: 30,),
                Column(
                  children: [Text('2019',style: TextStyle(color: Colors.white, fontSize: 18,fontWeight: FontWeight.w600)), Text("Joined",style: TextStyle(color: Colors.white, fontSize: 18,fontWeight: FontWeight.w600))],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
