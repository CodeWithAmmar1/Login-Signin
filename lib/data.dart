import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Data extends StatefulWidget {
  const Data({super.key});

  @override
  State<Data> createState() => _DataState();
}

class _DataState extends State<Data> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  List prodata = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            children: [
              ElevatedButton(
                  onPressed: () async {
                    Map<String, dynamic> data = {
                      "productname": "watch",
                      "productprice": 300
                    };
                    await firestore.collection("product").add(data);
                  },
                  child: Text("Add")),
              ElevatedButton(
                  onPressed: () async {
                    var productData =
                        await firestore.collection("product").get();
                    setState(() {
                      prodata = productData.docs;
                    });
                  },
                  child: Text("get")),
            ],
          ),
          // ListView.builder(
          //   itemBuilder: (context, index) {},
          //   itemCount: 3,
          // )
        ],
      ),
    );
  }
}
