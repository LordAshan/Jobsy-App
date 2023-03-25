import 'package:flutter/material.dart';
import 'package:jobsy_v2/Widgets/bottom_nav_bar.dart';

class AllWorkersScreen extends StatefulWidget {

  @override
  State<AllWorkersScreen> createState() => _AllWorkersScreenState();
}

class _AllWorkersScreenState extends State<AllWorkersScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, Colors.white],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          stops: [0.2, 0.9],
        ),
      ),
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBarForApp(indexNum: 1,),
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('All Workers Screen'),
          centerTitle: true,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blueAccent.shade400, Colors.blueAccent.shade400],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                stops: const [0.2, 0.9],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
