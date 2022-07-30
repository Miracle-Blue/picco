import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:picco/seller/views/pages/announcement/widgets/pagesView_bodies/9-title_page/provider.dart';
import 'package:provider/provider.dart';

class SetTitle extends StatelessWidget {
  const SetTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.select((SetTitleProvider provider) => provider);

    return Padding(
      padding:  EdgeInsets.fromLTRB(10.0, 40.0, 10.0, MediaQuery.of(context).viewInsets.bottom),
      child: TextField(
        controller: provider.titleController,
        focusNode: provider.titleFocus,
        keyboardType: TextInputType.multiline,
        maxLines: null,
        style: TextStyle(
          fontSize: 16.sp,
          color: Colors.black,
          fontWeight: FontWeight.normal,
        ),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(15, 5, 15, 35),
          hintText: 'Загаловок',
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 18),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: const BorderSide(color: Colors.blue),
          ),
        ),
        onChanged: (String title) {
          provider.getTitle(provider.titleController.text.trim());
        },
        onSubmitted: (String title) {
          provider.getTitle(provider.titleController.text.trim());
        },
      ),
    );
  }
}
