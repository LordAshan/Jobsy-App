import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jobsy_v2/Jobs/Enterpreneur_Home_Page.dart';
import 'package:jobsy_v2/Services/global_methods.dart';

class productDetailsScreen extends StatefulWidget {
  final String ProductuploadedBy;
  final String ProductId;

  const productDetailsScreen({
    required this.ProductuploadedBy,
    required this.ProductId,
  });

  @override
  State<productDetailsScreen> createState() => _productDetailsScreenState();
}

class _productDetailsScreenState extends State<productDetailsScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? authorName;
  String? userImageUrl;
  String? ProcuctCategory;
  String? ProductDescription;
  String? ProductName;
  String? SellerName;
  String? ContactNumber;
  String? UnitPrice;
  bool? recruitment;
  Timestamp? postedDateTimeStamp;
  String? postedDate;
  String? emailSeller = '';
  int applicants = 0;
  //bool isDeadlineAvailable = false;

  void getproductData() async {
    // final DocumentSnapshot userDoc = await FirebaseFirestore.instance
    //     .collection('users')
    //     .doc(widget.ProductuploadedBy)
    //     .get();

    // if (userDoc == null) {
    //   return;
    // } else {
    //   setState(() {
    //     //authorName = userDoc.get('name');
    //     userImageUrl = userDoc.get('userImage');
    //   });
    // }
    final DocumentSnapshot productDatabase = await FirebaseFirestore.instance
        .collection('Products')
        .doc(widget.ProductId)
        .get();
    if (productDatabase == null) {
      return;
    } else {
      setState(() {
        ProcuctCategory = productDatabase.get('ProcuctCategory');
        ProductDescription = productDatabase.get('ProductDescription');
        recruitment = productDatabase.get('recruitment');
        ProductName = productDatabase.get('ProductName');
        SellerName = productDatabase.get('SellerName');
        ContactNumber = productDatabase.get('ContactNumber');
        UnitPrice = productDatabase.get('UnitPrice');
        emailSeller = productDatabase.get('email');
        applicants = productDatabase.get('applicants');
        postedDateTimeStamp = productDatabase.get('createdAt');
        userImageUrl = productDatabase.get('productImage');
        var postDate = postedDateTimeStamp!.toDate();
        postedDate = '${postDate.year}-${postDate.month}-${postDate.day}';
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getproductData();
  }

  Widget dividerWidget() {
    return Column(
      children: const [
        SizedBox(
          height: 10,
        ),
        Divider(
          thickness: 1,
          color: Colors.grey,
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }

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
          leading: IconButton(
              icon: const Icon(
                Icons.close,
                size: 40,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => Enterpreneur_Home_Page()));
              }),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Card(
                  color: Colors.black54,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: Text(
                            ProductName == null ? '' : ProductName!,
                            maxLines: 3,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 3,
                                  color: Colors.grey,
                                ),
                                shape: BoxShape.rectangle,
                                image: DecorationImage(
                                  image: NetworkImage(
                                    userImageUrl == null
                                        ? ''
                                        : userImageUrl!,
                                  ),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    SellerName == null ? '' : SellerName!,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    UnitPrice == null ? '' : UnitPrice!,
                                   // UnitPrice!,
                                    style: const TextStyle(
                                       fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        dividerWidget(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              applicants.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(
                              width: 6,
                            ),
                            const Text(
                              'Orders',
                              style: TextStyle(color: Colors.grey),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Icon(
                              Icons.book,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                        FirebaseAuth.instance.currentUser!.uid != widget.ProductuploadedBy
                            ? Container()
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  dividerWidget(),
                                  const Text(
                                    'Product Status',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          User? user = _auth.currentUser;
                                          final _uid = user!.uid;
                                          if (_uid == widget.ProductuploadedBy) {
                                            try {
                                              FirebaseFirestore.instance
                                                  .collection('Products')
                                                  .doc(widget.ProductId)
                                                  .update(
                                                      {'recruitment': true});
                                            } catch (error) {
                                              GlobalMethod.showErrorDialog(
                                                error:
                                                    'Action cannot be perform',
                                                ctx: context,
                                              );
                                            }
                                          } else {
                                            GlobalMethod.showErrorDialog(
                                              error:
                                                  'You cannot perform this action',
                                              ctx: context,
                                            );
                                          }
                                          getproductData();
                                        },
                                        child: const Text(
                                          'Availability',
                                          style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            color: Colors.black,
                                            fontSize: 18,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                      Opacity(
                                        opacity: recruitment == true ? 1 : 0,
                                        child: const Icon(
                                          Icons.check_box,
                                          color: Colors.green,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
