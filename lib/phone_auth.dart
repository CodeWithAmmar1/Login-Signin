import 'package:animated_background/animated_background.dart';
import 'package:app/otp_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PhoneAuth extends StatefulWidget {
  const PhoneAuth({super.key});

  @override
  State<PhoneAuth> createState() => _PhoneAuthState();
}

class _PhoneAuthState extends State<PhoneAuth>
    with SingleTickerProviderStateMixin {
  TextEditingController phone = TextEditingController();
  bool isloding = false;

  Phone_verify(BuildContext context) async {
    setState(() {
      isloding = true;
    });

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phone.text,
      verificationCompleted: (PhoneAuthCredential credential) {
        setState(() {
          isloding = false;
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        setState(() {
          isloding = false;
        });
        print("Verification failed: ${e.toString()}");

        String errorMessage =
            "Phone number verification failed. Please try again.";

        if (e.code == 'invalid-phone-number') {
          errorMessage =
              "The phone number entered is invalid. Please check the format.";
        } else if (e.code == 'too-many-requests') {
          errorMessage = "You've made too many requests. Try again later.";
        } else if (e.code == 'network-request-failed') {
          errorMessage = "Network error. Please check your connection.";
        } else {
          errorMessage = e.message ?? "An unknown error occurred.";
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
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          isloding = false;
        });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OtpScreen(
              verfication_id: verificationId,
            ),
          ),
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        setState(() {
          isloding = false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  controller: phone,
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
                      "Phone Number",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                isloding
                    ? CircularProgressIndicator(
                        color: Colors.blue,
                      )
                    : ElevatedButton(
                        onPressed: () async {
                          if (phone.text.isNotEmpty) {
                            Phone_verify(context);
                            setState(() {
                              phone.clear();
                            });
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    Text("Please enter a valid phone number"),
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
