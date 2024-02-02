import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:form_field_validator/form_field_validator.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:local_auth/local_auth.dart';
import 'package:loginoption_forgetpassword/module/widget/home_screen.dart';
import 'package:loginoption_forgetpassword/module/widget/password_process/forget_process_1.dart';
import 'package:loginoption_forgetpassword/module/widget/profileInfo.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final LocalAuthentication auth = LocalAuthentication();
  _SupportState _supportState = _SupportState.unknown;
  bool? _canCheckBiometrics;
  List<BiometricType>? _availableBiometrics;
  String _authorized = 'Not Authorized';
  bool _isAuthenticating = false;
  Future<void> forceCrash() async {
    FirebaseCrashlytics.instance.crash();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    auth.isDeviceSupported().then(
          (bool isSupported) => setState(() => _supportState = isSupported
              ? _SupportState.supported
              : _SupportState.unsupported),
        );
    _checkBiometrics();
    _getAvailableBiometrics();
  }

  Future<void> _checkBiometrics() async {
    late bool canCheckBiometrics;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      canCheckBiometrics = false;
      print(e);
    }
    if (!mounted) {
      return;
    }

    setState(() {
      _canCheckBiometrics = canCheckBiometrics;
      print('Can check biometrics: $_canCheckBiometrics\n');
    });
  }

  Future<void> _getAvailableBiometrics() async {
    late List<BiometricType> availableBiometrics;
    try {
      availableBiometrics = await auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      availableBiometrics = <BiometricType>[];
      print(e);
    }
    if (!mounted) {
      return;
    }

    setState(() {
      _availableBiometrics = availableBiometrics;
      print("available biometrics ${_availableBiometrics}");
    });
  }

  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating';
      });
      authenticated = await auth.authenticate(
        localizedReason: 'Let OS determine authentication method',
        options: const AuthenticationOptions(
          stickyAuth: true,
        ),
      );
      setState(() {
        _isAuthenticating = false;
      });
    } on PlatformException catch (e) {
      print(e);
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Error - ${e.message}';
      });
      return;
    }
    if (!mounted) {
      return;
    }

    setState(
        () => _authorized = authenticated ? 'Authorized' : 'Not Authorized');
  }

  Future<void> _authenticateWithBiometrics() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating';
      });
      authenticated = await auth.authenticate(
        localizedReason:
            'Scan your fingerprint (or face or whatever) to authenticate',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Authenticating';
      });
    } on PlatformException catch (e) {
      print(e);
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Error - ${e.message}';
      });
      return;
    }
    if (!mounted) {
      return;
    }

    final String message = authenticated ? 'Authorized' : 'Not Authorized';
    setState(() {
      _authorized = message;
    });
  }

  Future<void> _cancelAuthentication() async {
    await auth.stopAuthentication();
    setState(() => _isAuthenticating = false);
  }

  String? email;
  String? password;
  String? emailErrorMessage;
  String? passwordErrorMessage;
  void validateForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (email == 'omartaamallah4@gmail.com' && password == '1234') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => ProfilePage(
                    email: email!,
                  )),
        );
      } else {
        setState(() {
          emailErrorMessage = 'Incorrect email';
          passwordErrorMessage = 'Incorrect password';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          toolbarHeight: 10,
          bottom: TabBar(
            labelColor: Color(0xff648ddb),
            indicatorColor: Color(0xff648ddb),
            tabs: [
              Tab(
                text: 'Login',
              ),
              Tab(text: 'Sign Up'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // First Tab: Login
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 5, bottom: 5),
                        child: Text("Your email"),
                        alignment: Alignment.topLeft,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter your email";
                          } else if (value != "omartaamallah4@gmail.com") {
                            return emailErrorMessage;
                          }
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          hintText: 'Enter your email',
                        ),
                        onSaved: (value) {
                          email = value;
                        },
                      ),
                      SizedBox(height: 16.0),
                      Container(
                        margin: EdgeInsets.only(left: 5, bottom: 5),
                        child: Text("Password"),
                        alignment: Alignment.topLeft,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter your password";
                          } else if (value != "1234") {
                            return passwordErrorMessage;
                          }
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          hintText: 'Enter your password',
                          suffixIcon: IconButton(
                            icon: Icon(Icons.visibility),
                            onPressed: () {},
                          ),
                        ),
                        obscureText: true,
                        onSaved: (value) {
                          password = value;
                        },
                      ),
                      SizedBox(height: 16.0),
                      SizedBox(height: 16.0),
                      Align(
                        alignment: Alignment.topRight,
                        child: TextButton(
                          onPressed: () {
                            // Navigate to forget password process1
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => forgetPwdPage1()),
                            );
                          },
                          child: Text.rich(
                            TextSpan(
                              text: 'Forget Password? ',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 124, 158, 220)),
                            ),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xff648ddb),
                          minimumSize: const Size.fromHeight(50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          //forceCrash();
                          validateForm();
                        },
                        child: Text(
                          'Login',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Row(
                        children: [
                          SizedBox(
                            height: 100,
                          ),
                          Flexible(
                            child: Divider(
                              indent: MediaQuery.of(context).size.width * .1,
                              endIndent:
                                  MediaQuery.of(context).size.width * .05,
                              color: Color.fromARGB(255, 188, 188, 188),
                              height: 10,
                            ),
                          ),
                          Text(
                            "or",
                            style: TextStyle(
                                color: Color.fromARGB(255, 188, 188, 188)),
                          ),
                          Flexible(
                            child: Divider(
                              indent: MediaQuery.of(context).size.width * .05,
                              endIndent: MediaQuery.of(context).size.width * .1,
                              color: Color.fromARGB(255, 188, 188, 188),
                              height: 10,
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            minimumSize: const Size.fromHeight(50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            )),
                        onPressed: () async {
                          final GoogleSignInAccount? gUser =
                              await GoogleSignIn().signIn();

                          final GoogleSignInAuthentication gAuth =
                              await gUser!.authentication;
                          final credential = GoogleAuthProvider.credential(
                            accessToken: gAuth.accessToken,
                            idToken: gAuth.idToken,
                          );
                          await FirebaseAuth.instance
                              .signInWithCredential(credential)
                              .then((value) {
                            if (FirebaseAuth.instance.currentUser != null) {
                              //create a logic if the email is omartaamallah4@gmail.com go to welcome screen if not go to welcomescreen withn the email the user will sign in with
                              print(
                                  "Info=====${FirebaseAuth.instance.currentUser!.email}");
                              print(
                                  "Info=====${FirebaseAuth.instance.currentUser!.displayName}");
                              print(
                                  "Info=====${FirebaseAuth.instance.currentUser!.phoneNumber}");
                              print(
                                  "Info=====${FirebaseAuth.instance.currentUser!.photoURL}");
                              print(
                                  "Info=====${FirebaseAuth.instance.currentUser!.metadata}");
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProfilePage(
                                          email:
                                              "${FirebaseAuth.instance.currentUser!.email}",
                                          DisplayName:
                                              "${FirebaseAuth.instance.currentUser!.displayName}",
                                          profilePicture:
                                              "${FirebaseAuth.instance.currentUser!.photoURL}",
                                          phoneNumber:
                                              "${FirebaseAuth.instance.currentUser!.phoneNumber}",
                                        )),
                              );
                            }
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Image(
                                image: AssetImage("assets/google_logo.png"),
                                height: 25.0,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: Text(
                                  'Login with Google',
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      //finger print and faceId authentification
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Row(
                            children: [
                              SizedBox(
                                height: 100,
                              ),
                              Flexible(
                                child: Divider(
                                  indent:
                                      MediaQuery.of(context).size.width * .1,
                                  endIndent:
                                      MediaQuery.of(context).size.width * .05,
                                  color: Color.fromARGB(255, 188, 188, 188),
                                  height: 10,
                                ),
                              ),
                              Text(
                                "or",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 188, 188, 188)),
                              ),
                              Flexible(
                                child: Divider(
                                  indent:
                                      MediaQuery.of(context).size.width * .05,
                                  endIndent:
                                      MediaQuery.of(context).size.width * .1,
                                  color: Color.fromARGB(255, 188, 188, 188),
                                  height: 10,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.fingerprint,
                                size: 50,
                              ),
                              Icon(
                                Icons.tag_faces_sharp,
                                size: 50,
                              ),
                              Icon(
                                Icons.pin_outlined,
                                size: 50,
                              )
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                minimumSize: const Size.fromHeight(50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                            onPressed: () async {
                              _authenticate().then((value) {
                                if (_authorized == "Authorized") {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => HomeScreen(),
                                      ));
                                }
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(left: 5),
                                    child: Text(
                                      'Login with fingerPrint | faceId | Code Pin',
                                      style: TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          // ElevatedButton(
                          //   onPressed: () {
                          //     _authenticate().then((value) {
                          //       if (_authorized == "Authorized") {
                          //         Navigator.push(
                          //             context,
                          //             MaterialPageRoute(
                          //               builder: (_) => HomeScreen(),
                          //             ));
                          //       }
                          //     });
                          //   },
                          //   child: Row(
                          //     mainAxisSize: MainAxisSize.min,
                          //     children: <Widget>[
                          //       Text('Login with '),
                          //       const Icon(Icons.fingerprint),
                          //       Text('or faceId '),
                          //       const Icon(Icons.tag_faces_sharp)
                          //     ],
                          //   ),
                          // ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),

            // Second Tab: Sign Up
            Center(
              child: Text('Signup'),
            ),
          ],
        ),
      ),
    );
  }
}

enum _SupportState {
  unknown,
  supported,
  unsupported,
}
