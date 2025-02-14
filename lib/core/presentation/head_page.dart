import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:net_runner/core/data/menu_item_data.dart';
import 'package:net_runner/core/domain/post_request/post_request_bloc.dart';
import 'package:net_runner/core/domain/web_socket/web_socket_bloc.dart';
import 'package:net_runner/core/presentation/widgets/drop_menu.dart';
import 'package:net_runner/features/hosts/presentation/hosts_pg.dart';
import 'package:net_runner/features/scanning/presentation/scanning_pg.dart';
import 'package:net_runner/locale/netrunner_localizations.dart';
import 'package:net_runner/core/presentation/widgets/drop_menu.dart'
    as dropmenu;
import 'package:net_runner/utils/constants/themes/app_themes.dart';

// ignore: must_be_immutable
class HeadPage extends StatefulWidget {
  static const String route = '/head';
  HeadPage({super.key, this.platform});
  String? platform;
  @override
  State<HeadPage> createState() => _HeadPageState();
}

class _HeadPageState extends State<HeadPage> {
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
            const SizedBox(
              width: 10,
            ),
            ElevatedButton(
              onPressed: (){
              ScaffoldMessenger.of(context).showMaterialBanner(
                  MaterialBanner(
                      content: Text('This is warning message', style: TextStyle(color: Colors.redAccent),),
                      actions:
                        [
                          IconButton(onPressed: (){
                            ScaffoldMessenger.of(context).clearMaterialBanners();
                          },
                          icon: Icon(Icons.close),
                          ),
                        ],
                  ),
              );

            }, child: Text('Message test'),),
            IconButton(
              onPressed: (){
                context.read<WebSocketBloc>().add(WebSocketDisconnect());
                context.read<PostRequestBloc>().add(ClearUriPostRequestEvent());
                Navigator.of(context).pushNamed('/init');
              },
              icon: const Icon(Icons.electrical_services_rounded),
            )
          ],
        ),
        bottomNavigationBar: const Padding(
          padding: EdgeInsets.all(8),
          child: null,
        ),
        body: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Center(
              child: Row(
            children: [
              NavigationRail(
                  indicatorShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  trailing: null,
                  leading: null,
                  useIndicator: true,
                  indicatorColor: const Color.fromRGBO(255, 255, 255, 0.5),
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

                  ],
                  selectedIndex: _selectedIndex),
              Expanded(
                  child: PageView(
                physics: const NeverScrollableScrollPhysics(),
                allowImplicitScrolling: false,
                controller: _pageController,
                scrollDirection: Axis.vertical,
                children: const [
                  HostsPg(),
                  ScanningPg(),
                ],
              )),
            ],
          )),
        ));
  }


}
