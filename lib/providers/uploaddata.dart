import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebasetest/models/elementx.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
enum imgupldstate{initial,uploading,uploaded,failed}
class UploadData extends ChangeNotifier{
  String imgurl='';
  final storageRef = FirebaseStorage.instance.ref();
  static const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();
  imgupldstate imgupldg=imgupldstate.initial;
  elementx temp=elementx.empty();
  CollectionReference _datasxref = FirebaseFirestore.instance.collection('datasx');


  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  UploadData(this.imgurl);

  Future<void> uploadimg(XFile xFile) async{
    imgupldg=imgupldstate.uploading;
    notifyListeners();
    String nameimg=getRandomString(10);
    final imageRef = storageRef.child(nameimg+".jpg");
    File file = File(xFile.path);
    try {
      await imageRef.putFile(file);
      imgurl=await imageRef.getDownloadURL();
      imgupldg=imgupldstate.uploaded;
      notifyListeners();
      print('File uploaded');
    } on FirebaseException catch (e) {
      imgupldg=imgupldstate.failed;
      notifyListeners();
      print('Exception : File Upload: '+e.toString());
    }
  }
  Future<bool?> updatexelement(String title,String descp,String id) async{
    temp=elementx(title: title, description: descp, imageurl: imgurl);
     await _datasxref.doc(id).update(
         temp.toJson()).then(
              (value) =>  true).catchError((error){
      return false;
      });
  }

  Future<bool?> addxelement(String title, String descp) async{
    temp=elementx(title: title, description: descp, imageurl: imgurl);
    _datasxref.add(temp.toJson());

  }

}