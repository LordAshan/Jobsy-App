import 'package:flutter/material.dart';

import '../Widgets/bottom_nav_bar.dart';

class ProfileScreen extends StatefulWidget {


  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, Colors.white],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          stops: const [0.2, 0.9],
        ),
      ),
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBarForApp(indexNum: 3,),
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Profile Screen'),
          centerTitle: true,
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.white, Colors.white],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  stops: const [0.2, 0.9],
                )
            ),
          ),
        ),
      ),
    );
  }
}
