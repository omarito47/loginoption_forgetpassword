// import 'package:flutter/material.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:flutter_facebook_login/flutter_facebook_login.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class LoginPage extends StatefulWidget {
//   @override
//   _LoginPageState createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final GoogleSignIn _googleSignIn = GoogleSignIn();
//   final FacebookLogin _facebookLogin = FacebookLogin();
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text('Or'),
//             SizedBox(height: 20),
//             GoogleSignInButton(onPressed: _handleGoogleSignIn),
//             SizedBox(height: 20),
//             FacebookSignInButton(onPressed: _handleFacebookSignIn),
//           ],
//         ),
//       ),
//     );
//   }

//   void _handleGoogleSignIn() async {
//     try {
//       GoogleSignInAccount googleUser = await _googleSignIn.signIn();
//       GoogleSignInAuthentication googleAuth = await googleUser.authentication;
//       FirebaseUser user = await _auth.signInWithGoogle(
//         accessToken: googleAuth.accessToken,
//         idToken: googleAuth.idToken,
//       );
//       print('Signed in as ${user.displayName}');
//     } catch (error) {
//       print(error);
//     }
//   }

//   void _handleFacebookSignIn() async {
//     try {
//       final FacebookLoginResult result =
//           await _facebookLogin.logInWithReadPermissions(['email']);
//       if (result.status == FacebookLoginStatus.loggedIn) {
//         final AccessToken accessToken = result.accessToken;
//         final AuthCredential credential = FacebookAuthProvider.getCredential(
//           accessToken: accessToken.token,
//         );
//         FirebaseUser user =
//             await _auth.signInWithCredential(credential);
//         print('Signed in as ${user.displayName}');
//       }
//     } catch (error) {
//       print(error);
//     }
//   }
// }

// class GoogleSignInButton extends StatelessWidget {
//   final Function onPressed;

//   GoogleSignInButton({this.onPressed});

//   @override
//   Widget build(BuildContext context) {
//     return OutlineButton(
//       borderSide: BorderSide(color: Colors.black),
//       onPressed: onPressed,
//       child: Padding(
//         padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Image(
//               image: AssetImage("assets/google_logo.png"),
//               height: 25.0,
//             ),
//             Padding(
//               padding: const EdgeInsets.only(left: 10),
//               child: Text(
//                 'Sign in with Google',
//                 style: TextStyle(
//                   fontSize: 18,
//                   color: Colors.black,
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

// class FacebookSignInButton extends StatelessWidget {
//   final Function onPressed;

//   FacebookSignInButton({this.onPressed});

//   @override
//   Widget build(BuildContext context) {
//     return OutlineButton(
//       borderSide: BorderSide(color: Colors.black),
//       onPressed: onPressed,
//       child: Padding(
//         padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Image(
//               image: AssetImage("assets/facebook_logo.png"),
//               height: 25.0,
//             ),
//             Padding(
//               padding: const EdgeInsets.only(left: 10),
//               child: Text(
//                 'Sign in with Facebook',
//                 style: TextStyle(
//                   fontSize: 18,
//                   color: Colors.black,
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }