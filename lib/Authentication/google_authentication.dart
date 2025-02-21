import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Google Sign-In Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginScreen(),
    );
  }
}

class FirebaseAuthServices {
  final auth = FirebaseAuth.instance;
  final googleSignIn = GoogleSignIn(
     clientId: const String.fromEnvironment('745044745250-8bhvbb497hnog602emolhs447ntpmgm4.apps.googleusercontent.com'),// Replace with your Client ID or set via environment variable
    scopes: ['email', 'password'] 
   // scopes: ['email', 'profile'] // Add necessary scopes
  );

  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        return await auth.signInWithCredential(credential);
      }
      return null;
    } catch (e) {
      print("Error signing in with Google: $e");
      return null;
    }
  }

  Future<void> signOut() async {
    await auth.signOut();
    await googleSignIn.signOut();
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuthServices _authService = FirebaseAuthServices();
  User? _user;

  @override
  void initState() {
    super.initState();
    _authService.auth.authStateChanges().listen((User? user) {
      setState(() {
        _user = user;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Sign-In Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_user != null)
              Text('Signed in as: ${_user!.email ?? "No email"}')
            else
              const Text('Not signed in'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (_user == null) {
                  UserCredential? userCredential =
                      await _authService.signInWithGoogle();
                  if (userCredential != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Successfully signed in!')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Sign-in failed.')),
                    );
                  }
                } else {
                  await _authService.signOut();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Signed out.')),
                  );
                }
              },
              child: Text(_user == null ? 'Sign in with Google' : 'Sign Out'),
            ),
          ],
        ),
      ),
    );
  }
}





































// import 'package:firebase_auth/firebase_auth.dart';

// import 'package:google_sign_in/google_sign_in.dart';

// class FirebaseAuthServices {
//   final auth = FirebaseAuth.instance;
//   final googleSignIn = GoogleSignIn();

//   signInWithGoogle() async {
//     try {
//       final GoogleSignInAccount? googleSignInAccount =
//           await googleSignIn.signIn();
//       if (googleSignInAccount != null) {
//         final GoogleSignInAuthentication googleSignInAuthentication =
//             await googleSignInAccount.authentication;
//         final AuthCredential authCredential = GoogleAuthProvider.credential(
//             accessToken: googleSignInAuthentication.accessToken,
//             idToken: googleSignInAuthentication.idToken);
//         await auth.signInWithCredential(authCredential);
//       }
//     } on FirebaseAuthException catch (e) {
//       print(e.toString());
      
//     }
//   }
// }
