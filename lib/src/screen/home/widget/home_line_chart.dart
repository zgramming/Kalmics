import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../provider/my_provider.dart';

class HomeLineChart extends StatefulWidget {
  @override
  _HomeLineChartState createState() => _HomeLineChartState();
}

class _HomeLineChartState extends State<HomeLineChart> {
  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.5,
      child: Container(
        margin: const EdgeInsets.all(8.0),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Color(0xFF190226),
        ),
        child: Padding(
          padding: const EdgeInsets.only(right: 12.0, top: 24, bottom: 12),
          child: Consumer(builder: (_, watch, __) {
            final _future = watch(initRecentPlayList);
            return _future.when(
              data: (_) {
                final _recentsDateRangeStatistic = watch(recentsDateRangeStatistic).state;
                final _recentsPlayLineChart = watch(recentsPlayLineChart).state;
                return LineChart(
                  _mainData(
                    spots: _recentsPlayLineChart,
                    rangeDate: _recentsDateRangeStatistic,
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) => Center(
                child: Text(error.toString()),
              ),
            );
            // final tes = watch(recentsPlayLineChart).state;
            // _recentsPlayProvider.forEach((element) {
            //   log('DateTime ${element.createDate?.weekday}');
            // });
          }),
        ),
      ),
    );
  }

  LineChartData _mainData({
    required List<FlSpot> spots,
    required String rangeDate,
  }) {
    return LineChartData(
      minY: 0,
      gridData: FlGridData(
        ///* Untuk menampilkan grid kotak" pada chart
        show: false,
      ),
      axisTitleData: FlAxisTitleData(
        topTitle: AxisTitle(
          showTitle: true,
          titleText: 'Statistik Pemutaran lagu Bulan $rangeDate',
          margin: 20,
          textStyle: GoogleFonts.montserrat(
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          getTitles: (value) {
            switch (value.toInt()) {
              case 1:
                return 'Jan';
              case 2:
                return 'Feb';
              case 3:
                return 'Mar';
              case 4:
                return 'Apr';
              case 5:
                return 'Mei';
              case 6:
                return 'Jun';
              case 7:
                return 'Jul';
              case 8:
                return 'Agu';
              case 9:
                return 'Sep';
              case 10:
                return 'Okt';
              case 11:
                return 'Nov';
              case 12:
                return 'Des';
              default:
            }
            return '';
          },
          margin: 10,
          getTextStyles: (value) => const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 11,
          ),
          rotateAngle: 30,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          interval: 250,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xff67727d),
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          colors: [
            Colors.blue,
            Colors.green,
            Colors.yellow,
            Colors.purple,
          ],
          barWidth: 2,

          // isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
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
