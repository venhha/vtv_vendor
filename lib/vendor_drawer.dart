import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vtv_common/auth.dart';
import 'package:vtv_common/core.dart';
import 'package:vtv_common/dev.dart';

import 'service_locator.dart';

class VendorDrawer extends StatefulWidget {
  const VendorDrawer({
    super.key,
    required this.onItemTapped,
    required this.selectedIndex,
  });

  final int selectedIndex;
  final void Function(int index) onItemTapped;

  @override
  State<VendorDrawer> createState() => _VendorDrawerState();
}

class _VendorDrawerState extends State<VendorDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          drawerHeader(),
          //# home page
          ListTile(
            title: const Text('Trang bán hàng'),
            selected: widget.selectedIndex == 0,
            onTap: () {
              widget.onItemTapped(0);
              Navigator.pop(context);
            },
          ),
          //# wallet page
          ListTile(
            title: const Text('Ví tiền'),
            selected: widget.selectedIndex == 1,
            onTap: () {
              widget.onItemTapped(1);
              Navigator.pop(context);
            },
          ),

          //# voucher manage page
          ListTile(
            title: const Text('Quản lý voucher của shop'),
            selected: widget.selectedIndex == 2,
            onTap: () {
              widget.onItemTapped(2);
              Navigator.pop(context);
            },
          ),

          //# revenue page
          ListTile(
            title: const Text('Thống kê'),
            selected: widget.selectedIndex == 3,
            onTap: () {
              widget.onItemTapped(3);
              Navigator.pop(context);
            },
          ),

          // NOTE dev
          const Divider(),
          ListTile(
            title: const Text('Thông tin ứng dụng'),
            onTap: () async {
              showCrossPlatformAboutDialog(
                  context: context,
                  children: [const SizedBox(height: 16), const Text('Ứng dụng dành cho người bán hàng')]);
            },
          ),
          ListTile(
            title: const Text('Dev Page'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return DevPage(sl: sl);
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  BlocBuilder<AuthCubit, AuthState> drawerHeader() {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state.status == AuthStatus.authenticated) {
          final auth = state.auth!;
          return UserAccountsDrawerHeader(
            accountName: Text(
              auth.userInfo.fullName ?? auth.userInfo.username ?? 'User',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            accountEmail: Text(
              auth.userInfo.email ?? 'Email',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            currentAccountPicture: const FlutterLogo(),
            otherAccountsPictures: [
              // logout icon
              IconButton(
                icon: const Icon(Icons.logout, color: Colors.red),
                onPressed: () async {
                  // show dialog to confirm logout
                  final isConfirm = await showDialogToConfirm(
                    context: context,
                    title: 'Đăng xuất',
                    content: 'Bạn có chắc chắn muốn đăng xuất?',
                  );
                  if (isConfirm) {
                    if (context.mounted) {
                      context.read<AuthCubit>().logout(state.auth!.refreshToken);
                      Navigator.pop(context);
                    }
                  }
                },
              ),
            ],
          );
        } else if (state.status == AuthStatus.unauthenticated) {
          return _authenticatedDrawerHeader(context);
        }
        return DrawerHeader(
          child: Center(
            child: Column(
              children: [
                const Text(
                  'Đang tải...',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black54),
                ),
                ElevatedButton(
                  onPressed: () {
                    log(state.toString());
                  },
                  child: const Text('Button'),
                ),
                ElevatedButton(
                  onPressed: () {
                    log('current domain: $host');
                  },
                  child: const Text('current domain'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  DrawerHeader _authenticatedDrawerHeader(BuildContext context) {
    return DrawerHeader(
      child: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Đăng nhập'),
        ),
      ),
    );
  }
}
