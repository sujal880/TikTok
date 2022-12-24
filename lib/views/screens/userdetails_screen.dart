import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tiktok_clone/views/screens/bottom_navigation.dart';
import 'package:tiktok_clone/views/widgets/textinputfield.dart';

import '../../models/usermodel.dart';
class UserDetails extends StatefulWidget {
  final UserModel userModel;
  final User firebaseuser;
  UserDetails({required this.userModel,required this.firebaseuser});
  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  TextEditingController nameController=TextEditingController();
  File ? pickedImage;
  void SelectImage(){
    showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
       title: Text("Select Image From"),
       content: Column(
         mainAxisSize: MainAxisSize.min,
         children: [
           ListTile(
             onTap: (){
               pickImage(ImageSource.camera);
             },
             leading: Icon(Icons.camera_alt),
             title: Text("Select From Camera"),
           ),
           ListTile(
             onTap: (){
               pickImage(ImageSource.gallery);
             },
             leading: Icon(Icons.image),
             title: Text("Select From Gallery"),
           ),
         ],
       ),
      );
    });
  }
  void CheckValues(){
    String name=nameController.text.trim();
    if(name=="" || pickedImage==""){
      showDialog(context: context, builder: (BuildContext context){
        return AlertDialog(
         title: Text("Enter Valid Details"),
         actions: [
           TextButton(onPressed: (){
             Navigator.pop(context);
           }, child: Text("Ok"))
         ],
        );
      });
    }
    else{
      UploadData();
    }
  }
  void UploadData()async{
    UploadTask uploadTask=FirebaseStorage.instance.ref("profilepictures").child(widget.userModel.email.toString()).putFile(pickedImage!);
    TaskSnapshot snapshot=await uploadTask;
    String ? imageUrl=await snapshot.ref.getDownloadURL();
    String ? name=nameController.text.trim();
    widget.userModel.fullname=name;
    widget.userModel.profilepic=imageUrl;
    log(name);
    FirebaseFirestore.instance.collection("users").doc(widget.userModel.email).set(widget.userModel.toMap()).then((value) => log("Data Uploaded"));
    Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>Bottom(userModel: widget.userModel,firebaseuser: widget.firebaseuser)));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: (){
              SelectImage();
            },
            child: pickedImage!=null ?
            CircleAvatar(
              radius: 80,
              backgroundImage: FileImage(pickedImage!),
              backgroundColor: Colors.white,
            ) : Icon(Icons.person,size: 70,color: Colors.white)
          ),
          SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: TextInputField(controller: nameController, myIcon: Icon(Icons.person,size: 40), mylabelText: "Full Name", tohide: false),
          ),
          SizedBox(height: 40),
          SizedBox(height: 45,
          width: 200,
            child: ElevatedButton(onPressed: (){
              CheckValues();
            }, child: Text("Submit")),
          )
        ],
      ),
    );
  }
  pickImage(ImageSource imageSource)async{
    try{
      final photo=await ImagePicker().pickImage(source: imageSource);
      if(photo==null)return;
      final tempimage=File(photo.path);
      setState(() {
        pickedImage=tempimage;
      });
    }catch(ex){
      log(ex.toString());
    }
  }
}
