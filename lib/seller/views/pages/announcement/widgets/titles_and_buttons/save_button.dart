import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:picco/seller/views/pages/announcement/widgets/pagesView_bodies/4-address_page/provider.dart';
import 'package:picco/services/color_service.dart';
import 'package:picco/services/log_service.dart';
import 'package:provider/provider.dart';

class SaveButton extends StatelessWidget {
  const SaveButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AddressPageProvider>(
      builder: (context, provider, child) {

        final onPressed = (provider.street.isNotEmpty &&
            addressPageProvider.lng != 0.0 &&
            addressPageProvider.lat != 0.0)
            ? () {
                provider.updateButtonDisability(false);
                Navigator.pop(context, false);
              }
            : null;

        return Container(
          color: Colors.white,
          child: MaterialButton(
            minWidth: double.infinity,
            height: 45.h,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            color: ColorService.main,
            splashColor: Colors.white54,
            textColor: Colors.white,
            child: const Text(
              'Сохранить',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: onPressed,
          ),
        );
      },
    );
  }
}
