import 'package:flutter/material.dart';
import 'package:global_template/global_template.dart';
import 'package:google_fonts/google_fonts.dart';

import '../home_screen.dart';

class HomePageViewRecentPlay extends StatefulWidget {
  @override
  HomePageViewRecentPlayState createState() => HomePageViewRecentPlayState();
}

class HomePageViewRecentPlayState extends State<HomePageViewRecentPlay>
    with SingleTickerProviderStateMixin {
  final _pageController = PageController(viewportFraction: .5);
  int _currentIndexPageView = 0;
  int _previousIndexPageView = -1;
  int _nextIndexPageView = 0;

  late AnimationController animationController;
  late Animation<double> mainScalePageView;
  late Animation<double> anotherScalePageView;

  void setCurrentIndex(int index, int totalList) {
    setState(() {
      if (index - 1 > -1) {
        _previousIndexPageView = index - 1;
      }

      if (index + 1 < totalList) {
        _nextIndexPageView = index + 1;
      }

      _currentIndexPageView = index;
    });
  }

  @override
  void initState() {
    animationController = AnimationController(vsync: this, duration: const Duration(seconds: 1));
    mainScalePageView = Tween<double>(begin: .6, end: 1).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.fastOutSlowIn,
      ),
    );
    anotherScalePageView = Tween<double>(begin: 1, end: .6).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.fastOutSlowIn,
      ),
    );

    animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Baru saja diputar',
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: sizes.height(context) / 3,
          child: PageView.builder(
            controller: _pageController,
            itemCount: listRecentPlay.length,
            onPageChanged: (index) {
              setCurrentIndex(index, listRecentPlay.length);
              animationController.reset();
              animationController.forward();
            },
            itemBuilder: (_, index) {
              final result = listRecentPlay[index];

              var margin = EdgeInsets.zero;
              if (index != _currentIndexPageView) {
                if (index == _previousIndexPageView) {
                  margin = const EdgeInsets.only(left: 24);
                }
                if (index == _nextIndexPageView) {
                  margin = const EdgeInsets.only(right: 24);
                }
              }

              return AnimatedBuilder(
                animation: animationController,
                builder: (_, child) {
                  return Transform.scale(
                    scale: index == _currentIndexPageView
                        ? mainScalePageView.value
                        : anotherScalePageView.value,
                    child: child,
                  );
                },
                child: Container(
                  margin: margin,
                  child: ShowImageNetwork(
                    imageUrl: result.imageUrl,
                    imageBorderRadius: BorderRadius.circular(10),
                    imageSize: 1,
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
