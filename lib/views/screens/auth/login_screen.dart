import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tiktok_clone/models/usermodel.dart';
import 'package:tiktok_clone/views/screens/auth/sign_up_screen.dart';
import 'package:tiktok_clone/views/screens/bottom_navigation.dart';
import 'package:tiktok_clone/views/widgets/glitch.dart';
import '../../widgets/textinputfield.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginAuthState();
}

class _LoginAuthState extends State<LoginScreen> {
  TextEditingController emailController=TextEditingController();
  TextEditingController passwordController=TextEditingController();

  void CheckValues()async{
    String email=emailController.text.trim();
    String password=passwordController.text.trim();
    emailController.clear();
    passwordController.clear();
    if(email=="" || password==""){
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
      UserCredential ? usercredential;
      try{
        usercredential=await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
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
      if(usercredential!=null){
        String uid=usercredential.user!.uid;
        DocumentSnapshot documentSnapshot=await FirebaseFirestore.instance.collection("users").doc(email).get();
        UserModel userModel=UserModel.fromMap(documentSnapshot.data() as Map<String,dynamic>);
        log("Logged In");
        Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>Bottom(userModel: userModel, firebaseuser:usercredential!.user! )));
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GlithEffect(child: Text("TikTok Clone",style: TextStyle(fontSize: 30,fontWeight: FontWeight.w900),)),
            SizedBox(height: 25),
            Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: TextInputField(controller: emailController,tohide: false,myIcon: Icon(Icons.mail),mylabelText: "Email",)),
            SizedBox(height: 20),
            Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: TextInputField(controller: passwordController,tohide: true,myIcon: Icon(Icons.lock),mylabelText: "Password",)),
            SizedBox(height: 30),
            ElevatedButton(onPressed: (){
              CheckValues();
            }, child: Container(
                height: 40,
                width: 80,
                child: Center(child: Text("Login",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),)))),
            TextButton(onPressed: (){
              Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>SignUpScreen()));
            }, child: Text("New User Sign Up?",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold)))
          ],
        )
      ),
    );
  }
}
