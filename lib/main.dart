import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:google_fonts/google_fonts.dart';

import 'ui/pages/dashboard.dart';

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
      themeMode: ThemeMode.light,
      theme: NeumorphicThemeData(
        baseColor: Colors.white,
        textTheme: GoogleFonts.ralewayTextTheme(),
      ),
      home: Dashboard(),
    );
  }
}
