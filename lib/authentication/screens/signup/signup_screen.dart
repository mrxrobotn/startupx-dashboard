import 'package:flutter/material.dart';
import 'package:startupx/authentication/screens/signup/signup_form.dart';

import '../../components/mobile_layout.dart';
import '../../components/responsivelayout.dart';
import '../../components/web_layout.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      webChild: WebLayout(
        imageWidget: Image.asset(
          "assets/images/signup.png",
          width: 150,
        ),

        dataWidget:
            SignUpForm(), //Lets define widget for Sign up form & use here
      ),
      mobileChild: MobileLayout(
        imageWidget: Image.asset(
          "assets/images/signup.png",
          width: 75,
        ),
        dataWidget: SignUpForm(),
      ),
    );
  }
}
