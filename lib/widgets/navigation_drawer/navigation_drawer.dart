import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_flutter/authProvider.dart';
import 'package:web_flutter/routing/route_names.dart';
import 'package:web_flutter/widgets/navigation_drawer/drawer_item.dart';

class MyNavigationDrawer extends StatefulWidget {
  const MyNavigationDrawer({Key? key}) : super(key: key);

  @override
  _MyNavigationDrawerState createState() => _MyNavigationDrawerState();
}

class _MyNavigationDrawerState extends State<MyNavigationDrawer> {
  bool _isAuthorized = false;
  bool _hasLicense = false;

  @override
  void initState() {
    super.initState();
    _checkAuthorizationAndLicense();
  }

  Future<void> _checkAuthorizationAndLicense() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isAuthorized = prefs.getBool('isAuthorized') ?? false;
      _hasLicense = prefs.getBool('hasLicense') ?? false;
    });
    print('_isAuthorized: $_isAuthorized');
    print('_hasLicense: $_hasLicense');
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = AuthorizationProvider.of(context);
    return Container(
      width: 300,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(53, 50, 50, 1),
      ),
      child: Column(
        children: <Widget>[
          ValueListenableBuilder<bool>(
            valueListenable: authProvider?.isAuthorizedNotifier ??
                ValueNotifier<bool>(false),
            builder: (context, isAuthorized, child) {
              return ValueListenableBuilder<bool>(
                valueListenable: authProvider?.hasLicenseNotifier ??
                    ValueNotifier<bool>(false),
                builder: (context, hasLicense, child) {
                  if (isAuthorized && !hasLicense) {
// Условие для авторизованных пользователей без лицензии
                    return Column(
                      children: [
                        DrawerItem('О нас', Icons.home, HomeRoute, Colors.white,
                            fontFamily: 'Jura'),
                        DrawerItem(
                            'Тарифы', Icons.shop_two, RatesRoute, Colors.white,
                            fontFamily: 'Jura'),
                        DrawerItem(
                            'Выход', Icons.logout, LogoutRoute, Colors.white,
                            fontFamily: 'Jura'),
                      ],
                    );
                  } else if (isAuthorized && hasLicense) {
// Условие для авторизованных пользователей с лицензией
                    return Column(
                      children: [
                        DrawerItem('Мой аккаунт', Icons.account_circle,
                            ProfileRoute, Colors.white,
                            fontFamily: 'Jura'),
                        DrawerItem('Подключение устройств', Icons.device_hub,
                            ConnectDevicesRoute, Colors.white,
                            fontFamily: 'Jura'),
                        DrawerItem(
                            'Выход', Icons.logout, LogoutRoute, Colors.white,
                            fontFamily: 'Jura'),
                      ],
                    );
                  } else {
// Условие для неавторизованных пользователей
                    return Column(
                      children: [
                        DrawerItem('О нас', Icons.home, HomeRoute, Colors.white,
                            fontFamily: 'Jura'),
                        DrawerItem(
                            'Тарифы', Icons.shop_two, RatesRoute, Colors.white,
                            fontFamily: 'Jura'),
                        DrawerItem('Авторизация', Icons.login_sharp, LoginRoute,
                            Colors.white,
                            fontFamily: 'Jura'),
                      ],
                    );
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
