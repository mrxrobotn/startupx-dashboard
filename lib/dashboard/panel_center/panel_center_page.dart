import 'package:flutter/material.dart';
import '../../constants.dart';
import '../charts.dart';

class PanelCenterPage extends StatelessWidget {
  const PanelCenterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
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
                  color: const Color(0xFFe3e1d3),
                ),
                width: double.infinity,
                child: const ListTile(
                  title: Text(
                    "Investors",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Constants.blackColor),
                  ),
                  subtitle: Text(
                    "The Investors created by the organizations",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Constants.blackColor),
                  ),
                  trailing: Icon(Icons.monetization_on),
                ),
              ),
            ),
          ),
          const InvestorsList(),
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
                  color: const Color(0xFF8DC4F2),
                ),
                width: double.infinity,
                child: const ListTile(
                  title: Text(
                    "Activities",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Constants.blackColor),
                  ),
                  subtitle: Text(
                    "The Activities created by the organizations",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Constants.blackColor),
                  ),
                  trailing: Icon(Icons.task),
                ),
              ),
            ),
          ),
          const TaskList(),
        ],
      ),
    );
  }
}
