import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tiktok_clone/views/screens/messages_screen.dart';
import 'package:tiktok_clone/views/screens/profile_screen.dart';
import 'package:tiktok_clone/views/screens/search_screen.dart';
import 'package:tiktok_clone/views/screens/uplaod_video.dart';

import '../../models/usermodel.dart';
import '../widgets/customaddicon.dart';
import 'homescreen.dart';
class Bottom extends StatefulWidget {
  final UserModel userModel;
  final User firebaseuser;
  Bottom({required this.userModel,required this.firebaseuser});
  @override
  State<Bottom> createState() => _BottomScreenState();
}

class _BottomScreenState extends State<Bottom> {
  int pageIdx = 0;
  @override
  Widget build(BuildContext context) {
    var pageindex=[
      HomeScreen(),
      SearchScreen(),
      UploadVideo(userModel: widget.userModel,firebaseuser: widget.firebaseuser),
      Messages(),
      ProfileScreen()
    ];
    return Scaffold(

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,
        onTap: (index){
          setState(() {
            pageIdx = index;
          });
        },
        currentIndex: pageIdx,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home, size: 25),
              label: 'Home'

          ),

          BottomNavigationBarItem(
              icon: Icon(Icons.search, size: 25),
              label: 'Search'

          ),

          BottomNavigationBarItem(
              icon: CustomAddIcon(),
              label: ''

          ),

          BottomNavigationBarItem(
              icon: Icon(Icons.message, size: 25),
              label: 'Messages'

          ),

          BottomNavigationBarItem(
              icon: Icon(Icons.person, size: 25),
              label: 'Profile'

          ),
        ],
      ),
      body: Center(
        child: pageindex[pageIdx],
      ),
    );
  }
}