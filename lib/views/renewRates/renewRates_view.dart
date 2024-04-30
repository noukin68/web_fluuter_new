import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:web_flutter/views/renewRates/renewRates_content_desktop.dart';
import 'package:web_flutter/views/renewRates/renewRates_content_mobile.dart';

class RenewRatesView extends StatelessWidget {
  final int userId;

  const RenewRatesView({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: RenewRatesMobile(userId: userId),
      desktop: RenewRatesDesktop(userId: userId),
    );
  }
}
