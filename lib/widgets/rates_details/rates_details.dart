import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:web_flutter/authProvider.dart';
import 'package:web_flutter/locator.dart';
import 'package:web_flutter/routing/route_names.dart';
import 'package:web_flutter/services/navigation_service.dart';
import 'package:web_flutter/utils/responsiveLayout.dart';

class RatesDetails extends StatelessWidget {
  final int userId;
  const RatesDetails({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFAA00FF),
            Color.fromRGBO(135, 90, 86, 1),
            Color.fromRGBO(229, 255, 0, 1),
          ],
        ),
      ),
      child: ResponsiveLayout(
        largeScreen: DesktopView(userId: userId),
        mediumScreen: TabletView(userId: userId),
        smallScreen: MobileView(userId: userId),
      ),
    );
  }
}

class DesktopView extends StatefulWidget {
  final int userId;
  DesktopView({Key? key, required this.userId}) : super(key: key);

  @override
  State<DesktopView> createState() => _DesktopViewState();
}

class _DesktopViewState extends State<DesktopView> {
  int selectedPlanIndex = 0;
  bool isLoggedIn = false;
  List<TariffPlan> tariffPlans = [
    TariffPlan('Подписка\nна 1 месяц', 30, 450),
    TariffPlan('Подписка\nна 3 месяце', 90, 1350),
    TariffPlan('Подписка\nна год', 365, 5400),
  ];

  Future<void> purchaseLicense(int selectedPlanIndex) async {
    // Получение количества дней лицензии в зависимости от выбранного тарифного плана
    int licenseDays = tariffPlans[selectedPlanIndex].days;

    // Формирование JSON-тела запроса
    var requestBody = {
      'userId': widget.userId,
      'selectedPlanIndex': selectedPlanIndex,
    };

    try {
      // Отправка данных на сервер
      var response = await http.post(
        Uri.parse('http://62.217.182.138:3000/purchaseLicense'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(requestBody),
      );

      if (!isLoggedIn) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Ошибка'),
              content: const Text('Пожалуйста, авторизуйтесь перед покупкой'),
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
        return;
      }

      // Проверка ответа от сервера
      if (response.statusCode == 200) {
        AuthorizationProvider.of(context)?.updateAuthorization(true, true);
        // Обработка успешного ответа (например, показ сообщения об успешной покупке)
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Успешная покупка'),
              content:
                  Text('Лицензия успешно приобретена на $licenseDays дней'),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    locator<NavigationService>()
                        .navigateTo(ProfileRoute, arguments: widget.userId);
                  },
                ),
              ],
            );
          },
        );
      } else {
        // Обработка ошибочного ответа (например, показ сообщения об ошибке)
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Ошибка'),
              content: const Text('Произошла ошибка при покупке лицензии'),
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
    } catch (e) {
      // Обработка ошибок при отправке запроса (например, показ сообщения об ошибке)
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Ошибка'),
            content: const Text('Произошла ошибка при отправке запроса'),
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
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMediumScreen = screenWidth <= 1450 && screenWidth > 1000;
    final isSmallScreen = screenWidth <= 1000 && screenWidth > 870;
    final isExtraSmallScreen = screenWidth <= 870;
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            SizedBox(height: 10),
            Text(
              'Тарифы',
              style: TextStyle(
                color: Colors.white,
                fontSize: isExtraSmallScreen
                    ? 68
                    : isMediumScreen
                        ? 68
                        : isSmallScreen
                            ? 68
                            : 96,
                fontWeight: FontWeight.bold,
                fontFamily: 'Jura',
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: Wrap(
                spacing: isExtraSmallScreen
                    ? 50
                    : isMediumScreen
                        ? 40
                        : isSmallScreen
                            ? 50
                            : 100,
                children: List.generate(tariffPlans.length, (index) {
                  return SubscriptionCard(
                    plan: tariffPlans[index],
                    purchaseLicense: () {
                      purchaseLicense(index);
                    },
                  );
                }),
              ),
            ),
            SizedBox(
              height: isExtraSmallScreen
                  ? 70
                  : isMediumScreen
                      ? 220
                      : isSmallScreen
                          ? 70
                          : 70,
            ),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              color: Color.fromRGBO(53, 50, 50, 1),
              child: SizedBox(
                height: isExtraSmallScreen
                    ? 60
                    : isMediumScreen
                        ? 60
                        : isSmallScreen
                            ? 60
                            : 87,
                width: isExtraSmallScreen
                    ? 574
                    : isMediumScreen
                        ? 574
                        : isSmallScreen
                            ? 574
                            : 804,
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      '**Скидка при покупке на несколько устройств 5%',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: isExtraSmallScreen
                            ? 21
                            : isMediumScreen
                                ? 21
                                : isSmallScreen
                                    ? 21
                                    : 30,
                        fontFamily: 'Jura',
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

class TabletView extends StatefulWidget {
  final int userId;
  TabletView({Key? key, required this.userId}) : super(key: key);

  @override
  State<TabletView> createState() => _TabletViewState();
}

class _TabletViewState extends State<TabletView> {
  int selectedPlanIndex = 0;
  bool isLoggedIn = false;
  List<TariffPlan> tariffPlans = [
    TariffPlan('Подписка\nна 1 месяц', 30, 450),
    TariffPlan('Подписка\nна 3 месяце', 90, 1350),
    TariffPlan('Подписка\nна год', 365, 5400),
  ];

  Future<void> purchaseLicense(int selectedPlanIndex) async {
    // Получение количества дней лицензии в зависимости от выбранного тарифного плана
    int licenseDays = tariffPlans[selectedPlanIndex].days;

    // Формирование JSON-тела запроса
    var requestBody = {
      'userId': widget.userId,
      'selectedPlanIndex': selectedPlanIndex,
    };

    try {
      // Отправка данных на сервер
      var response = await http.post(
        Uri.parse('http://62.217.182.138:3000/purchaseLicense'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(requestBody),
      );

      if (!isLoggedIn) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Ошибка'),
              content: const Text('Пожалуйста, авторизуйтесь перед покупкой'),
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
        return;
      }

      // Проверка ответа от сервера
      if (response.statusCode == 200) {
        AuthorizationProvider.of(context)?.updateAuthorization(true, true);
        // Обработка успешного ответа (например, показ сообщения об успешной покупке)
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Успешная покупка'),
              content:
                  Text('Лицензия успешно приобретена на $licenseDays дней'),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    locator<NavigationService>()
                        .navigateTo(ProfileRoute, arguments: widget.userId);
                  },
                ),
              ],
            );
          },
        );
      } else {
        // Обработка ошибочного ответа (например, показ сообщения об ошибке)
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Ошибка'),
              content: const Text('Произошла ошибка при покупке лицензии'),
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
    } catch (e) {
      // Обработка ошибок при отправке запроса (например, показ сообщения об ошибке)
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Ошибка'),
            content: const Text('Произошла ошибка при отправке запроса'),
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
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMediumScreen = screenWidth <= 1450 && screenWidth > 1000;
    final isSmallScreen = screenWidth <= 1000 && screenWidth > 870;
    final isExtraSmallScreen = screenWidth <= 870;
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          children: [
            SizedBox(height: 30),
            Text(
              'Тарифы',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: isExtraSmallScreen
                    ? 68
                    : isMediumScreen
                        ? 68
                        : isSmallScreen
                            ? 68
                            : 96,
                fontWeight: FontWeight.bold,
                fontFamily: 'Jura',
              ),
            ),
            SizedBox(height: 45),
            Center(
              child: Wrap(
                spacing: isExtraSmallScreen
                    ? 50
                    : isMediumScreen
                        ? 40
                        : isSmallScreen
                            ? 50
                            : 100,
                children: List.generate(tariffPlans.length, (index) {
                  return SubscriptionCard(
                    plan: tariffPlans[index],
                    purchaseLicense: () {
                      purchaseLicense(index);
                    },
                  );
                }),
              ),
            ),
            SizedBox(
              height: isExtraSmallScreen
                  ? 70
                  : isMediumScreen
                      ? 220
                      : isSmallScreen
                          ? 70
                          : 70,
            ),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              color: Color.fromRGBO(53, 50, 50, 1),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  '**Скидка при покупке на несколько устройств 5%',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: isExtraSmallScreen
                        ? 18
                        : isMediumScreen
                            ? 21
                            : isSmallScreen
                                ? 18
                                : 30,
                    fontFamily: 'Jura',
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

class MobileView extends StatefulWidget {
  final int userId;
  MobileView({Key? key, required this.userId}) : super(key: key);

  @override
  State<MobileView> createState() => _MobileViewState();
}

class _MobileViewState extends State<MobileView> {
  int selectedPlanIndex = 0;
  bool isLoggedIn = false;
  List<TariffPlan> tariffPlans = [
    TariffPlan('Подписка\nна 1 месяц', 30, 450),
    TariffPlan('Подписка\nна 3 месяце', 90, 1350),
    TariffPlan('Подписка\nна год', 365, 5400),
  ];

  Future<void> purchaseLicense(int selectedPlanIndex) async {
    // Получение количества дней лицензии в зависимости от выбранного тарифного плана
    int licenseDays = tariffPlans[selectedPlanIndex].days;

    // Формирование JSON-тела запроса
    var requestBody = {
      'userId': widget.userId,
      'selectedPlanIndex': selectedPlanIndex,
    };

    try {
      // Отправка данных на сервер
      var response = await http.post(
        Uri.parse('http://62.217.182.138:3000/purchaseLicense'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(requestBody),
      );

      if (!isLoggedIn) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Ошибка'),
              content: const Text('Пожалуйста, авторизуйтесь перед покупкой'),
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
        return;
      }

      // Проверка ответа от сервера
      if (response.statusCode == 200) {
        AuthorizationProvider.of(context)?.updateAuthorization(true, true);
        // Обработка успешного ответа (например, показ сообщения об успешной покупке)
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Успешная покупка'),
              content:
                  Text('Лицензия успешно приобретена на $licenseDays дней'),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    locator<NavigationService>()
                        .navigateTo(ProfileRoute, arguments: widget.userId);
                  },
                ),
              ],
            );
          },
        );
      } else {
        // Обработка ошибочного ответа (например, показ сообщения об ошибке)
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Ошибка'),
              content: const Text('Произошла ошибка при покупке лицензии'),
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
    } catch (e) {
      // Обработка ошибок при отправке запроса (например, показ сообщения об ошибке)
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Ошибка'),
            content: const Text('Произошла ошибка при отправке запроса'),
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
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Text(
              'Тарифы',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 60,
                fontWeight: FontWeight.bold,
                fontFamily: 'Jura',
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Wrap(
                spacing: 100,
                runSpacing: 20,
                children: List.generate(tariffPlans.length, (index) {
                  return SubscriptionCard(
                    plan: tariffPlans[index],
                    purchaseLicense: () {
                      purchaseLicense(index);
                    },
                  );
                }),
              ),
            ),
            SizedBox(height: 30),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              color: Color.fromRGBO(53, 50, 50, 1),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  '**Скидка при покупке на несколько устройств 5%',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    fontFamily: 'Jura',
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

class SubscriptionCard extends StatelessWidget {
  final TariffPlan plan;
  final VoidCallback purchaseLicense;

  const SubscriptionCard({
    required this.plan,
    required this.purchaseLicense,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMediumScreen = screenWidth <= 1450 && screenWidth > 1000;
    final isSmallScreen = screenWidth <= 1000 && screenWidth > 870;
    final isExtraSmallScreen = screenWidth <= 870;

    final double cardWidth = isExtraSmallScreen
        ? 311
        : isMediumScreen
            ? 311
            : isSmallScreen
                ? 311
                : 404;
    final double cardHeight = isExtraSmallScreen
        ? 362
        : isMediumScreen
            ? 362
            : isSmallScreen
                ? 362
                : 471;
    final double titleFontSize = isExtraSmallScreen
        ? 26
        : isMediumScreen
            ? 26
            : isSmallScreen
                ? 26
                : 36;
    final double fontSize = isExtraSmallScreen
        ? 21
        : isMediumScreen
            ? 21
            : isSmallScreen
                ? 21
                : 30;
    final double buttonFont = isExtraSmallScreen
        ? 46
        : isMediumScreen
            ? 46
            : isSmallScreen
                ? 46
                : 64;

    return Positioned(
      top: 273,
      left: 49,
      child: SizedBox(
        width: cardWidth,
        height: cardHeight,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(60),
          ),
          color: const Color.fromRGBO(53, 50, 50, 1),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  plan.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    height: 1,
                    color: Colors.white,
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Jura',
                  ),
                ),
                SizedBox(
                    height: isExtraSmallScreen
                        ? 143
                        : isMediumScreen
                            ? 143
                            : isSmallScreen
                                ? 143
                                : 200),
                Text(
                  '${plan.price}р за ${plan.days} дней',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: fontSize,
                    fontFamily: 'Jura',
                  ),
                ),
                SizedBox(
                    height: isExtraSmallScreen
                        ? 14
                        : isMediumScreen
                            ? 14
                            : isSmallScreen
                                ? 14
                                : 20),
                ElevatedButton(
                  onPressed: purchaseLicense,
                  child: Text(
                    'Купить',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: buttonFont,
                      fontFamily: 'Jura',
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(34, 16, 16, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100.0),
                    ),
                    minimumSize: Size(
                      isExtraSmallScreen
                          ? 216
                          : isMediumScreen
                              ? 216
                              : isSmallScreen
                                  ? 216
                                  : 302,
                      isExtraSmallScreen
                          ? 53
                          : isMediumScreen
                              ? 53
                              : isSmallScreen
                                  ? 53
                                  : 74,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TariffPlan {
  final String title;
  final int days;
  final int price;

  TariffPlan(this.title, this.days, this.price);
}

class Footer extends StatelessWidget {
  const Footer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromRGBO(53, 50, 50, 1),
      height: 59,
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
