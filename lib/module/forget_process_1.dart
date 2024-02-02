import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loginoption_forgetpassword/module/forget_process_2.dart';
import 'package:loginoption_forgetpassword/module/solution2/utils/common_utils.dart';

import 'package:sms_autofill/sms_autofill.dart';

class forgetPwdPage1 extends StatefulWidget {
  const forgetPwdPage1({super.key});

  @override
  State<forgetPwdPage1> createState() => _forgetPwdPage1State();
}

class _forgetPwdPage1State extends State<forgetPwdPage1> {
  final phoneController = TextEditingController();

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 50),
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color.fromARGB(235, 233, 233, 233),
              ),
              child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back_ios_new)),
            ),
            SizedBox(height: 50),
            Container(
              margin: EdgeInsets.only(left: 5, bottom: 5),
              child: Text("Forgot password",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  )),
            ),
            SizedBox(height: 16.0),
            Container(
              margin: EdgeInsets.only(left: 5, bottom: 5),
              child: Text(
                'Enter your phone number to reset your password.',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            SizedBox(height: 16.0),
            Container(
              margin: EdgeInsets.only(left: 5, bottom: 5),
              child: Text("Your Phone Number"),
              alignment: Alignment.topLeft,
            ),
            TextField(
              controller: phoneController,
              decoration: InputDecoration(
                hintText: '+216 XXX XXXXX',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 16.0),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Color(0xff648ddb),
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () async {
                  var appSignature = await SmsAutoFill().getAppSignature;
                  await CommonUtils.firebasePhoneAuth(
                      phone: phoneController.text, context: context);
                  Future.delayed(const Duration(seconds: 3)).whenComplete(() {
                    setState(() {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SmsVerificationPage(
                                  verifyId: CommonUtils.verify,
                                  phoneNumber: phoneController.text)));
                      print("App Signature : $appSignature");
                    });
                  });
                },
                child: Text(
                  'Send code',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
