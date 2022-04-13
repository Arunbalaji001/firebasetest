import 'package:firebasetest/providers/appprovider.dart';
import 'package:firebasetest/screens/homewidget.dart';
import 'package:firebasetest/screens/loginwidget.dart';
import 'package:firebasetest/screens/verifypagewidget.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(create: (context)=>appprovider(),
    child:MaterialApp(
      title: 'Firebase Test',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home:  loginwidget(),
      routes: {
        'verify':(context)=>VerifyPageWidget(),
        'home':(context)=>Homepage(),
        'login':(context)=>loginwidget(),
      },
    ),);
  }
}

