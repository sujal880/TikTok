import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tiktok_clone/views/screens/userdetails_screen.dart';
import 'package:tiktok_clone/views/widgets/textinputfield.dart';

import '../../../models/usermodel.dart';
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController emailController=TextEditingController();
  TextEditingController passwordController=TextEditingController();
  TextEditingController phoneController=TextEditingController();
  void CheckValues()async{
    String email=emailController.text.trim();
    String password=passwordController.text.trim();
    String phone=phoneController.text.trim();
    emailController.clear();
    passwordController.clear();
    phoneController.clear();
    if(email=="" || password=="" || phone==""){
      showDialog(context: context, builder:(BuildContext context){
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
      UserCredential ? userCredential;
      try{
        userCredential=await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      }on FirebaseAuthException catch(ex){
        showDialog(context: context, builder:(BuildContext context){
          return AlertDialog(
            title: Text(ex.code.toString()),
            actions: [
              TextButton(onPressed: (){
                Navigator.pop(context);
              }, child: Text("Ok"))
            ],
          );
        });
      }
      if(userCredential!=null){
        String uid=userCredential.user!.uid;
        UserModel newuser=UserModel(uid: uid, fullname: "", profilepic:"", email: email,phone: phone,caption: "",reel: "",song: "");
        FirebaseFirestore.instance.collection("users").doc(email).set(newuser.toMap()).then((value) => log("User Created"));
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>UserDetails(userModel: newuser, firebaseuser: userCredential!.user!)));
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: Text("Welcome To TikTok",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30),)),
          SizedBox(height: 20),
          SizedBox(height: 25),
          Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: TextInputField(controller: emailController, myIcon: Icon(Icons.mail,size: 30), mylabelText: "Email", tohide: false)),
          SizedBox(height: 20),
          Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: TextInputField(controller: passwordController, myIcon: Icon(Icons.key,size: 30), mylabelText: "Password", tohide: true)),
          SizedBox(height: 20),
          Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: TextInputField(controller: phoneController, myIcon: Icon(Icons.phone,size: 30), mylabelText: "Phone", tohide: false)),
          SizedBox(height: 20),
          ElevatedButton(onPressed: (){
            CheckValues();
          }, child: Container(
              width: 80,
              child: Center(child: Text("Sign Up"))))

        ],
      ),
    );
  }

}
