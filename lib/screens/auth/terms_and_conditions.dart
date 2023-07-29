import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:refrij_app/utilities/constants.dart';

class TermsAndConditionsSignUpPage extends StatefulWidget {
  const TermsAndConditionsSignUpPage({Key? key}) : super(key: key);

  @override
  State<TermsAndConditionsSignUpPage> createState() =>
      _TermsAndConditionsSignUpPageState();
}

class _TermsAndConditionsSignUpPageState
    extends State<TermsAndConditionsSignUpPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              FontAwesomeIcons.angleLeft,
              color: kBrownColor,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 100.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  //TOP SECTION
                  SizedBox(
                    height: 30.0,
                  ),
                  Icon(
                    FontAwesomeIcons.solidNoteSticky,
                    color: kPinkColor,
                    size: MediaQuery.of(context).size.width * 0.30,
                  ),
                  SizedBox(
                    height: 40.0,
                  ),
                  Text(
                    "Welcome to Refrij! By signing up and using our services, you agree to the following terms and conditions:  \n\nEligibility: You must be at least 17 years old to use our services. If you are under 17, you may not use our services.\n\nRegistration: To use our services, you must create an account with us. You agree to provide accurate and complete information when registering.\n\nUser Content: You are responsible for all content you upload, post, or otherwise transmit on our platform. You represent and warrant that you own or have the necessary licenses, rights, consents, and permissions to use and authorize us to use all patent, trademark, trade secret, copyright, or other proprietary rights in and to any and all User Content.\n\nProhibited Content: You may not upload, post, or otherwise transmit any User Content that is illegal, defamatory, abusive, harassing, threatening, harmful, vulgar, obscene, or otherwise objectionable or that infringes on any intellectual property or other rights of any third party.\n\nMonitoring: We reserve the right, but not the obligation, to monitor any User Content on our platform and remove any content that violates these Terms and Conditions.\n\nPrivacy: We are committed to protecting your privacy. Please read our Privacy Policy to understand how we collect, use, and protect your personal information.\n\nIntellectual Property: Our platform and its contents, including but not limited to text, graphics, images, logos, and software, are the property of our company and are protected by copyright, trademark, and other intellectual property laws.\n\nTermination: We reserve the right to terminate your account or restrict your access to our services at any time without notice or liability for any reason, including but not limited to a violation of these Terms and Conditions.\n\nIndemnification: You agree to indemnify and hold us harmless from any and all claims, damages, liabilities, costs, and expenses, including attorney fees, arising out of or in connection with your use of our services or any User Content you upload, post, or otherwise transmit on our platform.\n\nDisclaimer: We make no representations or warranties of any kind, express or implied, about the completeness, accuracy, reliability, suitability, or availability with respect to our platform or the information, products, services, or related graphics contained on our platform for any purpose.\n\nLimitation of Liability: In no event shall we be liable for any direct, indirect, incidental, special, or consequential damages arising out of or in connection with your use of our services or inability to use our services.\n\nGoverning Law: These Terms and Conditions shall be governed by and construed in accordance with the laws of the jurisdiction in which our company is registered.\n\nThank you for using Refrij!",
                    style: TextStyle(
                      fontFamily: 'Dosis Regular',
                      fontSize: 16.0,
                      color: kBlackColor,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
