import 'package:app/Views/encryption_page.dart';
import 'package:app/Views/profile_page.dart';
import 'package:app/utils/colors.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<Widget> screens = const [
      EncrytionPage(),ProfilePage()
    ];
    int selected_index = 0;
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: CyberpunkColors.oxfordBlue,
      body:screens[selected_index],
      bottomNavigationBar: Container(
        height: 70,
        width: screenWidth,
        // margin: EdgeInsets.only(bottom: 20),

        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(25),topRight: Radius.circular(25)),
                  color: CyberpunkColors.darkViolet,
        //   gradient: LinearGradient(
        //     colors: [
        //       CyberpunkColors.zaffre,
        //       CyberpunkColors.oxfordBlue
        //     ],
        //     begin: Alignment.topCenter,
        //     end: Alignment.bottomCenter
        //   ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(onPressed: (){
              setState(() {
                selected_index = 0;
              });
            }, icon: const Icon(Icons.select_all_rounded,size: 40,color: Colors.white,)),
                        IconButton(onPressed: (){
setState(() {
                            selected_index = 1;
});
                        }, icon: const Icon(Icons.person,size: 40,color: Colors.white,))

          ],
        ),
      ),
    );
  }
}
