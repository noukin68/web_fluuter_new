import 'package:flutter/material.dart';
import 'package:web_flutter/authProvider.dart';
import 'package:web_flutter/views/layout_template/layout_template.dart';

import 'locator.dart';

void main() {
  setupLocator();
  runApp(
    AuthorizationProvider(
      child: MyApp(),
      isAuthorized: false,
      hasLicense: false,
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Parental Control',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: Theme.of(context).textTheme.apply(fontFamily: 'Jura'),
      ),
      home: LayoutTemplate(),
    );
  }
}
