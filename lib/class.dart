import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ClassWork extends StatefulWidget {
  const ClassWork({super.key});

  @override
  State<ClassWork> createState() => _ClassWorkState();
}

class _ClassWorkState extends State<ClassWork> {
  TextEditingController text = TextEditingController();
  final ImagePicker picker = ImagePicker();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  XFile? currentImage;
  String? downloadurl;
  void pickImageFromGallery() async {
    currentImage = await picker.pickImage(source: ImageSource.gallery);
    setState(() {});
  }

  void pickImageFromCamera() async {
    currentImage = await picker.pickImage(source: ImageSource.camera);
    setState(() {});
  }

  addProduct() async {
    if (downloadurl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please select an image."),
        ),
      );
      return;
    }
    Map<String, dynamic> data = {
      "Name": "${text.text}",
      "Image": "$downloadurl",
    };
    await firestore.collection("info").add(data);
    setState(() {});
  }

  uploadToFirebase() async {
    var file = File(currentImage!.path);
    try {
      var date = DateTime.now();
      final storageRef = FirebaseStorage.instance.ref();
      final mountainImagesRef = storageRef.child("images/product_${date}.jpg");

      if (kIsWeb) {
        var imageData = await currentImage!.readAsBytes();
        await mountainImagesRef.putData(imageData);
      } else {
        var file = File(currentImage!.path);
        await mountainImagesRef.putFile(file);
      }
      var imageurl = await mountainImagesRef.getDownloadURL();

      setState(() {
        downloadurl = imageurl;
      });
    } catch (e) {
      print("this is error $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 40,
          ),
          if (currentImage != null || text.text.isNotEmpty) ...[
            ElevatedButton(
                onPressed: () {
                  if (currentImage == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Please select an image."),
                      ),
                    );
                    return;
                  }

                  if (text.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Please enter a title."),
                      ),
                    );
                    return;
                  }
                  uploadToFirebase();
                  addProduct();
                  text.clear();
                  currentImage = null;
                  setState(() {});
                },
                child: Text("Upload")),
            if (currentImage != null) ...[
              Text("${currentImage!.name}"),
              CircleAvatar(
                radius: 75,
                backgroundImage: kIsWeb
                    ? NetworkImage(currentImage!.path)
                    : FileImage(File(currentImage!.path)) as ImageProvider,
              ),
            ],
          ],
          SizedBox(
            height: 20,
          ),
          TextField(
            controller: text,
            decoration: InputDecoration(hintText: "Add title"),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () {
                    pickImageFromCamera();
                    setState(() {});
                  },
                  child: Text("Camera")),
              SizedBox(
                width: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    pickImageFromGallery();
                    setState(() {});
                  },
                  child: Text("Gallery"))
            ],
          ),
          SizedBox(
            height: 30,
          ),
          StreamBuilder<QuerySnapshot>(
            stream: firestore.collection('info').snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                final data = snapshot.data!.docs;
                return Expanded(
                  child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (BuildContext context, int index) {
                      var order = data[index];
                      return Container(
                        margin: EdgeInsets.all(10),
                        height: 100,
                        width: 400,
                        decoration: BoxDecoration(
                          color: Colors.green.shade200,
                          borderRadius: BorderRadius.all(
                            Radius.circular(25),
                          ),
                          border: Border.all(color: Colors.green, width: 2),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    radius: 25,
                                    backgroundImage:
                                        NetworkImage(order['Image']),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Text(
                                      "Name: ${order['Name']}",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () async {
                                try {
                                  await firestore
                                      .collection("info")
                                      .doc(order.id)
                                      .delete();
                                } catch (e) {
                                  print("Error deleting document: $e");
                                }
                              },
                              icon: Icon(
                                Icons.delete,
                                color: Colors.black,
                                size: 30,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              } else {
                return Center(child: Text("No orders found."));
              }
            },
          ),
        ],
      ),
    );
  }
}
