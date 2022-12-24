import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tiktok_clone/views/screens/auth/login_screen.dart';
import 'package:tiktok_clone/views/screens/bottom_navigation.dart';
import 'package:uuid/uuid.dart';
import '../models/usermodel.dart';
import 'models/firebase_helper.dart';
var uuid=Uuid();

void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  User? currentuser=FirebaseAuth.instance.currentUser;
  if(currentuser!=null){
    //Logged In
    UserModel? thisUserModel=await FirebaseHelper.getUserModelById(currentuser.email!);
    if(thisUserModel!=null){
      runApp(MyAppLoggedIn(userModel: thisUserModel, firebaseuser: currentuser));
    }
    else{
      runApp(MyApp());
    }
  }
  else{
    runApp(MyApp());
  }
}

//Not Logged In
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: Colors.black
        ),
        home: LoginScreen()
    );
  }
}


//Logged In
class MyAppLoggedIn extends StatelessWidget{
  final UserModel userModel;
  final User firebaseuser;
  MyAppLoggedIn({required this.userModel,required this.firebaseuser});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black
      ),
      home: Bottom(userModel: userModel,firebaseuser: firebaseuser),
    );
  }

}