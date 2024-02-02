import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class Qrcode_page extends StatefulWidget {
  String? phoneNumber;
  final String email;
  final String? displayName;
  final String? profilePicture;
  Qrcode_page(
      {Key? key,
      required this.email,
      this.phoneNumber,
      this.profilePicture,
      this.displayName})
      : super(key: key);

  @override
  State<Qrcode_page> createState() => _Qrcode_pageState();
}

class _Qrcode_pageState extends State<Qrcode_page> {
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
            Text("Scann the QR -code to get information",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                )),
            SizedBox(height: 100),
            Center(
              child: QrImageView(
                data: widget.phoneNumber == "null"
                    ? 'Full name : ${widget.displayName} \nEmail: ${widget.email}'
                    : 'Full name : ${widget.displayName} \nEmail: ${widget.email}\nPhone Number:${widget.phoneNumber}',
                version: QrVersions.auto,
                size: 320,
                gapless: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
