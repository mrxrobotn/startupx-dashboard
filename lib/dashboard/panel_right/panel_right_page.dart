import 'package:flutter/material.dart';

import '../../constants.dart';
import '../charts.dart';

class PanelRightPage extends StatefulWidget {
  const PanelRightPage({super.key});

  @override
  _PanelRightPageState createState() => _PanelRightPageState();
}

class _PanelRightPageState extends State<PanelRightPage> {
  Future getTotalNumberOfUsers() async {
    var snapshot = await countriesCollRef.get();
    return snapshot.docs
        .fold(0, (total, document) => document['users'].length + total);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
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
                    color: const Color(0xFFe1d3e3),
                  ),
                  width: double.infinity,
                  child: const ListTile(
                    title: Text(
                      "Organizations",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Constants.blackColor),
                    ),
                    subtitle: Text(
                      "The list of registered Organizations",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Constants.blackColor),
                    ),
                    trailing: Icon(Icons.account_balance),
                  ),
                ),
              ),
            ),
            const OrgsList(),
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
                    color: const Color(0xFFE1D340),
                  ),
                  width: double.infinity,
                  child: ListTile(
                    title: const Text(
                      "Number of Entrepreneurs:",
                      style: TextStyle(color: Constants.blackColor),
                    ),
                    subtitle: const Text(
                      "by country",
                      style: TextStyle(color: Constants.blackColor),
                    ),
                    trailing: FutureBuilder(
                      future: getTotalNumberOfUsers(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }
                        if (!snapshot.hasData) {
                          return const LinearProgressIndicator();
                        }
                        return Chip(
                            backgroundColor: Constants.listileColor,
                            label: Text(
                              'Total: ${snapshot.data}',
                              style:
                                  const TextStyle(color: Constants.blackColor),
                            ));
                      },
                    ),
                  ),
                ),
              ),
            ),
            CountryTable(),
          ],
        ),
      ),
    );
  }
}
