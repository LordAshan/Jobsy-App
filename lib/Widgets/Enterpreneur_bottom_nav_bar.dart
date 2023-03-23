import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jobsy_v2/Jobs/Enterpreneur_Home_Page.dart';
import 'package:jobsy_v2/Jobs/Enterpreneur_upload.dart';
import 'package:jobsy_v2/Search/Eprofile.dart';
import 'package:jobsy_v2/Search/Esearch_companies.dart';
import 'package:jobsy_v2/user_state.dart';

class Enterpreneur_BottomNavigationBarForApp extends StatelessWidget {
  int indexNum = 0;

  Enterpreneur_BottomNavigationBarForApp({required this.indexNum});

  void _logout(context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.black54,
            title: Row(
              children: const [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.logout,
                    color: Colors.white,
                    size: 36,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Sign Out',
                    style: TextStyle(color: Colors.white, fontSize: 26),
                  ),
                ),
              ],
            ),
            content: const Text(
              'Do you want to Log Out?',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  //Navigator.canPop(context) ? Navigator.pop(context):null;
                },
                child: const Text(
                  'No',
                  style: TextStyle(color: Colors.green, fontSize: 18),
                ),
              ),
              TextButton(
                onPressed: () {
                  _auth.signOut();
                  //   Navigator.canPop(context) ? Navigator.canPop(context) : null;

                  Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (_) => UserState()));
                },
                child: const Text(
                  'Yes',
                  style: TextStyle(color: Colors.green, fontSize: 18),
                ),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      color: Colors.blueAccent.shade400,
      backgroundColor: Colors.white,
      buttonBackgroundColor: Colors.blueAccent.shade400,
      height: 50,
      index: indexNum,
      items: const [
        
        Icon(
          Icons.home,
          size: 25,
          color: Colors.white,
        ),
        Icon(
          Icons.search,
          size: 25,
          color: Colors.white,
        ),
        Icon(
          Icons.add,
          size: 25,
          color: Colors.white,
        ),
        Icon(
          Icons.person_pin,
          size: 25,
          color: Colors.white,
        ),
        Icon(
          Icons.exit_to_app,
          size: 25,
          color: Colors.white,
        ),
      ],
      animationDuration: const Duration(
        microseconds: 300,
      ),
      animationCurve: Curves.bounceInOut,
      onTap: (index) {
       
        {
          if (index == 0) {

             Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            Enterpreneur_Home_Page()));
          
            // Navigator.pushReplacement(context,
            //     MaterialPageRoute(builder: (_) => Enterpreneur_Home_Page()));
          } else if (index == 1) {
          
            // Navigator.pushReplacement(context,
            //     MaterialPageRoute(builder: (_) => AllEWorkersScreen()));
             Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            AllEWorkersScreen()));
          } else if (index == 2) {
           
            // Navigator.pushReplacement(context,
            //     MaterialPageRoute(builder: (_) => Enterpreneur_Upload_Page()));
             Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            Enterpreneur_Upload_Page()));
          } else if (index == 3) {
            
            // Navigator.pushReplacement(
            //     context, MaterialPageRoute(builder: (_) => EProfile()));
             Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            EProfile()));
          } else if (index == 4) {
           
            _logout(context);
          }
        }
      },
    );
  }
}
