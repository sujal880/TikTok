import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/views/widgets/textinputfield.dart';
import 'package:video_player/video_player.dart';

import '../../models/usermodel.dart';
class AddCaption extends StatefulWidget {
  final UserModel userModel;
  final User firebaseuser;
  File ? videoFile;
  String? videopath;
  AddCaption({required this.videoFile,required this.videopath,required this.userModel,required this.firebaseuser});

  @override
  State<AddCaption> createState() => _AddCaptionState();
}

class _AddCaptionState extends State<AddCaption> {
  late VideoPlayerController videoPlayerController;
  TextEditingController SongController=TextEditingController();
  TextEditingController CaptionController=TextEditingController();
  File ? pickedImage;

  void CheckValues()async{
    String song=SongController.text.trim();
    String caption=CaptionController.text.trim();
    if(song=="" || caption==""){
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
    UploadTask uploadTask=FirebaseStorage.instance.ref("reels").child(widget.userModel.email.toString()).putFile(pickedImage!);
    TaskSnapshot snapshot=await uploadTask;
    String ? videoUrl=await snapshot.ref.getDownloadURL();
    String ? song=SongController.text.trim();
    String ? caption=CaptionController.text.trim();
    widget.userModel.reel=videoUrl;
    widget.userModel.song=song;
    widget.userModel.caption=caption;
    log(videoUrl);
    log(song);
    log(caption);
    FirebaseFirestore.instance.collection("users").doc(widget.userModel.email).set(widget.userModel.toMap()).then((value) => log("Video Uploaded"));
  }
  @override
  void initState() {
    super.initState();
    setState(() {
      //videoPlayerController=VideoPlayerController.file(widget.videoFile);
    });
    videoPlayerController.initialize();
    videoPlayerController.play();
    videoPlayerController.setLooping(true);
    videoPlayerController.setVolume(0.7);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height/1.5,
              width: MediaQuery.of(context).size.width,
              child: VideoPlayer(videoPlayerController),
            ),
            SizedBox(height: 20),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 30,vertical: 10),
              width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                TextInputField(controller: SongController, myIcon: Icon(Icons.music_note), mylabelText: "Song", tohide: false),
                SizedBox(height: 20),
                TextInputField(controller: CaptionController, myIcon: Icon(Icons.closed_caption), mylabelText: "Caption", tohide: false),
                SizedBox(height: 15),
                ElevatedButton(onPressed: (){
                  CheckValues();
                },style: ElevatedButton.styleFrom(backgroundColor: Colors.red), child: Text("Upload"))
              ],
            ),
            )
          ],
        ),
      ),
    );
  }
}
