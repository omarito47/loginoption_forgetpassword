import 'package:flutter/material.dart';
import 'package:loginoption_forgetpassword/module/utils/services/firestore_service.dart';
import 'package:loginoption_forgetpassword/module/widget/login/login.dart';

import '../utils/common_utils.dart';

class HomeScreen extends StatefulWidget {
  String? phoneNumber;
  final String email;
  final String? DisplayName;
  // final String? profilePicture;
  HomeScreen(
      {Key? key,
      required this.email,
      required this.DisplayName,
      required this.phoneNumber})
      : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Map<String, dynamic> dataFromFirestore;

  Future<void> getphoneNumber() async {
    await firestoreHandler()
        .getDataFromFirestore(widget.DisplayName)
        .then((value) {
      dataFromFirestore = value[0] as Map<String, dynamic>;
      setState(() {
        widget.phoneNumber = dataFromFirestore["phoneNumber"];
      });
      print("valeur -------> ${dataFromFirestore["phoneNumber"]}");
    });
  }

  @override
  void initState() {
    getphoneNumber();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEBEEF0),
      appBar: AppBar(
        title: const Text("Welcome"),
        centerTitle: true,
        backgroundColor: const Color(0xff648ddb),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Welcome user",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 22),
            ),
            Text("Email : ${widget.email}"),
            Text("Name : ${widget.DisplayName}"),
            Text("PhoneNumber : ${widget.phoneNumber}"),
            const SizedBox(
              height: 60,
            ),
            GestureDetector(
              onTap: () async {
                await CommonUtils.firebaseSignOut();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Log out successfully!"),
                  ),
                );
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 32),
                width: MediaQuery.of(context).size.width * 0.4,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: const Color(0xff648ddb),
                ),
                child: const Center(
                  child: Text(
                    "Sign Out",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
