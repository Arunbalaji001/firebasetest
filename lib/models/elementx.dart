
import 'package:cloud_firestore/cloud_firestore.dart';

class elementx{
  String title='';
  String description='';
  String imageurl='';

  elementx({required this.title, required this.description, required this.imageurl});

  elementx.fromJson(Map<String,dynamic> json){
   title=json['title'];
   description=json['description'];
   imageurl=json['imageurl'];
  }
  Map<String,dynamic> toJson()=>{
    'title':title,
    'description':description,
    'imageurl':imageurl,
    'created':  FieldValue.serverTimestamp()
  };
}