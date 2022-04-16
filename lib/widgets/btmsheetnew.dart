import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebasetest/models/elementx.dart';
import 'package:firebasetest/providers/uploaddata.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class BottomSheetNew extends StatefulWidget {

  BottomSheetNew({Key? key}) : super(key: key);
  @override
  _BottomSheetNewState createState() => _BottomSheetNewState();
}
class _BottomSheetNewState extends State<BottomSheetNew> {
  TextEditingController x1=TextEditingController();
  TextEditingController x2=TextEditingController();
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
          return
            ChangeNotifierProvider(
              create: (context)=>UploadData(''),
            builder: (context,child){
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
                      Consumer<UploadData>(builder: (context,model,child){
                        if(model.imgupldg!=imgupldstate.uploading) {
                          return InkWell(
                            child: model.imgurl != null &&
                                model.imgurl.isNotEmpty ?
                            CachedNetworkImage(
                              width: 100,
                              height: 100,
                              imageUrl: model.imgurl
                              ,
                              placeholder: (context, url) =>
                                  SizedBox(width: 24, height: 24, child: Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.deepPurple,
                                        strokeWidth: 1.5,)),),
                              errorWidget: (context, url, error) => Image.asset(
                                'assets/media.png', width: 100, height: 100,),
                            ) :
                            Image.asset(
                              'assets/mediax.png', width: 100, height: 100,),
                            onTap: () async {
                              final XFile? pickedFile = await _picker.pickImage(
                                source: ImageSource.gallery,);
                              if(pickedFile!=null) {
                                Provider.of<UploadData>(context, listen: false).uploadimg(pickedFile!);
                              }
                              else{
                                Fluttertoast.showToast(msg: 'Unable select, try again');
                              }
                            },);
                        }
                        return Container(
                          width: 100,
                          height: 100,
                          child: Center(
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 1.5,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        );
                      },),
                      SizedBox(height: 15,),
                      TextField(
                        controller: x1,
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
                            bool? valx=await Provider.of<UploadData>(context,listen: false).addxelement(x1.value.text, x2.value.text);
                            if(valx!=true){
                              Fluttertoast.showToast(msg: 'Data Added');
                              Navigator.pop(context);
                            }
                            else{
                              Fluttertoast.showToast(msg: 'Adding failed');
                            }
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
  }
}
