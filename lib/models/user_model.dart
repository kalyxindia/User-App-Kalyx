import 'package:firebase_database/firebase_database.dart';

class UserModel
{
  String? phone;
  String? name;
  String? id;
  String? email;

  UserModel({this.phone,this.name,this.id,this.email});

  UserModel.fromSnapShot(DataSnapshot snapshot){
    phone = (snapshot.value as dynamic)["phone"];
    name = (snapshot.value as dynamic)["name"];
    id = snapshot.key;
    email = (snapshot.value as dynamic)["email"];
  }

}