
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:localstorage/localstorage.dart';

import '../models/elementx.dart';

enum vrfystate{initial,loading,codesent,codetimeout,verifyfailed,completed}
enum loginstate{initial,loading,loggedin,notloggedin}
class appprovider extends ChangeNotifier{
  vrfystate xt=vrfystate.initial;
  var verfyID='';
  loginstate xpz=loginstate.initial;
  String userid='';
  elementx tempval=elementx.empty();

  final LocalStorage storage =  LocalStorage('firebasetest');
  FirebaseAuth auth = FirebaseAuth.instance;

  appprovider()  {
    getuser();
  }

  void settempval(elementx xt){
    tempval=xt;
    notifyListeners();
  }
  elementx gettempval()=>tempval;

  Future<void> verifyphonenum({required String number}) async{

    xt=vrfystate.loading;
    notifyListeners();
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+91 '+number,
      verificationCompleted: (PhoneAuthCredential credential) async {
          try {
            UserCredential usercred = await auth.signInWithCredential(
                credential);
            User? userx = usercred.user;
            if (userx != null) {
              await savecred(id: userx.uid.toString());
              xt = vrfystate.completed;
              notifyListeners();
            }
            else {
              xt = vrfystate.verifyfailed;
              notifyListeners();
            }
          }
        catch(e){
          print('Exception :::'+e.toString());
          xt=vrfystate.verifyfailed;
          notifyListeners();
         }

      },
      verificationFailed: (FirebaseAuthException e) {
        print('Failed :'+e.toString());
        xt=vrfystate.verifyfailed;
        notifyListeners();

      },
      codeSent: (String verificationId, int? resendToken) {
        print('Codesent :'+verificationId);
        verfyID=verificationId;
        xt=vrfystate.codesent;
        notifyListeners();


      },
      codeAutoRetrievalTimeout: (String verificationId) {
        print('Timeout7904419383');
        xt=vrfystate.codetimeout;
        notifyListeners();


      },
    );
  }

  Future<void> signinx({required String code}) async{
    if(xt==vrfystate.codesent||xt==vrfystate.codetimeout){
      try {
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
            verificationId: verfyID, smsCode: code);
        UserCredential usercred = await auth.signInWithCredential(credential);
        User? userx=usercred.user;
        if(userx!=null){
          await savecred(id: userx.uid.toString());
          xt=vrfystate.completed;
          notifyListeners();
        }
        else{
          xt=vrfystate.verifyfailed;
          notifyListeners();
        }
        // print(user);
      }
      catch(e){
        print('Exception :::'+e.toString());
        xt=vrfystate.verifyfailed;
        notifyListeners();
      }
    }
  }
  Future<void> savecred({required String id}) async{
    await storage.ready;
    storage.setItem('logx', true);
    storage.setItem('userloggedin', id.toString());
  }
  Future<void> getuser() async{
    xpz=loginstate.loading;
    notifyListeners();
    await storage.ready;
   var logx= storage.getItem('logx');
   if(logx!=null &&logx==true) {
     userid=storage.getItem('userloggedin');
     xpz=loginstate.loggedin;
     notifyListeners();
   }
   else{
     xpz=loginstate.notloggedin;
     notifyListeners();
   }
  }

}