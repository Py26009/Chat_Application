class UserModel{
  String ? userId;
  String ? name;
  String ? email;
  String ? mobNo;
  String ? gender;
  String ? createdAt;
  String ? profilePic;
  int ? status =1;
  int ? profileStatus;
  bool isOnline = false;

  UserModel({required this.name, required this.status, required this.email, required this.mobNo,
  required this.userId, required this.gender, required this.createdAt, required this.isOnline,
  required this.profilePic, required this.profileStatus});

  factory UserModel.fromDoc(Map<String, dynamic> doc){
    return UserModel(
        name:doc["name"],
        status: doc['status'],
        email:doc["email"],
        mobNo: doc["mobNo"],
        userId: doc["userId"],
        gender:doc["gender"],
        createdAt: doc["createdAt"],
        isOnline: doc['isOnline'],
        profilePic: doc['profilePic'],
        profileStatus: doc["profileStatus"]);
  }

  Map<String, dynamic> toDoc(){
    return{
      "name": name,
      "status": status,
      "email" :email,
      "mobNo":mobNo,
      "userId": userId,
      "gender": gender,
      "createdAt": createdAt,
      "isOnline":isOnline,
      "profilePic" :profilePic,
      "profileStatus":profileStatus
    };
  }
}