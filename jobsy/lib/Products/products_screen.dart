import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jobsy/Search/search_product.dart';
import 'package:jobsy/Widgets/bottom_nav_bar.dart';
import 'package:jobsy/Widgets/product_req_widget.dart';

import '../Persistent/persistent.dart';


class ProductScreen extends StatefulWidget {


  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {

  String? productCategoryFilter;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  _showTaskCategoriesDialog({required Size size})
  {
    showDialog(
        context: context,
        builder: (ctx)
        {
          return AlertDialog(
            backgroundColor: Colors.black54,
            title: const Text(
              'Product Category',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, color: Colors.white),
            ),
            content: Container(
              width: size.width * 0.9,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: Persistent.productCategoryList.length,
                  itemBuilder: (ctx, index)
                  {
                    return InkWell(
                      onTap: (){
                        setState(() {
                          productCategoryFilter = Persistent.productCategoryList[index];
                        });
                        Navigator.canPop(context) ? Navigator.pop(context) : null;
                        print(
                          'productCategoryList[index], ${Persistent.productCategoryList[index]}'
                        );
                      },
                      child: Row(
                        children: [
                          const Icon(
                            Icons.arrow_right_alt_outlined,
                            color: Colors.grey,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              Persistent.productCategoryList[index],
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),

                    );
                  }
              ),
            ),
            actions: [
              TextButton(
                onPressed: ()
                {
                  Navigator.canPop(context) ? Navigator.pop(context) : null;
                },
                child: const Text('Close', style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
                ),
              ),
              TextButton(
                onPressed: ()
                {
                  setState(() {
                    productCategoryFilter = null;
                  });
                  Navigator.canPop(context) ? Navigator.pop(context) : null;
                },
                child: const Text('Cancel Filter', style: TextStyle(color: Colors.white),),
              ),
            ],
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
        bottomNavigationBar: BottomNavigationBarForApp(indexNum: 0),
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.blueAccent.shade400,
                    Colors.blueAccent.shade400],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  stops: const [0.2, 0.9],
                )
            ),
          ),
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(Icons.filter_list_rounded, color: Colors.black,),
            onPressed: (){
              _showTaskCategoriesDialog(size: size);
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search_outlined, color: Colors.black,),
              onPressed: ()
              {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => SearchScreen()));
              },
            ),
          ],
        ),
        body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection('productRequests')
              .where('productCategory', isEqualTo: productCategoryFilter)
              .where('recruitment', isEqualTo: true)
              .orderBy('createdAt', descending: false)
              .snapshots(),
          builder: (context, AsyncSnapshot snapshot)
          {
            if(snapshot.connectionState == ConnectionState.waiting)
              {
                return const Center(child: CircularProgressIndicator(),);
              }
            else if(snapshot.connectionState == ConnectionState.active)
              {
                if(snapshot.data?.docs.isNotEmpty == true)
                {
                  return ListView.builder(
                    itemCount: snapshot.data?.docs.length,
                    itemBuilder: (BuildContext context, int index)
                    {
                      return ProductReqWidget(
                        productCategory: snapshot.data?.docs[index]['productCategory'],
                        productTitle: snapshot.data?.docs[index]['productTitle'],
                        productDescription: snapshot.data?.docs[index]['productDescription'],
                        productReqId: snapshot.data?.docs[index]['productReqId'],
                        uploadedBy: snapshot.data?.docs[index]['uploadedBy'],
                        productImage: snapshot.data?.docs[index]['productImage'],
                        name: snapshot.data?.docs[index]['name'],
                        recruitment: snapshot.data?.docs[index]['recruitment'],
                        email: snapshot.data?.docs[index]['email'],
                        location: snapshot.data?.docs[index]['location'],
                      );
                    }
                  );
                }
                else
                  {
                    return const Center(
                      child: Text('There is no products requests'),
                    );
                  }
              }
            return const Center(
              child: Text(
                'Something went wrong',
                    style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 30
              ),
              ),
            );
          }
        ),

        ),
      );
    //);
  }
}
