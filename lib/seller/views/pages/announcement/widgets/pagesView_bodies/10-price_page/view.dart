import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:picco/seller/views/pages/announcement/widgets/pagesView_bodies/10-price_page/provider.dart';
import 'package:picco/services/log_service.dart';
import 'package:provider/provider.dart';

class SetPrice extends StatelessWidget {
  const SetPrice({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SetPriceProvider>();
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            children: [
              MaterialButton(
                onPressed: () => provider.updatePriceByPressing(false),
                shape:
                    const CircleBorder(side: BorderSide(color: Colors.black)),
                child: const Icon(CupertinoIcons.minus),
              ),
              Expanded(
                child: TextField(
                  textAlign: TextAlign.center,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^\d[.]{0,1}\d{0,3}$')),
                  ],
                  controller: provider.priceController,
                  focusNode: provider.priceFocus,
                  keyboardType: TextInputType.number,
                  style: TextStyle(
                    fontSize: 40.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide:
                          const BorderSide(color: Colors.grey, width: 1.5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide:
                          const BorderSide(color: Colors.blue, width: 1.5),
                    ),
                  ),
                  onChanged: (String area) {
                    provider.updatePriceByTyping();
                  },
                  onSubmitted: (String area) {
                    if (provider.priceController.text.isEmpty) {
                      provider.priceController.text = "0";
                    }
                    provider.updatePriceByTyping();
                  },
                ),
              ),
              MaterialButton(
                onPressed: () => provider.updatePriceByPressing(true),
                shape:
                    const CircleBorder(side: BorderSide(color: Colors.black)),
                child: const Icon(CupertinoIcons.plus),
              ),
            ],
          ),
          SizedBox(
            width: 0.8.sw,
            child: Text(
              'Жилье похожие на ваше, стоит от \$${50 >= provider.price ? 0 : provider.price - 50.0} до \$${provider.price + 50.0}',
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(),
        ],
      ),
    );
  }
}
