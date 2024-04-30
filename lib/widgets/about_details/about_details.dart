import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:web_flutter/utils/responsiveLayout.dart';

class AboutDetails extends StatelessWidget {
  final int userId;
  const AboutDetails({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: [
            Colors.purple,
            Colors.purple,
            Color.fromRGBO(55, 55, 55, 1),
          ],
          center: Alignment.centerLeft,
          radius: 1.8,
          stops: [0.2, 0.3, 1],
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

class DesktopView extends StatelessWidget {
  final int userId;
  const DesktopView({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = ResponsiveLayout.isLargeScreen(context);
        final double imageWidth = isWide ? 400 : 200;
        final double cardWidth = isWide ? 1180 : double.infinity;

        return Container(
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          flex: isWide ? 2 : 1,
                          child: SizedBox(
                            width: imageWidth,
                            child: AspectRatio(
                              aspectRatio: 1.0,
                              child: Image.asset(
                                'assets/family.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          flex: isWide ? 3 : 1,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: FittedBox(
                              fit: BoxFit.contain,
                              child: SizedBox(
                                width: cardWidth,
                                child: const CardContent(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class TabletView extends StatelessWidget {
  final int userId;
  const TabletView({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = ResponsiveLayout.isMediumScreen(context);
        final double imageWidth = isWide ? 300 : 200;
        final double cardWidth = isWide ? double.infinity : 400;

        return SingleChildScrollView(
          child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          flex: isWide ? 1 : 2,
                          child: SizedBox(
                            width: imageWidth,
                            child: AspectRatio(
                              aspectRatio: 1.0,
                              child: Image.asset(
                                'assets/family.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          flex: isWide ? 1 : 2,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: FittedBox(
                              fit: BoxFit.contain,
                              child: SizedBox(
                                width: cardWidth,
                                child: const CardContent(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class MobileView extends StatelessWidget {
  final int userId;
  const MobileView({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      width: 300,
                      child: AspectRatio(
                        aspectRatio: 1.0,
                        child: Image.asset(
                          'assets/family.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const CardContent(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CardContent extends StatelessWidget {
  const CardContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = ResponsiveLayout.isSmallScreen(context);
        final titleFontSize = isMobile ? 16.0 : 40.0;
        final titleFontWeight = FontWeight.w400;
        final contentPadding = isMobile ? 16.0 : 45.0;
        final double cardWidth = isMobile ? constraints.maxWidth - 32 : 810;
        final double? cardHeight = isMobile ? null : 607;

        return Positioned(
          top: 166,
          left: 610,
          child: SizedBox(
            width: cardWidth,
            height: cardHeight,
            child: Card(
              color: Colors.white.withOpacity(0.8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              child: Padding(
                padding: EdgeInsets.all(contentPadding),
                child: AutoSizeText.rich(
                  TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text:
                            'Ваш ребенок стал проводить слишком много времени в компьютере? Стал более',
                        style: TextStyle(
                          fontSize: titleFontSize,
                          fontWeight: titleFontWeight,
                        ),
                      ),
                      TextSpan(
                        text: ' агрессивным',
                        style: TextStyle(
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: ' и проводит все',
                        style: TextStyle(
                          fontSize: titleFontSize,
                          fontWeight: titleFontWeight,
                        ),
                      ),
                      TextSpan(
                        text: ' меньше времени с семьей',
                        style: TextStyle(
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: '? Мы поможем',
                        style: TextStyle(
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text:
                            ' решить вашу проблему! Наше приложение поможет избавить ',
                        style: TextStyle(fontSize: titleFontSize),
                      ),
                      TextSpan(
                        text: 'вашего ребенка',
                        style: TextStyle(
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text:
                            ' от компьютерной зависимости, а также "подтянет" его по предметам',
                        style: TextStyle(fontSize: titleFontSize),
                      ),
                      TextSpan(
                        text: ' на ваш выбор',
                        style: TextStyle(
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: '! Наше приложение имеет',
                        style: TextStyle(fontSize: titleFontSize),
                      ),
                      TextSpan(
                        text: ' гибкую',
                        style: TextStyle(
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: ' вопросительную',
                        style: TextStyle(fontSize: titleFontSize),
                      ),
                      TextSpan(
                        text: ' базу',
                        style: TextStyle(
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: ' по всем школьным предметам,',
                        style: TextStyle(fontSize: titleFontSize),
                      ),
                      TextSpan(
                        text: ' удобную настройку',
                        style: TextStyle(
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: ' и',
                        style: TextStyle(fontSize: titleFontSize),
                      ),
                      TextSpan(
                        text: ' простое управление',
                        style: TextStyle(
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: ' через мобильное устройство',
                        style: TextStyle(fontSize: titleFontSize),
                      ),
                      TextSpan(
                        text: ' с любой точки',
                        style: TextStyle(
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: ' земного шара.',
                        style: TextStyle(fontSize: titleFontSize),
                      ),
                    ],
                  ),
                  style: TextStyle(
                    fontFamily: 'Jura',
                    color: Colors.black,
                  ),
                  maxLines: 12,
                  overflow: TextOverflow.visible,
                ),
              ),
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
