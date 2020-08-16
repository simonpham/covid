/*
 * Created by Simon Pham on Aug 16, 2020
 * Email: simon@simonit.dev
 */

import 'package:covid/ui/widgets/top_countries.dart';
import 'package:fluda/fluda.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';

import '../../constants/colors.dart';
import '../../constants/numbers.dart';
import '../../providers/covid_stats.dart';
import '../../ui/widgets/world_map_sliver_app_bar.dart';
import '../../utils/extensions.dart';
import '../widgets/case_summary.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final PageController _pageController = PageController();

  bool _isSnapping = false;

  int _selectedTopCountriesTab = 0;

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      context.read<CovidStats>().loadMap();
      await context.read<CovidStats>().loadWorldSummary();
      await context.read<CovidStats>().loadTopCountries();
      await context.read<CovidStats>().updateMap();
    });

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
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
                delegate: WorldMapSliverAppBar(),
              )
            ],
            body: Consumer<CovidStats>(
              builder: (_, CovidStats provider, __) {
                if (provider.worldSummary == null) {
                  return SummaryPlaceholder();
                }
                return Neumorphic(
                  style: NeumorphicStyle(
                    color: Colors.red.withOpacity(0.01),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CaseSummary(
                            title: "Total Cases",
                            subtitle:
                                "${provider.worldSummary.global.totalConfirmed.formatted}",
                            color: Colors.orange,
                          ).expand(),
                          SizedBox(width: FludaX.x),
                          CaseSummary(
                            title: "Recovered",
                            subtitle:
                                "${provider.worldSummary.global.totalRecovered.formatted}",
                            color: Colors.green,
                          ).expand(),
                          SizedBox(width: FludaX.x),
                          CaseSummary(
                            title: "Death",
                            subtitle:
                                "${provider.worldSummary.global.totalDeaths.formatted}",
                            color: Colors.red,
                          ).expand(),
                        ],
                      ).padHorizontal(3),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          NeumorphicText(
                            "Top Countries",
                            style: NeumorphicStyle(
                              color: Colors.black,
                            ),
                            textStyle: NeumorphicTextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                            textAlign: TextAlign.start,
                          ).expand(),
                          NeumorphicButton(
                            onPressed: () {
                              _scrollController.goTo(
                                  _scrollController.position.maxScrollExtent);
                            },
                            child: NeumorphicText(
                              "View all",
                              style: NeumorphicStyle(
                                color: Colors.black,
                              ),
                              textStyle: NeumorphicTextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.start,
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
                                _pageController.goTo(index);
                              });
                            },
                            thumb: Neumorphic(),
                            selectedIndex: _selectedTopCountriesTab,
                            children: [
                              ToggleElement(
                                foreground: Text(
                                  "Confirmed",
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
                      PageView(
                        onPageChanged: (index) {
                          setState(() {
                            _selectedTopCountriesTab = index;
                          });
                        },
                        controller: _pageController,
                        children: [
                          TopCountries(
                            provider.topConfirmedCountries,
                            topCase: TopCase.confirmed,
                          ),
                          TopCountries(
                            provider.topRecoveredCountries,
                            topCase: TopCase.recovered,
                          ),
                          TopCountries(
                            provider.topDeathCountries,
                            topCase: TopCase.death,
                          ),
                        ],
                      ).expand(),
                    ],
                  ),
                );
              },
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

class SummaryPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
