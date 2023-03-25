import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jobsy/Persistent/persistent.dart';
import 'package:jobsy/Services/global_methods.dart';
import 'package:uuid/uuid.dart';

import '../Services/global_variables.dart';
import '../Widgets/bottom_nav_bar.dart';

class UploadProductReqNow extends StatefulWidget {


  @override
  State<UploadProductReqNow> createState() => _UploadProductReqNowState();
}

class _UploadProductReqNowState extends State<UploadProductReqNow> {

  final TextEditingController _productCategoryController = TextEditingController(text: 'Select Product Category');
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _productDescriptionController = TextEditingController();
  final TextEditingController _deadlineController = TextEditingController(text: 'Select Product required Date');


  final _formKey = GlobalKey<FormState>();
  DateTime? picked;
  Timestamp? deadlineDateTimeStamp;

  File? imageFile;
  String? imageUrl;
  bool _isLoading = false;

  @override
  void dispose()
  {
    super.dispose();
    _productCategoryController.dispose();
    _productNameController.dispose();
    _productDescriptionController.dispose();
    _deadlineController.dispose();
  }

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
      setState(()
      {
        imageFile = File(croppedImage.path);
      });
    }
  }

  Widget _textTitles({required String label})
  {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _textFormFields({
  required String valueKey,
  required TextEditingController controller,
  required bool enabled,
  required Function fct,
  required int maxLength,
})
{
  return Padding(
    padding: const EdgeInsets.all(5.0),
    child: InkWell(
      onTap: (){
        fct();
      },
      child: TextFormField(
        validator: (value)
        {
          if(value!.isEmpty)
            {
              return'Value is missing';
            }
          return null;
        },
        controller: controller,
        enabled: enabled,
        key: ValueKey(valueKey),
        style: const TextStyle(
          color: Colors.white,
        ),
        maxLines: valueKey == 'ProductDescription' ? 2 : 1,
        //maxLength: maxLength,
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
          )
        ),
      ),
    ),
  );
}

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
                      _productCategoryController.text = Persistent.productCategoryList[index];
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
                 child: const Text('Cancel', style: TextStyle(
                     color: Colors.white,
                   fontSize: 16,
                 ),
                 ),
               ),
             ],
         );
       }
   );
 }

 void _pickDateDialog() async
 {
   picked = await showDatePicker(
     context: context,
     initialDate: DateTime.now(),
     firstDate: DateTime.now().subtract(
       const Duration(days: 0),
     ),
     lastDate: DateTime(2100),
   );

   if(picked != null)
     {
       setState(()
       {
         _deadlineController.text = '${picked!.year} - ${picked!.month} - ${picked!.day}';
         deadlineDateTimeStamp = Timestamp.fromMicrosecondsSinceEpoch(picked!.microsecondsSinceEpoch);
       });
     }
 }

 void _uploadTask() async
 {
   final productReqId = const Uuid().v4();
   User? user = FirebaseAuth.instance.currentUser;
   final _uid = user!.uid;
   final ref = FirebaseStorage.instance.ref().child('productRequestImages').child(_uid + '.jpg');
   await ref.putFile(imageFile!);
   imageUrl = await ref.getDownloadURL();
   final isValid = _formKey.currentState!.validate();

   if(isValid)
     {
       if(_deadlineController.text == 'Choose product required date' || _productCategoryController.text == 'Choose product category')
       {
         GlobalMethod.showErrorDialog(
           error: 'Please pick everything', ctx: context
         );
         return;
       }
       setState(() {
         _isLoading = true;
       });
       try
       {
         await FirebaseFirestore.instance.collection('productRequests').doc(productReqId).set({
           'productReqId' : productReqId,
           'uploadedBy': _uid,
           'email': user.email,
           'productTitle': _productNameController.text,
           'productDescription' : _productDescriptionController.text,
           'deadlineDate': _deadlineController.text,
           'deadlineDateTimeStamp': deadlineDateTimeStamp,
           'productCategory': _productCategoryController.text,
           'productImage': imageUrl,
           'productComments': [],
           'recruitment': true,
           'createdAt': Timestamp.now(),
           'name': name,
           //'userImage': imageUrl,
           'location': location,
           'applicants': 0,
         });
         await Fluttertoast.showToast(
           msg: 'The product requesting has been uploaded!',
           toastLength: Toast.LENGTH_LONG,
           backgroundColor: Colors.grey,
           fontSize: 18.0,
         );
         _productNameController.clear();
         _productDescriptionController.clear();
         setState(() {
           _productCategoryController.text = 'Choose product category';
           _deadlineController.text = 'Choose product required date';
         });
       }catch(error){
         {
           setState(() {
             _isLoading = false;
           });
           GlobalMethod.showErrorDialog(error: error.toString(), ctx: context);
         }
       }
       finally
       {
         setState(() {
           _isLoading = false;
         });
       }
     }
   else
   {
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
        bottomNavigationBar: BottomNavigationBarForApp(indexNum: 2,),
        backgroundColor: Colors.transparent,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Card(
              color: Colors.white10,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:  [
                    const SizedBox(height: 1,),
                    const Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.all(3.0),
                        child: Text(
                          'Product Requesting',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,

                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 5,),
                    const Divider(
                      thickness: 1,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _textTitles(label: 'Product Category :'),
                            _textFormFields(
                              valueKey: 'ProductCategory',
                              controller: _productCategoryController,
                              enabled: false,
                              fct: (){
                                _showTaskCategoriesDialog(size: size);
                              },
                              maxLength: 100,
                            ),
                            _textTitles(label: 'Product Name'),
                            _textFormFields(
                              valueKey: 'ProductName',
                              controller: _productNameController,
                              enabled: true,
                              fct: (){},
                              maxLength: 100,
                            ),
                            _textTitles(label: 'Product Description'),
                            _textFormFields(
                              valueKey: 'ProductDescription',
                              controller: _productDescriptionController,
                              enabled: true,
                              fct: (){},
                              maxLength: 100,
                            ),
                            _textTitles(label: 'Product Required Date'),
                            _textFormFields(
                              valueKey: 'Deadline',
                              controller: _deadlineController,
                              enabled: false,
                              fct: (){
                                _pickDateDialog();
                              },
                              maxLength: 100,
                            ),
                            _textTitles(label: 'Product Image'),
                            GestureDetector(
                              onTap: ()
                              {
                                _showImageDialog();
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Container(
                                  width: size.width * 0.20,
                                  height: size.width *0.20,
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
                        :MaterialButton(
                          onPressed: (){
                            _uploadTask();
                          },
                          color: Colors.black,
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text(
                                  'Submit',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                      fontSize: 25,
                                  ),
                                ),
                                SizedBox(width: 9,),
                                Icon(
                                  Icons.upload_file,
                                  color: Colors.white,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
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
