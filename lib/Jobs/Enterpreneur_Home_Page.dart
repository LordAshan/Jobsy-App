import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jobsy_v2/Search/search_job.dart';
import 'package:jobsy_v2/Widgets/Enterpreneur_bottom_nav_bar.dart';
//import 'package:jobsy_v2/Widgets/job_widget.dart';
import 'package:jobsy_v2/Jobs/Enterpreneur_Home_Page.dart';
import 'package:jobsy_v2/Widgets/product_widget.dart';

import '../Persistent/persistent.dart';

class Enterpreneur_Home_Page extends StatefulWidget {
  @override
  State<Enterpreneur_Home_Page> createState() => _Enterpreneur_Home_PageState();
}

class _Enterpreneur_Home_PageState extends State<Enterpreneur_Home_Page> {
  String? productCategoryFilter;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  _showTaskCategoriesDialog({required Size size}) {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            backgroundColor: Colors.black54,
            title: const Text(
              'Product Category',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            content: Container(
              width: size.width * 0.9,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: Persistent01.ProductCategoryList.length,
                  itemBuilder: (ctx, index) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          productCategoryFilter =
                              Persistent01.ProductCategoryList[index];
                        });
                        //--------------------------------------------------------------------------------------------------------------
                              Navigator.canPop(context) ? Navigator.pop(context) : null;
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) =>
                        //             Enterpreneur_Home_Page()));
                        print(
                            'productCategoryList[index], ${Persistent01.ProductCategoryList[index]}');
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
                              Persistent01.ProductCategoryList[index],
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Enterpreneur_Home_Page()));

                  //   Navigator.canPop(context) ? Navigator.pop(context) : null;
                },
                child: const Text(
                  'Close',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    productCategoryFilter = null;
                  });
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Enterpreneur_Home_Page()));
                  // Navigator.canPop(context) ? Navigator.pop(context) : null;
                },
                child: const Text(
                  'Cancel Filter',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          );
        });
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
          bottomNavigationBar:
              Enterpreneur_BottomNavigationBarForApp(indexNum: 0),
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.blueAccent.shade400,
                    Colors.blueAccent.shade400
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  stops: const [0.2, 0.9],
                ),
              ),
            ),
            automaticallyImplyLeading: false,
            leading: IconButton(
              icon: const Icon(
                Icons.filter_list_rounded,
                color: Colors.white,
              ),
              onPressed: () {
                _showTaskCategoriesDialog(size: size);
              },
            ),
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.search_outlined,
                  color: Colors.white,
                ),
                onPressed: () {
                  //  Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => SearchScreen()));
                },
              ),
            ],
          ),
          body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection('Products')
                  .where('ProcuctCategory', isEqualTo: productCategoryFilter)
                  .where('recruitment', isEqualTo: true)
                  .orderBy('createdAt', descending: false)
                  .snapshots(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.data?.docs.isNotEmpty == true) {
                    return ListView.builder(
                        itemCount: snapshot.data?.docs.length,
                        itemBuilder: (BuildContext context, int index) {
                          return productWidget(
                            ProductId: snapshot.data?.docs[index]['ProductId'],
                            ProductuploadedBy: snapshot.data?.docs[index]
                                ['ProductuploadedBy'],
                            email: snapshot.data?.docs[index]['email'],
                            ProductName: snapshot.data?.docs[index]
                                ['ProductName'],
                            ProcuctCategory: snapshot.data?.docs[index]
                                ['ProcuctCategory'],
                            UnitPrice: snapshot.data?.docs[index]['UnitPrice'],
                            SellerName: snapshot.data?.docs[index]
                                ['SellerName'],
                            ContactNumber: snapshot.data?.docs[index]
                                ['ContactNumber'],
                            ProductDescription: snapshot.data?.docs[index]
                                ['ProductDescription'],
                            productImage: snapshot.data?.docs[index]['productImage'],
                            recruitment: snapshot.data?.docs[index]['recruitment'],
                          );
                        });
                  } else {
                    return const Center(
                      child: Text('There is no Product'),
                    );
                  }
                }
                return const Center(
                  child: Text(
                    'Something went wrong',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                );
              })),
    );
  }
}
