import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Constants {
  static const double kPadding = 10.0;
  static const Color purpleLight = Colors.white;
  static const Color purpleDark = Color(0XFFe1eafa);
  static const Color blackColor = Colors.black;
  static const Color orange = Color(0XFFec8d2f);
  static const Color red = Color(0XFFf44336);
  static const Color listileColor = Color(0XFFe1eafa);
  static const Color smallTitles = Color(0xFF405264);
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> orgKey = GlobalKey<NavigatorState>();

final CollectionReference usersCollRef =
    FirebaseFirestore.instance.collection('user');
final CollectionReference countriesCollRef =
    FirebaseFirestore.instance.collection('countries');
final CollectionReference investorsCollRef =
    FirebaseFirestore.instance.collection('investors');
final CollectionReference tasksCollRef =
    FirebaseFirestore.instance.collection('tasks');
final CollectionReference orgCollRef =
    FirebaseFirestore.instance.collection('organizations');

FirebaseAuth auth = FirebaseAuth.instance;
User? user = auth.currentUser;
String? userId = user?.uid;
String? userEmail = user?.email;

//////////////////////////// Employees

int emplFamilyFriends = 0;
double avgEmplFamilyFriends = 0.0;

int emplCoFounder = 0;
double avgEmplCoFounder = 0.0;

int emplJobFair = 0;
double avgEmplJobFair = 0.0;

int emplJobListing = 0;
double avgEmplJobListing = 0.0;

int emplCostCoFounder = 0;
double avgEmplCostCoFounder = 0.0;

int emplCostFamilyFriends = 0;
double avgEmplCostFamilyFriends = 0.0;

int emplCostJobFair = 0;
double avgEmplCostJobFair = 0.0;

int emplCostJobListing = 0;
double avgEmplCostJobListing = 0.0;

int emplPercCoFounder = 0;
double avgEmplPercCoFounder = 0.0;

int emplPercFamilyFriends = 0;
double avgEmplPercFamilyFriends = 0.0;

int emplPercJobFair = 0;
double avgEmplPercJobFair = 0.0;

int emplPercJobListing = 0;
double avgEmplPercJobListing = 0.0;

//////////////////////////// Services

int servAccountingServices = 0;
double avgServAccountingServices = 0.0;

int servAdminstration = 0;
double avgServAdminstration = 0.0;

int servHR = 0;
double avgServHR = 0.0;

int servItAdminstration = 0;
double avgServItAdminstration = 0.0;

int servItDevComputer = 0;
double avgServItDevComputer = 0.0;

int servCostAccountingServices = 0;
double avgServCostAccountingServices = 0.0;

int servCostAdminstration = 0;
double avgServCostAdminstration = 0.0;

int servCostHR = 0;
double avgServCostHR = 0.0;

int servCostItAdminstration = 0;
double avgServCostItAdminstration = 0.0;

int servCostItDevComputer = 0;
double avgServCostItDevComputer = 0.0;

int servPercAccountingServices = 0;
double avgServPercAccountingServices = 0.0;

int servPercAdminstration = 0;
double avgServPercAdminstration = 0.0;

int servPercHR = 0;
double avgServPercHR = 0.0;

int servPercItAdminstration = 0;
double avgServPercItAdminstration = 0.0;

int servPercItDevComputer = 0;
double avgServPercItDevComputer = 0.0;

//////////////////////////// Break Even & Total Revenue

int trMonths = 0;
double avgTrMonths = 0.0;

int trRevenue = 0;
double avgTrRevenue = 0.0;

int beMoney = 0;
double avgBeMoney = 0.0;

int beMonths = 0;
double avgBeMonths = 0.0;

//////////////////////////// investors

int investors = 0;
double avgInvestors = 0.0;