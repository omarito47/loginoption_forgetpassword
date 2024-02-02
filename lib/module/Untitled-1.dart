// // import 'package:flutter/material.dart';

// // class forget_pwd_process2 extends StatefulWidget {
// //   const forget_pwd_process2({super.key});

// //   @override
// //   State<forget_pwd_process2> createState() => _forget_pwd_process2State();
// // }

// // class _forget_pwd_process2State extends State<forget_pwd_process2> {
// //   final _formKey = GlobalKey<FormState>();
// //   late String _resetCode;

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Reset Code'),
// //       ),
// //       body: Form(
// //         key: _formKey,
// //         child: Column(
// //           children: <Widget>[
// //             Text('A reset code has been sent to +216 99 999 999'),
// //             TextFormField(
// //               decoration: InputDecoration(
// //                 labelText: 'Enter 5 digit code',
// //               ),
// //               validator: (value) {
// //                 if (value!.length != 5) {
// //                   return 'The code must be 5 digits';
// //                 }
// //                 return null;
// //               },
// //               onSaved: (value) => _resetCode = value!,
// //             ),
// //             ElevatedButton(
// //               onPressed: () {
// //                 if (_formKey.currentState!.validate()) {
// //                   _formKey.currentState!.save();
// //                   // TODO: Verify the reset code
// //                 }
// //               },
// //               child: Text('Verify Code'),
// //             ),
// //             ElevatedButton(
// //               onPressed: () {
// //                 // TODO: Resend the reset code
// //               },
// //               child: Text('Haven\'t got the sms yet? Resend sms'),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:forget_password_process/main.dart';
// import 'package:android_sms_retriever/android_sms_retriever.dart';
// import 'package:otp_autofill/otp_autofill.dart';
// import 'package:pinput/pinput.dart';

// class forget_pwd_process2 extends StatefulWidget {
//   String phoneNumber;
//   final String verifyId;
//   forget_pwd_process2(
//       {super.key, required this.phoneNumber, required this.verifyId});

//   @override
//   State<forget_pwd_process2> createState() => _forget_pwd_process2State();
// }

// class _forget_pwd_process2State extends State<forget_pwd_process2> {
//   final _formKey = GlobalKey<FormState>();
//   late String _resetCode;
//   FirebaseAuth auth = FirebaseAuth.instance;
//   final resetCodeController1 = TextEditingController();
//   final resetCodeController2 = TextEditingController();
//   final resetCodeController3 = TextEditingController();
//   final resetCodeController4 = TextEditingController();
//   final resetCodeController5 = TextEditingController();
//   final resetCodeController6 = TextEditingController();
//   String _smsCode = "";
//   late OTPTextEditController controller;
//   late OTPInteractor _otpInteractor;

//   bool correct = false;
//   String? verifyId;
//   Future<void> _initInteractor() async {
//     _otpInteractor = OTPInteractor();

//     // You can receive your app signature by using this method.
//     final appSignature = await _otpInteractor.getAppSignature();

//     if (kDebugMode) {
//       print('Your app signature: $appSignature');
//     }
//   }

//   @override
//   void initState() {
//     //phoneAuth();
//     // TODO: implement initState
//     super.initState();

//     _initInteractor();
//     controller = OTPTextEditController(
//       codeLength: 6,
//       //ignore: avoid_print
//       onCodeReceive: (code) {
//         print('Your Application receive code - $code');
//         setState(() {
//           controller.text = code;
//         });
//       },
//       otpInteractor: _otpInteractor,
//     )..startListenUserConsent(
//         (code) {
//           final exp = RegExp(r'(\d{6})');
//           return exp.stringMatch(code ?? '') ?? '';
//         },
//       );
//   }

//   @override
//   void dispose() {
//     controller.stopListen();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Reset Code'),
//       ),
//       body: Form(
//         key: _formKey,
//         child: Column(
//           children: <Widget>[
//             Text('A reset code has been sent to ${widget.phoneNumber}'),
//             SizedBox(height: 20),
//             TextFormField(
//               controller: controller,
//               decoration: InputDecoration(
//                 labelText: 'Enter 6 digit code',
//               ),
//             ),
//             // Row(
//             //   children: [
//             //     SizedBox(width: 20),
//             //     textFieldCode(resetCodeController: resetCodeController1),
//             //     textFieldCode(resetCodeController: resetCodeController2),
//             //     textFieldCode(resetCodeController: resetCodeController3),
//             //     textFieldCode(resetCodeController: resetCodeController4),
//             //     textFieldCode(resetCodeController: resetCodeController5),
//             //     textFieldCode(resetCodeController: resetCodeController6),
//             //   ],
//             // ),
//             SizedBox(height: 10),
//             ElevatedButton(
//               onPressed: () async {
//                 // Update the UI - wait for the user to enter the SMS code
//                 String smsCode = 'xxxx';

//                 PhoneAuthCredential credential = PhoneAuthProvider.credential(
//                     verificationId: widget.verifyId, smsCode: controller.text);

//                 // Sign the user in (or link) with the credential
//                 await auth.signInWithCredential(credential);
//                 if (auth.currentUser != null) {
//                   Navigator.push(context,
//                       MaterialPageRoute(builder: (context) => MyApp()));
//                 }
//               },
//               child: Text('Verify Code'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class textFieldCode extends StatelessWidget {
//   const textFieldCode({
//     super.key,
//     required this.resetCodeController,
//   });

//   final TextEditingController resetCodeController;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 56,
//       height: 56,
//       margin: EdgeInsets.only(bottom: 16.0, right: 7),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.grey),
//       ),
//       child: DecoratedBox(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: TextFormField(
//           maxLength: 1,
//           controller: resetCodeController,
//           decoration: InputDecoration(
//             border: InputBorder.none,
//             contentPadding: EdgeInsets.all(12.0),
//           ),
//           validator: (value) {
//             if (value == null || value.isEmpty) {
//               return 'Please enter some text';
//             }
//             return null;
//           },
//         ),
//       ),
//     );
//   }
// }

// class SampleStrategy extends OTPStrategy {
//   @override
//   Future<String> listenForCode() {
//     return Future.delayed(
//       const Duration(seconds: 4),
//       () => 'Your code is 543213',
//     );
//   }
// }
// //solution 2
// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:pin_code_fields/pin_code_fields.dart';
// class PinCodeVerificationScreen extends StatefulWidget {
//   const PinCodeVerificationScreen({
//     Key? key,
//     this.phoneNumber,
//   }) : super(key: key);

//   final String? phoneNumber;

//   @override
//   State<PinCodeVerificationScreen> createState() =>
//       _PinCodeVerificationScreenState();
// }

// class _PinCodeVerificationScreenState extends State<PinCodeVerificationScreen> {
//   TextEditingController textEditingController = TextEditingController();
//   // ..text = "123456";

//   // ignore: close_sinks
//   StreamController<ErrorAnimationType>? errorController;

//   bool hasError = false;
//   String currentText = "";
//   final formKey = GlobalKey<FormState>();

//   @override
//   void initState() {
//     errorController = StreamController<ErrorAnimationType>();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     errorController!.close();

//     super.dispose();
//   }

//   // snackBar Widget
//   snackBar(String? message) {
//     return ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message!),
//         duration: const Duration(seconds: 2),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.amber,
//       body: GestureDetector(
//         onTap: () {},
//         child: SizedBox(
//           height: MediaQuery.of(context).size.height,
//           width: MediaQuery.of(context).size.width,
//           child: ListView(
//             children: <Widget>[
//               const SizedBox(height: 30),
              
//               const SizedBox(height: 8),
//               const Padding(
//                 padding: EdgeInsets.symmetric(vertical: 8.0),
//                 child: Text(
//                   'Phone Number Verification',
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//               Padding(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8),
//                 child: RichText(
//                   text: TextSpan(
//                     text: "Enter the code sent to ",
//                     children: [
//                       TextSpan(
//                         text: "${widget.phoneNumber}",
//                         style: const TextStyle(
//                           color: Colors.black,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 15,
//                         ),
//                       ),
//                     ],
//                     style: const TextStyle(
//                       color: Colors.black54,
//                       fontSize: 15,
//                     ),
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//               const SizedBox(
//                 height: 20,
//               ),
//               Form(
//                 key: formKey,
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(
//                     vertical: 8.0,
//                     horizontal: 30,
//                   ),
//                   child: PinCodeTextField(
//                     appContext: context,
//                     pastedTextStyle: TextStyle(
//                       color: Colors.green.shade600,
//                       fontWeight: FontWeight.bold,
//                     ),
//                     length: 6,
//                     obscureText: true,
//                     obscuringCharacter: '*',
//                     obscuringWidget: const FlutterLogo(
//                       size: 24,
//                     ),
//                     blinkWhenObscuring: true,
//                     animationType: AnimationType.fade,
//                     validator: (v) {
//                       if (v!.length < 3) {
//                         return "I'm from validator";
//                       } else {
//                         return null;
//                       }
//                     },
//                     pinTheme: PinTheme(
//                       shape: PinCodeFieldShape.box,
//                       borderRadius: BorderRadius.circular(5),
//                       fieldHeight: 50,
//                       fieldWidth: 40,
//                       activeFillColor: Colors.white,
//                     ),
//                     cursorColor: Colors.black,
//                     animationDuration: const Duration(milliseconds: 300),
//                     enableActiveFill: true,
//                     errorAnimationController: errorController,
//                     controller: textEditingController,
//                     keyboardType: TextInputType.number,
//                     boxShadows: const [
//                       BoxShadow(
//                         offset: Offset(0, 1),
//                         color: Colors.black12,
//                         blurRadius: 10,
//                       )
//                     ],
//                     onCompleted: (v) {
//                       debugPrint("Completed");
//                     },
//                     // onTap: () {
//                     //   print("Pressed");
//                     // },
//                     onChanged: (value) {
//                       debugPrint(value);
//                       setState(() {
//                         currentText = value;
//                       });
//                     },
//                     beforeTextPaste: (text) {
//                       debugPrint("Allowing to paste $text");
//                       //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
//                       //but you can show anything you want here, like your pop up saying wrong paste format or etc
//                       return true;
//                     },
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 30.0),
//                 child: Text(
//                   hasError ? "*Please fill up all the cells properly" : "",
//                   style: const TextStyle(
//                     color: Colors.red,
//                     fontSize: 12,
//                     fontWeight: FontWeight.w400,
//                   ),
//                 ),
//               ),
//               const SizedBox(
//                 height: 20,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Text(
//                     "Didn't receive the code? ",
//                     style: TextStyle(color: Colors.black54, fontSize: 15),
//                   ),
//                   TextButton(
//                     onPressed: () => snackBar("OTP resend!!"),
//                     child: const Text(
//                       "RESEND",
//                       style: TextStyle(
//                         color: Color(0xFF91D3B3),
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16,
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//               const SizedBox(
//                 height: 14,
//               ),
//               Container(
//                 margin:
//                     const EdgeInsets.symmetric(vertical: 16.0, horizontal: 30),
//                 child: ButtonTheme(
//                   height: 50,
//                   child: TextButton(
//                     onPressed: () {
//                       formKey.currentState!.validate();
//                       // conditions for validating
//                       if (currentText.length != 6 || currentText != "123456") {
//                         errorController!.add(ErrorAnimationType
//                             .shake); // Triggering error shake animation
//                         setState(() => hasError = true);
//                       } else {
//                         setState(
//                           () {
//                             hasError = false;
//                             snackBar("OTP Verified!!");
//                           },
//                         );
//                       }
//                     },
//                     child: Center(
//                       child: Text(
//                         "VERIFY".toUpperCase(),
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 decoration: BoxDecoration(
//                     color: Colors.green.shade300,
//                     borderRadius: BorderRadius.circular(5),
//                     boxShadow: [
//                       BoxShadow(
//                           color: Colors.green.shade200,
//                           offset: const Offset(1, -2),
//                           blurRadius: 5),
//                       BoxShadow(
//                           color: Colors.green.shade200,
//                           offset: const Offset(-1, 2),
//                           blurRadius: 5)
//                     ]),
//               ),
//               const SizedBox(
//                 height: 16,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   Flexible(
//                     child: TextButton(
//                       child: const Text("Clear"),
//                       onPressed: () {
//                         textEditingController.clear();
//                       },
//                     ),
//                   ),
//                   Flexible(
//                     child: TextButton(
//                       child: const Text("Set Text"),
//                       onPressed: () {
//                         setState(() {
//                           textEditingController.text = "123456";
//                         });
//                       },
//                     ),
//                   ),
//                 ],
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
