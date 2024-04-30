import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:responsive_builder/responsive_builder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_flutter/authProvider.dart';
import 'package:web_flutter/locator.dart';
import 'package:web_flutter/routing/route_names.dart';
import 'package:web_flutter/services/navigation_service.dart';
import 'package:web_flutter/utils/responsiveLayout.dart';

class LoginDetails extends StatelessWidget {
  const LoginDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFAA00FF),
            Color.fromARGB(255, 135, 90, 86),
            Color.fromARGB(255, 229, 255, 0),
          ],
        ),
      ),
      child: ResponsiveLayout(
        largeScreen: DesktopView(),
        mediumScreen: TabletView(),
        smallScreen: MobileView(),
      ),
    );
  }
}

class DesktopView extends StatefulWidget {
  DesktopView({Key? key}) : super(key: key);

  @override
  State<DesktopView> createState() => _DesktopViewState();
}

class _DesktopViewState extends State<DesktopView> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  int userId = 0;

  bool _isAuthorized = false;
  bool _hasLicense = false;

  void showErrorMessage(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Ошибка'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> checkLicenseStatus(int userId) async {
    try {
      var response = await http.get(
        Uri.parse('http://62.217.182.138:3000/licenseStatus/${userId}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        var licenseStatus = json.decode(response.body);
        bool hasLicense = licenseStatus['active'] == true;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool('hasLicense', hasLicense);
        setState(() {
          _hasLicense = hasLicense;
        });
        if (hasLicense) {
          locator<NavigationService>()
              .navigateTo(ProfileRoute, arguments: userId);
        } else {
          locator<NavigationService>()
              .navigateTo(RatesRoute, arguments: userId);
        }
      } else if (response.statusCode == 404) {
        locator<NavigationService>().navigateTo(RatesRoute, arguments: userId);
      } else {
        showErrorMessage(context, 'Ошибка при проверке статуса лицензии');
      }
    } catch (e) {
      showErrorMessage(context, 'Ошибка при проверке статуса лицензии: $e');
    }
  }

  Future<void> loginUser() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      showErrorMessage(context, 'Введите email и пароль');
      return;
    }

    try {
      var requestBody = jsonEncode({
        'email': email,
        'password': password,
      });

      var response = await http.post(
        Uri.parse('http://62.217.182.138:3000/userlogin'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: requestBody,
      );

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        int userId = responseData['userId'];
        await checkLicenseStatus(userId);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('email', email);
        setState(() {
          _isAuthorized = true;
        });

        AuthorizationProvider.of(context)
            ?.updateAuthorization(_isAuthorized, _hasLicense);

        prefs.setInt('userId', userId);
      } else {
        showErrorMessage(context, 'Неверный email или пароль');
      }
    } catch (e) {
      showErrorMessage(context, 'Ошибка аутентификации: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Text(
            'Авторизация',
            style: TextStyle(
              color: Colors.white,
              fontSize: 80,
              fontWeight: FontWeight.bold,
              fontFamily: 'Jura',
            ),
          ),
          Expanded(
            child: Center(
              child: Wrap(
                children: [
                  LoginCard(
                    emailController: emailController,
                    passwordController: passwordController,
                    loginUser: loginUser,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TabletView extends StatefulWidget {
  TabletView({Key? key}) : super(key: key);

  @override
  State<TabletView> createState() => _TabletViewState();
}

class _TabletViewState extends State<TabletView> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  int userId = 0;
  bool _isAuthorized = false;
  bool _hasLicense = false;

  void showErrorMessage(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Ошибка'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> checkLicenseStatus(int userId) async {
    try {
      var response = await http.get(
        Uri.parse('http://62.217.182.138:3000/licenseStatus/${userId}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        var licenseStatus = json.decode(response.body);
        bool hasLicense = licenseStatus['active'] == true;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool('hasLicense', hasLicense);
        setState(() {
          _hasLicense = hasLicense;
        });
        if (hasLicense) {
          locator<NavigationService>()
              .navigateTo(ProfileRoute, arguments: userId);
        } else {
          locator<NavigationService>()
              .navigateTo(RatesRoute, arguments: userId);
        }
      } else if (response.statusCode == 404) {
        locator<NavigationService>().navigateTo(RatesRoute, arguments: userId);
      } else {
        showErrorMessage(context, 'Ошибка при проверке статуса лицензии');
      }
    } catch (e) {
      showErrorMessage(context, 'Ошибка при проверке статуса лицензии: $e');
    }
  }

  Future<void> loginUser() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      showErrorMessage(context, 'Введите email и пароль');
      return;
    }

    try {
      var requestBody = jsonEncode({
        'email': email,
        'password': password,
      });

      var response = await http.post(
        Uri.parse('http://62.217.182.138:3000/userlogin'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: requestBody,
      );

      if (response.statusCode == 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('email', email);

        AuthorizationProvider.of(context)
            ?.updateAuthorization(true, _hasLicense);

        var responseData = json.decode(response.body);
        int userId = responseData['userId'];

        prefs.setInt('userId', userId);

        await checkLicenseStatus(userId);
      } else {
        showErrorMessage(context, 'Неверный email или пароль');
      }
    } catch (e) {
      showErrorMessage(context, 'Ошибка аутентификации: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 40,
              ),
              Text(
                'Авторизация',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Jura',
                ),
              ),
              Center(
                child: Wrap(
                  children: [
                    LoginCard(
                      emailController: emailController,
                      passwordController: passwordController,
                      loginUser: loginUser,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MobileView extends StatefulWidget {
  MobileView({Key? key}) : super(key: key);

  @override
  State<MobileView> createState() => _MobileViewState();
}

class _MobileViewState extends State<MobileView> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  int userId = 0;
  bool _isAuthorized = false;
  bool _hasLicense = false;

  void showErrorMessage(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Ошибка'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> checkLicenseStatus(int userId) async {
    try {
      var response = await http.get(
        Uri.parse('http://62.217.182.138:3000/licenseStatus/${userId}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        var licenseStatus = json.decode(response.body);
        bool hasLicense = licenseStatus['active'] == true;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool('hasLicense', hasLicense);
        setState(() {
          _hasLicense = hasLicense;
        });
        if (hasLicense) {
          locator<NavigationService>()
              .navigateTo(ProfileRoute, arguments: userId);
        } else {
          locator<NavigationService>()
              .navigateTo(RatesRoute, arguments: userId);
        }
      } else if (response.statusCode == 404) {
        locator<NavigationService>().navigateTo(RatesRoute, arguments: userId);
      } else {
        showErrorMessage(context, 'Ошибка при проверке статуса лицензии');
      }
    } catch (e) {
      showErrorMessage(context, 'Ошибка при проверке статуса лицензии: $e');
    }
  }

  Future<void> loginUser() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      showErrorMessage(context, 'Введите email и пароль');
      return;
    }

    try {
      var requestBody = jsonEncode({
        'email': email,
        'password': password,
      });

      var response = await http.post(
        Uri.parse('http://62.217.182.138:3000/userlogin'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: requestBody,
      );

      if (response.statusCode == 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('email', email);

        AuthorizationProvider.of(context)
            ?.updateAuthorization(true, _hasLicense);

        var responseData = json.decode(response.body);
        int userId = responseData['userId'];

        prefs.setInt('userId', userId);

        await checkLicenseStatus(userId);
      } else {
        showErrorMessage(context, 'Неверный email или пароль');
      }
    } catch (e) {
      showErrorMessage(context, 'Ошибка аутентификации: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Text(
                'Авторизация',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Jura',
                ),
              ),
              Center(
                child: Wrap(
                  children: [
                    LoginCard(
                      emailController: emailController,
                      passwordController: passwordController,
                      loginUser: loginUser,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginCard extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback loginUser;

  const LoginCard({
    required this.emailController,
    required this.passwordController,
    required this.loginUser,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = ResponsiveLayout.isSmallScreen(context);
        final isMedium = ResponsiveLayout.isMediumScreen(context);
        final double cardWidth = 957;
        final double cardHeight = 544;
        final double contentPadding = 30.0;
        final double textFieldWidth = 557;
        final double textFieldHeight = 85;
        final double buttonMinWidth = 302;
        final double buttonMinHeight = 74;
        final double titleFontSize = 40.0;
        final double subtitleFontSize = 32.0;
        final double subtitleFontSizeSmall = 25.0;
        final double buttonFontSize = 64.0;

        return Card(
          color: Color.fromRGBO(53, 50, 50, 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: Container(
            width: isMobile || isMedium ? 857 : cardWidth,
            height: isMobile || isMedium ? 444 : cardHeight,
            padding: EdgeInsets.all(contentPadding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(height: (isMobile) ? contentPadding / 2 : 0),
                Container(
                  width: textFieldWidth,
                  height: isMobile
                      ? textFieldHeight * 0.7
                      : isMedium
                          ? textFieldHeight * 0.7
                          : textFieldHeight,
                  child: TextFormField(
                    cursorColor: Colors.white,
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isMobile || isMedium
                          ? titleFontSize * 0.6
                          : titleFontSize,
                      fontFamily: 'Jura',
                    ),
                    decoration: InputDecoration(
                      hintText: 'E-mail',
                      hintStyle: TextStyle(
                        color: Color.fromRGBO(216, 216, 216, 1),
                        fontSize: isMobile || isMedium
                            ? titleFontSize * 0.6
                            : titleFontSize,
                        fontFamily: 'Jura',
                      ),
                      filled: true,
                      fillColor: Color.fromRGBO(100, 100, 100, 1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: (isMobile) ? contentPadding / 2 : 40),
                Container(
                  width: textFieldWidth,
                  height: isMobile
                      ? textFieldHeight * 0.7
                      : isMedium
                          ? textFieldHeight * 0.7
                          : textFieldHeight,
                  child: TextFormField(
                    cursorColor: Colors.white,
                    controller: passwordController,
                    obscureText: true,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isMobile || isMedium
                          ? titleFontSize * 0.6
                          : titleFontSize,
                      fontFamily: 'Jura',
                    ),
                    decoration: InputDecoration(
                      hintText: 'Пароль',
                      hintStyle: TextStyle(
                        color: Color.fromRGBO(216, 216, 216, 1),
                        fontSize: isMobile || isMedium
                            ? titleFontSize * 0.6
                            : titleFontSize,
                        fontFamily: 'Jura',
                      ),
                      filled: true,
                      fillColor: Color.fromRGBO(100, 100, 100, 1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: (isMobile) ? contentPadding / 2 : 40),
                Text(
                  'Нет аккаунта?',
                  style: TextStyle(
                    color: Color.fromRGBO(216, 216, 216, 1),
                    fontSize: isMobile || isMedium
                        ? subtitleFontSize * 0.75
                        : subtitleFontSize,
                    fontFamily: 'Jura',
                  ),
                ),
                Text.rich(
                  TextSpan(
                    text: 'Зарегистрироваться',
                    style: TextStyle(
                      color: Color.fromRGBO(136, 51, 166, 1),
                      fontSize: isMobile
                          ? subtitleFontSizeSmall * 0.8
                          : isMedium
                              ? subtitleFontSizeSmall * 0.8
                              : subtitleFontSizeSmall,
                      fontFamily: 'Jura',
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        locator<NavigationService>().navigateTo(RegisterRoute);
                      },
                  ),
                ),
                SizedBox(height: (isMobile) ? contentPadding / 2 : 50),
                ElevatedButton(
                  onPressed: () {
                    loginUser();
                  },
                  child: Text(
                    'Войти',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isMobile || isMedium
                          ? buttonFontSize * 0.75
                          : buttonFontSize,
                      fontFamily: 'Jura',
                    ),
                  ),
                  style: TextButton.styleFrom(
                    foregroundColor: Color.fromRGBO(216, 216, 216, 1),
                    backgroundColor: Color.fromRGBO(100, 100, 100, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(35),
                    ),
                    minimumSize: Size(
                      buttonMinWidth,
                      isMobile || isMedium
                          ? textFieldHeight * 0.7
                          : buttonMinHeight,
                    ),
                  ),
                ),
                SizedBox(height: (isMobile) ? contentPadding / 2 : 0),
              ],
            ),
          ),
        );
      },
    );
  }
}

class Footer extends StatelessWidget {
  const Footer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromRGBO(53, 50, 50, 1),
      height: 70,
      width: double.infinity,
      child: Center(
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'ооо ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 35,
                  fontFamily: 'Jura',
                ),
              ),
              TextSpan(
                text: '"ФТ-Групп"',
                style: TextStyle(
                  color: Color.fromRGBO(142, 51, 174, 1),
                  fontSize: 35,
                  fontFamily: 'Jura',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
