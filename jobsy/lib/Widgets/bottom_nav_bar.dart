import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jobsy/Products/products_screen.dart';
import 'package:jobsy/Products/upload_product_request.dart';
import 'package:jobsy/Search/profile_buyer.dart';
import 'package:jobsy/Search/search_products.dart';
import 'package:jobsy/user_state.dart';

class BottomNavigationBarForApp extends StatelessWidget {

  int indexNum = 0;

  BottomNavigationBarForApp({required this.indexNum});

  void _logout(context)
  {
    final FirebaseAuth _auth = FirebaseAuth.instance;

    showDialog(
      context: context,
      builder: (context)
      {
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
                  style: TextStyle(color: Colors.white, fontSize: 28),
                ),
              ),
            ],
          ),
          content: const Text(
            'Do you want to Log Out?',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          actions: [
            TextButton(
              onPressed: (){
                Navigator.canPop(context) ? Navigator.pop(context) : null;
              },
              child: const Text('No', style: TextStyle(color: Colors.green, fontSize: 18),),
            ),
            TextButton(
              onPressed: (){
                _auth.signOut();
                Navigator.canPop(context) ? Navigator.pop(context) : null;
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => UserState()));
              },
              child: const Text('Yes', style: TextStyle(color: Colors.red, fontSize: 18),),
            ),
          ],
        );
      }
    );
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
        Icon(Icons.list, size: 19, color: Colors.white,),
        Icon(Icons.search, size: 19, color: Colors.white,),
        Icon(Icons.add, size: 19, color: Colors.white,),
        Icon(Icons.person_pin, size: 19, color: Colors.white,),
        Icon(Icons.exit_to_app, size: 19, color: Colors.white,),

      ],
      animationDuration: const Duration(
        milliseconds: 300,
      ),
      animationCurve: Curves.bounceInOut,
      onTap: (index)
      {
        if(index == 0)
          {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ProductScreen()));
          }
        else if(index == 1)
          {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => AllProductsScreen()));
          }
        else if(index == 2)
        {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => UploadProductReqNow()));
        }
        else if(index == 3)
        {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ProfileScreen()));
        }
        else if(index == 4)
        {
          _logout(context);
        }
      },
    );
  }
}
