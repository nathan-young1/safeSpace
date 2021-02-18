import 'package:flutter/material.dart';
import 'package:safeSpace/Styles/textStyle.dart';

class TermsOfService extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: RichText(text: TextSpan(
          children: <TextSpan>[
            TextSpan(text: 'Terms and Conditions',style: listTextStyle),
            TextSpan(text: 'Welcome to Safe Space!'),

TextSpan(text: 'These terms and conditions outline the rules and regulations for the use of this application.'),

TextSpan(text: '''By using this application we assume you accept these terms and conditions. Do not continue to use Safe Space if you do not agree to take all of the terms and conditions stated on this page.

The following terminology applies to these Terms and Conditions, Privacy Statement and Disclaimer Notice and all Agreements: “Client”, “You” and “Your” refers to you, the person using this application and compliant to the Company's terms and conditions. “The Company”, “Ourselves”, “We”, “Our” and “Us”, refers to our Safe Space. “Party”, “Parties”, or “Us”, refers to both the Client and ourselves. Any use of the above terminology or other words in the singular, plural, capitalization and/or he/she or they, are taken as interchangeable and therefore as referring to same.'''),

TextSpan(text: '''License
Unless otherwise stated, Safe Space and/or its licensors own the intellectual property rights for all material on Safe Space. All intellectual property rights are reserved.
You must not:'''),

TextSpan(text: 'Republish material from Safe Space'),
TextSpan(text: '''
Sell, rent or sub-license material from Safe Space
Reproduce, duplicate, reverse engineer or copy material from Safe Space
Redistribute content from Safe Space
This Agreement shall begin on the date hereof.'''),


TextSpan(text: 'Reservation of Rights'),
TextSpan(text: '''
We reserve the right to update our terms of service whenever we see it fit to do so, existing users will be notified via email in the event of any update to this document.

We reserve the right to enhance, upgrade, improve, or modify features of our Services as we see fit. ''')

          ]
          )),
      )
    );
  }
}