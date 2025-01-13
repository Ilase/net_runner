import 'netrunner_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appBarAppTitle => 'NetRunner';

  @override
  String get appBarActionsButtonTitle => 'Действия';

  @override
  String get appBarInfoButtonTitle => 'Справка';

  @override
  String get splashScreenLoading => 'Загрузка';

  @override
  String get closeButton => 'Закрыть';

  @override
  String get scanningServerButton => 'Сканировать сервер';

  @override
  String get helpButton => 'Помощь';

  @override
  String get mainRailDestination => 'Main menu';

  @override
  String get hostsRailDestination => 'Hosts';

  @override
  String get scanningRailDestination => 'Сканирование';

  @override
  String get reportsRailDestination => 'Отчеты';

  @override
  String get networkRailDestination => 'Сеть';
}
