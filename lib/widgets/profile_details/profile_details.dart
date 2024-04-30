import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:web_flutter/locator.dart';
import 'package:web_flutter/routing/route_names.dart';
import 'package:web_flutter/services/navigation_service.dart';
import 'package:web_flutter/utils/responsiveLayout.dart';

class ProfileDetails extends StatelessWidget {
  final int userId;

  const ProfileDetails({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: [
            Colors.purple,
            Colors.purple, // Цвет внутри круга
            Color.fromRGBO(55, 55, 55, 1), // Цвет вне круга
          ],
          center: Alignment.centerLeft, // Центр градиента - по центру экрана
          radius: 1.8, // Радиус градиента
          stops: [0.2, 0.3, 1], // Остановки для цветового перехода
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

  const DesktopView({Key? key, required this.userId}) : super(key: key);

  @override
  State<DesktopView> createState() => _DesktopViewState();
}

class _DesktopViewState extends State<DesktopView> {
  late Future<Map<String, dynamic>> _userInfoFuture;
  Map<String, dynamic>? _userInfo;

  @override
  void initState() {
    super.initState();
    _fetchUserInfo();
  }

  Future<void> _fetchUserInfo() async {
    _userInfoFuture = fetchUserInfo(widget.userId);
    final data = await _userInfoFuture;
    setState(() {
      _userInfo = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final middleSizedBoxWidth = screenWidth <= 1450 && screenWidth > 1000;
    final smallSizedBoxWidth =
        screenWidth <= 1000 && screenWidth > 870; // 20% of the screen width

    if (_userInfo != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: 575,
            child: UserInfoCard(userId: widget.userId, userInfo: _userInfo),
          ),
          SizedBox(
            width: middleSizedBoxWidth
                ? 100
                : smallSizedBoxWidth
                    ? 10
                    : 500,
          ),
          SizedBox(
            width: 300,
            child: LicenseInfoCard(userId: widget.userId, userInfo: _userInfo),
          ),
        ],
      );
    } else {
      return FutureBuilder<Map<String, dynamic>>(
        future: _userInfoFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: 575,
                  child: UserInfoCard(
                      userId: widget.userId, userInfo: snapshot.data),
                ),
                SizedBox(
                  width: middleSizedBoxWidth
                      ? 100
                      : smallSizedBoxWidth
                          ? 10
                          : 500,
                ),
                SizedBox(
                  width: 357,
                  child: LicenseInfoCard(
                      userId: widget.userId, userInfo: snapshot.data),
                ),
              ],
            );
          }
        },
      );
    }
  }
}

class TabletView extends StatefulWidget {
  final int userId;

  const TabletView({Key? key, required this.userId}) : super(key: key);

  @override
  State<TabletView> createState() => _TabletViewState();
}

class _TabletViewState extends State<TabletView> {
  late Future<Map<String, dynamic>> _userInfoFuture;
  Map<String, dynamic>? _userInfo;

  @override
  void initState() {
    super.initState();
    _fetchUserInfo();
  }

  Future<void> _fetchUserInfo() async {
    _userInfoFuture = fetchUserInfo(widget.userId);
    final data = await _userInfoFuture;
    setState(() {
      _userInfo = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final middleSizedBoxWidth = screenWidth <= 1450 && screenWidth > 1000;
    final smallSizedBoxWidth =
        screenWidth <= 1000 && screenWidth > 870; // 20% of the screen width

    if (_userInfo != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: 575,
            child: UserInfoCard(userId: widget.userId, userInfo: _userInfo),
          ),
          SizedBox(
            width: middleSizedBoxWidth
                ? 250
                : smallSizedBoxWidth
                    ? 10
                    : 500,
          ),
          SizedBox(
            width: 357,
            child: LicenseInfoCard(userId: widget.userId, userInfo: _userInfo),
          ),
        ],
      );
    } else {
      return FutureBuilder<Map<String, dynamic>>(
        future: _userInfoFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: 575,
                  child: UserInfoCard(
                      userId: widget.userId, userInfo: snapshot.data),
                ),
                SizedBox(
                  width: middleSizedBoxWidth
                      ? 250
                      : smallSizedBoxWidth
                          ? 10
                          : 500,
                ),
                SizedBox(
                  width: 357,
                  child: LicenseInfoCard(
                      userId: widget.userId, userInfo: snapshot.data),
                ),
              ],
            );
          }
        },
      );
    }
  }
}

class MobileView extends StatefulWidget {
  final int userId;

  const MobileView({Key? key, required this.userId}) : super(key: key);

  @override
  State<MobileView> createState() => _MobileViewState();
}

class _MobileViewState extends State<MobileView> {
  late Future<Map<String, dynamic>> _userInfoFuture;
  Map<String, dynamic>? _userInfo;

  @override
  void initState() {
    super.initState();
    _fetchUserInfo();
  }

  Future<void> _fetchUserInfo() async {
    _userInfoFuture = fetchUserInfo(widget.userId);
    final data = await _userInfoFuture;
    setState(() {
      _userInfo = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_userInfo != null) {
      return SingleChildScrollView(
        child: Column(
          children: [
            UserInfoCard(userId: widget.userId, userInfo: _userInfo),
            LicenseInfoCard(userId: widget.userId, userInfo: _userInfo),
          ],
        ),
      );
    } else {
      return FutureBuilder<Map<String, dynamic>>(
        future: _userInfoFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return SingleChildScrollView(
              child: Column(
                children: [
                  UserInfoCard(userId: widget.userId, userInfo: snapshot.data),
                  LicenseInfoCard(
                      userId: widget.userId, userInfo: snapshot.data),
                ],
              ),
            );
          }
        },
      );
    }
  }
}

class UserInfoCard extends StatefulWidget {
  final int userId;
  final Map<String, dynamic>? userInfo;

  const UserInfoCard({Key? key, required this.userId, this.userInfo})
      : super(key: key);

  @override
  State<UserInfoCard> createState() => _UserInfoCardState();
}

class _UserInfoCardState extends State<UserInfoCard> {
  late Future<Map<String, dynamic>> _userInfoFuture;

  @override
  void initState() {
    super.initState();
    _userInfoFuture = fetchUserInfo(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMediumScreen = screenWidth <= 1450 && screenWidth > 1000;
    final isSmallScreen = screenWidth <= 1000 && screenWidth > 870;
    final isExtraSmallScreen = screenWidth <= 870;
    final double cardWidth = isExtraSmallScreen
        ? 360
        : isMediumScreen
            ? 383
            : isSmallScreen
                ? 50
                : 575;
    final double cardHeight = isExtraSmallScreen
        ? 300
        : isMediumScreen
            ? 348
            : isSmallScreen
                ? 248
                : 448;
    final avatarRadius = isExtraSmallScreen
        ? 40.0
        : isMediumScreen
            ? 70.0
            : isSmallScreen
                ? 60.0
                : 70.0;
    double titleFontSize = isExtraSmallScreen
        ? 14
        : isMediumScreen
            ? 20
            : isSmallScreen
                ? 18
                : 20;
    double headTitleFontSize = isExtraSmallScreen
        ? 20
        : isMediumScreen
            ? 24
            : isSmallScreen
                ? 20
                : 32;
    double cardRadius = isExtraSmallScreen
        ? 20
        : isMediumScreen
            ? 20
            : isSmallScreen
                ? 20
                : 60;

    return FutureBuilder<Map<String, dynamic>>(
      future: widget.userInfo == null
          ? _userInfoFuture
          : Future.value(widget.userInfo),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else {
          final userInfo = snapshot.data!;
          return Container(
            width: cardWidth,
            height: cardHeight,
            child: Card(
              color: Color.fromRGBO(53, 50, 50, 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(cardRadius),
              ),
              child: Padding(
                padding: EdgeInsets.all(isExtraSmallScreen
                    ? 16.0
                    : isMediumScreen
                        ? 20.0
                        : isSmallScreen
                            ? 20.0
                            : 20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text('Информация о пользователе',
                        style: TextStyle(
                          fontSize: headTitleFontSize,
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(236, 236, 236, 1),
                          fontFamily: 'Jura',
                        )),
                    SizedBox(
                        height: isExtraSmallScreen
                            ? 20
                            : isMediumScreen
                                ? 40
                                : isSmallScreen
                                    ? 40
                                    : 40),
                    Flexible(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(width: titleFontSize),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text('Имя: ${userInfo['username']}',
                                        style: TextStyle(
                                          fontSize: titleFontSize,
                                          color:
                                              Color.fromRGBO(202, 202, 202, 1),
                                          fontFamily: 'Jura',
                                        ))),
                                SizedBox(height: titleFontSize),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Почта: ${userInfo['email']}',
                                    style: TextStyle(
                                      fontSize: titleFontSize,
                                      color: Color.fromRGBO(202, 202, 202, 1),
                                      fontFamily: 'Jura',
                                    ),
                                  ),
                                ),
                                SizedBox(height: titleFontSize),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Номер телефона:',
                                          style: TextStyle(
                                            fontSize: titleFontSize,
                                            color: Color.fromRGBO(
                                                202, 202, 202, 1),
                                            fontFamily: 'Jura',
                                          ),
                                        ),
                                        SizedBox(width: 8.0),
                                        if (!isExtraSmallScreen)
                                          Expanded(
                                            child: Text(
                                              userInfo['phone_number'],
                                              style: TextStyle(
                                                fontSize: titleFontSize,
                                                color: Color.fromRGBO(
                                                    202, 202, 202, 1),
                                                fontFamily: 'Jura',
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                    if (isExtraSmallScreen)
                                      Padding(
                                        padding: EdgeInsets.only(top: 8.0),
                                        child: Text(
                                          userInfo['phone_number'],
                                          style: TextStyle(
                                            fontSize: titleFontSize,
                                            color: Color.fromRGBO(
                                                202, 202, 202, 1),
                                            fontFamily: 'Jura',
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ), // Space between text fields and avatar
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                  height:
                                      0), // Space between text fields and avatar
                              Align(
                                alignment: Alignment.topCenter,
                                child: GestureDetector(
                                  onTap: () async {
                                    FilePickerResult? result =
                                        await FilePicker.platform.pickFiles(
                                      type: FileType.image,
                                      allowMultiple: false,
                                    );

                                    if (result != null) {
                                      PlatformFile file = result.files.first;
                                      await uploadAvatar(
                                          widget.userId.toString(),
                                          file.bytes!,
                                          file.name);
                                      setState(() {
                                        _userInfoFuture =
                                            fetchUserInfo(widget.userId);
                                      });
                                    }
                                  },
                                  child: FutureBuilder<Map<String, dynamic>>(
                                    future: _userInfoFuture,
                                    builder: (context, snapshot) {
                                      final userInfo = snapshot.data;
                                      final avatarUrl = userInfo?['avatar_url'];

                                      return CircleAvatar(
                                        radius: avatarRadius,
                                        backgroundColor: const Color.fromRGBO(
                                            100, 100, 100, 1),
                                        backgroundImage: avatarUrl != null &&
                                                avatarUrl.isNotEmpty
                                            ? NetworkImage(avatarUrl)
                                            : null,
                                        child: avatarUrl == null ||
                                                avatarUrl.isEmpty
                                            ? Image.asset(
                                                "assets/person.png",
                                                scale: isExtraSmallScreen
                                                    ? 8
                                                    : isSmallScreen
                                                        ? 6
                                                        : isMediumScreen
                                                            ? 5
                                                            : 5,
                                              )
                                            : null,
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
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
      },
    );
  }
}

class LicenseInfoCard extends StatelessWidget {
  final int userId;
  final Map<String, dynamic>? userInfo;

  const LicenseInfoCard({Key? key, required this.userId, this.userInfo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMediumScreen = screenWidth <= 1450 && screenWidth > 1000;
    final isSmallScreen = screenWidth <= 1000 && screenWidth > 870;
    final isExtraSmallScreen = screenWidth <= 870;

    final double fontButton = isExtraSmallScreen
        ? 18
        : isMediumScreen
            ? 18
            : isSmallScreen
                ? 14
                : 18;
    final double identifierCardWidth = isMediumScreen
        ? 300
        : isSmallScreen
            ? 250
            : 357;
    final double identifierCardHeight = isExtraSmallScreen
        ? 90
        : isMediumScreen
            ? 111
            : isSmallScreen
                ? 85
                : 111;
    final double licenseCardWidth = isMediumScreen
        ? 300
        : isSmallScreen
            ? 250
            : 357;
    final double licenseCardHeight = isExtraSmallScreen
        ? 175
        : isMediumScreen
            ? 200
            : isSmallScreen
                ? 167
                : 200;
    double titleFontSize = isExtraSmallScreen
        ? 14
        : isMediumScreen
            ? 18
            : isSmallScreen
                ? 14
                : 20;
    double headTitleFontSize = isExtraSmallScreen
        ? 20
        : isMediumScreen
            ? 25
            : isSmallScreen
                ? 20
                : 30;

    return FutureBuilder<Map<String, dynamic>>(
      future: userInfo == null ? fetchUserInfo(userId) : Future.value(userInfo),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else {
          final licenseInfo = snapshot.data!;
          return _buildLicenseInfo(
            licenseInfo,
            context,
            identifierCardWidth,
            identifierCardHeight,
            licenseCardWidth,
            licenseCardHeight,
            titleFontSize,
            headTitleFontSize,
            fontButton,
          );
        }
      },
    );
  }

  Widget _buildLicenseInfo(
    Map<String, dynamic> licenseInfo,
    BuildContext context,
    double identifierCardWidth,
    double identifierCardHeight,
    double licenseCardWidth,
    double licenseCardHeight,
    double titleFontSize,
    double headTitleFontSize,
    double fontButton,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;
    final heightMediumScreen = screenWidth <= 1450 && screenWidth > 1000;
    final heightSmallScreen = screenWidth <= 1000 && screenWidth > 870;
    final isExtraSmallScreen = screenWidth <= 870;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _buildIdentifierCard(
          licenseInfo['uid'],
          titleFontSize,
          context,
          identifierCardWidth,
          identifierCardHeight,
          headTitleFontSize,
        ),
        SizedBox(
            height: isExtraSmallScreen
                ? 0
                : heightMediumScreen
                    ? 28
                    : heightSmallScreen
                        ? 0
                        : 120),
        _buildLicenseStatusCard(
          licenseInfo,
          titleFontSize,
          headTitleFontSize,
          userId,
          context,
          licenseCardWidth,
          licenseCardHeight,
          fontButton,
        ),
      ],
    );
  }

  Widget _buildIdentifierCard(
    String uid,
    double titleFontSize,
    BuildContext context,
    double cardWidth,
    double cardHeight,
    double headTitleFontSize,
  ) {
    return Container(
      width: cardWidth,
      height: cardHeight,
      child: Card(
        color: const Color.fromRGBO(53, 50, 50, 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(13),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Идентификатор',
                      style: TextStyle(
                        fontSize: headTitleFontSize,
                        color: Color.fromRGBO(236, 236, 236, 1),
                        fontFamily: 'Jura',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      uid,
                      style: TextStyle(
                        fontSize: titleFontSize,
                        color: Color.fromRGBO(202, 202, 202, 1),
                        fontFamily: 'Jura',
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                iconSize: 24,
                icon: const Icon(
                  Icons.copy,
                  color: Colors.white,
                ),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: uid));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('UID скопирован')),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLicenseStatusCard(
    Map<String, dynamic> licenseInfo,
    double titleFontSize,
    double headTitleFontSize,
    int userId,
    BuildContext context,
    double cardWidth,
    double cardHeight,
    double fontButton,
  ) {
    return Container(
      width: cardWidth,
      height: cardHeight,
      child: Card(
        color: const Color.fromRGBO(53, 50, 50, 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text('Статус лицензии',
                    style: TextStyle(
                      fontSize: headTitleFontSize,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(236, 236, 236, 1),
                      fontFamily: 'Jura',
                    )),
              ),
              const SizedBox(
                height: 5,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Статус: Активна',
                    style: TextStyle(
                      fontSize: titleFontSize,
                      color: Color.fromRGBO(202, 202, 202, 1),
                      fontFamily: 'Jura',
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Срок окончания: ${calculateRemainingDays(licenseInfo['expiration_date'])} дней',
                    style: TextStyle(
                      fontSize: titleFontSize,
                      color: Color.fromRGBO(202, 202, 202, 1),
                      fontFamily: 'Jura',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10), // Add space between elements
              Center(
                child: Container(
                  width: 220,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () {
                      locator<NavigationService>()
                          .navigateTo(RenewRatesRoute, arguments: userId);
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color.fromRGBO(100, 100, 100, 1)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Продлить лицензию',
                        style: TextStyle(
                          fontSize: fontButton,
                          color: Color.fromRGBO(202, 202, 202, 1),
                          fontFamily: 'Jura',
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

Future<Map<String, dynamic>> fetchUserInfo(int userId,
    {bool fetchAvatar = true}) async {
  final response =
      await http.get(Uri.parse('http://62.217.182.138:3000/user/${userId}'));
  final licenseResponse = await http
      .get(Uri.parse('http://62.217.182.138:3000/licenseInfo/${userId}'));

  if (response.statusCode == 200 && licenseResponse.statusCode == 200) {
    final userInfo = jsonDecode(response.body);
    final licenseInfo = jsonDecode(licenseResponse.body);
    final avatarResponse = await http
        .get(Uri.parse('http://62.217.182.138:3000/getAvatar/${userId}'));
    String? avatarUrl;
    if (avatarResponse.statusCode == 200) {
      final avatarData = jsonDecode(avatarResponse.body);
      avatarUrl = avatarData['avatarUrl'];
    }
    return {
      'uid': licenseInfo['uid'] ?? '',
      'expiration_date': licenseInfo['expiration_date'] ?? '',
      'username': userInfo['username'] ?? '',
      'email': userInfo['email'] ?? '',
      'phone_number': userInfo['phone_number'] ?? '',
      'avatar_url': avatarUrl ?? '',
    };
  } else {
    throw Exception('Failed to load user info');
  }
}

Future<File?> pickImage() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['png', 'jpg'],
    allowMultiple: false,
  );

  if (result != null) {
    PlatformFile file = result.files.first;
    return File(file.path!);
  } else {
    return null;
  }
}

Future<void> uploadAvatar(
    String userId, List<int> imageBytes, String fileName) async {
  final url = Uri.parse('http://62.217.182.138:3000/uploadAvatar/$userId');
  final request = http.MultipartRequest('POST', url);
  request.files.add(
      http.MultipartFile.fromBytes('avatar', imageBytes, filename: fileName));

  final response = await request.send();
  final responseData = await response.stream.bytesToString();

  if (response.statusCode == 200) {
    final data = jsonDecode(responseData);
    final avatarUrl = data['avatarUrl'];
    print('Avatar uploaded successfully. URL: $avatarUrl');
  } else {
    print('Failed to upload avatar: ${response.reasonPhrase}');
  }
}

int calculateRemainingDays(String? expirationDate) {
  if (expirationDate == null) return 0;

  DateTime now = DateTime.now();
  DateTime expire = DateTime.parse(expirationDate);
  int difference = expire.difference(now).inDays;
  return difference > 0 ? difference : 0;
}

class Footer extends StatelessWidget {
  const Footer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromRGBO(53, 50, 50, 1),
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
