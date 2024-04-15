import 'package:flutter/material.dart';

import '../../components/mobile_layout.dart';
import '../../components/responsivelayout.dart';
import '../../components/web_layout.dart';
import 'forgot_password_form.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
        webChild: WebLayout(
          imageWidget: Image.asset(
            "assets/images/forgot-password.png",
            width: 150,
          ),
          dataWidget:
              ForgotPasswordForm(), //Lets create widget for forgot password for & use here
        ),
        mobileChild: MobileLayout(
          imageWidget: Image.asset(
            "assets/images/forgot-password.png",
            width: 75,
          ),
          dataWidget: ForgotPasswordForm(),
        ));
  }
}
