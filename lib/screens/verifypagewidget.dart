
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:provider/provider.dart';

import '../providers/appprovider.dart';
import 'package:cupertino_icons/cupertino_icons.dart';

class VerifyPageWidget extends StatefulWidget {
  const VerifyPageWidget({Key? key}) : super(key: key);

  @override
  State<VerifyPageWidget> createState() => _VerifyPageWidgetState();
}

class _VerifyPageWidgetState extends State<VerifyPageWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(243, 237, 247, 1),
      body:   Container(
      padding: EdgeInsets.symmetric(horizontal: 40),
    child:
        Consumer<appprovider>(builder: (context,model,child){
          if(model.xt==vrfystate.codesent||model.xt==vrfystate.codetimeout){
            return Container(
                alignment: Alignment.center,
                child:
                Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child:
                        Text('Verify your Phone',
                          style: GoogleFonts.roboto(
                              fontSize: 24,
                              fontWeight: FontWeight.normal,
                              color: Colors.black),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      SizedBox(height:12),
                      Container(

                        constraints: BoxConstraints(maxHeight: 150),
                        child:
                        OTPTextField(
                          // controller: otpController,
                            length: 6,
                            width: MediaQuery.of(context).size.width-80,
                            textFieldAlignment: MainAxisAlignment.spaceAround,
                            fieldWidth: (MediaQuery.of(context).size.width-80)/7,
                            fieldStyle: FieldStyle.box,
                            outlineBorderRadius: 15,
                            style: TextStyle(fontSize: 17),
                            onChanged: (pin) {
                              print("Changed: " + pin);
                            },
                            onCompleted: (pin) async {
                              print("Completed: " + pin);
                              await Provider.of<appprovider>(context,listen: false).signinx(code: pin);
                            }),
                      ),

                    ]));
          }
          else if(model.xt==vrfystate.completed){
                Future.delayed(Duration(seconds:2),()=>Navigator.of(context).pushNamed('home'));
            return Container(
                alignment: Alignment.center,
                child:
                Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  Icon(CupertinoIcons.check_mark_circled,color: Colors.green.shade600,),
                  SizedBox(height: 24,),
                  Text('Success - Verification completed.')
                ]));
          }
          else if(model.xt==vrfystate.verifyfailed){

            return Container(
                alignment: Alignment.center,
                child:
                Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [
                      Icon(CupertinoIcons.clear_circled,color: Colors.red.shade600,),
                      SizedBox(height: 24,),
                      Text('Failed - Verification failed.'),
                      SizedBox(height: 24,),
                      TextButton(onPressed: (){
                        Navigator.of(context).pushNamed('login');
                      }, child: Text('RETRY'),)
                    ]));
          }
          else {

            return Container(
                alignment: Alignment.center,
                child:
                Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [
                      Icon(CupertinoIcons.clear_circled,color: Colors.red.shade600,),
                      SizedBox(height: 24,),
                      Text('Error - Something went wrong.'),
                      SizedBox(height: 24,),
                      TextButton(onPressed: (){
                        Navigator.of(context).pushNamed('login');
                      }, child: Text('RETRY'),)
                    ]));
          }

        },),
),
    );
  }
}
