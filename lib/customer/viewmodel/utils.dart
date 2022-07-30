import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:picco/services/log_service.dart';

extension ExtendedWidget on Widget {
  Expanded addExpanded([int flex = 1]) {
    return Expanded(child: this,flex: flex,);
  }
}

extension OnTapWidgets on Widget {
  GestureDetector onTap({function}) {
    return GestureDetector(
      onTap: function,
      child: this,
    );
  }
}

extension ElevationWidgets on Widget {
  Material putElevation({elevation, radius}) {
    return Material(
      elevation: elevation,
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
      child: this,
    );
  }
}

extension OnTapInkwellWidgets on Widget {
  Material onTapInkwell({function}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        splashColor: Colors.grey.withOpacity(0.1),
        splashFactory: InkRipple.splashFactory,
        child: this,
      ),
    );
  }
}

extension ElevationOffsetWidgets on Widget {
  Container putElevationOffset({elevation, radius, x, y}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
              offset: Offset(x, y), color: Colors.grey, blurRadius: elevation),
        ],
      ),
      child: this,
    );
  }
}

class Permissions {
  static Future<bool> getDirectoryPermission() async {
    if (!await Permission.storage.isGranted) {
      await Permission.storage.request();
    }

    return Permission.storage.isGranted;
  }

  static Future<Position> getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
  }
}

class TextFieldCheckError {
  static errorText(TextEditingController controller, bool isPhoneNumber,
      bool isConfirmPassword,
      [errorConfirmPassword = false]) {
    Log.d(controller.text);
    if (controller.text.trim().toString().isEmpty) {
      return "Не может быть пустым";
    } else if (isPhoneNumber && (controller.text.trim().length != 17)) {
      return "Пожалуйста, введите полностью";
    } else if (isConfirmPassword && errorConfirmPassword) {
      return "Ошибка подтверждения пароля";
    }
    return null;
  }

  static errorBorder(TextEditingController controller) {
    if (controller.text.trim().isNotEmpty) {
      return Colors.grey;
    }
    return Colors.red;
  }
}
