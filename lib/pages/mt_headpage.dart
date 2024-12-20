import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:net_runner/l10n/netrunner_localizations.dart';
import 'package:net_runner/modules/dialogs/mt_dialog_send_scan_request.dart';
import 'package:net_runner/modules/mt_dropmenu.dart';
import 'package:net_runner/modules/mt_navigation_rail.dart';

// ignore: must_be_immutable
class MtHeadpage extends StatefulWidget {
  MtHeadpage({super.key, this.platform});
  String? platform;
  @override
  State<MtHeadpage> createState() => _MtHeadpageState();
}

class _MtHeadpageState extends State<MtHeadpage> {
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
            MtDropmenu(
              title: AppLocalizations.of(context)!.appBarInfoButtonTitle,
            ),
          ],
        ),
        bottomNavigationBar: const Padding(
          padding: EdgeInsets.all(8),
          child: null,
        ),
        body: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Center(
              child: Row(
            children: [
              MtNavigationRail(),
              MtDialogSendScanRequest(),
            ],
          )),
        ));
  }
}
