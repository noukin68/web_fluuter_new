import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:web_flutter/views/connectDevices/connectDevices_content_desktop.dart';
import 'package:web_flutter/views/connectDevices/connectDevices_content_mobile.dart';
import 'package:web_flutter/widgets/connectDevices_details/connectDevices_details.dart';

class ConnectDevicesView extends StatelessWidget {
  final int userId;
  final ConnectionManager connectionManager; // Assuming ConnectionManager is required
  const ConnectDevicesView({Key? key, required this.userId, required this.connectionManager}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: ConnectDevicesContentMobile(userId: userId, connectionManager: connectionManager),
      desktop: ConnectDevicesContentDesktop(userId: userId, connectionManager: connectionManager),
    );
  }
}
