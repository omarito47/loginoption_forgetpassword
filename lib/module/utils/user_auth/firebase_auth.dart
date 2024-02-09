import 'package:firebase_auth/firebase_auth.dart';
import 'package:loginoption_forgetpassword/module/utils/services/firestore_service.dart';

class FirebaseAuthHelper {
  static Future<User?> registerUsingEmailPassword({
    required String phoneNumer,
    required String name,
    required String email,
    required String password,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    print('phone = $phoneNumer');
    await firestoreHandler()
        .saveDataToFirestore(name, {"phoneNumber": "$phoneNumer"});

    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      user = userCredential.user;
      await user!.updateProfile(displayName: name);
      await user.updatePhoneNumber(phoneNumer as PhoneAuthCredential);
      await user.reload();
      user = auth.currentUser;
      print("user-info: ${user}");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }

    return user;
  }

  static Future<User?> signInUsingEmailPassword({
    required String email,
    required String password,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided.');
      }
    }

    return user;
  }
}
//register with phone number solution
///import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:intl/intl.dart';

// class FirebaseAuthHelper {
//   final SmsQuery _query = SmsQuery();
//   List<SmsMessage> _messages = [];
//   bool condition1 = false;
//   bool condition2 = false;
//   String otpCode = "";
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

//   Future<void> retrieveSMS() async {
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

//       condition1 = isAllNumbers(messages[0].body.toString().substring(0, 6));
//       condition2 =
//           isDifferenceGreaterThanOneMinute(messages[0].date.toString());
//       if (condition1 == true && condition2 == false) {
//         otpCode = messages[0].body.toString().substring(0, 6);
//       }

//       _messages = messages;
//     } else {
//       await Permission.sms.request();
//     }
//   }

//   Future<User?> registerUsingEmailPassword(
//       {required String phoneNumer,
//       required String name,
//       required String email,
//       required String password,
//       String? smsCode}) async {
//     FirebaseAuth auth = FirebaseAuth.instance;
//     User? user;
//     otpCode = smsCode!;
//     //await retrieveSMS();
//     try {
//       UserCredential userCredential = await auth.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );

//       user = userCredential.user;
//       await user!.updateProfile(displayName: name);
//       // await user.updatePhoneNumber(phoneNumer as PhoneAuthCredential);
//       FirebaseAuth.instance.verifyPhoneNumber(
//         phoneNumber: phoneNumer,
//         timeout: const Duration(minutes: 2),
//         verificationCompleted: (credential) async {
//           await (await auth.currentUser)?.updatePhoneNumber(credential);
//           // either this occurs or the user needs to manually enter the SMS code
//         },
//         verificationFailed: (error) {
//           print('Verification Failed ${error.code}: ${error.message}');
//         },
//         codeSent: (verificationId, [forceResendingToken]) async {
//           String smsCode;
//           // get the SMS code from the user somehow (probably using a text field)
//           final credential = PhoneAuthProvider.credential(
//               verificationId: verificationId, smsCode: otpCode);
//           await (FirebaseAuth.instance.currentUser)
//               ?.updatePhoneNumber(credential);
//         },
//         codeAutoRetrievalTimeout: (verificationId) {
//           print('Time out $verificationId');
//         },
//       );
//       await user.reload();
//       user = auth.currentUser;
//       print("user-info: ${user}");
//     } on FirebaseAuthException catch (e) {
//       if (e.code == 'weak-password') {
//         print('The password provided is too weak.');
//       } else if (e.code == 'email-already-in-use') {
//         print('The account already exists for that email.');
//       }
//     } catch (e) {
//       print(e);
//     }

//     return user;
//   }

//   static Future<User?> signInUsingEmailPassword({
//     required String email,
//     required String password,
//   }) async {
//     FirebaseAuth auth = FirebaseAuth.instance;
//     User? user;

//     try {
//       UserCredential userCredential = await auth.signInWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//       user = userCredential.user;
//     } on FirebaseAuthException catch (e) {
//       if (e.code == 'user-not-found') {
//         print('No user found for that email.');
//       } else if (e.code == 'wrong-password') {
//         print('Wrong password provided.');
//       }
//     }

//     return user;
//   }
// }










