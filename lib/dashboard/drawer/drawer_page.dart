import 'package:flutter/material.dart';
import 'package:startupx/dashboard/drawer/settings_page.dart';
import '../../authentication/screens/signin/signin_screen.dart';
import '../../authentication/services/authentication_service.dart';
import '../../constants.dart';

class DrawerPage extends StatefulWidget {
  const DrawerPage({super.key});

  @override
  _DrawerPageState createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
  var tilePadding = const EdgeInsets.only(left: 8, right: 8, top: 4);
  var drawerTextColor = const TextStyle(color: Constants.blackColor);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0,
      child: Column(
        children: [
          const DrawerHeader(
            child: Icon(
              Icons.home,
              size: 100,
            ),
          ),
          Padding(
            padding: tilePadding,
            child: GestureDetector(
              child: ListTile(
                leading: const Icon(Icons.settings),
                title: Text(
                  'S E T T I N G S',
                  style: drawerTextColor,
                ),
              ),
              onTap: () {
                showDialog<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return const AlertDialog(
                      title: Text('Settings'),
                      content: SettingsPage(),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: tilePadding,
            child: GestureDetector(
              child: ListTile(
                leading: const Icon(Icons.info),
                title: Text(
                  'A B O U T',
                  style: drawerTextColor,
                ),
              ),
              onTap: () {},
            ),
          ),
          Padding(
            padding: tilePadding,
            child: GestureDetector(
              child: ListTile(
                leading: const Icon(Icons.logout),
                title: Text(
                  'L O G O U T',
                  style: drawerTextColor,
                ),
              ),
              onTap: () {
                AuthenticationService().signOut().then((value) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SignInScreen()),
                  );
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
