import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_flutter/authProvider.dart';
import 'package:web_flutter/routing/route_names.dart';
import 'navbar_item.dart';
import 'navbar_logo.dart';

class NavigationBarTabletDesktop extends StatefulWidget {
  const NavigationBarTabletDesktop({Key? key}) : super(key: key);

  @override
  _NavigationBarTabletDesktopState createState() =>
      _NavigationBarTabletDesktopState();
}

class _NavigationBarTabletDesktopState
    extends State<NavigationBarTabletDesktop> {
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
    final screenWidth = MediaQuery.of(context).size.width;
    final isMediumScreen = screenWidth <= 1450 && screenWidth > 1000;
    final isSmallScreen = screenWidth <= 1000 && screenWidth > 870;
    final isExtraSmallScreen = screenWidth <= 870;
    return Container(
      height: 59,
      color: const Color.fromRGBO(53, 50, 50, 1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          const NavBarLogo(),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ValueListenableBuilder<bool>(
                valueListenable: authProvider?.isAuthorizedNotifier ??
                    ValueNotifier<bool>(false),
                builder: (context, isAuthorized, child) {
                  return ValueListenableBuilder<bool>(
                    valueListenable: authProvider?.hasLicenseNotifier ??
                        ValueNotifier<bool>(false),
                    builder: (context, hasLicense, child) {
                      return Row(
                        children: [
                          if (isAuthorized &&
                              !hasLicense) // Условие для авторизованных пользователей без лицензии
                            ...[
                            NavBarItem(
                              'О нас',
                              HomeRoute,
                              fontSize: isExtraSmallScreen
                                  ? 24
                                  : isSmallScreen
                                      ? 24
                                      : isMediumScreen
                                          ? 28
                                          : 32,
                            ),
                            SizedBox(
                              width: isExtraSmallScreen
                                  ? 60
                                  : isSmallScreen
                                      ? 60
                                      : isMediumScreen
                                          ? 130
                                          : 250,
                            ),
                            NavBarItem(
                              'Тарифы',
                              RatesRoute,
                              fontSize: isExtraSmallScreen
                                  ? 24
                                  : isSmallScreen
                                      ? 24
                                      : isMediumScreen
                                          ? 28
                                          : 32,
                            ),
                            SizedBox(
                              width: isExtraSmallScreen
                                  ? 60
                                  : isSmallScreen
                                      ? 60
                                      : isMediumScreen
                                          ? 130
                                          : 250,
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                right: isExtraSmallScreen
                                    ? 66
                                    : isSmallScreen
                                        ? 66
                                        : isMediumScreen
                                            ? 86
                                            : 106,
                              ),
                              child: NavBarItem(
                                'Выход',
                                LogoutRoute,
                                fontSize: isExtraSmallScreen
                                    ? 24
                                    : isSmallScreen
                                        ? 24
                                        : isMediumScreen
                                            ? 28
                                            : 32,
                              ),
                            ),
                          ] else if (isAuthorized &&
                              hasLicense) // Условие для авторизованных пользователей с лицензией
                            ...[
                            NavBarItem(
                              'Мой аккаунт',
                              ProfileRoute,
                              fontSize: isExtraSmallScreen
                                  ? 24
                                  : isSmallScreen
                                      ? 24
                                      : isMediumScreen
                                          ? 28
                                          : 32,
                            ),
                            SizedBox(
                              width: isExtraSmallScreen
                                  ? 60
                                  : isSmallScreen
                                      ? 60
                                      : isMediumScreen
                                          ? 100
                                          : 250,
                            ),
                            NavBarItem(
                              'Подключение устройств',
                              ConnectDevicesRoute,
                              fontSize: isExtraSmallScreen
                                  ? 24
                                  : isSmallScreen
                                      ? 24
                                      : isMediumScreen
                                          ? 28
                                          : 32,
                            ),
                            SizedBox(
                              width: isExtraSmallScreen
                                  ? 60
                                  : isSmallScreen
                                      ? 60
                                      : isMediumScreen
                                          ? 100
                                          : 250,
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                right: isExtraSmallScreen
                                    ? 50
                                    : isSmallScreen
                                        ? 50
                                        : isMediumScreen
                                            ? 80
                                            : 106,
                              ),
                              child: NavBarItem(
                                'Выход',
                                LogoutRoute,
                                fontSize: isExtraSmallScreen
                                    ? 24
                                    : isSmallScreen
                                        ? 24
                                        : isMediumScreen
                                            ? 28
                                            : 32,
                              ),
                            ),
                          ] else // Условие для неавторизованных пользователей
                            ...[
                            NavBarItem(
                              'О нас',
                              HomeRoute,
                              fontSize: isExtraSmallScreen
                                  ? 24
                                  : isSmallScreen
                                      ? 24
                                      : isMediumScreen
                                          ? 28
                                          : 32,
                            ),
                            SizedBox(
                              width: isExtraSmallScreen
                                  ? 60
                                  : isSmallScreen
                                      ? 60
                                      : isMediumScreen
                                          ? 130
                                          : 250,
                            ),
                            NavBarItem(
                              'Тарифы',
                              RatesRoute,
                              fontSize: isExtraSmallScreen
                                  ? 24
                                  : isSmallScreen
                                      ? 24
                                      : isMediumScreen
                                          ? 28
                                          : 32,
                            ),
                            SizedBox(
                              width: isExtraSmallScreen
                                  ? 60
                                  : isSmallScreen
                                      ? 60
                                      : isMediumScreen
                                          ? 130
                                          : 250,
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                right: isExtraSmallScreen
                                    ? 50
                                    : isSmallScreen
                                        ? 50
                                        : isMediumScreen
                                            ? 130
                                            : 170,
                              ),
                              child: NavBarItem(
                                'Авторизация',
                                LoginRoute,
                                fontSize: isExtraSmallScreen
                                    ? 24
                                    : isSmallScreen
                                        ? 24
                                        : isMediumScreen
                                            ? 28
                                            : 32,
                              ),
                            ),
                          ],
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
