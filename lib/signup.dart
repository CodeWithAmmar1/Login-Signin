import 'package:animated_background/animated_background.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> with SingleTickerProviderStateMixin {
  TextEditingController text = TextEditingController();
  TextEditingController pass = TextEditingController();
  bool isloading = false;
  bool hide = false;
  loginFun(context) async {
    setState(() {
      isloading = true;
    });
    try {
      UserCredential credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: text.text,
        password: pass.text,
      );
      var snackBar = SnackBar(
        content: Text('The account is created ${credential.user!.email}'),
        backgroundColor: Colors.blue,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 6.0,
        duration: Duration(seconds: 2),
      );
      setState(() {
        isloading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        var snackBar = SnackBar(
          content: Text('The password provided is too weak.'),
          backgroundColor: Colors.blue,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 6.0,
          duration: Duration(seconds: 2),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        setState(() {
          isloading = false;
        });
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        var snackBar = SnackBar(
          content: Text('The account already exists for this email.'),
          backgroundColor: Colors.blue,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 6.0,
          duration: Duration(seconds: 2),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        setState(() {
          isloading = false;
        });
      } else {
        var snackBar = SnackBar(
          content: Text('${e.code}'),
          backgroundColor: Colors.blue,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 6.0,
          duration: Duration(seconds: 2),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        setState(() {
          isloading = false;
        });
      }
    } catch (e) {
      print(e);
      var snackBar = SnackBar(
        content: Text('error : ${e}'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      setState(() {
        isloading = false;
      });
    }
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
                  style: TextStyle(color: Colors.white, fontSize: 16),
                  controller: text,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide(color: Colors.blue, width: 3),
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(color: Colors.white, width: 2)),
                    label: Text(
                      "Email",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    prefixIcon: Icon(
                      Icons.email_outlined,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  style: TextStyle(color: Colors.white, fontSize: 18),
                  textAlign: TextAlign.start,
                  controller: pass,
                  obscureText: hide,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(color: Colors.blue, width: 3)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(color: Colors.white, width: 2)),
                    prefixIcon: Icon(
                      Icons.lock_open_outlined,
                      color: Colors.white,
                    ),
                    suffix: IconButton(
                        onPressed: () {
                          setState(() {
                            hide = !hide;
                          });
                        },
                        icon: Icon(
                          Icons.remove_red_eye_outlined,
                          color: Colors.white,
                        )),
                    label: Text(
                      "Password",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                isloading
                    ? CircularProgressIndicator(
                        color: Colors.blue,
                      )
                    : ElevatedButton(
                        onPressed: () {
                          loginFun(context);
                        },
                        child: Text(
                          "Sign Up",
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
