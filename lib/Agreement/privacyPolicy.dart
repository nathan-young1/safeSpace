import 'package:flutter/material.dart';
import 'package:safeSpace/Styles/textStyle.dart';

class PrivacyPolicy extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RichText(text: TextSpan(
        children: <TextSpan>[
          TextSpan(text: '''
          Privacy Policy for Safe Space

At Safe Space, one of our main priorities is the privacy of our visitors.

/*If you have additional questions or require more information about our Privacy Policy, do not hesitate to contact us through email at Safespace@Website.com*/

This privacy policy applies to the use of this application. This policy is not applicable to any information collected offline or via channels other than this application.

Consent

By using our Safe Space, you hereby consent to our Privacy Policy and agree to its terms.

Information we collect

When you register for an Account, we may ask for your contact information, including items such as name, email address, and telephone number.

How we use your contact Information

Provide, operate, and maintain safe space

Develop new products, services, features, and functionality

Communicate with you, either directly or through one of our partners, including for customer service, to provide you with updates and other information relating to safe space, and for marketing and promotional purposes

Send you emails

Find and prevent fraud



Your Vault Key

Your vault key is not stored on our database, you and only you know it, this key is used to encrypt any data you store in the vault ,therefore store it securely. In the event you forget this key you can still retrieve account under the following circumstances:

• You are logged into the account from another device.
• You enabled biometric authentication on your local device.

Otherwise you have lost total access to all those data, because they can only be decrypted with your vault key.

Encryption
Safe Space takes the security of your info as our top priority that is why all your data is encrypted with AES(Advanced Encryption Standard) 256 using your master passwords making it impossible for your data to be compromised without your master password, even in the highly unlikely event of our database being hacked.


What is AES
AES is the Advanced Encryption Standard, a standard for cryptography that is used to encrypt data to keep it private. It is a popular cypher algorithm, used even by the US Government to keep classified data secure.


AES is a symmetric, block cipher which means that blocks of text of a certain size (256 bits) are encrypted, as opposed to a stream cipher where each character is encrypted one at a time. The symmetric part refers to that the identical key is used for the encryption process, as well as to decrypt the message.

Read more at https://en.wikipedia.org/wiki/Advanced_Encryption_Standard''')
        ],style: listTextStyle
        ))
    );
  }
}