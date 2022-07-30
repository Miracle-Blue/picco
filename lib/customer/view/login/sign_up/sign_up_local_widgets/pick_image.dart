import 'package:flutter/material.dart';

Container pickImage() {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: const CircleAvatar(
      radius: 50.5,
      backgroundColor: Colors.black,
      child: CircleAvatar(
        radius: 50,
        backgroundColor: Colors.white,
        child: Align(
          alignment: Alignment.bottomRight,
          child: CircleAvatar(
            radius: 12,
            backgroundColor: Colors.black,
            child: CircleAvatar(
              radius: 11,
              child: Text("+"),
              backgroundColor: Colors.white,
            ),
          ),
        ),
      ),
    ),
  );
}

Container pickedImage(image) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: CircleAvatar(
      radius: 50.5,
      backgroundColor: Colors.black,
      backgroundImage: FileImage(image),
    ),
  );
}
