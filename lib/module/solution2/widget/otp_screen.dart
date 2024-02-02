import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:loginoption_forgetpassword/module/solution2/widget/white_container.dart';


import 'package:sms_autofill/sms_autofill.dart';

import '../utils/common_utils.dart';
import 'border_box.dart';
import 'home_screen.dart';

import 'package:permission_handler/permission_handler.dart';

class OtpScreen extends StatefulWidget {
  final String phone;

  const OtpScreen({Key? key, required this.phone}) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String otpCode = "";
  String otp = "";
  bool isLoaded = false;
  final FirebaseAuth auth = FirebaseAuth.instance;
  bool condition1 = false;
  bool condition2 = false;
  final SmsQuery _query = SmsQuery();
  List<SmsMessage> _messages = [];

  bool isAllNumbers(String value) {
    final numericRegex = RegExp(r'^\d+$');
    return numericRegex.hasMatch(value);
  }

  bool isDifferenceGreaterThanOneMinute(String messageDate) {
    final dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
    final messageDateTime = dateFormat.parse(messageDate);
    final now = DateTime.now();

    final difference = now.difference(messageDateTime);
    final differenceInMinutes = difference.inMinutes;

    return differenceInMinutes > 1;
  }

  retrieveSMS() async {
    var permission = await Permission.sms.status;
    if (permission.isGranted) {
      final messages = await _query.querySms(
        kinds: [
          SmsQueryKind.inbox,
          SmsQueryKind.sent,
        ],
        // address: '+254712345789',
        count: 10,
      );
      debugPrint('sms inbox messages: ${messages.length}');
      debugPrint('sms inbox messages content: ${messages.toString()}');
      debugPrint('sms inbox messages body: ${messages[0].body}');
      debugPrint('sms inbox messages sender: ${messages[0].sender}');
      debugPrint('sms inbox messages date: ${messages[0].date}');

      setState(() {
        condition1 = isAllNumbers(messages[0].body.toString().substring(0, 6));
        condition2 =
            isDifferenceGreaterThanOneMinute(messages[0].date.toString());
        if (condition1 == true && condition2 == false) {
          otpCode = messages[0].body.toString().substring(0, 6);
        }
      });

      setState(() => _messages = messages);
    } else {
      await Permission.sms.request();
    }
  }

  @override
  void initState() {
    _listenOtp();
    retrieveSMS();
    super.initState();
  }

  @override
  void dispose() {
    SmsAutoFill().unregisterListener();
    print("Unregistered Listener");
    super.dispose();
  }

  void _listenOtp() async {
    // await SmsAutoFill().
    await SmsAutoFill().listenForCode();
    print("OTP Listen is called");
  }

  static const MethodChannel _channel = const MethodChannel('sms_autofill');
  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 3000), () {
      retrieveSMS();
      print('ALL IS GOOD: $otpCode');
      setState(() {});
    });

    print('_messages: ${_messages.toString()}');
    return GestureDetector(
      onTap: () async => {
        await SmsAutoFill().listenForCode(),
        await _channel.invokeMethod('listenForCode', <String, String>{
          'smsCodeRegexPattern': '\\d{4,6}'
        }).then((value) => print('CODE from build: $value'))
      },
      child: ColorfulSafeArea(
        color: const Color(0xFF8C4A52),
        child: SafeArea(
          child: Scaffold(
            backgroundColor: isLoaded ? Colors.white : const Color(0xFF8C4A52),
            body: isLoaded
                ? const Center(child: CircularProgressIndicator())
                : CustomScrollView(
                    slivers: [
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.only(top: 50),
                              child: Container(
                                height: 50,
                              ),
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            WhiteContainer(
                              headerText: "Enter OTP",
                              labelText:
                                  "OTP has been successfully sent to your \n ${widget.phone}",
                              child: Container(
                                height: 70,
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  children: [
                                    PinFieldAutoFill(
                                      currentCode: otpCode,
                                      decoration: BoxLooseDecoration(
                                          radius: Radius.circular(12),
                                          strokeColorBuilder: FixedColorBuilder(
                                              Color(0xFF8C4A52))),
                                      codeLength: 6,
                                      onCodeChanged: (code) {
                                        print("OnCodeChanged : $code");
                                        otpCode = code.toString();
                                      },
                                      onCodeSubmitted: (val) {
                                        print("OnCodeSubmitted : $val");
                                      },
                                    )
                                    // Expanded(
                                    //   child: ListView.builder(
                                    //       itemCount: 6,
                                    //       scrollDirection: Axis.horizontal,
                                    //       itemBuilder: (context, index) {
                                    //         return BorderBox(
                                    //             width: 55,
                                    //             padding:
                                    //                 const EdgeInsets.symmetric(
                                    //                     horizontal: 21),
                                    //             margin: true,
                                    //             color: Colors.grey.shade200,
                                    //             child: TextFormField(
                                    //               textAlign: TextAlign.center,
                                    //               initialValue: null,
                                    //               keyboardType:
                                    //                   TextInputType.number,
                                    //               autofocus: true,
                                    //               inputFormatters: [
                                    //                 LengthLimitingTextInputFormatter(
                                    //                     1),
                                    //                 FilteringTextInputFormatter
                                    //                     .digitsOnly
                                    //               ],
                                    //               validator: (value) {
                                    //                 if (value!.isEmpty) {
                                    //                   return "?";
                                    //                 }
                                    //               },
                                    //               // maxLength: 1,
                                    //               onChanged: (value) {
                                    //                 if (value.length == 1) {
                                    //                   if (index < 5) {
                                    //                     FocusScope.of(context)
                                    //                         .nextFocus();
                                    //                   } else {
                                    //                     FocusScope.of(context)
                                    //                         .unfocus();
                                    //                   }
                                    //                 }
                                    //                 if (value.isEmpty) {
                                    //                   if (index > 0) {
                                    //                     FocusScope.of(context)
                                    //                         .previousFocus();
                                    //                     return;
                                    //                   }
                                    //                 }
                                    //                 otp += value;
                                    //                 if (index == 5) {
                                    //                   otpCode = otp;
                                    //                   otp = "";
                                    //                 }
                                    //               },
                                    //               style: const TextStyle(
                                    //                   fontSize: 19,
                                    //                   fontWeight:
                                    //                       FontWeight.w600),
                                    //               // textInputAction: TextInputAction.next,
                                    //               decoration: InputDecoration(
                                    //                   border: InputBorder.none,
                                    //                   hintText: "0",
                                    //                   hintStyle: TextStyle(
                                    //                       color: Colors
                                    //                           .grey.shade400)),
                                    //             ));
                                    //       }),
                                    // ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
            bottomNavigationBar: Container(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
              color: Colors.white,
              child: GestureDetector(
                onTap: () async {
                  print("OTP: $otpCode");
                  setState(() {
                    isLoaded = true;
                  });
                  try {
                    PhoneAuthCredential credential =
                        PhoneAuthProvider.credential(
                            verificationId: CommonUtils.verify,
                            smsCode: otpCode);
                    await auth.signInWithCredential(credential);
                    setState(() {
                      isLoaded = false;
                    });
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const HomeScreen()));
                  } catch (e) {
                    setState(() {
                      isLoaded = false;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Wrong OTP! Please enter again")));
                    print("Wrong OTP");
                  }
                },
                child: const BorderBox(
                  margin: false,
                  color: Color(0xFF8C4A52),
                  height: 50,
                  child: Text(
                    "Continue",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
