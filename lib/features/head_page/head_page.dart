import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:net_runner/core/domain/theme_controller/theme_controller_cubit.dart';
import 'package:net_runner/core/presentation/widgets/notification_manager.dart';
import 'package:net_runner/features/graph/graph_pg.dart';
import 'package:net_runner/features/hosts/presentation/hosts_pg.dart';
import 'package:net_runner/features/scanning/presentation/scanning_pg.dart';
import 'package:net_runner/features/title_page/presentation/title_pg.dart';

class HeadPage extends StatefulWidget {
  static const String route = '/head';
  const HeadPage({super.key});

  @override
  State<HeadPage> createState() => _HeadPageState();
}

class _HeadPageState extends State<HeadPage> {
  final PageController _pageController = PageController();
  double drawerWidth = 100;

  bool showFadedButtons = false;

  bool isDrawerExpanded = false;
  int selectedPageIndex = 0;

  bool _isDarkTheme = false;

  final List<Widget> pages = [
    TitlePg(),
    HostsPg(),
    ScanningPg(),
    GraphPg()
  ];

  void _setOpenDrawerState(PointerEvent event) {
    setState(() {
      isDrawerExpanded = !isDrawerExpanded;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          MouseRegion(
            onEnter: _setOpenDrawerState,
            onExit: (event) {
              setState(() {
                isDrawerExpanded = !isDrawerExpanded;
                // showFadedButtons = !showFadedButtons;
              });
            },
            child: AnimatedContainer(
              onEnd: () {
                setState(() {
                  showFadedButtons = !showFadedButtons;
                });
              },
              width: isDrawerExpanded ? 300 : 100,
              duration: Duration(milliseconds: 100),
              curve: Curves.easeInOut,
              decoration: BoxDecoration(
                color: Colors.white,
                //border: Border.all(width: 2),
                boxShadow: [
                  isDrawerExpanded
                      ? BoxShadow(
                          offset: Offset(3, 3),
                          color: Colors.grey,
                          blurRadius: 50,
                        )
                      : BoxShadow(),
                ],
                borderRadius: isDrawerExpanded
                    ? BorderRadius.horizontal(right: Radius.circular(15))
                    : BorderRadius.horizontal(right: Radius.circular(0)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AnimatedCrossFade(
                      firstChild: Center(
                        child: Text('NetRunner'),
                      ),
                      secondChild: Text('NT'),
                      crossFadeState: isDrawerExpanded
                          ? CrossFadeState.showFirst
                          : CrossFadeState.showSecond,
                      duration: Duration(milliseconds: 100),
                    ),
                    _buildDrawer(),
                    Column(
                      children: [
                        IconButton(
                          onPressed: () {
                            NotificationManager().showAnimatedNotification(
                                context,
                                'ERROR',
                                'Error accurred while something');
                          },
                          icon: Icon(Icons.exit_to_app),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.person_2_outlined),
                        ),
                        Switch(
                          value: _isDarkTheme,
                          onChanged: (value) {
                            setState(() {
                              _isDarkTheme = value;
                            });
                            context.read<ThemeControllerCubit>().toggleTheme();
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              children: pages,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer(
      // int pageIndex,
      // IconData icon,
      // String text,
      ) {
    return AnimatedCrossFade(
      firstChild: Container(
        // /height: MediaQuery.of(context).size.height / 3,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: EdgeInsetsDirectional.all(4),
              child: OutlinedButton(
                  onPressed: () {
                    _pageController.animateToPage(0,
                        duration: Duration(milliseconds: 200),
                        curve: Curves.easeInOut);
                  },
                  child: Text('Главная')),
            ),
            Padding(
              padding: EdgeInsetsDirectional.all(4),
              child: OutlinedButton(
                  onPressed: () {
                    _pageController.animateToPage(1,
                        duration: Duration(milliseconds: 200),
                        curve: Curves.easeInOut);
                  },
                  child: Text('Хосты')),
            ),
            Padding(
              padding: EdgeInsetsDirectional.all(4),
              child: OutlinedButton(
                  onPressed: () {
                    _pageController.animateToPage(2,
                        duration: Duration(milliseconds: 200),
                        curve: Curves.easeInOut);
                  },
                  child: Text('Сканирования')),
            ),
            Padding(
              padding: EdgeInsetsDirectional.all(4),
              child: OutlinedButton(
                  onPressed: () {
                    _pageController.animateToPage(3,
                        duration: Duration(milliseconds: 200),
                        curve: Curves.easeInOut);
                  },
                  child: Text('Сеть')),
            ),
          ],
        ),
      ),
      secondChild: Container(
        // /height: MediaQuery.of(context).size.height / 3,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: EdgeInsetsDirectional.all(4),
              child: Icon(Icons.home),
            ),
            Padding(
              padding: EdgeInsetsDirectional.all(4),
              child: Icon(Icons.group),
            ),
            Padding(
              padding: EdgeInsetsDirectional.all(4),
              child: Icon(Icons.radar),
            ),
            Padding(
              padding: EdgeInsetsDirectional.all(4),
              child: Icon(Icons.graphic_eq_rounded),
            ),
          ],
        ),
      ),
      crossFadeState: showFadedButtons
          ? CrossFadeState.showFirst
          : CrossFadeState.showSecond,
      duration: Duration(milliseconds: 100),
      firstCurve: Curves.easeInOut,
      secondCurve: Curves.linear,
    );
  }
}
