import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:net_runner/features/graph/mt_graph_pg.dart';
import 'package:net_runner/features/hosts/presentation/mt_hosts_pg.dart';
import 'package:net_runner/features/scanning/presentation/mt_scanning_pg.dart';
import 'package:net_runner/locale/netrunner_localizations.dart';
import 'package:net_runner/core/presentation/widgets/mt_dropmenu.dart' as dropmenu;
import 'package:net_runner/features/statistic_headpage/presentation/mt_homepage_pg.dart';
import 'package:net_runner/utils/constants/themes/app_themes.dart';
import 'package:net_runner/utils/constants/themes/text_styles.dart';

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
    bool isLanguageSwitch = false;
    return Scaffold(
        // Main Navigator
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: AutoSizeText(
            AppLocalizations.of(context)!.appBarAppTitle,
            minFontSize: 36,
            maxFontSize: 48,
            overflow: TextOverflow.ellipsis,
          ),
          actions: [
            Switch(
              value: isLanguageSwitch,
              onChanged: (value){
                setState(() {
                  isLanguageSwitch = value;
                });
              },
            ),
            const SizedBox(width: 10,),
            dropmenu.MtDropMenu(
              title: AppLocalizations.of(context)!.appBarActionsButtonTitle,
              popupMenuItems: [
                dropmenu.buildPopupMenuItem(
                  Icons.electrical_services,
                  'Scanning server*',
                  'Scanning server*',
            )
              ],
            ),
            const SizedBox(
              width: 10,
            ),
            dropmenu.MtDropMenu(
              title: AppLocalizations.of(context)!.appBarInfoButtonTitle,
              popupMenuItems: [
                dropmenu.buildPopupMenuItem(
                  Icons.help,
                  'Help*',
                  'Help*',

                )
              ],
            ),
          ],
        ),
        bottomNavigationBar: const Padding(
          padding: EdgeInsets.all(8),
          child: null,
        ),
        body:
      Padding(
        padding: const EdgeInsets.all(4.0),
         child:
          Center(
              child: Row(
            children: [
              NavigationRail(
                  indicatorShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)
                  ),
                  trailing: null,
                  leading: null,
                  useIndicator: true,
                  indicatorColor: Color.fromRGBO(255, 255, 255, 0.5),
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
                      icon: Icon(
                        Icons.home,
                        size: 45,
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                      ),
                      selectedIcon: Icon(
                        Icons.home_outlined,
                        size: 45,
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                      ),
                      label: Text(
                        'Главная*',
                        style: AppTheme.lightTheme.textTheme.labelSmall,
                      ),
                    ),
                    NavigationRailDestination(
                      icon: Icon(
                        Icons.group,
                        size: 45,
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                      ),
                      selectedIcon: Icon(
                        Icons.group_outlined,
                        size: 45,
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                      ),
                      label: Text(
                        'Хосты*',
                        style: AppTheme.lightTheme.textTheme.labelSmall,
                      ),
                    ),
                    NavigationRailDestination(
                      icon: Icon(
                        Icons.radar,
                        size: 45,
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                      ),
                      selectedIcon: Icon(
                        Icons.radio_button_checked_sharp,
                        size: 45,
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                      ),
                      label: Text(
                        'Сканирование*',
                        style: AppTheme.lightTheme.textTheme.labelSmall,
                      ),
                    ),
                    NavigationRailDestination(
                      icon: Icon(
                        Icons.document_scanner,
                        size: 45,
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                      ),
                      selectedIcon: Icon(
                        Icons.document_scanner_outlined,
                        size: 45,
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                      ),
                      label: Text(
                        'Отчёты*',
                        style: AppTheme.lightTheme.textTheme.labelSmall,
                      ),
                    ),
                    NavigationRailDestination(
                        icon: Icon(
                          Icons.share_rounded,
                          size: 45,
                          color: AppTheme.lightTheme.colorScheme.onSurface,
                        ),
                        selectedIcon: Icon(
                          Icons.share_outlined,
                          size: 45,
                          color: AppTheme.lightTheme.colorScheme.onSurface,
                        ),
                        label: Text(
                          'Сеть*',
                          style: AppTheme.lightTheme.textTheme.labelSmall,
                        ))
                  ],
                  selectedIndex: _selectedIndex
              ),
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
                  MtHostsPg(),
                  //scans
                  MtScanningPg(),
                  //otcetiki
                  Container(
                    child: const Center(
                      child: Text('Otchetiki*'),
                    ),
                  ),
                  //network
                  Container(
                    child: Center(
                        child: Text(
                          'Graph',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        )
                    )
                  ),
                  // Container(
                  //   child: const Center(
                  //     child: Text('Graphical network?*'),
                  //   ),
                  // ),
                ],
              )),
            ],
          )
    ),
      )
        );
  }
}
