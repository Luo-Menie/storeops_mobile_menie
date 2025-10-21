import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_it.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('it'),
  ];

  /// No description provided for @copyright.
  ///
  /// In en, this message translates to:
  /// **'Copyright © 2025 Checkpoint Systems, Inc. All right are reserved.'**
  String get copyright;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @user.
  ///
  /// In en, this message translates to:
  /// **'User ID'**
  String get user;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get send;

  /// No description provided for @unauthorized.
  ///
  /// In en, this message translates to:
  /// **'Your user is not authorized'**
  String get unauthorized;

  /// No description provided for @incorrect.
  ///
  /// In en, this message translates to:
  /// **'Your user or password are wrong'**
  String get incorrect;

  /// No description provided for @no_user.
  ///
  /// In en, this message translates to:
  /// **'You must enter your username'**
  String get no_user;

  /// No description provided for @no_password.
  ///
  /// In en, this message translates to:
  /// **'You must enter your password'**
  String get no_password;

  /// No description provided for @principal_menu.
  ///
  /// In en, this message translates to:
  /// **'Principal Menu'**
  String get principal_menu;

  /// No description provided for @waiting_client.
  ///
  /// In en, this message translates to:
  /// **'Waiting Info Client'**
  String get waiting_client;

  /// No description provided for @waiting_store.
  ///
  /// In en, this message translates to:
  /// **'Waiting Info Store'**
  String get waiting_store;

  /// No description provided for @real_time_events.
  ///
  /// In en, this message translates to:
  /// **'Real Time Events'**
  String get real_time_events;

  /// No description provided for @events_for_readers.
  ///
  /// In en, this message translates to:
  /// **'Events for readers'**
  String get events_for_readers;

  /// No description provided for @daily_report.
  ///
  /// In en, this message translates to:
  /// **'Daily Report'**
  String get daily_report;

  /// No description provided for @sold_report.
  ///
  /// In en, this message translates to:
  /// **'Sold Report'**
  String get sold_report;

  /// No description provided for @report_today.
  ///
  /// In en, this message translates to:
  /// **'Report today'**
  String get report_today;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @config_app.
  ///
  /// In en, this message translates to:
  /// **'Config App'**
  String get config_app;

  /// No description provided for @customer.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get customer;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search Customer'**
  String get search;

  /// No description provided for @site.
  ///
  /// In en, this message translates to:
  /// **'Site'**
  String get site;

  /// No description provided for @search_site.
  ///
  /// In en, this message translates to:
  /// **'Search Site'**
  String get search_site;

  /// No description provided for @search_group.
  ///
  /// In en, this message translates to:
  /// **'Search Group'**
  String get search_group;

  /// No description provided for @group.
  ///
  /// In en, this message translates to:
  /// **'Group'**
  String get group;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @technologies.
  ///
  /// In en, this message translates to:
  /// **'Technologies'**
  String get technologies;

  /// No description provided for @sold.
  ///
  /// In en, this message translates to:
  /// **'Sold'**
  String get sold;

  /// No description provided for @pc.
  ///
  /// In en, this message translates to:
  /// **'People Counting'**
  String get pc;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @push_notifications.
  ///
  /// In en, this message translates to:
  /// **'Push Notifications'**
  String get push_notifications;

  /// No description provided for @total_alarms.
  ///
  /// In en, this message translates to:
  /// **'Total Alarms'**
  String get total_alarms;

  /// No description provided for @total_audible_alarms.
  ///
  /// In en, this message translates to:
  /// **'Total Audible Alarms'**
  String get total_audible_alarms;

  /// No description provided for @avg_daily_audible_alarms.
  ///
  /// In en, this message translates to:
  /// **'AVG Daily Audible Alarms'**
  String get avg_daily_audible_alarms;

  /// No description provided for @total_audible_alarms_by_category.
  ///
  /// In en, this message translates to:
  /// **'Total audible alarms by category'**
  String get total_audible_alarms_by_category;

  /// No description provided for @config_saved.
  ///
  /// In en, this message translates to:
  /// **'Config Saved'**
  String get config_saved;

  /// No description provided for @select_client.
  ///
  /// In en, this message translates to:
  /// **'You must select a client'**
  String get select_client;

  /// No description provided for @select_store.
  ///
  /// In en, this message translates to:
  /// **'You must select a store'**
  String get select_store;

  /// No description provided for @select_group.
  ///
  /// In en, this message translates to:
  /// **'You must select a group'**
  String get select_group;

  /// No description provided for @select_technology.
  ///
  /// In en, this message translates to:
  /// **'You must select at least one technology'**
  String get select_technology;

  /// No description provided for @saving_configuration.
  ///
  /// In en, this message translates to:
  /// **'Saving Configuration'**
  String get saving_configuration;

  /// No description provided for @loading_customers_info.
  ///
  /// In en, this message translates to:
  /// **'Loading Customers Info'**
  String get loading_customers_info;

  /// No description provided for @no_description.
  ///
  /// In en, this message translates to:
  /// **'No Description'**
  String get no_description;

  /// No description provided for @image_break.
  ///
  /// In en, this message translates to:
  /// **'Image break'**
  String get image_break;

  /// No description provided for @image_unavailable.
  ///
  /// In en, this message translates to:
  /// **'Image unavailable'**
  String get image_unavailable;

  /// No description provided for @loading_events.
  ///
  /// In en, this message translates to:
  /// **'Loading Events from'**
  String get loading_events;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logOut;

  /// No description provided for @confirmLogOut.
  ///
  /// In en, this message translates to:
  /// **'¿Do you want to log out?'**
  String get confirmLogOut;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'loading'**
  String get loading;

  /// No description provided for @waitingClientSelection.
  ///
  /// In en, this message translates to:
  /// **'Waiting client selection'**
  String get waitingClientSelection;

  /// No description provided for @access_success.
  ///
  /// In en, this message translates to:
  /// **'Access success'**
  String get access_success;

  /// No description provided for @search_store.
  ///
  /// In en, this message translates to:
  /// **'Search store...'**
  String get search_store;

  /// No description provided for @store.
  ///
  /// In en, this message translates to:
  /// **'Store'**
  String get store;

  /// No description provided for @session_expired.
  ///
  /// In en, this message translates to:
  /// **'Session Expired'**
  String get session_expired;

  /// No description provided for @session_expired_message.
  ///
  /// In en, this message translates to:
  /// **'Your session has expired. Please log in again'**
  String get session_expired_message;

  /// No description provided for @accept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get accept;

  /// No description provided for @log_out.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get log_out;

  /// No description provided for @log_out_question.
  ///
  /// In en, this message translates to:
  /// **'¿Do you want to log out?'**
  String get log_out_question;

  /// No description provided for @events_from.
  ///
  /// In en, this message translates to:
  /// **'Events from: '**
  String get events_from;

  /// No description provided for @to.
  ///
  /// In en, this message translates to:
  /// **' to: '**
  String get to;

  /// No description provided for @sold_uppercase.
  ///
  /// In en, this message translates to:
  /// **'SOLD'**
  String get sold_uppercase;

  /// No description provided for @filter_events.
  ///
  /// In en, this message translates to:
  /// **'Filter Events'**
  String get filter_events;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @date_range.
  ///
  /// In en, this message translates to:
  /// **'Date Range'**
  String get date_range;

  /// No description provided for @loading_report.
  ///
  /// In en, this message translates to:
  /// **'Loading Report'**
  String get loading_report;

  /// No description provided for @total_sales.
  ///
  /// In en, this message translates to:
  /// **'Total Sales'**
  String get total_sales;

  /// No description provided for @total_sales_category.
  ///
  /// In en, this message translates to:
  /// **'Total sales by category'**
  String get total_sales_category;

  /// No description provided for @forgotten_tag.
  ///
  /// In en, this message translates to:
  /// **'Forgotten tag'**
  String get forgotten_tag;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'it'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'it':
      return AppLocalizationsIt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
