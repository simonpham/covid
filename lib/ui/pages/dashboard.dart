/*
 * Created by Simon Pham on Aug 16, 2020
 * Email: simon@simonit.dev
 */

import 'dart:math';

import 'package:fluda/fluda.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import '../../constants/colors.dart';
import '../../constants/numbers.dart';
import '../../data/world_map.dart';
import '../../ui/widgets/map_country.dart';
import '../../ui/widgets/world_map_sliver_app_bar.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with TickerProviderStateMixin {
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
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: NotificationListener(
          onNotification: _handleScrollNotification,
          child: NestedScrollView(
            controller: _scrollController,
            headerSliverBuilder: (_, __) => [
              SliverPersistentHeader(
                pinned: true,
                delegate: WorldMapSliverAppBar(
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
      final middleBound = kExpandedAppBarHeight * 0.5;

      if (offset < middleBound && offset != 0.0) {
        await _scrollController.goTo(0.0);
      }

      if (offset >= middleBound && offset != kExpandedAppBarHeight) {
        await _scrollController.goTo(kExpandedAppBarHeight);
      }

      _isSnapping = false;
    });
  }
}
