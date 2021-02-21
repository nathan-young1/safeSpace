import 'package:flutter/material.dart';
import 'package:safeSpace/Styles/fontSize.dart';
import 'package:safeSpace/Styles/textStyle.dart';

class PrivacyPolicy extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RichText(text: TextSpan(
        text: 'privacy',
        children: <TextSpan>[
        ],style: TextStyle(fontSize: RFontSize.normal)
        ))
    );
  }
}

// Privacy Policy for Safe Space

// At Safe Space, one of our main priorities is the privacy of our users.

// If you have additional questions or require more information about our Privacy Policy, do not hesitate to contact us through email at 
// Safespace.web@gmail.com/*Safespace@Website.com*/

// This privacy policy applies to the use of this application. This policy is not applicable to any information collected offline or via channels other than this application. This privacy policy can be change at any time , all existing users will be notified of the change ,if you keep using this app after the change Safe Space assumes that you comply with the change.

// Consent

// By using our Safe Space, you hereby consent to our Privacy Policy and agree to its terms of service.

// Information we collect

// Registration Data:

// When you register for an Account, we may ask for your contact information, including items such as name, email address, and telephone number.

// Billing Data:

// We use third party service providers (currently google play store) to process payment made through the app. We do not receive any or store any billing data when you pay for a subscription.

// Vault Key:

// To create an account you must create a “Vault Key” this is used for encrypting the information you store in the app (Encrypted data as will be further discussed below). So the more secure your Vault Key is, the more secure your data will be. This is because, in the event of a hacker obtaining the data in our server, they would have to hack each account separately (Because your data is encrypted based on your Vault Key). Safe Space employs a zero knowledge system to ensure that we do not know your Vault Key, in other words we cannot access secured data. Your Vault key is not stored anywhere on our servers. So you are advised to store it securely and do not share it with anyone else.

// Encrypted Data:

// Safe space helps you manage sensitive information like passwords, Payment details , documents e.t.c. This and everything else you store in the app is encrypted with your Vault key before it is stored on the servers. All data is encrypted at all times with the Vault key making it accessible to you and only you.

// Your Contact Information

// We use this information to:

// ⦁	Provide, operate, and maintain safe space

// ⦁	Develop new products, services, features, and functionality

// ⦁	Communicate with you, either directly or through one of our partners, including for customer service, to provide you with updates and other information relating to safe space, and for marketing and promotional purposes

// ⦁	Send you emails

// ⦁	Find and prevent fraud



// Your Vault Key

// Your vault key is not stored on our database, you and only you know it, this key is used to encrypt any data you store in the vault ,therefore store it securely. In the event you forget this key you can still retrieve account under the following circumstances:

// • You are logged into the account from another device.
// • You enabled biometric authentication on your local device.

// Otherwise you have lost total access to all those data, because they can only be decrypted with your vault key.

// Encryption
// Safe Space takes the security of your info as our top priority that is why all your data is encrypted with AES(Advanced Encryption Standard) 256 bits using your master passwords making it impossible for your data to be compromised without your master password, even in the highly unlikely event of our database being hacked.


// What is AES
// AES is the Advanced Encryption Standard, a standard for cryptography that is used to encrypt data to keep it private. It is a popular cypher algorithm, used even by the US Government to keep classified data secure.


// AES is a symmetric, block cipher which means that blocks of text of a certain size (256 bits) are encrypted, as opposed to a stream cipher where each character is encrypted one at a time. The symmetric part refers to that the identical key is used for the encryption process, as well as to decrypt the message.
