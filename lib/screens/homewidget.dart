import 'dart:io';
import 'dart:math';

import 'package:firebasetest/models/elementx.dart';
import 'package:firebasetest/widgets/btmsheetedit.dart';
import 'package:firebasetest/widgets/btmsheetnew.dart';
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(243, 237, 247, 1),
        automaticallyImplyLeading: false,
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
                        child: Icon(CupertinoIcons.trash,color: Colors.white,),
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
                                  showModalBottomSheet(
                                    context: context,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    isScrollControlled: true,
                                    builder: (context) {
                                      return  BottomSheetEdit(id: document.id,val: xzc);
                                    },
                                  );
                              },
                              child: CircleAvatar(child:
                              Icon(CupertinoIcons.pencil_circle,
                                color: Color.fromRGBO(80, 55, 139, 1),),
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
        onTap: ()=>  showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        ),
        isScrollControlled: true,
        builder: (context) {
          return BottomSheetNew();
        }
    ),//showbtmsht(_datasxref),
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
}
