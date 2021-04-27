import 'package:flutter/material.dart';
import 'package:global_template/global_template.dart';
import 'package:google_fonts/google_fonts.dart';

import './screen/music_player/music_player_screen.dart';
import './screen/music_player_detail/music_player_detail_screen.dart';
import './screen/splash/splash_screen.dart';
import './screen/welcome/welcome_screen.dart';

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final routeAnimation = RouteAnimation();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kalmics',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: colorPallete.primaryColor,
        accentColor: colorPallete.accentColor,
        textTheme: GoogleFonts.openSansTextTheme(),
      ),
      home: SplashScreen(),
      onGenerateRoute: (settings) {
        if (settings.name == MusicPlayerScreen.routeNamed) {
          return routeAnimation.slideTransition(
            screen: (ctx, animation, secondaryAnimation) => MusicPlayerScreen(),
            slidePosition: SlidePosition.fromLeft,
          );
        } else if (settings.name == MusicPlayerDetailScreen.routeNamed) {
          return routeAnimation.fadeTransition(
            screen: (ctx, animation, secondaryAnimation) => MusicPlayerDetailScreen(),
          );
        } else if (settings.name == WelcomeScreen.routeNamed) {
          return routeAnimation.scaleTransition(
            screen: (ctx, animation, secondaryAnimation) => WelcomeScreen(),
          );
        }
        return MaterialPageRoute(builder: (_) => UnknownScreen());
      },
    );
  }
}
