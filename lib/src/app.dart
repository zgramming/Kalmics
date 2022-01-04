import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:global_template/global_template.dart';
import 'package:google_fonts/google_fonts.dart';

import 'presentation/pages/home/home_page.dart';
import 'presentation/pages/music_player/music_player_page.dart';
import 'presentation/pages/song_edit/song_edit_page.dart';
import 'presentation/pages/song_info/song_info_page.dart';
import 'presentation/pages/splash/splash_page.dart';
import 'presentation/pages/welcome/welcome_page.dart';
import 'utils/colors.dart';
import 'utils/navigation.dart';

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final ThemeData theme = ThemeData();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kalmics',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('id', 'ID')],
      navigatorKey: navigatorKey,
      theme: theme.copyWith(
        colorScheme: theme.colorScheme.copyWith(
          primary: primary,
          secondary: secondary,
          onError: Colors.red,
        ),
        textTheme: GoogleFonts.amikoTextTheme(Theme.of(context).textTheme),
        scaffoldBackgroundColor: primary,
        bottomSheetTheme: const BottomSheetThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(20.0),
            ),
          ),
        ),
      ),
      home: const SplashPage(),
      onGenerateRoute: (settings) {
        final routeAnimation = RouteAnimation();
        switch (settings.name) {
          case WelcomePage.routeNamed:
            return routeAnimation.fadeTransition(
              screen: (ctx, animation, secondaryAnimation) => const WelcomePage(),
            );

          case HomePage.routeNamed:
            return routeAnimation.fadeTransition(
              screen: (ctx, animation, secondaryAnimation) => const HomePage(),
            );

          case SongEditPage.routeNamed:
            return routeAnimation.fadeTransition(
              screen: (ctx, animation, secondaryAnimation) => const SongEditPage(),
            );

          case SongInfoPage.routeNamed:
            return routeAnimation.fadeTransition(
              screen: (ctx, animation, secondaryAnimation) => const SongInfoPage(),
            );

          case MusicPlayerPage.routeNamed:
            return routeAnimation.slideTransition(
              screen: (ctx, animation, secondaryAnimation) => const MusicPlayerPage(),
            );

          default:
        }
      },
    );
  }
}
