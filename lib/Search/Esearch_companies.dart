import 'package:flutter/material.dart';
import 'package:jobsy_v2/Widgets/Enterpreneur_bottom_nav_bar.dart';

class AllEWorkersScreen extends StatefulWidget {

  @override
  State<AllEWorkersScreen> createState() => _AllEWorkersScreenState();
}

class _AllEWorkersScreenState extends State<AllEWorkersScreen> {
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
        bottomNavigationBar: Enterpreneur_BottomNavigationBarForApp(indexNum: 1,),
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('All E Workers Screen'),
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
