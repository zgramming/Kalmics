import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kalmics/src/provider/my_provider.dart';

const urlImageTesting = 'https://homepages.cae.wisc.edu/~ece533/images/girl.png';

class RecentPlay {
  final int id;
  final String title;
  final String imageUrl;

  RecentPlay({
    required this.id,
    required this.title,
    required this.imageUrl,
  });
}

final List<RecentPlay> listRecentPlay = [
  RecentPlay(
    id: 1,
    title: 'Shigatsu wa kimi Uso # OP 2-Nanairo Symphony',
    imageUrl: urlImageTesting,
  ),
  RecentPlay(
    id: 2,
    title: 'Shigatsu wa kimi Uso # OP 2-Nanairo Symphony',
    imageUrl: 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png',
  ),
  RecentPlay(
    id: 3,
    title: 'Shigatsu wa kimi Uso # OP 2-Nanairo Symphony',
    imageUrl: 'https://homepages.cae.wisc.edu/~ece533/images/baboon.png',
  ),
  RecentPlay(
    id: 4,
    title: 'Shigatsu wa kimi Uso # OP 2-Nanairo Symphony',
    imageUrl: 'https://homepages.cae.wisc.edu/~ece533/images/watch.png',
  ),
  RecentPlay(
    id: 5,
    title: 'Shigatsu wa kimi Uso # OP 2-Nanairo Symphony',
    imageUrl: 'https://homepages.cae.wisc.edu/~ece533/images/pool.png',
  ),
];

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
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
    return Padding(
      padding: EdgeInsets.only(
        top: sizes.statusBarHeight(context) * 2,
        left: 16.0,
        right: 16.0,
      ),
      child: Stack(
        children: [
          SizedBox.expand(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  LineChartSample2(),
                  const SizedBox(height: 20),
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
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Lagu Favoritku',
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Lihat Selengkapnya',
                        style: GoogleFonts.openSans(
                          color: Colors.white,
                          fontWeight: FontWeight.w300,
                          fontSize: 10,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: sizes.height(context) / 8,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: listRecentPlay.length,
                      shrinkWrap: true,
                      itemExtent: sizes.width(context) / 4,
                      itemBuilder: (context, index) {
                        final result = listRecentPlay[index];
                        return SizedBox(
                          child: ShowImageNetwork(
                            padding: const EdgeInsets.all(8.0),
                            imageUrl: result.imageUrl,
                            imageBorderRadius: BorderRadius.circular(10),
                            imageSize: 1,
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    ),
                  ),
                  Consumer(
                    builder: (context, watch, child) {
                      final _currengSongProvider = watch(currentSongProvider.state);
                      final _currentSongIsPlaying = _currengSongProvider.song.idMusic.isNotEmpty;
                      if (_currentSongIsPlaying) {
                        return SizedBox(height: sizes.height(context) / 8);
                      }
                      return SizedBox(height: sizes.height(context) / 10);
                    },
                  ),
                ],
              ),
            ),
          ),
          Consumer(
            builder: (context, watch, child) {
              final _currengSongProvider = watch(currentSongProvider.state);
              final _currentSongIsPlaying = _currengSongProvider.song.idMusic.isNotEmpty;

              if (_currentSongIsPlaying) {
                return Positioned(
                  bottom: 10,
                  right: 0,
                  child: Container(
                    height: sizes.height(context) / 10,
                    width: sizes.width(context) / 3,
                    decoration: BoxDecoration(
                      color: colorPallete.accentColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              }
              return const SizedBox();
            },
          )
        ],
      ),
    );
  }
}

class LineChartSample2 extends StatefulWidget {
  @override
  _LineChartSample2State createState() => _LineChartSample2State();
}

class _LineChartSample2State extends State<LineChartSample2> {
  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.5,
      child: Container(
        // margin: const EdgeInsets.all(16.0),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(18),
          ),
          color: Color(0xFF190226),
        ),
        child: Padding(
          padding: const EdgeInsets.only(right: 12.0, top: 24, bottom: 12),
          child: LineChart(_mainData()),
        ),
      ),
    );
  }

  LineChartData _mainData() {
    return LineChartData(
      minX: 0,
      minY: 0,
      axisTitleData: FlAxisTitleData(
        topTitle: AxisTitle(
            showTitle: true,
            titleText: 'Berapa banyak kamu memutar musik ?',
            margin: 20,
            textStyle: GoogleFonts.montserrat(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            )),
      ),
      gridData: FlGridData(
        ///* Untuk menampilkan grid kotak" pada chart
        show: false,
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          getTextStyles: (value) => const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          interval: 20,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xff67727d),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          reservedSize: 28,
          margin: 12,
        ),
      ),
      lineBarsData: [
        LineChartBarData(
          spots: [
            FlSpot(0, 20),
            FlSpot(1, 20),
            FlSpot(2, 10),
            FlSpot(3, 35),
            FlSpot(4, 20),
            FlSpot(5, 20),
            FlSpot(6, 10),
          ],
          isCurved: true,
          colors: [
            Colors.blue,
            Colors.green,
            Colors.yellow,
            Colors.purple,
          ],
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            colors: gradientColors.map((color) => color.withOpacity(0.3)).toList(),
          ),
        ),
      ],
    );
  }
}
