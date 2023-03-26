// ignore_for_file: non_constant_identifier_names, camel_case_types, use_key_in_widget_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jobsy_v2/Jobs/Enterpreneur_Home_Page.dart';
import 'package:jobsy_v2/Jobs/product_details.dart';
//import 'package:jobsy_v2/Jobs/job_details.dart';
import 'package:jobsy_v2/Services/global_methods.dart';

class productWidget extends StatefulWidget {
  final String ProductId;
  final String ProductuploadedBy;
  final String email;
  final String ProductName;
  final String ProcuctCategory;
  final String UnitPrice;
  final bool recruitment;
  final String SellerName;
  final String ContactNumber;
  final String ProductDescription;
  final String productImage;

  const productWidget({
    required this.ProductId,
    required this.ProductuploadedBy,
    required this.email,
    required this.ProductName,
    required this.ProcuctCategory,
    required this.UnitPrice,
    required this.recruitment,
    required this.SellerName,
    required this.ContactNumber,
    required this.ProductDescription,
    required this.productImage,
  });

  @override
  State<productWidget> createState() => _productWidgetState();
}

class _productWidgetState extends State<productWidget> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  _deleteDialog() {
    User? user = _auth.currentUser;
    // ignore: no_leading_underscores_for_local_identifiers
    final _uid = user!.uid;
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            actions: [
              TextButton(
                onPressed: () async {
                  try {
                    if (widget.ProductuploadedBy == _uid) {
                      await FirebaseFirestore.instance
                          .collection('Products')
                          .doc(widget.ProductId)
                          .delete();
                      await Fluttertoast.showToast(
                        msg: 'Product has been deleted',
                        toastLength: Toast.LENGTH_LONG,
                        backgroundColor: Colors.grey,
                        fontSize: 18.0,
                      );
                      //  Navigator.canPop(context) ? Navigator.pop(context) : null;
                      // ignore: use_build_context_synchronously
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Enterpreneur_Home_Page()));
                    } else {
                      GlobalMethod.showErrorDialog(
                          error: 'You cannot perform this action', ctx: ctx);
                    }
                  } catch (error) {
                    //GlobalMethod.showErrorDialog(
                        //error: 'This task cannot be deleted', ctx: ctx);
                  } finally {}
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    Text(
                      'Delete',
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white24,
      elevation: 8,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: ListTile(
        onTap: () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => productDetailsScreen(
                        //------------------------------------------------------------------------------------------------------------------------
                        ProductuploadedBy: widget.ProductuploadedBy,
                        ProductId: widget.ProductId,
                      )));
        },
        onLongPress: () {
          _deleteDialog();
        },
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        leading: Container(
          padding: const EdgeInsets.only(right: 12),
          decoration: const BoxDecoration(
              border: Border(
            right: BorderSide(width: 1),
          )),
          child: Image.network(widget.productImage),
        ),
        title: Text(
          widget.ProductName,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.blueAccent,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              widget.UnitPrice,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              widget.SellerName,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              widget.ContactNumber,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              widget.ProductDescription,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 15,
              ),
            ),
          ],
        ),
        trailing: const Icon(
          Icons.keyboard_arrow_right,
          size: 30,
          color: Colors.black,
        ),
      ),
    );
  }
}
