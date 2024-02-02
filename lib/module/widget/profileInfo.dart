import 'package:flutter/material.dart';
import 'package:loginoption_forgetpassword/module/widget/login/login.dart';
import 'package:loginoption_forgetpassword/module/widget/ui/qrcode.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ProfilePage extends StatefulWidget {
  final String? phoneNumber;
  final String email;
  final String? DisplayName;
  final String? profilePicture;
  const ProfilePage(
      {super.key,
      required this.email,
      this.DisplayName,
      this.profilePicture,
      this.phoneNumber});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Function to launch a URL
  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Color(0xff648ddb),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                      "${widget.profilePicture}") // Replace with your own image URL
                  ),
              SizedBox(height: 20),
              Text(
                '${widget.DisplayName}',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'Software Developer',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
              SizedBox(height: 20),
              Text(
                'About Me',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              // Padding(
              //   padding: const EdgeInsets.all(20.0),
              //   child: Text(
              //     'I\'m software developer in BiwamConsulting and I\'m student in Esprit higher school of engineering and my plan is to become a powerfull software engineer at the end of the my eductaion',
              //     textAlign: TextAlign.center,
              //     style: TextStyle(fontSize: 16),
              //   ),
              // ),
              SizedBox(
                height: 10,
              ),

              Icon(Icons.mail_outlined, size: 50),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  '${widget.email}',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Icon(Icons.phone, size: 50),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: widget.phoneNumber == "null"
                    ? Text(
                        'Phone number not available',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      )
                    : Text(
                        '${widget.phoneNumber}',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),
              ),
              Row(
                children: [
                  // Container(
                  //   margin: EdgeInsets.only(
                  //       left: MediaQuery.of(context).size.width * .25,
                  //       bottom: 10),
                  //   child: InkWell(
                  //     onTap: () {
                  //       launchUrl(Uri.parse(
                  //           'https://www.linkedin.com/in/omar-taamallah-54bb41225/'));
                  //     },
                  //     child: CircleAvatar(
                  //       radius: 30,
                  //       backgroundImage: AssetImage(
                  //           "assets/linkedIn.png"), // Replace with your own image URL
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(
                  //   width: 10,
                  // ),
                  // Container(
                  //   margin: EdgeInsets.only(bottom: 10),
                  //   child: InkWell(
                  //     onTap: () {
                  //       launchUrl(Uri.parse('https://github.com/omarito47'));
                  //     },
                  //     child: CircleAvatar(
                  //       radius: 30,
                  //       backgroundImage: AssetImage(
                  //           "assets/github.png"), // Replace with your own image URL
                  //     ),
                  //   ),
                  // ),
                  SizedBox(width: 10),
                  Container(
                    margin: EdgeInsets.only(
                        bottom: 10,
                        left: MediaQuery.of(context).size.width * .41),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => Qrcode_page(
                                      email: widget.email,
                                      displayName: widget.DisplayName,
                                      phoneNumber: widget.phoneNumber,
                                    )));
                      },
                      child: CircleAvatar(
                        backgroundColor: Colors.blue[50],
                        radius: 30,
                        backgroundImage: AssetImage(
                            "assets/qrcode.png"), // Replace with your own image URL
                      ),
                    ),
                  )
                ],
              ),

              SizedBox(
                width: MediaQuery.of(context).size.width * .8,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xff648ddb),
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Confirm Logout'),
                          content: Text('Are you sure you want to logout?'),
                          actions: [
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Color.fromARGB(
                                                  255, 250, 249, 248)),
                                    ),
                                    child: Text(
                                      'No',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(); // Close the dialog
                                    },
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Color(0xff648ddb)),
                                    ),
                                    child: Text('Yes'),
                                    onPressed: () {
                                      // Perform logout action here
                                      // ...
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => LoginPage()),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            )
                          ],
                        );
                      },
                    );
                  },
                  child: Text(
                    'Logout',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
