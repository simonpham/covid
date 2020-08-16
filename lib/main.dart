import 'dart:math';

import 'package:covid/data/world_map.dart';
import 'package:covid/utils/extensions.dart';
import 'package:fluda/fluda.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import 'constants/numbers.dart';

void main() {
  runApp(
    Covid(),
  );
}

class Covid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return NeumorphicApp(
      debugShowCheckedModeBanner: false,
      title: 'COVID-19',
      darkTheme: NeumorphicThemeData.dark(),
      theme: NeumorphicThemeData(
        baseColor: Colors.white,
        textTheme: GoogleFonts.ralewayTextTheme(),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  bool _isSnapping = false;

  final List<MapCountry> _countries = <MapCountry>[];

  int _selectedTopCountriesTab = 0;
  var color;

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));

    for (var country in worldMap["shapes"].keys) {
      final random = Random().nextDouble();
      _countries.add(
        MapCountry(
          country: country,
          doubleRandom: random,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: NotificationListener(
          onNotification: _handleScrollNotification,
          child: NestedScrollView(
            controller: _scrollController,
            headerSliverBuilder: (_, __) => [
              SliverPersistentHeader(
                pinned: true,
                delegate: CustomSliverAppBar(
                  countries: _countries,
                ),
              )
            ],
            body: Neumorphic(
              style: NeumorphicStyle(
                color: Colors.red.withOpacity(0.01),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "Top Countries",
                        style: context.theme.textTheme.headline6,
                      ).expand(),
                      NeumorphicButton(
                        onPressed: () {},
                        child: Text(
                          "View all",
                        ),
                      ),
                    ],
                  ).padHorizontal().marginTop(3),
                  Row(
                    children: [
                      NeumorphicToggle(
                        onChanged: (index) {
                          setState(() {
                            _selectedTopCountriesTab = index;
                          });
                        },
                        thumb: Neumorphic(),
                        selectedIndex: _selectedTopCountriesTab,
                        children: [
                          ToggleElement(
                            foreground: Text(
                              "Infected",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ).center(),
                            background: Text("Infected").center(),
                          ),
                          ToggleElement(
                            foreground: Text(
                              "Recovered",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ).center(),
                            background: Text("Recovered").center(),
                          ),
                          ToggleElement(
                            foreground: Text(
                              "Death",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ).center(),
                            background: Text("Death").center(),
                          ),
                        ],
                      ).expand(),
                    ],
                  ).padHorizontal().marginTop(),
                  Neumorphic(
                    margin: const EdgeInsets.all(FludaX.x3),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "China",
                        ).center(),
                        NeumorphicButton(
                          onPressed: () {},
                          child: Text(
                            "Details",
                          ),
                        ).marginTop(),
                      ],
                    ).spaceAround(3),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    // rebuild widget with updated _getMarginTopFactor
    setState(() {});

    if (!_isSnapping && notification is ScrollEndNotification) {
      _onEndScroll();
    }
    return true;
  }

  void _onEndScroll() {
    _isSnapping = true;

    Future.microtask(() async {
      final offset = _scrollController.offset;
      final middleBound = expandedAppBarHeight * 0.5;

      if (offset < middleBound && offset != 0.0) {
        await _scrollController.goTo(0.0);
      }

      if (offset >= middleBound && offset != expandedAppBarHeight) {
        await _scrollController.goTo(expandedAppBarHeight);
      }

      _isSnapping = false;
    });
  }
}

class CustomSliverAppBar extends SliverPersistentHeaderDelegate {
  final List<MapCountry> countries;

  CustomSliverAppBar({this.countries});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Stack(
      children: [
        Positioned(
          top: FludaX.x6,
          left: 0,
          right: 0,
          child: NeumorphicText(
            "Worldwide COVID-19",
            style: NeumorphicStyle(
              color: Colors.redAccent.withOpacity(
                1.0 -
                    max(
                      0.0,
                      min(2.0 * shrinkOffset / maxExtent, 1.0),
                    ),
              ),
            ),
            textStyle: NeumorphicTextStyle(
              fontSize: FludaX.x4,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ]..addAll(
          countries.map(
            (MapCountry country) {
              return Positioned(
                top: 0 - shrinkOffset * 2 * country.doubleRandom,
                left: 0 - shrinkOffset * 2 * country.doubleRandom,
                right: 0 - shrinkOffset * 2 * country.doubleRandom,
                bottom: -100,
                child: country,
              );
            },
          ).toList(growable: false),
        ),
    );
  }

  @override
  double get maxExtent => expandedAppBarHeight;

  @override
  double get minExtent => collapsedAppBarHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}

class MapCountry extends StatefulWidget {
  final double doubleRandom;
  final String country;

  const MapCountry({Key key, this.country, this.doubleRandom})
      : super(key: key);

  @override
  _MapCountryState createState() => _MapCountryState();
}

const Color background = Color.fromRGBO(249, 243, 243, 1.0);
const Color mostInfected = Color.fromRGBO(255, 48, 47, 1.0);
const Color lessInfected = Color.fromRGBO(255, 130, 129, 1.0);

class _MapCountryState extends State<MapCountry> {
  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.string(
      '''
      <svg height="400" width="1000">
          <path d="${worldMap["shapes"][widget.country]}" stroke="${background.toHex()}" stroke-width="1" fill="${(isHover ? mostInfected : lessInfected).toHex()}" />
      </svg>
          ''',
      key: UniqueKey(),
    );
  }
}
