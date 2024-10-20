import 'package:animated_background/animated_background.dart';
import 'package:app/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OtpScreen extends StatefulWidget {
  final String verfication_id;
  const OtpScreen({super.key, required this.verfication_id});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen>
    with SingleTickerProviderStateMixin {
  TextEditingController otp = TextEditingController();
  bool isLoading = false;

  Otp_verify(BuildContext context) async {
    setState(() {
      isLoading = true;
    });

    try {
      final credential = PhoneAuthProvider.credential(
          verificationId: widget.verfication_id, smsCode: otp.text);

      await FirebaseAuth.instance.signInWithCredential(credential);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Homepage()),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        isLoading = false;
      });

      String errorMessage = "An error occurred while verifying the OTP.";

      if (e.code == 'invalid-verification-code') {
        errorMessage = "The entered OTP is incorrect. Please try again.";
      } else if (e.code == 'session-expired') {
        errorMessage = "The OTP session has expired. Please request a new one.";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.blue,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 6.0,
          duration: Duration(seconds: 1),
        ),
      );
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to verify OTP. Please try again."),
          backgroundColor: Colors.blue,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 6.0,
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      body: Stack(children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/wall.jpg"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        AnimatedBackground(
          vsync: this,
          behaviour: RandomParticleBehaviour(
              options: ParticleOptions(
                  baseColor: Colors.blue,
                  spawnMaxRadius: 40,
                  spawnMaxSpeed: 40,
                  spawnMinSpeed: 15,
                  particleCount: 60,
                  spawnOpacity: 0.1)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  style: TextStyle(color: Colors.white, fontSize: 18),
                  controller: otp,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(color: Colors.blue, width: 2)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(color: Colors.white, width: 1)),
                    prefixIcon: Icon(
                      Icons.lock_open_outlined,
                      color: Colors.white,
                    ),
                    label: Text(
                      "Enter OTP",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                isLoading
                    ? CircularProgressIndicator(color: Colors.blue)
                    : ElevatedButton(
                        onPressed: () {
                          if (otp.text.isNotEmpty) {
                            Otp_verify(context);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Please enter the OTP"),
                                backgroundColor: Colors.blue,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                elevation: 6.0,
                                duration: Duration(seconds: 1),
                              ),
                            );
                          }
                        },
                        child: Text(
                          "Confirm",
                          style: TextStyle(fontSize: 20),
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                                vertical: 20, horizontal: 150)),
                      ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
