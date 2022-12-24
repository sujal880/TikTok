import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tiktok_clone/views/screens/add_caption_screen.dart';

import '../../models/usermodel.dart';
class UploadVideo extends StatefulWidget {
  final UserModel userModel;
  final User firebaseuser;
  UploadVideo({required this.userModel,required this.firebaseuser});
  @override
  State<UploadVideo> createState() => _UploadVideoState();
}

class _UploadVideoState extends State<UploadVideo> {
  void pickVideo(ImageSource imageSource)async{
    final video=await ImagePicker().pickVideo(source: imageSource);
    if(video!=null){
      Get.snackbar("Video Selected",video.path);
    Navigator.push(context,MaterialPageRoute(builder: (context)=>AddCaption(videoFile: File(video.path), videopath: video.path, userModel: widget.userModel,firebaseuser: widget.firebaseuser)));
    }
    else{
      Get.snackbar("Error", "Please Choose another Video");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Center(child: GestureDetector(onTap:()=>showDialog(context: context, builder:(BuildContext context){
          return AlertDialog(
            title: Text("Select Video From"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  onTap: (){
                    pickVideo(ImageSource.camera);
                  },
                  leading: Icon(Icons.camera_alt),
                  title: Text("Camera"),
                ),
                ListTile(
                  onTap: (){
                    pickVideo(ImageSource.gallery);
                  },
                  leading: Icon(Icons.image),
                  title: Text("Gallery"),
                ),
              ],
            ),
          );
        }),
        child: Container(
          height: 40,
          width: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.red
          ),
          child: Center(child: Text("Add Video",style: TextStyle(fontSize: 15,color: Colors.white,fontWeight: FontWeight.bold),)),
        ),
        ),),
      ),
    );
  }
}
