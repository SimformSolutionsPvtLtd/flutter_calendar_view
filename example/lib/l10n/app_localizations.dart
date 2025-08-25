import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

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
    Locale('ar'),
    Locale('en'),
    Locale('es')
  ];

  /// No description provided for @flutterCalendarPage.
  ///
  /// In en, this message translates to:
  /// **'Flutter Calendar Page'**
  String get flutterCalendarPage;

  /// No description provided for @flutterCalendarPageDemo.
  ///
  /// In en, this message translates to:
  /// **'Flutter Calendar Page Demo'**
  String get flutterCalendarPageDemo;

  /// No description provided for @monthView.
  ///
  /// In en, this message translates to:
  /// **'Month View'**
  String get monthView;

  /// No description provided for @dayView.
  ///
  /// In en, this message translates to:
  /// **'Day View'**
  String get dayView;

  /// No description provided for @weekView.
  ///
  /// In en, this message translates to:
  /// **'Week View'**
  String get weekView;

  /// No description provided for @multidayView.
  ///
  /// In en, this message translates to:
  /// **'Multi-Day View'**
  String get multidayView;

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Flutter Calendar Page Demo'**
  String get appTitle;

  /// No description provided for @projectMeetingTitle.
  ///
  /// In en, this message translates to:
  /// **'Project meeting'**
  String get projectMeetingTitle;

  /// No description provided for @projectMeetingDesc.
  ///
  /// In en, this message translates to:
  /// **'Today is project meeting.'**
  String get projectMeetingDesc;

  /// No description provided for @leetcodeContestTitle.
  ///
  /// In en, this message translates to:
  /// **'Leetcode Contest'**
  String get leetcodeContestTitle;

  /// No description provided for @leetcodeContestDesc.
  ///
  /// In en, this message translates to:
  /// **'Give leetcode contest'**
  String get leetcodeContestDesc;

  /// No description provided for @physicsTestTitle.
  ///
  /// In en, this message translates to:
  /// **'Physics test prep'**
  String get physicsTestTitle;

  /// No description provided for @physicsTestDesc.
  ///
  /// In en, this message translates to:
  /// **'Prepare for physics test'**
  String get physicsTestDesc;

  /// No description provided for @weddingAnniversaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Wedding anniversary'**
  String get weddingAnniversaryTitle;

  /// No description provided for @weddingAnniversaryDesc.
  ///
  /// In en, this message translates to:
  /// **'Attend uncle\'s wedding anniversary.'**
  String get weddingAnniversaryDesc;

  /// No description provided for @footballTournamentTitle.
  ///
  /// In en, this message translates to:
  /// **'Football Tournament'**
  String get footballTournamentTitle;

  /// No description provided for @footballTournamentDesc.
  ///
  /// In en, this message translates to:
  /// **'Go to football tournament.'**
  String get footballTournamentDesc;

  /// No description provided for @sprintMeetingTitle.
  ///
  /// In en, this message translates to:
  /// **'Sprint Meeting.'**
  String get sprintMeetingTitle;

  /// No description provided for @sprintMeetingDesc.
  ///
  /// In en, this message translates to:
  /// **'Last day of project submission for last year.'**
  String get sprintMeetingDesc;

  /// No description provided for @teamMeetingTitle.
  ///
  /// In en, this message translates to:
  /// **'Team Meeting'**
  String get teamMeetingTitle;

  /// No description provided for @teamMeetingDesc.
  ///
  /// In en, this message translates to:
  /// **'Team Meeting'**
  String get teamMeetingDesc;

  /// No description provided for @chemistryVivaTitle.
  ///
  /// In en, this message translates to:
  /// **'Chemistry Viva'**
  String get chemistryVivaTitle;

  /// No description provided for @chemistryVivaDesc.
  ///
  /// In en, this message translates to:
  /// **'Today is Joe\'s birthday.'**
  String get chemistryVivaDesc;

  /// No description provided for @createNewEvent.
  ///
  /// In en, this message translates to:
  /// **'Create New Event'**
  String get createNewEvent;

  /// No description provided for @updateEvent.
  ///
  /// In en, this message translates to:
  /// **'Update Event'**
  String get updateEvent;

  /// No description provided for @activeView.
  ///
  /// In en, this message translates to:
  /// **'Active View:'**
  String get activeView;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark mode:'**
  String get darkMode;

  /// No description provided for @eventTitle.
  ///
  /// In en, this message translates to:
  /// **'Event Title'**
  String get eventTitle;

  /// No description provided for @pleaseEnterEventTitle.
  ///
  /// In en, this message translates to:
  /// **'Please enter event title.'**
  String get pleaseEnterEventTitle;

  /// No description provided for @recurringEvent.
  ///
  /// In en, this message translates to:
  /// **'Recurring Event'**
  String get recurringEvent;

  /// No description provided for @startDate.
  ///
  /// In en, this message translates to:
  /// **'Start Date'**
  String get startDate;

  /// No description provided for @pleaseSelectStartDate.
  ///
  /// In en, this message translates to:
  /// **'Please select start date.'**
  String get pleaseSelectStartDate;

  /// No description provided for @endDate.
  ///
  /// In en, this message translates to:
  /// **'End Date'**
  String get endDate;

  /// No description provided for @endDateBeforeStartDate.
  ///
  /// In en, this message translates to:
  /// **'End date occurs before start date.'**
  String get endDateBeforeStartDate;

  /// No description provided for @startTime.
  ///
  /// In en, this message translates to:
  /// **'Start Time'**
  String get startTime;

  /// No description provided for @endTime.
  ///
  /// In en, this message translates to:
  /// **'End Time'**
  String get endTime;

  /// No description provided for @endTimeLessThanStartTime.
  ///
  /// In en, this message translates to:
  /// **'End time is less than start time.'**
  String get endTimeLessThanStartTime;

  /// No description provided for @eventDescription.
  ///
  /// In en, this message translates to:
  /// **'Event Description'**
  String get eventDescription;

  /// No description provided for @pleaseEnterEventDescription.
  ///
  /// In en, this message translates to:
  /// **'Please enter event description.'**
  String get pleaseEnterEventDescription;

  /// No description provided for @repeat.
  ///
  /// In en, this message translates to:
  /// **'Repeat'**
  String get repeat;

  /// No description provided for @daily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get daily;

  /// No description provided for @weekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get weekly;

  /// No description provided for @monthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get monthly;

  /// No description provided for @yearly.
  ///
  /// In en, this message translates to:
  /// **'Yearly'**
  String get yearly;

  /// No description provided for @reoccurrenceEndsOn.
  ///
  /// In en, this message translates to:
  /// **'Reoccurrence ends on: '**
  String get reoccurrenceEndsOn;

  /// No description provided for @never.
  ///
  /// In en, this message translates to:
  /// **'Never'**
  String get never;

  /// No description provided for @on.
  ///
  /// In en, this message translates to:
  /// **'On'**
  String get on;

  /// No description provided for @after.
  ///
  /// In en, this message translates to:
  /// **'After'**
  String get after;

  /// No description provided for @endsOn.
  ///
  /// In en, this message translates to:
  /// **'Ends on'**
  String get endsOn;

  /// No description provided for @recurrenceEndsAfterEndDate.
  ///
  /// In en, this message translates to:
  /// **'Recurrence ends after end date'**
  String get recurrenceEndsAfterEndDate;

  /// No description provided for @pleaseSelectEndDate.
  ///
  /// In en, this message translates to:
  /// **'Please select end date.'**
  String get pleaseSelectEndDate;

  /// No description provided for @pleaseSpecifyOccurrences.
  ///
  /// In en, this message translates to:
  /// **'Please specify occurrences'**
  String get pleaseSpecifyOccurrences;

  /// No description provided for @occurrences.
  ///
  /// In en, this message translates to:
  /// **'Occurrences'**
  String get occurrences;

  /// No description provided for @eventColor.
  ///
  /// In en, this message translates to:
  /// **'Event Color: '**
  String get eventColor;

  /// No description provided for @selectEventColor.
  ///
  /// In en, this message translates to:
  /// **'Select event color'**
  String get selectEventColor;

  /// No description provided for @select.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get select;

  /// No description provided for @addEvent.
  ///
  /// In en, this message translates to:
  /// **'Add Event'**
  String get addEvent;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date:'**
  String get date;

  /// No description provided for @from.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get from;

  /// No description provided for @to.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get to;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @deleteEvent.
  ///
  /// In en, this message translates to:
  /// **'Delete Event'**
  String get deleteEvent;

  /// No description provided for @editEvent.
  ///
  /// In en, this message translates to:
  /// **'Edit Event'**
  String get editEvent;

  /// No description provided for @deleteRecurringEvent.
  ///
  /// In en, this message translates to:
  /// **'Delete recurring event'**
  String get deleteRecurringEvent;

  /// No description provided for @thisEvent.
  ///
  /// In en, this message translates to:
  /// **'This event'**
  String get thisEvent;

  /// No description provided for @thisAndFollowingEvents.
  ///
  /// In en, this message translates to:
  /// **'This and following events'**
  String get thisAndFollowingEvents;

  /// No description provided for @allEvents.
  ///
  /// In en, this message translates to:
  /// **'All events'**
  String get allEvents;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;
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
      <String>['ar', 'en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
