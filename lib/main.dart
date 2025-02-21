import 'package:airbnb_app_ui/Provider/favorite_provider.dart';
import 'package:airbnb_app_ui/model/place_model.dart';
import 'package:airbnb_app_ui/view/login_screen.dart';
import 'package:airbnb_app_ui/view/main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';




void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyC0lhWRFrc5Oo1XFgYYWwvnAhuOENY_qhE",
        authDomain: "airbnb-7fcda.firebaseapp.com",
        projectId: "airbnb-7fcda",
        storageBucket: "airbnb-7fcda.appspot.com",
        messagingSenderId: "745044745250",
        appId: "1:745044745250:web:2e6516d0e72b6ed125fe7b",
        measurementId: "G-V6VSNNN3ND",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => FavoriteProvider(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: 
            // keep user login until logout

            StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return const AppMainScreen();
            } else {
              return const LoginScreen();
            }
          },
        ),
      ),
    );
  }
}

class UploadDataInfirebase extends StatelessWidget {
  const UploadDataInfirebase({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: (){
            savePlacesToFirebase();
          },
          child: Text("Upload Data")),
      ),
    );
  }
}