// ignore_for_file: unused_import

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jobsy_v2/Jobs/Enterpreneur_Home_Page.dart';
import 'package:jobsy_v2/Persistent/persistent.dart';
import 'package:jobsy_v2/Services/global_methods.dart';
import 'package:uuid/uuid.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/gestures.dart';

import '../Services/global_variables.dart';
import '../Widgets/Enterpreneur_bottom_nav_bar.dart';

class Enterpreneur_Upload_Page extends StatefulWidget {
  @override
  State<Enterpreneur_Upload_Page> createState() =>
      _Enterpreneur_Upload_PageState();
}

class _Enterpreneur_Upload_PageState extends State<Enterpreneur_Upload_Page> {
  // late Animation<double> _animation;
  // late AnimationController _animationController;

  final TextEditingController _ProductCategoryController =
      TextEditingController(text: 'Select Product Category');
  final TextEditingController _ProductNameController = TextEditingController();
  final TextEditingController _UnitPriceController = TextEditingController();
  final TextEditingController _SellerNameController = TextEditingController();
  final TextEditingController _ContactNumberController =
      TextEditingController();
  final TextEditingController _productDescriptionController =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();
  //bool _isLoading = false;

  final _signUpFormKey = GlobalKey<FormState>();
  bool _obscureText = true;
  File? imageFile;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  String? imageUrl;

  @override
  void dispose() {
    super.dispose();
    _ProductCategoryController.dispose();
    _ProductNameController.dispose();
    _UnitPriceController.dispose();
    _SellerNameController.dispose();
    _ContactNumberController.dispose();
    _productDescriptionController.dispose();

   // _animationController.dispose();
    super.dispose();
  }
//--------------------------------------------------------------------
//  @override
//   void initState() {
//     _animationController = AnimationController(vsync: this, duration: const Duration(seconds: 60));
//     _animation = CurvedAnimation(parent: _animationController, curve: Curves.linear)
//       ..addListener(() {
//         setState(() {

//         });
//       })
//       ..addStatusListener((animationStatus) {
//         if(animationStatus == AnimationStatus.completed)
//         {
//           _animationController.reset();
//           _animationController.forward();
//         }
//       });
//     _animationController.forward();
//     super.initState();
//   }
 void _showImageDialog()
  {
    showDialog(
      context: context,
      builder: (context)
        {
          return AlertDialog(
            title: const Text('Please choose an option'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: (){
                    _getFromCamera();
                  },
                  child: Row(
                    children: const [
                      Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Icon(
                          Icons.camera,
                          color: Colors.purple,
                        ),
                      ),
                      Text(
                        'Camera',
                         style: TextStyle(color: Colors.purple),
                      )
                    ],
                  ),
                ),
                InkWell(
                  onTap: (){
                    _getFromGallery();
                  },
                  child: Row(
                    children: const [
                      Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Icon(
                          Icons.image,
                          color: Colors.purple,
                        ),
                      ),
                      Text(
                        'Gallery',
                        style: TextStyle(color: Colors.purple),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        }
    );
  }

  void _getFromCamera() async
  {
    XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
    _cropImage(pickedFile!.path);
    Navigator.pop(context);
  }
  void _getFromGallery() async
  {
    XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    _cropImage(pickedFile!.path);
    Navigator.pop(context);
  }

  void _cropImage(filePath) async
  {
    CroppedFile? croppedImage = await ImageCropper().cropImage(
        sourcePath: filePath, maxHeight: 1080, maxWidth: 1080
    );

    if(croppedImage != null)
      {
        setState(() {
          imageFile = File(croppedImage.path);
        });
      }
  }

  Widget _textTitles({required String label}) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
//-------------------------------------------------------------------
  Widget _textFormFields({
    required String valueKey,
    required TextEditingController controller,
    required bool enabled,
    required Function fct,
    required int maxLength,
  }) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: InkWell(
        onTap: () {
          fct();
        },
        child: TextFormField(
          validator: (value) {
            if (value!.isEmpty) {
              return 'Value is missing';
            }
            return null;
          },
          controller: controller,
          enabled: enabled,
          key: ValueKey(valueKey),
          style: const TextStyle(
            color: Colors.white,
          ),
          maxLines: valueKey == 'ProductDescription' ? 3 : 1,
          maxLength: maxLength,
          keyboardType: TextInputType.text,
          decoration: const InputDecoration(
              filled: true,
              fillColor: Colors.black54,
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
              errorBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
              )),
        ),
      ),
    );
  }

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
                          _ProductCategoryController.text =
                              Persistent01.ProductCategoryList[index];
                        });
                        Navigator.pop(context);
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
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          );
        });
  }

  void _uploadTask() async {
    final ProductId = const Uuid().v4();
    User? user = FirebaseAuth.instance.currentUser;
    final _uid = user!.uid;
    final ref = FirebaseStorage.instance.ref().child('ProductImages').child(_uid + '.jpg');
              await ref.putFile(imageFile!);
              imageUrl = await ref.getDownloadURL();
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      if(imageFile == null)
        {
          GlobalMethod.showErrorDialog(
              error: 'Please pick an image',
              ctx: context,
          );
          return;
        }
      if (_ProductCategoryController.text == 'Choose Product Category') {
        GlobalMethod.showErrorDialog(
            error: 'Please pick everything', ctx: context);
        return;
      }
      setState(() {
        _isLoading = true;
      });
      try {
        await FirebaseFirestore.instance
            .collection('Product')
            .doc(ProductId)
            .set({
          'ProductId': ProductId,
          'ProductuploadedBy': _uid,
          'email': user.email,
          'ProductName': _ProductNameController.text,
          'ProcuctCategory': _ProductCategoryController.text,
          'UnitPrice': _UnitPriceController.text,
          'SellerName': _SellerNameController.text,
          'ContactNumber': _ContactNumberController.text,
          'ProductDescription': _productDescriptionController.text,
          'recruitment': true,
          'createdAt': Timestamp.now(),
          'name': name,
          'userImage': imageUrl,
          'applicants': 0,
        });
        await Fluttertoast.showToast(
          msg: 'The task has been uploaded',
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.grey,
          fontSize: 18.0,
        );
        _ProductNameController.clear();
        _UnitPriceController.clear();
        _SellerNameController.clear();
        _ContactNumberController.clear();
        _productDescriptionController.clear();
        setState(() {
          _ProductCategoryController.text = 'Choose Product Category';
        });
      } catch (error) {
        setState(() {
          _isLoading = false;
        });
        GlobalMethod.showErrorDialog(error: error.toString(), ctx: context);
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      print('Its not valid');
    }
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
        bottomNavigationBar: Enterpreneur_BottomNavigationBarForApp(
          indexNum: 2,
        ),
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Upload Product Now'),
          centerTitle: true,
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
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(7.0),
            
            child: Card(
              color: Colors.white10,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    const Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Please fill all fields',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 25,
                            //fontWeight: FontWeight.bold,
                            //fontFamily: 'Signatra',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Divider(
                      thickness: 1,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // CachedNetworkImage(
                            //      imageUrl: signUpUrlImage,
                            //      placeholder: (context, url) => Image.asset(
                            //      'assets/images/wallpaper.jpg',
                            //      fit: BoxFit.fill,
                            //       ),
                            //     errorWidget: (context,url, error) => const Icon(Icons.error),
                            //     width: double.infinity,
                            //     height: double.infinity,
                            //     fit: BoxFit.cover,
                            //    alignment: FractionalOffset(_animation.value, 0),
                            //   ),
                         
                            _textTitles(label: 'Product Category :'),
                            _textFormFields(
                              valueKey: 'ProcuctCategory',
                              controller: _ProductCategoryController,
                              enabled: false,
                              fct: () {
                                _showTaskCategoriesDialog(size: size);
                              },
                              maxLength: 100,
                            ),
                            _textTitles(label: 'Product Name : '),
                            _textFormFields(
                              valueKey: 'ProductName',
                              controller: _ProductNameController,
                              enabled: true,
                              fct: () {},
                              maxLength: 50,
                            ),
                            _textTitles(label: 'Unit Price : '),
                            _textFormFields(
                              valueKey: 'UnitPrice',
                              controller: _UnitPriceController,
                              enabled: true,
                              fct: () {},
                              maxLength: 50,
                            ),
                            _textTitles(label: 'Seller Name : '),
                            _textFormFields(
                              valueKey: 'SellerName',
                              controller: _SellerNameController,
                              enabled: true,
                              fct: () {},
                              maxLength: 50,
                            ),
                            _textTitles(label: 'Contact Number : '),
                            _textFormFields(
                              valueKey: 'ContactNumber',
                              controller: _ContactNumberController,
                              enabled: true,
                              fct: () {},
                              maxLength: 50,
                            ),
                            _textTitles(label: 'Product Description : '),
                            _textFormFields(
                              valueKey: 'ProductDescription',
                              controller: _productDescriptionController,
                              enabled: true,
                              fct: () {},
                              maxLength: 100,
                            ),
                                 GestureDetector(
                                  
                          onTap: ()
                          {
                            _showImageDialog();
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 135, right: 80),
                            child: Container(
                              //padding: const EdgeInsets.all(10.0),
                              width: size.width * 0.24,
                              height: size.width * 0.24,
                              decoration: BoxDecoration(
                                border: Border.all(width: 1, color: Colors.cyanAccent,),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: ClipRRect(
                                
                                borderRadius: BorderRadius.circular(16),
                                child: imageFile == null
                                  ? const Icon(Icons.camera_enhance_sharp, color: Colors.cyan, size: 30,)
                                  : Image.file(imageFile!, fit: BoxFit.fill,),
                              ),
                            ),
                          ),
                        ),
                          ],
                        ),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 30),
                        child: _isLoading
                            ? const CircularProgressIndicator()
                            : MaterialButton(
                                onPressed: () {
                                  _uploadTask();
                                },
                                color: Colors.black,
                                elevation: 8,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(13),
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 14),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Text(
                                        'Submit',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 9,
                                      ),
                                      Icon(
                                        Icons.upload_file,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
