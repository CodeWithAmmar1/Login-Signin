import 'package:animated_background/animated_background.dart';
import 'package:app/homepage.dart';
import 'package:app/phone_auth.dart';
import 'package:app/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin {
  TextEditingController text = TextEditingController();
  TextEditingController pass = TextEditingController();
  bool isloading = false;
  bool isExpanded = false;
  bool isExpand = false;
  bool hide = false;

  loginFun(context) async {
    setState(() {
      isloading = true;
    });
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: text.text, password: pass.text);

      var snackBar = SnackBar(
        content: Text('The account is login ${credential.user!.email}'),
        backgroundColor: Colors.blue,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 6.0,
        duration: Duration(seconds: 1),
      );

      setState(() {
        isloading = false;
        text.clear();
        pass.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Future.delayed(snackBar.duration, () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Homepage()),
        );
      });
      ;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        var snackBar = SnackBar(
          content: Text('No user found for that email.'),
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
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        var snackBar = SnackBar(
          content: Text('User not exist.'),
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
      } else if (e.code == 'invalid-credential') {
        print('Wrong password provided for that user.');
        var snackBar = SnackBar(
          content: Text('User not exist.'),
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
                          "login",
                          style: TextStyle(fontSize: 20),
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                                vertical: 20, horizontal: 150)),
                      ),
                Row(
                  children: [
                    Text(
                      "Did not have account? ? ",
                      style: TextStyle(color: Colors.white),
                    ),
                    Builder(
                      builder: (context) => TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Signup()));
                          },
                          child: Text(
                            "SIGN UP",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )),
                    )
                  ],
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      isExpand = !isExpand;
                    });
                    Future.delayed(Duration(milliseconds: 500), () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => PhoneAuth()));
                      setState(() {
                        isExpand = false;
                      });
                    });
                  },
                  child: AnimatedContainer(
                    margin: EdgeInsets.all(20),
                    width: isExpand ? 330 : 310,
                    height: isExpand ? 55 : 50,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.blue.shade800,
                      ),
                    ),
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    child: Animate(
                      effects: [
                        FadeEffect(delay: 500.ms),
                        SlideEffect(curve: Curves.easeIn, delay: 5.ms)
                      ],
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ClipOval(
                            child: Image.asset(
                              'assets/phone_icon.png',
                              width: 30,
                              height: 30,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            "Login with Phone Number",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      isExpanded = !isExpanded;
                    });
                    Future.delayed(Duration(milliseconds: 500), () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => PhoneAuth()));
                      setState(() {
                        isExpanded = false;
                      });
                    });
                  },
                  child: AnimatedContainer(
                    margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                    width: isExpanded ? 330 : 310,
                    height: isExpanded ? 55 : 50,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.blue.shade800,
                      ),
                    ),
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    child: Animate(
                      effects: [
                        FadeEffect(delay: 500.ms),
                        SlideEffect(curve: Curves.easeIn, delay: 5.ms)
                      ],
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ClipOval(
                            child: Image.asset(
                              'assets/google_icon.png',
                              width: 30,
                              height: 30,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            "Login with Google Account",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
