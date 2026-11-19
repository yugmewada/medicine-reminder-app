import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

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

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
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
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// App name shown by the OS task switcher. Brand name: do not translate.
  ///
  /// In en, this message translates to:
  /// **'Doseza'**
  String get appTitle;

  /// Button that closes an information dialog.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get actionClose;

  /// Button that cancels a dialog or form.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get actionCancel;

  /// Tooltip for the close (X) button on an in-app notification banner.
  ///
  /// In en, this message translates to:
  /// **'Dismiss'**
  String get actionDismiss;

  /// Reverts the last dose log.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get actionUndo;

  /// Screen-reader label for a button that is busy.
  ///
  /// In en, this message translates to:
  /// **'{label}, loading'**
  String loadingLabel(String label);

  /// Screen-reader label for the app logo.
  ///
  /// In en, this message translates to:
  /// **'{appName} logo'**
  String logoLabel(String appName);

  /// A full date, e.g. Thursday, November 19.
  ///
  /// In en, this message translates to:
  /// **'{date}'**
  String longDate(DateTime date);

  /// A percentage, e.g. 20%. Value is a fraction (0.2).
  ///
  /// In en, this message translates to:
  /// **'{value}'**
  String percentValue(double value);

  /// Short tagline under the app name on the splash screen.
  ///
  /// In en, this message translates to:
  /// **'Your medicines, organised.'**
  String get splashTagline;

  /// Skips the walkthrough.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get onboardingSkip;

  /// Goes to the next walkthrough page.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onboardingNext;

  /// Finishes the walkthrough.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get onboardingGetStarted;

  /// Screen-reader label for the walkthrough page dots.
  ///
  /// In en, this message translates to:
  /// **'Page {current} of {total}'**
  String onboardingPageLabel(int current, int total);

  /// Walkthrough page 1 headline.
  ///
  /// In en, this message translates to:
  /// **'All your medicines in one place'**
  String get onboardingInventoryTitle;

  /// Walkthrough page 1 body.
  ///
  /// In en, this message translates to:
  /// **'Keep a simple list of what you have, with an optional photo and how much is in stock.'**
  String get onboardingInventoryBody;

  /// Walkthrough page 2 headline.
  ///
  /// In en, this message translates to:
  /// **'See each day at a glance'**
  String get onboardingPlanTitle;

  /// Walkthrough page 2 body.
  ///
  /// In en, this message translates to:
  /// **'Pick any day to see what is on your schedule, then log each dose as taken or skipped.'**
  String get onboardingPlanBody;

  /// Walkthrough page 3 headline.
  ///
  /// In en, this message translates to:
  /// **'Progress without pressure'**
  String get onboardingProgressTitle;

  /// Walkthrough page 3 body. Supportive tone; avoid blame.
  ///
  /// In en, this message translates to:
  /// **'A clear daily summary of what you have logged. No streaks, no judgement — just your own record.'**
  String get onboardingProgressBody;

  /// Welcome screen headline.
  ///
  /// In en, this message translates to:
  /// **'Welcome!'**
  String get welcomeTitle;

  /// Welcome screen supporting text.
  ///
  /// In en, this message translates to:
  /// **'Keep track of your medicines and log each day, at your own pace.'**
  String get welcomeSubtitle;

  /// Demo sign-in button. Provider is a brand name.
  ///
  /// In en, this message translates to:
  /// **'Continue with {provider}'**
  String continueWithProvider(String provider);

  /// Divider between social sign-in and the demo button.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get welcomeOr;

  /// Enters the app as a guest (view and log doses; cannot change medicines).
  ///
  /// In en, this message translates to:
  /// **'Continue as guest'**
  String get continueAsGuest;

  /// Welcome-screen note explaining guest restrictions.
  ///
  /// In en, this message translates to:
  /// **'As a guest you can view medicines and log doses. Sign in to add, edit or delete them.'**
  String get guestLimitsNote;

  /// Footnote explaining sign-in is not real.
  ///
  /// In en, this message translates to:
  /// **'Sign-in is simulated in this prototype. No account is created and no credentials are collected.'**
  String get welcomeSimulatedNote;

  /// Title of the dialog shown before simulated sign-in.
  ///
  /// In en, this message translates to:
  /// **'Demo sign-in'**
  String get demoSignInTitle;

  /// Explains that social sign-in is simulated.
  ///
  /// In en, this message translates to:
  /// **'{provider} sign-in is simulated in this prototype. No {provider} account is used, nothing is sent, and no account is created. You will continue with a fictional demo profile.'**
  String demoSignInMessage(String provider);

  /// Confirms entering the demo.
  ///
  /// In en, this message translates to:
  /// **'Continue to demo'**
  String get demoSignInConfirm;

  /// Bottom navigation: daily plan tab.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get navToday;

  /// Bottom navigation: medicine list tab.
  ///
  /// In en, this message translates to:
  /// **'Inventory'**
  String get navInventory;

  /// Bottom navigation: profile tab.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// Home greeting by time of day.
  ///
  /// In en, this message translates to:
  /// **'{period, select, morning{Good morning, {name}} afternoon{Good afternoon, {name}} other{Good evening, {name}}}'**
  String greeting(String period, String name);

  /// Home greeting for a guest (no name).
  ///
  /// In en, this message translates to:
  /// **'{period, select, morning{Good morning} afternoon{Good afternoon} other{Good evening}}'**
  String greetingGuest(String period);

  /// Subtitle when today is selected.
  ///
  /// In en, this message translates to:
  /// **'Today · {date}'**
  String todayWithDate(DateTime date);

  /// Button that selects today in the date strip.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get jumpToToday;

  /// Screen-reader label for a day in the date strip.
  ///
  /// In en, this message translates to:
  /// **'{date}'**
  String dayCellLabel(DateTime date);

  /// Screen-reader label for today's cell in the date strip.
  ///
  /// In en, this message translates to:
  /// **'{date}, today'**
  String dayCellTodayLabel(DateTime date);

  /// Section heading for today's doses.
  ///
  /// In en, this message translates to:
  /// **'Today\'s plan'**
  String get todayPlanTitle;

  /// Section heading for another day's doses.
  ///
  /// In en, this message translates to:
  /// **'Plan for {date}'**
  String planForDate(DateTime date);

  /// Number of scheduled doses.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 dose} other{{count} doses}}'**
  String doseCount(int count);

  /// Daily progress summary. Percent is a fraction formatted as a percentage.
  ///
  /// In en, this message translates to:
  /// **'{taken} of {total} scheduled {total, plural, =1{dose} other{doses}} logged as taken — {percent}'**
  String progressHeadline(int taken, int total, double percent);

  /// Progress card when nothing is scheduled.
  ///
  /// In en, this message translates to:
  /// **'No doses scheduled for this day'**
  String get progressNone;

  /// Shown in the progress ring when nothing is scheduled.
  ///
  /// In en, this message translates to:
  /// **'–'**
  String get progressNoValue;

  /// Count of skipped doses.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, other{{count} skipped}}'**
  String progressSkipped(int count);

  /// Count of doses without a log.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, other{{count} not logged yet}}'**
  String progressNotLogged(int count);

  /// Shown when every dose has a log.
  ///
  /// In en, this message translates to:
  /// **'Everything is logged'**
  String get progressAllLogged;

  /// Separator between times in a list, e.g. 8:00 AM, 8:00 PM.
  ///
  /// In en, this message translates to:
  /// **', '**
  String get timeListSeparator;

  /// Separator between short facts on one line.
  ///
  /// In en, this message translates to:
  /// **' · '**
  String get listSeparator;

  /// Clarifies progress reflects user logs, not verified intake.
  ///
  /// In en, this message translates to:
  /// **'Based on what you log in this demo. It does not confirm a medicine was taken.'**
  String get progressCaption;

  /// Empty state title for a day with no doses.
  ///
  /// In en, this message translates to:
  /// **'Nothing scheduled'**
  String get emptyPlanTitle;

  /// Empty state message; date is a weekday name.
  ///
  /// In en, this message translates to:
  /// **'There are no doses on your demo schedule for {date}.'**
  String emptyPlanMessage(DateTime date);

  /// Prototype disclaimer at the bottom of Home.
  ///
  /// In en, this message translates to:
  /// **'Prototype with fictional sample data. Logs stay in memory for this session. This app does not give medical advice; follow the directions from your pharmacist or prescriber.'**
  String get todayNotice;

  /// Status chip on a dose card. Avoid wording that blames the user.
  ///
  /// In en, this message translates to:
  /// **'{status, select, taken{Taken} skipped{Skipped} upcoming{Upcoming} scheduled{Scheduled} other{Not logged}}'**
  String doseStatus(String status);

  /// Dose card subtitle: time and medicine type.
  ///
  /// In en, this message translates to:
  /// **'{time} · {type}'**
  String doseTimeAndType(String time, String type);

  /// Logs a dose as taken.
  ///
  /// In en, this message translates to:
  /// **'Taken'**
  String get actionTaken;

  /// Logs a dose as skipped.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get actionSkip;

  /// Screen-reader hint for the Taken button.
  ///
  /// In en, this message translates to:
  /// **'Logs {time} {medicine} as taken'**
  String doseTakenHint(String time, String medicine);

  /// Screen-reader hint for the Skip button.
  ///
  /// In en, this message translates to:
  /// **'Logs {time} {medicine} as skipped'**
  String doseSkipHint(String time, String medicine);

  /// Shown instead of log buttons on future days.
  ///
  /// In en, this message translates to:
  /// **'You can log this dose on the day.'**
  String get doseFutureNote;

  /// Confirmation after logging a dose.
  ///
  /// In en, this message translates to:
  /// **'{status, select, taken{{medicine} ({time}) logged as taken.} other{{medicine} ({time}) logged as skipped.}}'**
  String doseLogged(String status, String medicine, String time);

  /// Form of a medicine.
  ///
  /// In en, this message translates to:
  /// **'{type, select, tablet{Tablet} capsule{Capsule} liquid{Liquid} other{Other}}'**
  String medicineType(String type);

  /// How often a medicine appears on the schedule (not course length).
  ///
  /// In en, this message translates to:
  /// **'{frequency, select, daily{Daily} weekly{Weekly} other{Monthly}}'**
  String frequencyName(String frequency);

  /// Schedule summary for a daily medicine.
  ///
  /// In en, this message translates to:
  /// **'Every day'**
  String get cadenceDaily;

  /// Schedule summary for a weekly medicine.
  ///
  /// In en, this message translates to:
  /// **'Every {weekday}'**
  String cadenceWeekly(DateTime weekday);

  /// Schedule summary for a monthly medicine.
  ///
  /// In en, this message translates to:
  /// **'Monthly on day {day}'**
  String cadenceMonthly(int day);

  /// Inventory unit name on a choice chip.
  ///
  /// In en, this message translates to:
  /// **'{unit, select, tablets{tablets} capsules{capsules} millilitres{mL} other{units}}'**
  String stockUnitName(String unit);

  /// Inventory amount with unit. This is stock on hand, never a dose.
  ///
  /// In en, this message translates to:
  /// **'{unit, select, tablets{{count, plural, =1{1 tablet} other{{count} tablets}}} capsules{{count, plural, =1{1 capsule} other{{count} capsules}}} millilitres{{count} mL} other{{count, plural, =1{1 unit} other{{count} units}}}}'**
  String stockAmount(String unit, int count);

  /// Stock line on a medicine card.
  ///
  /// In en, this message translates to:
  /// **'{amount} in stock'**
  String inStock(String amount);

  /// Medicine card subtitle.
  ///
  /// In en, this message translates to:
  /// **'{type} · {cadence}'**
  String typeAndCadence(String type, String cadence);

  /// Inventory screen title.
  ///
  /// In en, this message translates to:
  /// **'Inventory'**
  String get inventoryTitle;

  /// Number of medicines in the inventory.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 medicine} other{{count} medicines}}'**
  String medicineCount(int count);

  /// Prototype notice on the inventory.
  ///
  /// In en, this message translates to:
  /// **'Sample medicines with fictional names. Changes last for this session only and reset when you log out or restart the app.'**
  String get inventoryNotice;

  /// Hint above the inventory list. 'left' means toward the start edge in left-to-right languages; adapt for right-to-left.
  ///
  /// In en, this message translates to:
  /// **'Tip: swipe a medicine left to edit or delete it.'**
  String get inventorySwipeHint;

  /// Empty inventory title.
  ///
  /// In en, this message translates to:
  /// **'No medicines yet'**
  String get emptyInventoryTitle;

  /// Empty inventory message.
  ///
  /// In en, this message translates to:
  /// **'Add a medicine to keep track of your stock and see it on your daily plan.'**
  String get emptyInventoryMessage;

  /// Opens the add-medicine form; also the form title and submit button.
  ///
  /// In en, this message translates to:
  /// **'Add medicine'**
  String get addMedicine;

  /// Title when a medicine cannot be found.
  ///
  /// In en, this message translates to:
  /// **'Medicine'**
  String get medicineFallbackTitle;

  /// Shown when a medicine id does not exist.
  ///
  /// In en, this message translates to:
  /// **'Medicine not found'**
  String get medicineNotFoundTitle;

  /// Explains a missing medicine.
  ///
  /// In en, this message translates to:
  /// **'It may have been reset with the demo session.'**
  String get medicineNotFoundMessage;

  /// Returns to the inventory list.
  ///
  /// In en, this message translates to:
  /// **'Back to inventory'**
  String get backToInventory;

  /// Opens the edit form; also the edit form title.
  ///
  /// In en, this message translates to:
  /// **'Edit medicine'**
  String get editMedicine;

  /// Deletes the medicine (toolbar tooltip and button on the detail screen).
  ///
  /// In en, this message translates to:
  /// **'Delete medicine'**
  String get deleteMedicine;

  /// Confirmation dialog title before deleting a medicine.
  ///
  /// In en, this message translates to:
  /// **'Delete {name}?'**
  String deleteMedicineTitle(String name);

  /// Confirmation dialog message before deleting a medicine.
  ///
  /// In en, this message translates to:
  /// **'It will be removed from your inventory and daily plan for this session.'**
  String get deleteMedicineMessage;

  /// Confirms deleting; also the swipe action label.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteConfirm;

  /// Snackbar after deleting a medicine; offers Undo.
  ///
  /// In en, this message translates to:
  /// **'{name} deleted.'**
  String medicineDeleted(String name);

  /// Swipe action that opens the edit form.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get actionEdit;

  /// Label for how often a medicine is scheduled.
  ///
  /// In en, this message translates to:
  /// **'Frequency'**
  String get labelFrequency;

  /// Label for demo schedule times.
  ///
  /// In en, this message translates to:
  /// **'Schedule times (demo)'**
  String get labelScheduleTimes;

  /// Label for the stock amount.
  ///
  /// In en, this message translates to:
  /// **'In stock'**
  String get labelInStock;

  /// Frequency and its schedule summary.
  ///
  /// In en, this message translates to:
  /// **'{frequency} · {cadence}'**
  String frequencyWithCadence(String frequency, String cadence);

  /// Disclaimer on the medicine detail screen.
  ///
  /// In en, this message translates to:
  /// **'Schedule times are entries for this demo, not dosing instructions. Follow the directions from your pharmacist or prescriber.'**
  String get detailNotice;

  /// Photo field label.
  ///
  /// In en, this message translates to:
  /// **'Photo (optional)'**
  String get photoTitle;

  /// Explains how photos are picked and kept.
  ///
  /// In en, this message translates to:
  /// **'Chosen with your system photo picker. Kept in memory for this session only.'**
  String get photoHelp;

  /// Opens the photo picker.
  ///
  /// In en, this message translates to:
  /// **'Choose photo'**
  String get photoChoose;

  /// Picks a different photo.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get photoChange;

  /// Removes the chosen photo.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get photoRemove;

  /// Screen-reader label for the empty photo box.
  ///
  /// In en, this message translates to:
  /// **'Add a photo'**
  String get photoAddLabel;

  /// Screen-reader label for the photo preview.
  ///
  /// In en, this message translates to:
  /// **'Change photo'**
  String get photoChangeLabel;

  /// Error when picking a photo fails.
  ///
  /// In en, this message translates to:
  /// **'{reason, select, accessDenied{Photo access is turned off for this app.} invalidImage{That file is not a supported image.} alreadyActive{The photo picker is already open.} other{The photo could not be loaded.}}'**
  String pickFailed(String reason);

  /// Name field label.
  ///
  /// In en, this message translates to:
  /// **'Medicine name'**
  String get fieldName;

  /// Medicine type field label.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get fieldType;

  /// Explains frequency is cadence, not course duration.
  ///
  /// In en, this message translates to:
  /// **'How often it appears on your schedule.'**
  String get fieldFrequencyHelp;

  /// Weekday choice for weekly medicines.
  ///
  /// In en, this message translates to:
  /// **'Day of the week'**
  String get fieldWeekday;

  /// Day choice for monthly medicines.
  ///
  /// In en, this message translates to:
  /// **'Day of the month'**
  String get fieldDayOfMonth;

  /// Explains why days stop at 28.
  ///
  /// In en, this message translates to:
  /// **'Days 1–28, so every month includes it.'**
  String get fieldDayOfMonthHelp;

  /// One option in the day-of-month list.
  ///
  /// In en, this message translates to:
  /// **'Day {day}'**
  String dayOfMonthOption(int day);

  /// Explains demo schedule times.
  ///
  /// In en, this message translates to:
  /// **'Times you choose to see this medicine on your daily plan. Not dosing advice.'**
  String get scheduleTimesHelp;

  /// Adds a schedule time.
  ///
  /// In en, this message translates to:
  /// **'Add time'**
  String get addTime;

  /// Tooltip to remove a schedule time.
  ///
  /// In en, this message translates to:
  /// **'Remove {time}'**
  String removeTime(String time);

  /// Shown when the time limit is reached.
  ///
  /// In en, this message translates to:
  /// **'Up to {count} times'**
  String maxTimes(int count);

  /// Time picker heading.
  ///
  /// In en, this message translates to:
  /// **'Select a schedule time'**
  String get timePickerHelp;

  /// Warning when adding a duplicate time.
  ///
  /// In en, this message translates to:
  /// **'{time} is already on the list.'**
  String timeAlreadyAdded(String time);

  /// Stock quantity field label.
  ///
  /// In en, this message translates to:
  /// **'Quantity in stock'**
  String get fieldQuantity;

  /// Clarifies stock is not a dose.
  ///
  /// In en, this message translates to:
  /// **'How many you have on hand. This is not a dose.'**
  String get fieldQuantityHelp;

  /// Unit choice for stock.
  ///
  /// In en, this message translates to:
  /// **'Stock unit'**
  String get fieldUnit;

  /// Explains session-only saving.
  ///
  /// In en, this message translates to:
  /// **'Saved in memory for this session only. Nothing is written to the device or sent anywhere.'**
  String get formSessionNote;

  /// Submit button on the edit form.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get saveChanges;

  /// Snackbar shown when saving the medicine form fails validation. One message per problem; fields never show inline errors.
  ///
  /// In en, this message translates to:
  /// **'{issue, select, nameMissing{Please enter a medicine name.} nameTooLong{Please use {maxName} characters or fewer for the name.} timesMissing{Please add at least one schedule time.} quantityMissing{Please enter the quantity in stock.} quantityNotWhole{Please enter the quantity as a whole number.} other{Please enter a quantity from {minQuantity} to {maxQuantity}.}}'**
  String medicineFormIssue(
    String issue,
    int maxName,
    int minQuantity,
    int maxQuantity,
  );

  /// Confirmation after adding.
  ///
  /// In en, this message translates to:
  /// **'{name} added for this session.'**
  String medicineAdded(String name);

  /// Confirmation after editing.
  ///
  /// In en, this message translates to:
  /// **'{name} updated for this session.'**
  String medicineUpdated(String name);

  /// Dialog title when leaving a changed form.
  ///
  /// In en, this message translates to:
  /// **'Discard changes?'**
  String get discardTitle;

  /// Dialog message when leaving a changed form.
  ///
  /// In en, this message translates to:
  /// **'Your changes to this medicine will not be saved.'**
  String get discardMessage;

  /// Confirms discarding changes.
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get discardConfirm;

  /// Returns to the form.
  ///
  /// In en, this message translates to:
  /// **'Keep editing'**
  String get keepEditing;

  /// Profile screen title.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// Profile section heading.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get aboutSection;

  /// Profile row and dialog title.
  ///
  /// In en, this message translates to:
  /// **'Terms and Conditions'**
  String get termsTitle;

  /// Indicates the terms are a placeholder.
  ///
  /// In en, this message translates to:
  /// **'Placeholder'**
  String get termsSubtitle;

  /// Placeholder terms dialog.
  ///
  /// In en, this message translates to:
  /// **'This prototype has no terms and conditions. Real terms would be written and reviewed before any public release.'**
  String get termsMessage;

  /// Profile row and dialog title.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyTitle;

  /// Privacy row subtitle.
  ///
  /// In en, this message translates to:
  /// **'How this prototype handles data'**
  String get privacySubtitle;

  /// Honest data statement. Do not add claims about encryption or compliance.
  ///
  /// In en, this message translates to:
  /// **'This prototype has no published privacy policy.\n\nIt has no backend, account system or analytics. Sample data and your changes are kept in memory on this device and reset when you log out or close the app.'**
  String get privacyMessage;

  /// Profile row and dialog title.
  ///
  /// In en, this message translates to:
  /// **'Share App'**
  String get shareTitle;

  /// Share row subtitle.
  ///
  /// In en, this message translates to:
  /// **'Demo only'**
  String get shareSubtitle;

  /// Mock share dialog.
  ///
  /// In en, this message translates to:
  /// **'Sharing is not available in this prototype, and there is no store listing to share yet.'**
  String get shareMessage;

  /// Opens the license page.
  ///
  /// In en, this message translates to:
  /// **'Open-source licenses'**
  String get licensesTitle;

  /// Logout row and confirm button.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logoutTitle;

  /// Logout row subtitle.
  ///
  /// In en, this message translates to:
  /// **'Resets this demo session'**
  String get logoutSubtitle;

  /// Logout confirmation title.
  ///
  /// In en, this message translates to:
  /// **'Log out of the demo?'**
  String get logoutConfirmTitle;

  /// Logout confirmation message.
  ///
  /// In en, this message translates to:
  /// **'You will return to the welcome screen. Medicines and dose logs you changed in this session will be reset to the sample data.'**
  String get logoutConfirmMessage;

  /// Confirmation after logout.
  ///
  /// In en, this message translates to:
  /// **'Logged out. Demo changes were cleared.'**
  String get loggedOut;

  /// App version footer.
  ///
  /// In en, this message translates to:
  /// **'{appName} {version} · Prototype'**
  String versionLine(String appName, String version);

  /// Version and build number.
  ///
  /// In en, this message translates to:
  /// **'{version} (build {build})'**
  String versionWithBuild(String version, String build);

  /// Screen-reader label for the avatar.
  ///
  /// In en, this message translates to:
  /// **'Profile picture for {name}'**
  String avatarLabel(String name);

  /// Profile name shown for a guest.
  ///
  /// In en, this message translates to:
  /// **'Guest'**
  String get guestName;

  /// Profile subtitle for a guest (instead of an email).
  ///
  /// In en, this message translates to:
  /// **'Browsing as a guest'**
  String get guestSubtitle;

  /// Chip on the profile marking guest mode.
  ///
  /// In en, this message translates to:
  /// **'Guest mode'**
  String get guestModeChip;

  /// Screen-reader label for the guest avatar.
  ///
  /// In en, this message translates to:
  /// **'Guest profile picture'**
  String get guestAvatarLabel;

  /// Opens the (simulated) sign-in prompt.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

  /// Title of the sign-in prompt shown to guests.
  ///
  /// In en, this message translates to:
  /// **'Sign in to manage medicines'**
  String get signInPromptTitle;

  /// Explains guest restrictions in the sign-in prompt.
  ///
  /// In en, this message translates to:
  /// **'Guests can view medicines and log doses. Sign in to add, edit or delete medicines.'**
  String get signInPromptMessage;

  /// Closes the sign-in prompt.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get notNow;

  /// Snackbar after a guest signs in.
  ///
  /// In en, this message translates to:
  /// **'Signed in with {provider} (simulated). You can now manage medicines.'**
  String signedInUpgrade(String provider);

  /// Banner on the inventory for guests.
  ///
  /// In en, this message translates to:
  /// **'You\'re browsing as a guest. Sign in to add, edit or delete medicines.'**
  String get inventoryGuestBanner;

  /// Profile row for guests (instead of Log out).
  ///
  /// In en, this message translates to:
  /// **'Exit guest mode'**
  String get exitGuestTitle;

  /// Subtitle of the exit-guest row.
  ///
  /// In en, this message translates to:
  /// **'Returns to the welcome screen'**
  String get exitGuestSubtitle;

  /// Confirmation title when a guest exits.
  ///
  /// In en, this message translates to:
  /// **'Exit guest mode?'**
  String get exitGuestConfirmTitle;

  /// Confirmation message when a guest exits.
  ///
  /// In en, this message translates to:
  /// **'You will return to the welcome screen. Doses you logged in this session will be reset.'**
  String get exitGuestConfirmMessage;

  /// Snackbar after a guest exits.
  ///
  /// In en, this message translates to:
  /// **'Exited guest mode. Session changes were cleared.'**
  String get exitedGuestMode;

  /// Chip when entered via simulated social sign-in.
  ///
  /// In en, this message translates to:
  /// **'Demo profile · {provider} sign-in simulated'**
  String demoProfileSimulated(String provider);

  /// Title for an unknown link.
  ///
  /// In en, this message translates to:
  /// **'Page not found'**
  String get notFoundTitle;

  /// Message for an unknown link.
  ///
  /// In en, this message translates to:
  /// **'This link doesn\'t match anything in the app.'**
  String get notFoundMessage;

  /// Navigates to the home tab.
  ///
  /// In en, this message translates to:
  /// **'Go to Today'**
  String get goToToday;
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
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
