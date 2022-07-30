import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:picco/customer/view/pages/search/detail_page.dart';
import 'package:picco/models/home_model.dart';
import 'package:picco/services/data_service.dart';

class DeepLinkHomePage extends StatelessWidget {
  final String productId;

  const DeepLinkHomePage({Key? key, required this.productId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection(FirestoreService.homesFolder)
            .doc("buy_houses")
            .collection("house")
            .doc(productId)
            .get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasData) {
            HomeModel homeModel = HomeModel.fromJson(
                snapshot.data!.data() as Map<String, dynamic>);
            return DetailPage(homeModel: homeModel);
          } else if (snapshot.hasError) {
            return const Center(child: Text("Error! Not Found"));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
