
import 'package:flutter/material.dart';
import 'package:picco/models/all_models.dart';
import 'package:picco/services/hive_service.dart';

class ProfileMainElement extends StatelessWidget {
  final ProfileModel element;

  const ProfileMainElement({Key? key, required this.element}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => element.id));
      },
      leading: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          color: const Color(0xffF2F2F2),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Icon(element.icon, size: 25, color: Colors.black),
      ),
      title: Text(element.text),
      trailing: const Icon(
        Icons.arrow_forward_ios_outlined,
        size: 17,
        color: Colors.black,
      ),
    );
  }
}
