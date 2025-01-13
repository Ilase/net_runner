import 'netrunner_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appBarAppTitle => 'NetRunner';

  @override
  String get appBarActionsButtonTitle => 'Actions';

  @override
  String get appBarInfoButtonTitle => 'Help';

  @override
  String get splashScreenLoading => 'Loading';

  @override
  String get closeButton => 'Close';

  @override
  String get scanningServerButton => 'Scanning server';

  @override
  String get helpButton => 'Help';

  @override
  String get mainRailDestination => 'Main menu';

  @override
  String get hostsRailDestination => 'Hosts';

  @override
  String get scanningRailDestination => 'Scanning';

  @override
  String get reportsRailDestination => 'Reports';

  @override
  String get networkRailDestination => 'Network';
}
