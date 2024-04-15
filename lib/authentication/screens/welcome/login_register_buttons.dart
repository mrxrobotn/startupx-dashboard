import 'package:flutter/material.dart';
import 'package:startupx/authentication/screens/signup/signup_org_form.dart';

import '../../components/rounded_button.dart';
import '../signin/signin_screen.dart';
import '../signup/signup_screen.dart';

class LoginRegisterButtons extends StatelessWidget {
  const LoginRegisterButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const Text(
            "Welcome",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
          ),

          const SizedBox(
            height: 20,
          ),

          //Lets write another widget for rounded button & use here and in other screens
          RoundedButton(
              label: "SIGN IN",
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SignInScreen()),
                    (route) => false);
              }),

          const SizedBox(
            height: 10,
          ),

          RoundedButton(
              label: "SIGN UP",
              onPressed: () {
                //We will write code here to open sign up screen
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SignUpScreen()),
                    (route) => false); //Now lets check
              }),

          const SizedBox(
            height: 10,
          ),

          RoundedButton(
              label: "SIGN UP ORGANIZATION",
              onPressed: () {
                //We will write code here to open sign up screen
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SignUpOrgForm()),
                    (route) => false); //Now lets check
              }),
        ],
      ),
    );
  }
}
