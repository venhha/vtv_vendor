import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vtv_common/auth.dart';

import 'vendor_register_update_page.dart';

class VendorLoginPage extends StatelessWidget {
  const VendorLoginPage({
    super.key,
    this.showTitle = true,
  });

  final bool showTitle;

  @override
  Widget build(BuildContext context) {
    return LoginPage(
      showTitle: showTitle,
      onLoginPressed: (username, password) async {
        context.read<AuthCubit>().loginWithUsernameAndPassword(username: username, password: password);
      },
      onRegisterPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return const VendorRegisterUpdatePage();
            },
          ),
        );
      },
    );
  }
}
