import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:net_runner/features/scanning/presentation/mt_scanning_pg.dart';
import 'package:net_runner/locale/netrunner_localizations.dart';
import 'package:net_runner/core/presentation/widgets/mt_dropmenu.dart';

// ignore: must_be_immutable
class MtHeadpage extends StatefulWidget {
  MtHeadpage({super.key, this.platform});
  String? platform;
  @override
  State<MtHeadpage> createState() => _MtHeadpageState();
}

class _MtHeadpageState extends State<MtHeadpage> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // Main Navigator
        appBar: AppBar(
          title: AutoSizeText(
            AppLocalizations.of(context)!.appBarAppTitle,
            minFontSize: 36,
            maxFontSize: 48,
            overflow: TextOverflow.ellipsis,
          ),
          titleTextStyle: GoogleFonts.comfortaa(
            color: Colors.white,
          ),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          actions: [
            MtDropmenu(
              title: AppLocalizations.of(context)!.appBarActionsButtonTitle,
            ),
            const SizedBox(
              width: 10,
            ),
            MtDropmenu(
              title: AppLocalizations.of(context)!.appBarInfoButtonTitle,
            ),
          ],
        ),
        bottomNavigationBar: const Padding(
          padding: EdgeInsets.all(8),
          child: null,
        ),
        body: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Center(
              child: Row(
            children: [
              NavigationRail(
                  trailing: null,
                  leading: null,
                  useIndicator: true,
                  indicatorColor: null,
                  backgroundColor: null,
                  selectedIconTheme: const IconThemeData(
                    opacity: 1,
                  ),
                  groupAlignment: -1,
                  labelType: NavigationRailLabelType.selected,
                  onDestinationSelected: (int index) {
                    setState(() {
                      _selectedIndex = index;
                      _pageController.animateToPage(index,
                          duration: const Duration(milliseconds: 700),
                          curve: Curves.easeInOut);
                    });
                  },
                  destinations: <NavigationRailDestination>[
                    NavigationRailDestination(
                      icon: const Icon(
                        Icons.home,
                        size: 45,
                        color: Colors.blue,
                      ),
                      selectedIcon: const Icon(
                        Icons.home_outlined,
                        size: 45,
                        color: Colors.blue,
                      ),
                      label: Text(
                        'Главная',
                        style: GoogleFonts.comfortaa(color: Colors.blue),
                      ),
                    ),
                    NavigationRailDestination(
                      icon: const Icon(
                        Icons.group,
                        size: 45,
                        color: Colors.blue,
                      ),
                      selectedIcon: const Icon(
                        Icons.group_outlined,
                        size: 45,
                        color: Colors.blue,
                      ),
                      label: Text(
                        'Хосты',
                        style: GoogleFonts.comfortaa(color: Colors.blue),
                      ),
                    ),
                    NavigationRailDestination(
                      icon: const Icon(
                        Icons.radar,
                        size: 45,
                        color: Colors.blue,
                      ),
                      selectedIcon: const Icon(
                        Icons.radio_button_checked_sharp,
                        size: 45,
                        color: Colors.blue,
                      ),
                      label: Text(
                        'Сканирование',
                        style: GoogleFonts.comfortaa(color: Colors.blue),
                      ),
                    ),
                    NavigationRailDestination(
                      icon: const Icon(
                        Icons.document_scanner,
                        size: 45,
                        color: Colors.blue,
                      ),
                      selectedIcon: const Icon(
                        Icons.document_scanner_outlined,
                        size: 45,
                        color: Colors.blue,
                      ),
                      label: Text(
                        'Отчёты',
                        style: GoogleFonts.comfortaa(color: Colors.blue),
                      ),
                    ),
                    NavigationRailDestination(
                        icon: const Icon(
                          Icons.share_rounded,
                          size: 45,
                          color: Colors.blue,
                        ),
                        selectedIcon: const Icon(
                          Icons.share_outlined,
                          size: 45,
                          color: Colors.blue,
                        ),
                        label: Text(
                          'Сеть',
                          style: GoogleFonts.comfortaa(color: Colors.blue),
                        ))
                  ],
                  selectedIndex: _selectedIndex),
              Expanded(
                  child: PageView(
                physics: const NeverScrollableScrollPhysics(),
                allowImplicitScrolling: false,
                controller: _pageController,
                scrollDirection: Axis.vertical,
                children: [
                  //MainPage
                  Container(),
                  //hosts
                  Container(),
                  //scans
                  MtScanningPg(),
                  //otcetiki
                  Container(
                    child: const Center(
                      child: Text('Otchetiki'),
                    ),
                  ),
                  //network
                  Container(
                    child: const Center(
                      child: Text('Graphical network?'),
                    ),
                  ),
                ],
              )),
            ],
          )),
        ));
  }
}
