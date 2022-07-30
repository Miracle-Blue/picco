import 'package:flutter/material.dart';
import 'package:picco/customer/view/pages/profile/logged_view.dart';
import 'package:picco/customer/viewmodel/providers/user_provider.dart';
import 'package:picco/services/log_service.dart';
import 'package:provider/provider.dart';

import 'unlogged_view.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<UserProvider>();
    Log.d("profile page  => ${provider.user}");
    return Scaffold(
      body: provider.user.role == "anonymous"
          ? const UnLoggedView()
          : const LoggedView(),
    );
  }
}
