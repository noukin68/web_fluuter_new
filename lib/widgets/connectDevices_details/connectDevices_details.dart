import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:convert';
import 'package:web_flutter/utils/responsiveLayout.dart';

class ConnectionManager {
  late IO.Socket socket;
  late List<String> connectedUIDs;
  late Map<String, IO.Socket> sockets;
  static List<String> staticConnectedUIDs = [];

  ConnectionManager() {
    connectedUIDs = staticConnectedUIDs;
    sockets = {};
    initSocket();
  }

  void initSocket() {
    socket = IO.io('http://62.217.182.138:3000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket.connect();

    socket.on('action', (data) {
      String uid = data['uid'];
      String action = data['action'];
      print('Received action: $action for UID: $uid');
    });
  }

  Future<void> addUID(String uid) async {
    Map<String, dynamic> requestBody = {
      'uid': uid,
      'type': 'flutter',
    };

    try {
      var response = await http.post(
        Uri.parse('http://62.217.182.138:3000/check-uid-license'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        socket.emit('join', requestBody);
        socket.once('joined', (data) {
          if (!staticConnectedUIDs.contains(uid)) {
            staticConnectedUIDs.add(uid);
            connectedUIDs = staticConnectedUIDs;
            sockets[uid] = socket;
            updateConnectedDevicesList(uid);
          }
          socket.emit('flutter-connected', {'uid': uid});
        });
      } else {
        var jsonResponse = jsonDecode(response.body);
        throw Exception('Ошибка: ${jsonResponse['error']}');
      }
    } catch (error) {
      throw Exception('Ошибка: $error');
    }
  }

  void Function(String) updateConnectedDevicesList = (String uid) {};

  void setUpdateConnectedDevicesListCallback(void Function(String) callback) {
    updateConnectedDevicesList = callback;
  }

  void disconnectUID(String uid) {
    staticConnectedUIDs.remove(uid);
    connectedUIDs = staticConnectedUIDs;
    sockets.remove(uid);
    socket.emit('disconnect-uid', uid);
    socket.emit('flutter-disconnected', {'uid': uid});
    updateConnectedDevicesList(uid);
  }
}

class ConnectDevicesDetails extends StatelessWidget {
  final int userId;
  final ConnectionManager connectionManager;

  const ConnectDevicesDetails(
      {Key? key, required this.userId, required this.connectionManager})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: [
            Color.fromRGBO(111, 128, 20, 1),
            Color.fromRGBO(111, 128, 20, 1),
            Color.fromRGBO(55, 55, 55, 1), // Цвет внутри круга// Цвет вне круга
          ],
          center: Alignment.bottomRight, // Центр градиента - по центру экрана
          radius: 1.8, // Радиус градиента
          stops: [0.2, 0.3, 1], // Остановки для цветового перехода
        ),
      ),
      child: ResponsiveLayout(
        largeScreen:
            DesktopView(userId: userId, connectionManager: connectionManager),
        mediumScreen:
            TabletView(userId: userId, connectionManager: connectionManager),
        smallScreen:
            MobileView(userId: userId, connectionManager: connectionManager),
      ),
    );
  }
}

class DesktopView extends StatefulWidget {
  final int userId;
  final ConnectionManager connectionManager;

  const DesktopView(
      {Key? key, required this.userId, required this.connectionManager})
      : super(key: key);

  @override
  State<DesktopView> createState() => _DesktopViewState();
}

class _DesktopViewState extends State<DesktopView> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMediumScreen = screenWidth <= 1450 && screenWidth > 1000;
    final isSmallScreen = screenWidth <= 1000 && screenWidth > 870;
    final isExtraSmallScreen = screenWidth <= 870;

    final double cardWidth = isExtraSmallScreen
        ? 360.5
        : isMediumScreen
            ? 721
            : isSmallScreen
                ? 721
                : 721;
    final double cardHeight = isExtraSmallScreen
        ? 136
        : isMediumScreen
            ? 272
            : isSmallScreen
                ? 272
                : 272;
    final double fontTitle = isExtraSmallScreen
        ? 20
        : isMediumScreen
            ? 54
            : isSmallScreen
                ? 44
                : 64;
    return Column(
      children: [
        SizedBox(height: 40.0),
        SizedBox(
          width: cardWidth,
          height: cardHeight,
          child: ConnectDevicesCard(
            userId: widget.userId,
            connectionManager: widget.connectionManager,
          ),
        ),
        Expanded(
          child: Align(
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                Text(
                  'Список подключенных устройств:',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: fontTitle,
                    fontFamily: 'Jura',
                  ),
                ),
                SizedBox(height: 20.0),
                Expanded(
                  child: Container(
                    width: 957,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(53, 50, 50, 1),
                      borderRadius: BorderRadius.circular(60),
                    ),
                    child: ConnectedDevicesList(
                      userId: widget.userId,
                      connectedUIDs: widget.connectionManager.connectedUIDs,
                      disconnectUID: widget.connectionManager.disconnectUID,
                      connectionManager: widget.connectionManager,
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class TabletView extends StatefulWidget {
  final int userId;
  final ConnectionManager connectionManager;

  const TabletView(
      {Key? key, required this.userId, required this.connectionManager})
      : super(key: key);

  @override
  State<TabletView> createState() => _TabletViewState();
}

class _TabletViewState extends State<TabletView> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMediumScreen = screenWidth <= 1450 && screenWidth > 1000;
    final isSmallScreen = screenWidth <= 1000 && screenWidth > 870;
    final isExtraSmallScreen = screenWidth <= 870;

    final double cardWidth = isExtraSmallScreen
        ? 360.5
        : isMediumScreen
            ? 721
            : isSmallScreen
                ? 721
                : 721;
    final double cardHeight = isExtraSmallScreen
        ? 136
        : isMediumScreen
            ? 272
            : isSmallScreen
                ? 272
                : 272;
    final double fontTitle = isExtraSmallScreen
        ? 20
        : isMediumScreen
            ? 54
            : isSmallScreen
                ? 44
                : 64;
    return Column(
      children: [
        SizedBox(height: 40.0),
        SizedBox(
          width: cardWidth,
          height: cardHeight,
          child: ConnectDevicesCard(
            userId: widget.userId,
            connectionManager: widget.connectionManager,
          ),
        ),
        Expanded(
          child: Align(
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                Text(
                  'Список подключенных устройств:',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: fontTitle,
                    fontFamily: 'Jura',
                  ),
                ),
                SizedBox(height: 20.0),
                Expanded(
                  child: Container(
                    width: 957,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(53, 50, 50, 1),
                      borderRadius: BorderRadius.circular(60),
                    ),
                    child: ConnectedDevicesList(
                      userId: widget.userId,
                      connectedUIDs: widget.connectionManager.connectedUIDs,
                      disconnectUID: widget.connectionManager.disconnectUID,
                      connectionManager: widget.connectionManager,
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class MobileConnectedDevicesList extends StatefulWidget {
  final List<String> connectedUIDs;
  final Function(String) disconnectUID;
  final ConnectionManager connectionManager;

  MobileConnectedDevicesList({
    Key? key,
    required this.connectedUIDs,
    required this.disconnectUID,
    required this.connectionManager,
  }) : super(key: key);

  @override
  State<MobileConnectedDevicesList> createState() =>
      _MobileConnectedDevicesListState();
}

class _MobileConnectedDevicesListState
    extends State<MobileConnectedDevicesList> {
  @override
  void initState() {
    super.initState();
    widget.connectionManager.setUpdateConnectedDevicesListCallback(updateList);
  }

  void updateList(String uid) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.connectedUIDs.map((uid) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Container(
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(100, 100, 100, 1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: FittedBox(
                    // Обертка текста
                    fit: BoxFit.scaleDown, // Масштабирование текста
                    child: Text(
                      uid,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontFamily: 'Jura',
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 20), // Отступ между текстом и кнопкой
              Flexible(
                child: Container(
                  height: 61,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: ElevatedButton(
                      onPressed: () {
                        widget.connectionManager.disconnectUID(uid);
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          Color.fromRGBO(34, 16, 16, 1),
                        ),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(35),
                          ),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Отключить',
                          style: TextStyle(
                            fontSize: 28, // Уменьшаем размер шрифта
                            color: Color.fromRGBO(202, 202, 202, 1),
                            fontFamily: 'Jura',
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class MobileView extends StatefulWidget {
  final int userId;
  final ConnectionManager connectionManager;

  const MobileView(
      {Key? key, required this.userId, required this.connectionManager})
      : super(key: key);

  @override
  State<MobileView> createState() => _MobileViewState();
}

class _MobileViewState extends State<MobileView> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMediumScreen = screenWidth <= 1450 && screenWidth > 1000;
    final isSmallScreen = screenWidth <= 1000 && screenWidth > 870;
    final isExtraSmallScreen = screenWidth <= 870;

    final double cardWidth = isExtraSmallScreen
        ? 360.5
        : isMediumScreen
            ? 721
            : isSmallScreen
                ? 721
                : 721;
    final double cardHeight = isExtraSmallScreen
        ? 136
        : isMediumScreen
            ? 272
            : isSmallScreen
                ? 272
                : 272;
    final double fontTitle = isExtraSmallScreen
        ? 20
        : isMediumScreen
            ? 54
            : isSmallScreen
                ? 44
                : 64;
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 30.0),
          SizedBox(
            width: cardWidth,
            height: cardHeight,
            child: ConnectDevicesCard(
              userId: widget.userId,
              connectionManager: widget.connectionManager,
            ),
          ),
          SizedBox(height: 50.0),
          Text(
            'Список подключенных устройств:',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: fontTitle,
              fontFamily: 'Jura',
            ),
          ),
          SizedBox(height: 20.0),
          Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.3,
            decoration: BoxDecoration(
              color: Color.fromRGBO(53, 50, 50, 1),
              borderRadius: BorderRadius.circular(30),
            ),
            child: MobileConnectedDevicesList(
              connectedUIDs: widget.connectionManager.connectedUIDs,
              disconnectUID: widget.connectionManager.disconnectUID,
              connectionManager: widget.connectionManager,
            ),
          ),
          SizedBox(height: 20.0),
        ],
      ),
    );
  }
}

class ConnectDevicesCard extends StatefulWidget {
  final int userId;
  final ConnectionManager connectionManager;

  const ConnectDevicesCard({
    Key? key,
    required this.userId,
    required this.connectionManager,
  }) : super(key: key);

  @override
  State<ConnectDevicesCard> createState() => _ConnectDevicesCardState();
}

class _ConnectDevicesCardState extends State<ConnectDevicesCard> {
  TextEditingController uidController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMediumScreen = screenWidth <= 1450 && screenWidth > 1000;
    final isSmallScreen = screenWidth <= 1000 && screenWidth > 870;
    final isExtraSmallScreen = screenWidth <= 870;

    final double cardWidth = isExtraSmallScreen
        ? 278.5
        : isMediumScreen
            ? 557
            : isSmallScreen
                ? 557
                : 557;
    final double cardHeight = isExtraSmallScreen
        ? 50
        : isMediumScreen
            ? 85
            : isSmallScreen
                ? 85
                : 85;
    final double buttonWidth = isExtraSmallScreen
        ? 165
        : isMediumScreen
            ? 330
            : isSmallScreen
                ? 330
                : 330;
    final double buttonHeight = isExtraSmallScreen
        ? 33
        : isMediumScreen
            ? 74
            : isSmallScreen
                ? 74
                : 74;
    final double titleFontSize = isExtraSmallScreen
        ? 20
        : isMediumScreen
            ? 48
            : isSmallScreen
                ? 48
                : 48;
    final double heightSize = isExtraSmallScreen
        ? 25
        : isMediumScreen
            ? 50
            : isSmallScreen
                ? 50
                : 50;
    return Card(
      color: Color.fromRGBO(53, 50, 50, 1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(60)),
      child: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: cardWidth,
              height: cardHeight,
              child: TextField(
                controller: uidController,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: titleFontSize,
                    fontFamily: 'Jura'),
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color.fromRGBO(100, 100, 100, 1),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  hintText: 'Идентификатор',
                  hintStyle: TextStyle(
                      fontSize: titleFontSize,
                      color: Colors.white,
                      fontFamily: 'Jura'),
                ),
              ),
            ),
            SizedBox(height: heightSize),
            SizedBox(
              width: buttonWidth,
              height: buttonHeight,
              child: ElevatedButton(
                onPressed: () {
                  String uid = uidController.text.trim();
                  if (uid.isNotEmpty) {
                    widget.connectionManager.addUID(uid);
                    uidController.clear();
                  } else {
                    showErrorMessage(
                        'Пожалуйста, введите действительный UID', context);
                  }
                },
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      Color.fromRGBO(34, 16, 16, 1),
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(35.0),
                      ),
                    )),
                child: Text(
                  'Подключить',
                  style:
                      TextStyle(color: Colors.white, fontSize: titleFontSize),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void showErrorMessage(String message, BuildContext context) {
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

class ConnectedDevicesList extends StatefulWidget {
  final int userId;
  final List<String> connectedUIDs;
  final Function(String) disconnectUID;
  final ConnectionManager connectionManager;

  ConnectedDevicesList({
    Key? key,
    required this.userId,
    required this.connectedUIDs,
    required this.disconnectUID,
    required this.connectionManager,
  }) : super(key: key);

  @override
  State<ConnectedDevicesList> createState() => _ConnectedDevicesListState();
}

class _ConnectedDevicesListState extends State<ConnectedDevicesList>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
    widget.connectionManager.setUpdateConnectedDevicesListCallback(updateList);
  }

  void updateList(String uid) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.connectedUIDs.isEmpty
        ? Center(
            child: Text(
              'У пользователя нет подключений',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 30, color: Colors.white, fontFamily: 'Jura'),
            ),
          )
        : Column(
            children: widget.connectedUIDs.map((uid) {
              return Padding(
                padding: EdgeInsets.symmetric(
                    vertical: 30.0,
                    horizontal: 30.0), // Отступы по вертикали и горизонтали
                child: SizedBox(
                  height:
                      70, // Фиксированная высота для каждого элемента списка
                  child: Row(
                    children: [
                      SizedBox(
                        width: 437,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            alignment: Alignment.centerLeft,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(100, 100, 100, 1),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text(
                              uid,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 40,
                                fontFamily: 'Jura',
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 20), // Отступ между текстом и кнопкой
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            width: 245,
                            height: 61,
                            child: ElevatedButton(
                              onPressed: () {
                                widget.disconnectUID(uid);
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  Color.fromRGBO(34, 16, 16, 1),
                                ),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(35),
                                  ),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  'Отключить',
                                  style: TextStyle(
                                    fontSize: 36,
                                    color: Color.fromRGBO(202, 202, 202, 1),
                                    fontFamily: 'Jura',
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
  }

  @override
  bool get wantKeepAlive => true;
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
