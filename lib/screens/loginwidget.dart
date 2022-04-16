import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasetest/providers/appprovider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';

class loginwidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _loginwidgetState();
  }
}

class _loginwidgetState extends State<loginwidget> {
  final phnctrlr=TextEditingController();

  @override
  void initState() {

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(243, 237, 247, 1),
      // appBar: AppBar(
      //   title: Text("loginwidget"),
      // ),
      body:
          Container(
            padding: EdgeInsets.symmetric(horizontal: 40),
      child:
        Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Container(
              alignment: Alignment.centerLeft,
            child:
            Text('Continue with Phone',
              style: GoogleFonts.roboto(
                  fontSize: 24,
                  fontWeight: FontWeight.normal,
                  color: Colors.black),
            textAlign: TextAlign.start,
            ),
            ),
            SizedBox(height:60),
            TextField(
              controller: phnctrlr,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: BorderSide(color: Color.fromRGBO(121, 116, 126, 1),width: 0.25)
                ),
                labelText: "Mobile Number",
                labelStyle: GoogleFonts.roboto(fontSize: 12,fontWeight: FontWeight.normal),
                prefixIcon: Icon(Icons.call_outlined)

              ),
            ),
            SizedBox(height:80),
            Consumer<appprovider>(
              builder: (context,model,child){
                if(model.xpz==loginstate.loggedin)
                {
                  Future.delayed(Duration.zero,(){
                    Navigator.of(context).pushReplacementNamed('home');
                  });
                }
                return  InkWell(
                  child:
                  Container(
                    width:model.xt==vrfystate.initial? 200:80,
                    padding: EdgeInsets.symmetric(horizontal: 24,vertical: 10),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Color.fromRGBO(103, 80, 164, 1)
                    ),
                    child: model.xt==vrfystate.initial?Text('CONTINUE', style: GoogleFonts.roboto(fontSize: 14,fontWeight: FontWeight.normal,color: Colors.white))
                        :SizedBox(width: 24,height: 24,child: Center(
                      child: CircularProgressIndicator(color: Colors.white,strokeWidth: 1.5),
                    ),),
                  ),
                  onTap: () async{
                    if(phnctrlr.value.text.length==10)
                    {
                      Provider.of<appprovider>(context,listen: false).verifyphonenum(number: phnctrlr.value.text);
                      Future.delayed(Duration.zero,(){
                        Navigator.of(context).pushReplacementNamed('verify');
                      });
                    }
                  },
                );
              },
            ),

          ],
        ),
          ),
      );
  }
}
