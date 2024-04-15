import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../responsive_layout.dart';
import '../charts.dart';

class PanelLeftPage extends StatefulWidget {
  const PanelLeftPage({super.key});

  @override
  _PanelLeftPageState createState() => _PanelLeftPageState();
}

class _PanelLeftPageState extends State<PanelLeftPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          if (ResponsiveLayout.isComputer(context))
            Container(
              color: Constants.purpleLight,
              width: 50,
              child: Container(
                decoration: const BoxDecoration(
                  color: Constants.purpleDark,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                  ),
                ),
              ),
            ),
          SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      top: Constants.kPadding / 2,
                      right: Constants.kPadding / 2,
                      left: Constants.kPadding / 2),
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: const Color(0xFFb9c5a4),
                        ),
                        width: double.infinity,
                        child: StreamBuilder(
                            stream: usersCollRef.snapshots(),
                            builder: (context,
                                AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                              if (streamSnapshot.hasData) {
                                return const ListTile(
                                  title: Text(
                                    "Users",
                                    textAlign: TextAlign.center,
                                    style:
                                        TextStyle(color: Constants.blackColor),
                                  ),
                                  subtitle: Text(
                                    "All registered Users",
                                    textAlign: TextAlign.center,
                                    style:
                                        TextStyle(color: Constants.blackColor),
                                  ),
                                  trailing: Icon(Icons.account_circle_rounded),
                                );
                              }
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            })),
                  ),
                ),
                const UsersList(),
                Padding(
                  padding: const EdgeInsets.only(
                      top: Constants.kPadding / 2,
                      right: Constants.kPadding / 2,
                      left: Constants.kPadding / 2),
                  child: Card(
                    color: Constants.purpleLight,
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: const Color(0xFFd3d5e3),
                      ),
                      width: double.infinity,
                      child: const ListTile(
                        title: Text(
                          "Gender",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Constants.blackColor),
                        ),
                        subtitle: Text(
                          "Entrepreneurs Gender percentage",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Constants.blackColor),
                        ),
                        trailing: Icon(Icons.transgender),
                      ),
                    ),
                  ),
                ),
                const GenderPieChart(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
