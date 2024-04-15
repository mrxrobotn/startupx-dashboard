import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import '../../../constants.dart';
import '../../../dashboard/drawer/drawer_page.dart';
import '../../../dashboard/org_charts.dart';
import '../../../dashboard/widgets/app_bar_widget.dart';
import '../../../responsive_layout.dart';

class OrganizationScreen extends StatelessWidget {
  const OrganizationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "D A S H B O A R D",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          scaffoldBackgroundColor: Constants.purpleDark,
          primarySwatch: Colors.blue,
          canvasColor: Constants.purpleLight),
      navigatorKey: orgKey,
      home: const OrgDashboard(),
    );
  }
}

class OrgDashboard extends StatefulWidget {
  const OrgDashboard({Key? key}) : super(key: key);

  @override
  State<OrgDashboard> createState() => _OrgDashboardState();
}

class _OrgDashboardState extends State<OrgDashboard> {
  int currentIndex = 1;

  final List<Widget> _icons = [
    const Icon(Icons.list, size: 30),
    const Icon(Icons.add, size: 30),
    const Icon(Icons.compare_arrows, size: 30),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity, 70),
        child: (ResponsiveLayout.isTinyLimit(context) ||
                ResponsiveLayout.isTinyHeightLimit(context))
            ? Container()
            : const AppBarWidget(),
      ),
      body: ResponsiveLayout(
        tiny: Container(),
        phone: currentIndex == 0
            ? const PanelLeft()
            : currentIndex == 1
                ? const PanelCenter()
                : const PanelRight(),
        tablet: Row(
          children: const [
            Expanded(child: PanelLeft()),
            Expanded(
              child: PanelCenter(),
            )
          ],
        ),
        largeTablet: Row(
          children: const [
            Expanded(child: PanelLeft()),
            Expanded(child: PanelCenter()),
            Expanded(
              child: PanelRight(),
            )
          ],
        ),
        computer: Row(
          children: const [
            Expanded(child: DrawerPage()),
            Expanded(child: PanelLeft()),
            Expanded(
              child: PanelCenter(),
            ),
            Expanded(
              child: PanelRight(),
            )
          ],
        ),
      ),
      drawer: const DrawerPage(),
      bottomNavigationBar: ResponsiveLayout.isPhone(context)
          ? CurvedNavigationBar(
              index: currentIndex,
              backgroundColor: Constants.purpleDark,
              items: _icons,
              onTap: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
            )
          : const SizedBox(),
    );
  }
}

class PanelLeft extends StatefulWidget {
  const PanelLeft({Key? key}) : super(key: key);

  @override
  State<PanelLeft> createState() => _PanelLeftState();
}

class _PanelLeftState extends State<PanelLeft> {
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
                      right: Constants.kPadding / 2,
                      top: Constants.kPadding / 2,
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
                          color: const Color(0xFFb9c5a4),
                        ),
                        width: double.infinity,
                        child: StreamBuilder(
                            stream: orgCollRef
                                .doc(userId)
                                .collection('users')
                                .snapshots(),
                            builder: (context,
                                AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                              if (streamSnapshot.hasData) {
                                return ListTile(
                                  title: const Text(
                                    "Members",
                                    textAlign: TextAlign.center,
                                    style:
                                        TextStyle(color: Constants.blackColor),
                                  ),
                                  subtitle: const Text(
                                    "Members list registered in this organization",
                                    textAlign: TextAlign.center,
                                    style:
                                        TextStyle(color: Constants.blackColor),
                                  ),
                                  trailing: TextButton(
                                    onPressed: (){
                                      LoopThroughUsers();
                                    },
                                    child: const Text('Average'),
                                  ),
                                  leading: const Icon(Icons.account_circle_rounded),
                                );
                              }
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                        )
                    ),
                  ),
                ),
                const MembersList(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PanelCenter extends StatefulWidget {
  const PanelCenter({Key? key}) : super(key: key);

  @override
  State<PanelCenter> createState() => _PanelCenterState();
}

class _PanelCenterState extends State<PanelCenter> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
                right: Constants.kPadding / 2,
                top: Constants.kPadding / 2,
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
                    color: const Color(0xFFe3e1d3),
                  ),
                  width: double.infinity,
                  child: StreamBuilder(
                      stream: orgCollRef
                          .doc(userId)
                          .collection('investors')
                          .snapshots(),
                      builder: (context,
                          AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                        if (streamSnapshot.hasData) {
                          return ListTile(
                            title: const Text(
                              "Investors List",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Constants.blackColor),
                            ),
                            subtitle: const Text(
                              "Click on the + to add an Investor",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Constants.blackColor),
                            ),
                            leading: IconButton(
                                color: Constants.blackColor,
                                icon: const Icon(Icons.refresh),
                                onPressed: () {
                                  streamSnapshot.data!.docs
                                      .forEach((documentSnapshot) {
                                    documentSnapshot.reference
                                        .update({'isChecked': false});
                                  });
                                }),
                            trailing: IconButton(
                              icon: const Icon(
                                Icons.add,
                                color: Constants.blackColor,
                              ),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => const AlertDialog(
                                      backgroundColor: Constants.purpleLight,
                                      title: Text(
                                        'Add an Investor:',
                                        style: TextStyle(
                                            color: Constants.blackColor),
                                      ),
                                      content: SizedBox(
                                        width: 500,
                                        child: Investors(),
                                      )),
                                );
                              },
                            ),
                          );
                        }
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      })),
            ),
          ),
          const InvestorsList(),
        ],
      ),
    );
  }
}

class PanelRight extends StatefulWidget {
  const PanelRight({Key? key}) : super(key: key);

  @override
  State<PanelRight> createState() => _PanelRightState();
}

class _PanelRightState extends State<PanelRight> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
                right: Constants.kPadding / 2,
                top: Constants.kPadding / 2,
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
                  color: const Color(0xFF8DC4F2),
                ),
                width: double.infinity,
                child: ListTile(
                  title: const Text(
                    textAlign: TextAlign.center,
                    "Activities",
                    style: TextStyle(color: Constants.blackColor),
                  ),
                  subtitle: const Text(
                    textAlign: TextAlign.center,
                    "Add or Edit an Activity",
                    style: TextStyle(color: Constants.blackColor),
                  ),
                  trailing: IconButton(
                    icon: const Icon(
                      Icons.add,
                      color: Constants.blackColor,
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                            backgroundColor: Constants.purpleLight,
                            title: const Text(
                              'Add an Activity:',
                              style: TextStyle(color: Constants.blackColor),
                            ),
                            content: SizedBox(
                              width: 500,
                              child: Tasks(),
                            )),
                      );
                    },
                  ),
                  leading: const Icon(Icons.task),
                ),
              ),
            ),
          ),
          const TasksList(),
        ],
      ),
    );
  }
}
