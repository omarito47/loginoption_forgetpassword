import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:loginoption_forgetpassword/module/widget/password_process/forget_process_1.dart';
import 'package:loginoption_forgetpassword/module/widget/login/login.dart';
import 'package:loginoption_forgetpassword/module/utils/common_utils.dart';

import 'package:otp_autofill/otp_autofill.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:intl/intl.dart';

import '../../../main.dart';

class SmsVerificationPage extends StatefulWidget {
  final String verifyId;
  String phoneNumber;

  SmsVerificationPage(
      {Key? key, required this.verifyId, required this.phoneNumber})
      : super(key: key);

  @override
  State<SmsVerificationPage> createState() => _SmsVerificationPageState();
}

class _SmsVerificationPageState extends State<SmsVerificationPage>
    with SingleTickerProviderStateMixin {
  AnimationController? _animationController;
  int levelClock = 2 * 60;
  late final String signature;
  String otpCode = "";
  FirebaseAuth auth = FirebaseAuth.instance;
  late OTPTextEditController controller;
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
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: Duration(seconds: levelClock));

    _animationController!.forward();

    _listenSmsCode();
    retrieveSMS();
  }

  @override
  void dispose() {
    SmsAutoFill().unregisterListener();
    _animationController!.dispose();
    super.dispose();
  }

  _listenSmsCode() async {
    signature = await SmsAutoFill().getAppSignature;
    print("Signature: $signature");

    await SmsAutoFill().listenForCode().then((value) => null);
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 3000), () {
      retrieveSMS();
      print('ALL IS GOOD: $otpCode');
      setState(() {});
    });
    return Scaffold(
      backgroundColor: const Color(0xffF5F4FD),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => forgetPwdPage1()));
                  },
                  icon: Icon(Icons.arrow_back_ios_new)),
            ),
            SizedBox(
              height: 120,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "Check Your phone",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        "We sent a reset code to ",
                        style: TextStyle(color: Colors.grey),
                      ),
                      Text("${widget.phoneNumber}")
                    ],
                  ),
                  Text(
                    "enter 6 digits code that mentioned in the SMS",
                    style: TextStyle(color: Colors.grey),
                  )
                ],
              ),
            ),
            Center(
              child: PinFieldAutoFill(
                currentCode: otpCode,
                onCodeChanged: (p0) {
                  print("code ==>$p0");
                },
                codeLength: 6,
                autoFocus: true,
                decoration: UnderlineDecoration(
                  lineHeight: 2,
                  lineStrokeCap: StrokeCap.square,
                  bgColorBuilder: PinListenColorBuilder(
                      Colors.green.shade200, Colors.grey.shade200),
                  colorBuilder: const FixedColorBuilder(Colors.transparent),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Resend code after: "),
                Countdown(
                  animation: StepTween(
                    begin: levelClock, // THIS IS A USER ENTERED NUMBER
                    end: 0,
                  ).animate(_animationController!),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Color(0xff648ddb),
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () async {
                try {
                  PhoneAuthCredential credential = PhoneAuthProvider.credential(
                      verificationId: CommonUtils.verify, smsCode: otpCode);
                  await auth.signInWithCredential(credential);

                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => LoginPage()));
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Wrong OTP! Please enter again")));
                  print("Wrong OTP");
                }
              },
              child: Text(
                "Verify Code",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Countdown extends AnimatedWidget {
  Countdown({Key? key, required this.animation})
      : super(key: key, listenable: animation);
  Animation<int> animation;

  @override
  build(BuildContext context) {
    Duration clockTimer = Duration(seconds: animation.value);

    String timerText =
        '${clockTimer.inMinutes.remainder(60).toString()}:${clockTimer.inSeconds.remainder(60).toString().padLeft(2, '0')}';
    return Text(
      timerText,
      style: TextStyle(
        fontSize: 18,
        color: Color(0xff648ddb),
      ),
    );
  }
}
