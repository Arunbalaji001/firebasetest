import 'dart:io';
import 'dart:math';

import 'package:firebasetest/models/elementx.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../providers/appprovider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Homepage extends StatefulWidget{
  @override
  _HomepageState createState()=>_HomepageState();
}

class _HomepageState extends State<Homepage>{
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final Stream<QuerySnapshot> _datasxStream = FirebaseFirestore.instance.collection('datasx').orderBy('created', descending: true).snapshots();
  CollectionReference _datasxref = FirebaseFirestore.instance.collection('datasx');
  final ImagePicker _picker = ImagePicker();
  final storageRef = FirebaseStorage.instance.ref();
  static const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(243, 237, 247, 1),
        title: Text('ITEMS',style: GoogleFonts.roboto(fontSize: 22,color: Colors.black,),),
        centerTitle: true,
      ),
        backgroundColor: Color.fromRGBO(243, 237, 247, 1),
        body: StreamBuilder<QuerySnapshot>(
            stream: _datasxStream,
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text("Loading");
              }

              return ListView(
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  elementx xzc = elementx.fromJson( document.data()! as Map<
                      String,
                      dynamic>);
                  return Dismissible(
                      key:Key(document.id),
                      onDismissed: (direction) async{
                       await _datasxref.doc(document.id).delete();
                       setState(() {

                       });
                      },
                      background: Container(
                        height: 80,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(6),
                            boxShadow: [
                              BoxShadow(color: Colors.black12,offset: Offset(0,2),blurRadius: 6,spreadRadius: 2)
                            ]
                        ),
                        margin: EdgeInsets.symmetric(horizontal: 18,vertical: 6),
                        padding: EdgeInsets.symmetric(horizontal: 18),
                        alignment: Alignment.centerLeft,
                        child: Icon(Icons.restore_from_trash,color: Colors.white,),
                      ),
                      child: Container(
                        height: 80,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 251, 254, 1),
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: [
                          BoxShadow(color: Colors.black12,offset: Offset(0,2),blurRadius: 6,spreadRadius: 2)
                        ]
                      ),
                    margin: EdgeInsets.symmetric(horizontal: 18,vertical: 6),
                    child:Row(
                      children:[
                        xzc.imageurl!=null&&xzc.imageurl.isNotEmpty?
                            Container(
                              height: 80,
                              width: 94,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade400,
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(8),
                                bottomLeft: Radius.circular(8))
                              ),
                              child:
                              CachedNetworkImage(
                                imageUrl:xzc.imageurl,
                                placeholder: (context, url) => SizedBox(width: 24,height: 24,child: Center(child: CircularProgressIndicator(color: Colors.deepPurple,strokeWidth: 1.5,)),),
                                errorWidget: (context, url, error) => Image.asset('assets/media.png',),
                              ),
                            ):
                           Image.asset('assets/media.png',width: 94,),
                           SizedBox(width: 6,),
                           Expanded(child: Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             mainAxisSize: MainAxisSize.min,
                             children: [
                               Text(xzc.title,style: GoogleFonts.roboto(fontSize: 16),),
                               Text(xzc.description,style: GoogleFonts.roboto(fontSize: 16),),
                             ],
                           )),
                            InkWell(
                              onTap:(){
                                  editbtmsht(_datasxref, document.id, xzc);
                              },
                              child: CircleAvatar(child: Icon(CupertinoIcons.pencil_ellipsis_rectangle,color: Color.fromRGBO(80, 55, 139, 1),),
                                  backgroundColor: Color.fromRGBO(234, 221, 255, 1)),
                            ),
                        SizedBox(width: 8,)
                        ]),
                    // subtitle: Text(data['company']),
                  ));
                }).toList(),
              );
            }),
      floatingActionButton: InkWell(
        onTap: ()=>showbtmsht(_datasxref),
    child:Container(
        height: 70,
        width: 70,
        decoration: BoxDecoration(
          color: Color.fromRGBO(255, 216, 228, 1),
          borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(color: Colors.black12,offset: Offset(0,4),blurRadius: 8,spreadRadius: 3)
            ]
        ),
        child: Icon(Icons.add,color: Colors.black,),
      ),
      ),
      );

  }
  void showbtmsht(CollectionReference _datasxref){
    TextEditingController x1=TextEditingController();
    TextEditingController x2=TextEditingController();
    bool imgupld=false;
    String imgurl='';

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(builder:   (BuildContext context, StateSetter setsheetstate ) {
          return Container(
              padding: EdgeInsets.only(bottom:MediaQuery.of(context).viewInsets.bottom),
              color: Colors.black12,
              child:Container(
                  // height: MediaQuery.of(context).size.height/2,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 34,),
                      Text('Add Item',style: GoogleFonts.roboto(fontSize: 24,color: Colors.black,fontWeight: FontWeight.bold),),
                      SizedBox(height: 15,),
                      InkWell(
                        child:imgupld?CachedNetworkImage(
                          width: 100,height: 100,
                          imageUrl:imgurl,
                          placeholder: (context, url) => SizedBox(width: 24,height: 24,child: Center(child: CircularProgressIndicator(color: Colors.deepPurple,strokeWidth: 1.5,)),),
                          errorWidget: (context, url, error) => Image.asset('assets/media.png',width: 100,height: 100,),
                        ):
                        Image.asset('assets/mediax.png',width: 100,height: 100,),
                        onTap: () async{
                          final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery,);
                          String nameimg=getRandomString(10);
                          print(pickedFile!.mimeType);
                          final imageRef = storageRef.child(nameimg+".jpg");
                          File file = File(pickedFile!.path);
                          try {
                            await imageRef.putFile(file);
                            imgupld=true;
                            imgurl=await imageRef.getDownloadURL() ;
                            setsheetstate((){});
                            print('File uploaded');
                          } on FirebaseException catch (e) {
                            print('Exception : File Upload: '+e.toString());
                          }

                        },),
                      SizedBox(height: 15,),
                      TextField(
                        controller: x1,
                        // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        // keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide: BorderSide(color: Color.fromRGBO(121, 116, 126, 1),width: 0.25)
                          ),
                          labelText: "Title",
                          labelStyle: GoogleFonts.roboto(fontSize: 12,fontWeight: FontWeight.normal,color: Color.fromRGBO(103, 80, 164, 1)),

                        ),
                      ),
                      SizedBox(height: 15,),
                      TextField(
                        controller: x2,
                        // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        // keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide: BorderSide(color: Color.fromRGBO(121, 116, 126, 1),width: 0.25)
                          ),
                          labelText: "Description",
                          labelStyle: GoogleFonts.roboto(fontSize: 12,fontWeight: FontWeight.normal,color: Color.fromRGBO(103, 80, 164, 1)),

                        ),
                      ),
                      SizedBox(height: 15,),
                      InkWell(
                        child:
                        Container(
                            padding: EdgeInsets.symmetric(horizontal: 24,vertical: 10),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Color.fromRGBO(103, 80, 164, 1)
                            ),
                            child: Text('SAVE', style: GoogleFonts.roboto(fontSize: 14,fontWeight: FontWeight.normal,color: Colors.white))
                        ),
                        onTap: () async{
                          if(x1.value.text.isNotEmpty&&x2.value.text.isNotEmpty) {
                            elementx itemx = elementx(
                                title: x1.value.text,
                                description: x2.value.text,
                                imageurl: imgurl);
                            _datasxref.add(itemx.toJson());
                            Navigator.pop(context);
                          }
                          else{
                            Fluttertoast.showToast(msg: 'Fill all the Fields');
                          }
                        },
                      ),
                      SizedBox(height: 18,)
                    ],
                  )
              )
          );
        });

      },
    );
  }
  void editbtmsht(CollectionReference _datasxref,String id,elementx val){
    TextEditingController x1=TextEditingController(text: val.title);
    TextEditingController x2=TextEditingController(text:val.description);
    // bool imgupld=false;
    // String imgurl='';

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(builder:   (BuildContext context, StateSetter setsheetstate ) {
          return Container(
              color: Colors.black12,
              padding: EdgeInsets.only(bottom:MediaQuery.of(context).viewInsets.bottom),
              child:Container(
                  // height: MediaQuery.of(context).size.height/2,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 34,),
                      Text('Edit Item',style: GoogleFonts.roboto(fontSize: 24,color: Colors.black,fontWeight: FontWeight.bold),),
                      SizedBox(height: 15,),
                      InkWell(
                        child: val.imageurl!=null&&val.imageurl.isNotEmpty?CachedNetworkImage(
                          width: 100,height: 100,
                          imageUrl:val.imageurl,
                          placeholder: (context, url) => SizedBox(width: 24,height: 24,child: Center(child: CircularProgressIndicator(color: Colors.deepPurple,strokeWidth: 1.5,)),),
                          errorWidget: (context, url, error) => Image.asset('assets/media.png',width: 100,height: 100,),
                        ):
                        Image.asset('assets/mediax.png',width: 100,height: 100,),
                        onTap: () async{
                          final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery,);
                          String nameimg=getRandomString(10);
                          print(pickedFile!.mimeType);
                          final imageRef = storageRef.child(nameimg+".jpg");
                          File file = File(pickedFile!.path);
                          try {
                            await imageRef.putFile(file);
                            // imgupld=true;
                            // imgurl=await imageRef.getDownloadURL() ;
                            val.imageurl=await imageRef.getDownloadURL();
                            setsheetstate((){});
                            print('File uploaded');
                          } on FirebaseException catch (e) {
                            print('Exception : File Upload: '+e.toString());
                          }

                        },),
                      SizedBox(height: 15,),
                      TextField(
                        controller: x1,
                        // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        // keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide: BorderSide(color: Color.fromRGBO(121, 116, 126, 1),width: 0.25)
                          ),
                          labelText: "Title",
                          labelStyle: GoogleFonts.roboto(fontSize: 12,fontWeight: FontWeight.normal,color: Color.fromRGBO(103, 80, 164, 1)),

                        ),
                      ),
                      SizedBox(height: 15,),
                      TextField(
                        controller: x2,
                        // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        // keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide: BorderSide(color: Color.fromRGBO(121, 116, 126, 1),width: 0.25)
                          ),
                          labelText: "Description",
                          labelStyle: GoogleFonts.roboto(fontSize: 12,fontWeight: FontWeight.normal,color: Color.fromRGBO(103, 80, 164, 1)),

                        ),
                      ),
                      SizedBox(height: 15,),
                      InkWell(
                        child:
                        Container(
                            padding: EdgeInsets.symmetric(horizontal: 24,vertical: 10),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Color.fromRGBO(103, 80, 164, 1)
                            ),
                            child: Text('SAVE', style: GoogleFonts.roboto(fontSize: 14,fontWeight: FontWeight.normal,color: Colors.white))
                        ),
                        onTap: () async{
                          if(x1.value.text.isNotEmpty&&x2.value.text.isNotEmpty) {
                            _datasxref.doc(id).update(val.toJson()).then((value) => Navigator.pop(context)).catchError((error){
                              Fluttertoast.showToast(msg: 'Error : '+error.toString());
                            });

                          }
                          else{
                            Fluttertoast.showToast(msg: 'Fill all the Fields');
                          }
                        },
                      ),
                      SizedBox(height: 18,)
                    ],
                  )
              )
          );
        });

      },
    );
  }

}
