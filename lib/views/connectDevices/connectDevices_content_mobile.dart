import 'package:flutter/material.dart';
import 'package:web_flutter/widgets/connectDevices_details/connectDevices_details.dart';

class ConnectDevicesContentMobile extends StatelessWidget {
  final int userId;
  final ConnectionManager connectionManager; // Define connectionManager

  const ConnectDevicesContentMobile({Key? key, required this.userId, required this.connectionManager}) // Add connectionManager to constructor
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              child: ConnectDevicesDetails(userId: userId, connectionManager: connectionManager), // Pass connectionManager to ConnectDevicesDetails
            ),
          ),
          Footer(),
        ],
      ),
    );
  }
}