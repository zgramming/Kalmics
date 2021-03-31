import 'package:flutter/material.dart';
import 'package:global_template/global_template.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kalmics/src/network/my_network.dart';

class HomePageViewRecentPlayItem extends StatefulWidget {
  final List<RecentPlayModel> recentsPlay;
  const HomePageViewRecentPlayItem({
    Key? key,
    required this.recentsPlay,
  }) : super(key: key);
  @override
  _HomePageViewRecentPlayItemState createState() => _HomePageViewRecentPlayItemState();
}

class _HomePageViewRecentPlayItemState extends State<HomePageViewRecentPlayItem>
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
    return PageView.builder(
      controller: _pageController,
      itemCount: widget.recentsPlay.length,
      onPageChanged: (index) {
        setCurrentIndex(index, widget.recentsPlay.length);
        animationController.reset();
        animationController.forward();
      },
      itemBuilder: (_, index) {
        final result = widget.recentsPlay[index];

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
          child: Stack(
            fit: StackFit.expand,
            clipBehavior: Clip.none,
            children: [
              Container(
                // margin: margin,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: result.music.artwork == null
                      ? ShowImageAsset(
                          imageUrl: '${appConfig.urlImageAsset}/${appConfig.nameLogoAsset}',
                          fit: BoxFit.cover,
                        )
                      : Image.memory(
                          result.music.artwork!,
                          fit: BoxFit.cover,
                          width: sizes.width(context),
                          errorBuilder: (context, error, stackTrace) {
                            return ShowImageAsset(
                              imageUrl: '${appConfig.urlImageAsset}/${appConfig.nameLogoAsset}',
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                ),
              ),
              if (index == _currentIndexPageView) ...[
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(15)),
                      color: colorPallete.accentColor,
                    ),
                    child: Text(
                      result.music.title ?? 'Unknown Title',
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.openSans(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 8,
                      ),
                    ),
                  ),
                )
              ] else
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(.8),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
