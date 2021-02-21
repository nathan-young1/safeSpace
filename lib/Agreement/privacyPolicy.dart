import 'package:flutter/material.dart';
import 'package:safeSpace/Core-Services/global.dart';
import 'package:safeSpace/Styles/fontSize.dart';
import 'package:safeSpace/Core-Services/screenUtilExtension.dart';
import 'package:velocity_x/velocity_x.dart';

class PrivacyPolicy extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
        leading: Padding(
          padding: (context.isMobileTypeHandset)?const EdgeInsets.all(0):const EdgeInsets.fromLTRB(8,0,0,0),
          child: IconButton(icon: Icon(Icons.arrow_back_ios,size: (context.isMobileTypeHandset)?30:19.w,color: Colors.black),
          onPressed: ()=> Navigator.of(context).pop()),
        ),
        title: Text('Privacy Policy',
        style: Theme.of(context).appBarTheme.textTheme.headline1),),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(12.r),
            child: Column(
              children: [
                Align(child: Image.asset('assets/images/SafeSpace.png',color: mainColor,height: 70.h,width: 70.w,fit: BoxFit.contain)),
                SizedBox(height: 15.h),
                Align(
                  child: Text('Privacy Policy',
                        style: TextStyle(
                          fontSize: RFontSize.medium,
                          fontWeight: FontWeight.bold
                        )
                      ),
                ),
                RichText(text: TextSpan(
                  children: <TextSpan>[
TextSpan(
  text: '''\nThis privacy policy applies any use of this application. This policy is not applicable to any information collected offline or via channels other than this application. This privacy policy may be change at any time , all existing users will be notified of the change ,if you keep using this app after the change Safe Space assumes that you comply with the changes.''',
style: TextStyle(
fontSize: RFontSize.normal,
)
),
TextSpan(
  text: '\n\nConsent:',
  style: TextStyle(
fontSize: RFontSize.normal,
fontWeight: FontWeight.bold
)
),
TextSpan(
  text: '''\nBy using our Safe Space, you hereby consent to our Privacy Policy and agree to its terms of service.''',
style: TextStyle(
fontSize: RFontSize.normal,
)
),
TextSpan(
  text: '''\n\nInformation we collect
\nRegistration Data: ''',
  style: TextStyle(
fontSize: RFontSize.normal,
fontWeight: FontWeight.bold
)
),
TextSpan(
text: '\nWhen you register for an Account, we may ask for your contact information, including items such as name, email address, and telephone number.',
style: TextStyle(
fontSize: RFontSize.normal,
)
),
TextSpan(
  text: '\n\nBilling Data:  ',
  style: TextStyle(
fontSize: RFontSize.normal,
fontWeight: FontWeight.bold
)
),
TextSpan(text: '\nWe use third party service providers (currently google play store) to process payment made through the app. We do not receive any or store any billing data when you pay for a subscription.',
style: TextStyle(
fontSize: RFontSize.normal,
)
),
TextSpan(
  text: '\n\nVault Key: ',
  style: TextStyle(
fontSize: RFontSize.normal,
fontWeight: FontWeight.bold
)
),
TextSpan(text: '\nTo create an account you must create a “Vault Key” this is used for encrypting the information you store in the app (Encrypted data as will be further discussed below). So the more secure your Vault Key is, the more secure your data will be. This is because, in the event of a hacker obtaining the data in our server, they would have to hack each account separately (Because your data is encrypted based on your Vault Key). Safe Space employs a zero knowledge system to ensure that we do not know your Vault Key, in other words we cannot access secured data. Your Vault key is not stored anywhere on our servers. So you are advised to store it securely and do not share it with anyone else.',
style: TextStyle(
fontSize: RFontSize.normal,
)),
TextSpan(
  text: '\n\nEncrypted Data: ',
  style: TextStyle(
fontSize: RFontSize.normal,
fontWeight: FontWeight.bold
)
),
TextSpan(text: '\nSafe space helps you manage sensitive information like passwords, Payment details , documents e.t.c. This and everything else you store in the app is encrypted with your Vault key before it is stored on the servers. All data is encrypted at all times with the Vault key making it accessible to you and only you.',
style: TextStyle(
fontSize: RFontSize.normal,
)),
TextSpan(
  text: '\n\nYour Contact Information: ',
  style: TextStyle(
fontSize: RFontSize.normal,
fontWeight: FontWeight.bold
)
),
TextSpan(text: '''\n\nWe use this information to:
\n⦁	Provide, operate, and maintain safe space.
⦁	Develop new products, services, features, and functionality.
⦁	Communicate with you, either directly or through one of our partners, including for customer service, to provide you with updates and other information relating to safe space, and for marketing and promotional purposes.
⦁	Send you emails.
⦁	Find and prevent fraud.
''',
style: TextStyle(
fontSize: RFontSize.normal,
)
),
TextSpan(
  text: '\n\nVault Key: ',
  style: TextStyle(
fontSize: RFontSize.normal,
fontWeight: FontWeight.bold
)
),
TextSpan(text: '''\n\nYour vault key is not stored on our database, you and only you know it, this key is used to encrypt any data you store in the vault ,therefore store it securely. In the event you forget this key you can still retrieve account under the following circumstances:

• You are logged into the account from another device.

Otherwise you have lost total access to all those data, because they can only be decrypted with your vault key.
''',
style: TextStyle(
fontSize: RFontSize.normal,
)
),
TextSpan(
  text: '\n\nEncryption: ',
  style: TextStyle(
fontSize: RFontSize.normal,
fontWeight: FontWeight.bold
)
),
TextSpan(text: '''\n\nSafe Space takes the security of your info as our top priority that is why all your data is encrypted with AES(Advanced Encryption Standard) 256 bits using your master passwords making it impossible for your data to be compromised without your master password, even in the highly unlikely event of our database being hacked.''',
style: TextStyle(
fontSize: RFontSize.normal,
)),
TextSpan(
  text: '\n\nWhat is AES ',
  style: TextStyle(
fontSize: RFontSize.normal,
fontWeight: FontWeight.bold
)
),
TextSpan(text: '''\n\nAES is the Advanced Encryption Standard, a standard for cryptography that is used to encrypt data to keep it private. It is a popular cypher algorithm, used even by the US Government to keep classified data secure.
AES is a symmetric, block cipher which means that blocks of text of a certain size (256 bits) are encrypted, as opposed to a stream cipher where each character is encrypted one at a time. The symmetric part refers to that the identical key is used for the encryption process, as well as to decrypt the message.'''
,style: TextStyle(
fontSize: RFontSize.normal,
)),
TextSpan(
text: '''\n\n\n\nIf you have an inquiry to make, do not hesitate to contact us through email at safespace.web@gmail.com''',
style: TextStyle(
fontSize: RFontSize.normal,
fontWeight: FontWeight.bold
)
),
        ],style: TextStyle(fontSize: RFontSize.normal,color: Colors.black)
        )),
    ],
  ),
),
        )
      ),
    );
  }
}

