class UserModel{
  String ? uid;
  String ? fullname;
  String ? profilepic;
  String ? email;
  String ? phone;
  String ? song;
  String ? caption;
  String ? reel;
  UserModel({required this.uid,required this.fullname,required this.profilepic,required this.email,required this.phone,required this.song,required this.caption,required this.reel});
  UserModel.fromMap(Map<String,dynamic>map){
    uid=map["uid"];
    fullname=map["fullname"];
    profilepic=map["profilepic"];
    email=map["email"];
    phone=map["phone"];
    song=map["song"];
    caption=map["caption"];
    reel=map["reel"];
  }
  Map<String,dynamic>toMap(){
    return {
      "uid":uid,
      "fullname":fullname,
      "profilepic":profilepic,
      "email":email,
      "phone":phone,
      "song":song,
      "caption":caption,
      "reel":reel
    };
  }
}