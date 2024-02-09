import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loginoption_forgetpassword/module/utils/user_auth/firebase_auth.dart';

import 'package:loginoption_forgetpassword/module/utils/user_auth/firebase_auth_services.dart';
import 'package:loginoption_forgetpassword/module/widget/home_screen.dart';
import 'package:loginoption_forgetpassword/module/widget/login/login.dart';
import 'package:loginoption_forgetpassword/module/widget/ui/form_container_widget.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  // final FirebaseAuthService _auth = FirebaseAuthService();

  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  bool isSigningUp = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Sign Up",
                style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 30,
              ),
              FormContainerWidget(
                controller: _usernameController,
                hintText: "Username",
                isPasswordField: false,
              ),
              SizedBox(
                height: 10,
              ),
              FormContainerWidget(
                controller: _emailController,
                hintText: "Email",
                isPasswordField: false,
              ),
              SizedBox(
                height: 10,
              ),
              FormContainerWidget(
                controller: _passwordController,
                hintText: "Password",
                isPasswordField: true,
              ),
              SizedBox(
                height: 10,
              ),
              FormContainerWidget(
                controller: _confirmPasswordController,
                hintText: "Confirm Password",
                isPasswordField: true,
              ),
              SizedBox(
                height: 10,
              ),
              FormContainerWidget(
                controller: _phoneNumberController,
                hintText: "PhoneNumber",
                isPasswordField: false,
              ),
              SizedBox(
                height: 30,
              ),
              GestureDetector(
                onTap: () {
                  // FirebaseAuthService().signUpWithEmailAndPassword(
                  //     _emailController.text, _passwordController.text);
                  _signUp();
                },
                child: Container(
                  width: double.infinity,
                  height: 45,
                  decoration: BoxDecoration(
                    color: Color(0xff648ddb),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                      child: isSigningUp
                          ? CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : Text(
                              "Sign Up",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            )),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account?"),
                  SizedBox(
                    width: 5,
                  ),
                  GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()),
                            (route) => false);
                      },
                      child: Text(
                        "Login",
                        style: TextStyle(
                            color: Color(0xff648ddb),
                            fontWeight: FontWeight.bold),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void _signUp() async {
    setState(() {
      isSigningUp = true;
    });

    String username = _usernameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;
    String confirmPassword = _confirmPasswordController.text;
    String phoneNumber = _phoneNumberController.text;

    if (password != confirmPassword) {
      showToast(message: "Passwords do not match");
      setState(() {
        isSigningUp = false;
      });
      return;
    }

    User? user = await FirebaseAuthHelper.registerUsingEmailPassword(
      name: username,
      email: email,
      password: password,
      phoneNumer: phoneNumber,
    );

    setState(() {
      isSigningUp = false;
    });

    if (user != null) {
      showToast(message: "User is successfully created");
      await FirebaseAuthHelper.signInUsingEmailPassword(
        email: _emailController.text,
        password: _passwordController.text,
      ).then((value) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => HomeScreen(
              DisplayName: username,
              email: email,
              phoneNumber: phoneNumber,
            ),
          ),
        );
      });
      // Navigator.pushNamed(context, "/home");
    } else {
      showToast(message: "Some error happened!!");
    }
  }
}
//register with phonenumber solution
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
// import 'package:loginoption_forgetpassword/module/utils/user_auth/firebase_auth.dart';

// import 'package:loginoption_forgetpassword/module/utils/user_auth/firebase_auth_services.dart';
// import 'package:loginoption_forgetpassword/module/widget/login/login.dart';
// import 'package:loginoption_forgetpassword/module/widget/ui/form_container_widget.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:intl/intl.dart';

// class SignUpPage extends StatefulWidget {
//   const SignUpPage({super.key});

//   @override
//   State<SignUpPage> createState() => _SignUpPageState();
// }

// class _SignUpPageState extends State<SignUpPage> {
//   // final FirebaseAuthService _auth = FirebaseAuthService();

//   TextEditingController _usernameController = TextEditingController();
//   TextEditingController _emailController = TextEditingController();
//   TextEditingController _passwordController = TextEditingController();
//   TextEditingController _phoneNumberController = TextEditingController();
//   bool condition1 = false;
//   bool condition2 = false;
//   String otpCode = "";

//   final SmsQuery _query = SmsQuery();
//   List<SmsMessage> _messages = [];

//   bool isSigningUp = false;
//   bool isAllNumbers(String value) {
//     final numericRegex = RegExp(r'^\d+$');
//     return numericRegex.hasMatch(value);
//   }

//   bool isDifferenceGreaterThanOneMinute(String messageDate) {
//     final dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
//     final messageDateTime = dateFormat.parse(messageDate);
//     final now = DateTime.now();

//     final difference = now.difference(messageDateTime);
//     final differenceInMinutes = difference.inMinutes;

//     return differenceInMinutes > 1;
//   }

//   retrieveSMS() async {
//     var permission = await Permission.sms.status;
//     if (permission.isGranted) {
//       final messages = await _query.querySms(
//         kinds: [
//           SmsQueryKind.inbox,
//           SmsQueryKind.sent,
//         ],
//         // address: '+254712345789',
//         count: 10,
//       );
//       debugPrint('sms inbox messages: ${messages.length}');
//       debugPrint('sms inbox messages content: ${messages.toString()}');
//       debugPrint('sms inbox messages body: ${messages[0].body}');
//       debugPrint('sms inbox messages sender: ${messages[0].sender}');
//       debugPrint('sms inbox messages date: ${messages[0].date}');

//       setState(() {
//         condition1 = isAllNumbers(messages[0].body.toString().substring(0, 6));
//         condition2 =
//             isDifferenceGreaterThanOneMinute(messages[0].date.toString());
//         if (condition1 == true && condition2 == false) {
//           otpCode = messages[0].body.toString().substring(0, 6);
//         }
//       });

//       setState(() => _messages = messages);
//     } else {
//       await Permission.sms.request();
//     }
//   }

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     retrieveSMS();
//   }

//   @override
//   void dispose() {
//     _usernameController.dispose();
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     Future.delayed(const Duration(milliseconds: 3000), () {
//       retrieveSMS();
//       print('ALL IS GOOD: $otpCode');
//       setState(() {});
//     });
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 15),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               "Sign Up",
//               style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(
//               height: 30,
//             ),
//             FormContainerWidget(
//               controller: _usernameController,
//               hintText: "Username",
//               isPasswordField: false,
//             ),
//             SizedBox(
//               height: 10,
//             ),
//             FormContainerWidget(
//               controller: _emailController,
//               hintText: "Email",
//               isPasswordField: false,
//             ),
//             SizedBox(
//               height: 10,
//             ),
//             FormContainerWidget(
//               controller: _passwordController,
//               hintText: "Password",
//               isPasswordField: true,
//             ),
//             SizedBox(
//               height: 10,
//             ),
//             FormContainerWidget(
//               controller: _phoneNumberController,
//               hintText: "PhoneNumber",
//               isPasswordField: false,
//             ),
//             SizedBox(
//               height: 30,
//             ),
//             GestureDetector(
//               onTap: () {
//                 // FirebaseAuthService().signUpWithEmailAndPassword(
//                 //     _emailController.text, _passwordController.text);
//                 _signUp();
//               },
//               child: Container(
//                 width: double.infinity,
//                 height: 45,
//                 decoration: BoxDecoration(
//                   color: Color(0xff648ddb),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Center(
//                     child: isSigningUp
//                         ? CircularProgressIndicator(
//                             color: Colors.white,
//                           )
//                         : Text(
//                             "Sign Up",
//                             style: TextStyle(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.bold),
//                           )),
//               ),
//             ),
//             SizedBox(
//               height: 20,
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text("Already have an account?"),
//                 SizedBox(
//                   width: 5,
//                 ),
//                 GestureDetector(
//                     onTap: () {
//                       Navigator.pushAndRemoveUntil(
//                           context,
//                           MaterialPageRoute(builder: (context) => LoginPage()),
//                           (route) => false);
//                     },
//                     child: Text(
//                       "Login",
//                       style: TextStyle(
//                           color: Color(0xff648ddb),
//                           fontWeight: FontWeight.bold),
//                     ))
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   void _signUp() async {
//     setState(() {
//       isSigningUp = true;
//     });

//     String username = _usernameController.text;
//     String email = _emailController.text;
//     String password = _passwordController.text;
//     String phoneNumber = _phoneNumberController.text;

//     User? user = await FirebaseAuthHelper().registerUsingEmailPassword(
//         name: username,
//         email: email,
//         password: password,
//         phoneNumer: phoneNumber,smsCode: otpCode);

//     setState(() {
//       isSigningUp = false;
//     });
//     if (user != null) {
//       showToast(message: "User is successfully created");
//       // Navigator.pushNamed(context, "/home");
//     } else {
//       showToast(message: "Some error happend!!");
//     }
//   }
// }