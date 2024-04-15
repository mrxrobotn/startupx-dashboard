import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:startupx/authentication/screens/home/home_screen.dart';
import 'package:startupx/authentication/screens/home/organization_screen.dart';
import 'authentication/screens/welcome/welcome_screen.dart';
import 'constants.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  User? user = FirebaseAuth.instance.currentUser;
  String? userId = user?.uid;

  if (user != null) {
    // User is logged in
    print("User is logged in: ${user.email}");

    await usersCollRef.doc(userId).get().then((value) {
      if (value['role'] == 'admin') {
        print('is admin');
        runApp(const AdminDashboard());
      } else {
        print('is player');
      }
    }).catchError((onError) {
      print('error');
    });

    await orgCollRef.doc(userId).get().then((value) {
      if (value['role'] == 'organization') {
        print('is organization');
        runApp(const OrganizationScreen());
      } else {
        print('is player');
      }
    }).catchError((onError) {
      print('error');
    });
  } else {
    // User is not logged in
    print("User is not logged in.");
    runApp(MyApp());
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Welcome Page',
      home: WelcomeScreen(),
    );
  }
}

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Admin Panel',
      home: HomeScreen(),
    );
  }
}

class OrgDashboard extends StatelessWidget {
  const OrgDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Organization Panel',
      home: OrganizationScreen(),
    );
  }
}
