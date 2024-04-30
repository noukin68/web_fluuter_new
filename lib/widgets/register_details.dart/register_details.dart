import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_flutter/locator.dart';
import 'package:web_flutter/routing/route_names.dart';
import 'package:web_flutter/services/navigation_service.dart';
import 'package:web_flutter/utils/responsiveLayout.dart';

class RegisterDetails extends StatelessWidget {
  const RegisterDetails({Key? key}) : super(key: key);

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
  const DesktopView({Key? key});

  @override
  State<DesktopView> createState() => _DesktopViewState();
}

class _DesktopViewState extends State<DesktopView> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Text(
            'Регистрация',
            style: TextStyle(
              color: Colors.white,
              fontSize: 96,
              fontWeight: FontWeight.bold,
              fontFamily: 'Jura',
            ),
          ),
          RegisterCard(),
        ],
      ),
    );
  }
}

class TabletView extends StatefulWidget {
  const TabletView({Key? key});

  @override
  State<TabletView> createState() => _TabletViewState();
}

class _TabletViewState extends State<TabletView> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Text(
            'Регистрация',
            style: TextStyle(
              color: Colors.white,
              fontSize: 48,
              fontWeight: FontWeight.bold,
              fontFamily: 'Jura',
            ),
          ),
          RegisterCard(),
        ],
      ),
    );
  }
}

class MobileView extends StatefulWidget {
  const MobileView({Key? key});

  @override
  State<MobileView> createState() => _MobileViewState();
}

class _MobileViewState extends State<MobileView> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 30,
          ),
          Text(
            'Регистрация',
            style: TextStyle(
              color: Colors.white,
              fontSize: 48,
              fontWeight: FontWeight.bold,
              fontFamily: 'Jura',
            ),
          ),
          RegisterCard(),
        ],
      ),
    );
  }
}

class RegisterCard extends StatefulWidget {
  @override
  State<RegisterCard> createState() => _RegisterCardState();
}

class _RegisterCardState extends State<RegisterCard> {
  bool isChecked = false;

  TextEditingController emailController = TextEditingController();

  TextEditingController usernameController = TextEditingController();

  TextEditingController phoneController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  TextEditingController emailVerificationCodeController =
      TextEditingController();

  bool enableConfirmEmail = false;

  bool isEmailVerified = false;

  int userId = 0;

  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Ошибка'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void navigateToLoginPage() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Успешная регистрация'),
          content: const Text('Вы успешно зарегистрированы!'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                locator<NavigationService>().navigateTo(LoginRoute);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> registerUser() async {
    String email = emailController.text.trim();
    String username = usernameController.text.trim();
    String phone = phoneController.text.trim();
    String password = passwordController.text;

    if (email.isEmpty ||
        username.isEmpty ||
        phone.isEmpty ||
        password.isEmpty ||
        !isEmailVerified) {
      if (!isEmailVerified) {
        showErrorMessage('Пожалуйста, подтвердите email');
      } else {
        showErrorMessage('Пожалуйста, заполните все поля');
      }
      return;
    }

    RegExp phoneRegExp = RegExp(r'^\+7|8[0-9]{10}$');
    if (!phoneRegExp.hasMatch(phone)) {
      showErrorMessage('Пожалуйста, введите корректный номер телефона');
      return;
    }

    try {
      var requestBody = jsonEncode({
        'email': email,
        'username': username,
        'phone': phone,
        'password': password,
      });

      var response = await http.post(
        Uri.parse('http://62.217.182.138:3000/userregister'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: requestBody,
      );

      if (response.statusCode == 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('email', email);

        navigateToLoginPage();
      } else {
        showErrorMessage('Ошибка регистрации');
      }
    } catch (e) {
      showErrorMessage('Ошибка регистрации: $e');
    }
  }

  Future<void> sendEmailVerificationCode() async {
    String email = emailController.text.trim();

    if (email.isEmpty) {
      showErrorMessage('Пожалуйста, введите email');
      return;
    }

    try {
      var response = await http.post(
        Uri.parse('http://62.217.182.138:3000/checkEmailExists'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        if (responseData['exists'] == true) {
          showErrorMessage('Этот email уже зарегистрирован');
          return;
        }
      } else {
        showErrorMessage('Ошибка проверки email');
        return;
      }
    } catch (e) {
      showErrorMessage('Ошибка проверки email: $e');
      return;
    }

    // Если email не существует, отправляем код подтверждения
    try {
      var response = await http.post(
        Uri.parse('http://62.217.182.138:3000/sendEmailVerificationCode'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        if (responseData['error'] != null) {
          showErrorMessage(
              'Ошибка отправки кода подтверждения: ${responseData['error']}');
        }
      } else {
        showErrorMessage('Ошибка отправки кода подтверждения');
      }
    } catch (e) {
      showErrorMessage('Ошибка отправки кода подтверждения: $e');
    }
  }

  Future<void> verifyEmail() async {
    String email = emailController.text.trim();
    String code = emailVerificationCodeController.text.trim();

    if (email.isEmpty || code.isEmpty) {
      showErrorMessage('Пожалуйста, заполните все поля');
      return;
    }

    try {
      var response = await http.post(
        Uri.parse('http://62.217.182.138:3000/verifyEmail'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({'email': email, 'code': code}),
      );

      if (response.statusCode == 200) {
        setState(() {
          isEmailVerified = true;
        });
      } else {
        showErrorMessage('Ошибка подтверждения email');
      }
    } catch (e) {
      showErrorMessage('Ошибка подтверждения email: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = ResponsiveLayout.isSmallScreen(context);
        final isMedium = ResponsiveLayout.isMediumScreen(context);
        final double cardWidth = 957;
        final double cardHeight = 612;
        final double contentPadding = 30.0;
        final double textFieldWidth = 557;
        final double textFieldHeight = 82;
        final double buttonMinWidth = 302;
        final double buttonMinHeight = 74;
        final double titleFontSize = 35.0;
        final double subtitleFontSize = 20.0;
        final double buttonFontSize = 60.0;

        return Card(
          color: Color.fromRGBO(53, 50, 50, 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: Container(
            width: isMobile || isMedium ? 857 : cardWidth,
            height: isMobile || isMedium ? null : cardHeight,
            padding: EdgeInsets.all(contentPadding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(height: (isMobile) ? contentPadding / 2 : 0),
                Container(
                  width: textFieldWidth,
                  height: isMobile
                      ? textFieldHeight * 0.6
                      : isMedium
                          ? textFieldHeight * 0.7
                          : textFieldHeight,
                  child: TextFormField(
                    controller: usernameController,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isMobile
                          ? titleFontSize * 0.5
                          : isMedium
                              ? titleFontSize * 0.6
                              : titleFontSize,
                      fontFamily: 'Jura',
                    ),
                    cursorColor: Colors.white,
                    decoration: InputDecoration(
                      hintText: 'Имя',
                      hintStyle: TextStyle(
                        color: Color.fromRGBO(216, 216, 216, 1),
                        fontSize: isMobile
                            ? titleFontSize * 0.5
                            : isMedium
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
                SizedBox(height: (isMobile) ? contentPadding / 2 : 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: textFieldWidth,
                      height: isMobile
                          ? textFieldHeight * 0.6
                          : isMedium
                              ? textFieldHeight * 0.7
                              : textFieldHeight,
                      child: TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isMobile
                              ? titleFontSize * 0.5
                              : isMedium
                                  ? titleFontSize * 0.6
                                  : titleFontSize,
                          fontFamily: 'Jura',
                        ),
                        cursorColor: Colors.white,
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(
                          hintText: 'E-mail',
                          hintStyle: TextStyle(
                            color: Color.fromRGBO(216, 216, 216, 1),
                            fontSize: isMobile
                                ? titleFontSize * 0.5
                                : isMedium
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
                        onChanged: (value) {
                          setState(() {
                            enableConfirmEmail = value.isNotEmpty;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: (isMobile) ? contentPadding / 2 : 20),
                Container(
                  width: textFieldWidth,
                  height: isMobile
                      ? textFieldHeight * 0.6
                      : isMedium
                          ? textFieldHeight * 0.7
                          : textFieldHeight,
                  child: TextFormField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isMobile
                          ? titleFontSize * 0.5
                          : isMedium
                              ? titleFontSize * 0.6
                              : titleFontSize,
                      fontFamily: 'Jura',
                    ),
                    cursorColor: Colors.white,
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        if (!value.startsWith('+7') && !value.startsWith('8')) {
                          phoneController.text = '+7';
                          phoneController.selection =
                              TextSelection.fromPosition(
                            TextPosition(offset: phoneController.text.length),
                          );
                        }

                        String digits = value.replaceAll(RegExp(r'\D'), '');

                        if (digits.length >= 1) {
                          String formattedPhone = '+7';

                          if (digits.length >= 2) {
                            formattedPhone += ' (' + digits.substring(1, 4);
                          }

                          if (digits.length >= 5) {
                            formattedPhone += ') ' + digits.substring(4, 7);
                          }

                          if (digits.length >= 8) {
                            formattedPhone += '-' + digits.substring(7, 9);
                          }

                          if (digits.length >= 10) {
                            formattedPhone += '-' + digits.substring(9, 11);
                          }

                          phoneController.value =
                              phoneController.value.copyWith(
                            text: formattedPhone,
                            selection: TextSelection.collapsed(
                                offset: formattedPhone.length),
                          );
                        }
                      }
                    },
                    decoration: InputDecoration(
                      hintText: 'Номер телефона',
                      hintStyle: TextStyle(
                        color: Color.fromRGBO(216, 216, 216, 1),
                        fontSize: isMobile
                            ? titleFontSize * 0.5
                            : isMedium
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
                    validator: (value) {
                      RegExp phoneRegExp =
                          RegExp(r'^\+7 $$\d{3}$$ \d{3}-\d{2}-\d{2}$');
                      if (!phoneRegExp.hasMatch(value!)) {
                        return 'Введите корректный номер телефона';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: (isMobile) ? contentPadding / 2 : 20),
                Container(
                  width: textFieldWidth,
                  height: isMobile
                      ? textFieldHeight * 0.6
                      : isMedium
                          ? textFieldHeight * 0.7
                          : textFieldHeight,
                  child: TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isMobile
                          ? titleFontSize * 0.5
                          : isMedium
                              ? titleFontSize * 0.6
                              : titleFontSize,
                      fontFamily: 'Jura',
                    ),
                    cursorColor: Colors.white,
                    decoration: InputDecoration(
                      hintText: 'Пароль',
                      hintStyle: TextStyle(
                        color: Color.fromRGBO(216, 216, 216, 1),
                        fontSize: isMobile
                            ? titleFontSize * 0.5
                            : isMedium
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
                SizedBox(height: (isMobile) ? contentPadding / 2 : 20),
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 30,
                        height: 30,
                        child: Checkbox(
                          value: isChecked,
                          onChanged: (bool? newValue) {
                            setState(() {
                              isChecked = newValue!;
                            });
                          },
                          activeColor: Colors.white,
                          checkColor: Colors.black,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Flexible(
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'Я согласен с ',
                                style: TextStyle(
                                  color: Color.fromRGBO(216, 216, 216, 1),
                                  fontSize: isMobile
                                      ? subtitleFontSize * 0.6
                                      : isMedium
                                          ? subtitleFontSize * 0.8
                                          : subtitleFontSize,
                                  fontFamily: 'Jura',
                                ),
                              ),
                              TextSpan(
                                text: 'лицензионным соглашением',
                                style: TextStyle(
                                  color: Color.fromRGBO(192, 8, 196, 1),
                                  fontSize: isMobile
                                      ? subtitleFontSize * 0.6
                                      : isMedium
                                          ? subtitleFontSize * 0.8
                                          : subtitleFontSize,
                                  fontFamily: 'Jura',
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {},
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: (isMobile) ? contentPadding / 2 : 20),
                ElevatedButton(
                  onPressed: () {
                    registerUser();
                  },
                  child: Text(
                    'Войти',
                    style: TextStyle(
                      fontSize: isMobile
                          ? buttonFontSize * 0.6
                          : isMedium
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
                      isMobile
                          ? textFieldHeight * 0.6
                          : isMedium
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
