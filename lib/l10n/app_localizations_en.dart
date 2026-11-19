// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Doseza';

  @override
  String get actionClose => 'Close';

  @override
  String get actionCancel => 'Cancel';

  @override
  String get actionDismiss => 'Dismiss';

  @override
  String get actionUndo => 'Undo';

  @override
  String loadingLabel(String label) {
    return '$label, loading';
  }

  @override
  String logoLabel(String appName) {
    return '$appName logo';
  }

  @override
  String longDate(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.MMMMEEEEd(
      localeName,
    );
    final String dateString = dateDateFormat.format(date);

    return '$dateString';
  }

  @override
  String percentValue(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.percentPattern(localeName);
    final String valueString = valueNumberFormat.format(value);

    return '$valueString';
  }

  @override
  String get splashTagline => 'Your medicines, organised.';

  @override
  String get onboardingSkip => 'Skip';

  @override
  String get onboardingNext => 'Next';

  @override
  String get onboardingGetStarted => 'Get started';

  @override
  String onboardingPageLabel(int current, int total) {
    return 'Page $current of $total';
  }

  @override
  String get onboardingInventoryTitle => 'All your medicines in one place';

  @override
  String get onboardingInventoryBody =>
      'Keep a simple list of what you have, with an optional photo and how much is in stock.';

  @override
  String get onboardingPlanTitle => 'See each day at a glance';

  @override
  String get onboardingPlanBody =>
      'Pick any day to see what is on your schedule, then log each dose as taken or skipped.';

  @override
  String get onboardingProgressTitle => 'Progress without pressure';

  @override
  String get onboardingProgressBody =>
      'A clear daily summary of what you have logged. No streaks, no judgement — just your own record.';

  @override
  String get welcomeTitle => 'Welcome!';

  @override
  String get welcomeSubtitle =>
      'Keep track of your medicines and log each day, at your own pace.';

  @override
  String continueWithProvider(String provider) {
    return 'Continue with $provider';
  }

  @override
  String get welcomeOr => 'or';

  @override
  String get continueAsGuest => 'Continue as guest';

  @override
  String get guestLimitsNote =>
      'As a guest you can view medicines and log doses. Sign in to add, edit or delete them.';

  @override
  String get welcomeSimulatedNote =>
      'Sign-in is simulated in this prototype. No account is created and no credentials are collected.';

  @override
  String get demoSignInTitle => 'Demo sign-in';

  @override
  String demoSignInMessage(String provider) {
    return '$provider sign-in is simulated in this prototype. No $provider account is used, nothing is sent, and no account is created. You will continue with a fictional demo profile.';
  }

  @override
  String get demoSignInConfirm => 'Continue to demo';

  @override
  String get navToday => 'Today';

  @override
  String get navInventory => 'Inventory';

  @override
  String get navProfile => 'Profile';

  @override
  String greeting(String period, String name) {
    String _temp0 = intl.Intl.selectLogic(period, {
      'morning': 'Good morning, $name',
      'afternoon': 'Good afternoon, $name',
      'other': 'Good evening, $name',
    });
    return '$_temp0';
  }

  @override
  String greetingGuest(String period) {
    String _temp0 = intl.Intl.selectLogic(period, {
      'morning': 'Good morning',
      'afternoon': 'Good afternoon',
      'other': 'Good evening',
    });
    return '$_temp0';
  }

  @override
  String todayWithDate(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.MMMMEEEEd(
      localeName,
    );
    final String dateString = dateDateFormat.format(date);

    return 'Today · $dateString';
  }

  @override
  String get jumpToToday => 'Today';

  @override
  String dayCellLabel(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.MMMMEEEEd(
      localeName,
    );
    final String dateString = dateDateFormat.format(date);

    return '$dateString';
  }

  @override
  String dayCellTodayLabel(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.MMMMEEEEd(
      localeName,
    );
    final String dateString = dateDateFormat.format(date);

    return '$dateString, today';
  }

  @override
  String get todayPlanTitle => 'Today\'s plan';

  @override
  String planForDate(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.MMMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return 'Plan for $dateString';
  }

  @override
  String doseCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count doses',
      one: '1 dose',
    );
    return '$_temp0';
  }

  @override
  String progressHeadline(int taken, int total, double percent) {
    final intl.NumberFormat percentNumberFormat =
        intl.NumberFormat.percentPattern(localeName);
    final String percentString = percentNumberFormat.format(percent);

    String _temp0 = intl.Intl.pluralLogic(
      total,
      locale: localeName,
      other: 'doses',
      one: 'dose',
    );
    return '$taken of $total scheduled $_temp0 logged as taken — $percentString';
  }

  @override
  String get progressNone => 'No doses scheduled for this day';

  @override
  String get progressNoValue => '–';

  @override
  String progressSkipped(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count skipped',
    );
    return '$_temp0';
  }

  @override
  String progressNotLogged(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count not logged yet',
    );
    return '$_temp0';
  }

  @override
  String get progressAllLogged => 'Everything is logged';

  @override
  String get timeListSeparator => ', ';

  @override
  String get listSeparator => ' · ';

  @override
  String get progressCaption =>
      'Based on what you log in this demo. It does not confirm a medicine was taken.';

  @override
  String get emptyPlanTitle => 'Nothing scheduled';

  @override
  String emptyPlanMessage(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.EEEE(localeName);
    final String dateString = dateDateFormat.format(date);

    return 'There are no doses on your demo schedule for $dateString.';
  }

  @override
  String get todayNotice =>
      'Prototype with fictional sample data. Logs stay in memory for this session. This app does not give medical advice; follow the directions from your pharmacist or prescriber.';

  @override
  String doseStatus(String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'taken': 'Taken',
      'skipped': 'Skipped',
      'upcoming': 'Upcoming',
      'scheduled': 'Scheduled',
      'other': 'Not logged',
    });
    return '$_temp0';
  }

  @override
  String doseTimeAndType(String time, String type) {
    return '$time · $type';
  }

  @override
  String get actionTaken => 'Taken';

  @override
  String get actionSkip => 'Skip';

  @override
  String doseTakenHint(String time, String medicine) {
    return 'Logs $time $medicine as taken';
  }

  @override
  String doseSkipHint(String time, String medicine) {
    return 'Logs $time $medicine as skipped';
  }

  @override
  String get doseFutureNote => 'You can log this dose on the day.';

  @override
  String doseLogged(String status, String medicine, String time) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'taken': '$medicine ($time) logged as taken.',
      'other': '$medicine ($time) logged as skipped.',
    });
    return '$_temp0';
  }

  @override
  String medicineType(String type) {
    String _temp0 = intl.Intl.selectLogic(type, {
      'tablet': 'Tablet',
      'capsule': 'Capsule',
      'liquid': 'Liquid',
      'other': 'Other',
    });
    return '$_temp0';
  }

  @override
  String frequencyName(String frequency) {
    String _temp0 = intl.Intl.selectLogic(frequency, {
      'daily': 'Daily',
      'weekly': 'Weekly',
      'other': 'Monthly',
    });
    return '$_temp0';
  }

  @override
  String get cadenceDaily => 'Every day';

  @override
  String cadenceWeekly(DateTime weekday) {
    final intl.DateFormat weekdayDateFormat = intl.DateFormat.EEEE(localeName);
    final String weekdayString = weekdayDateFormat.format(weekday);

    return 'Every $weekdayString';
  }

  @override
  String cadenceMonthly(int day) {
    return 'Monthly on day $day';
  }

  @override
  String stockUnitName(String unit) {
    String _temp0 = intl.Intl.selectLogic(unit, {
      'tablets': 'tablets',
      'capsules': 'capsules',
      'millilitres': 'mL',
      'other': 'units',
    });
    return '$_temp0';
  }

  @override
  String stockAmount(String unit, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tablets',
      one: '1 tablet',
    );
    String _temp1 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count capsules',
      one: '1 capsule',
    );
    String _temp2 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count units',
      one: '1 unit',
    );
    String _temp3 = intl.Intl.selectLogic(unit, {
      'tablets': '$_temp0',
      'capsules': '$_temp1',
      'millilitres': '$count mL',
      'other': '$_temp2',
    });
    return '$_temp3';
  }

  @override
  String inStock(String amount) {
    return '$amount in stock';
  }

  @override
  String typeAndCadence(String type, String cadence) {
    return '$type · $cadence';
  }

  @override
  String get inventoryTitle => 'Inventory';

  @override
  String medicineCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count medicines',
      one: '1 medicine',
    );
    return '$_temp0';
  }

  @override
  String get inventoryNotice =>
      'Sample medicines with fictional names. Changes last for this session only and reset when you log out or restart the app.';

  @override
  String get inventorySwipeHint =>
      'Tip: swipe a medicine left to edit or delete it.';

  @override
  String get emptyInventoryTitle => 'No medicines yet';

  @override
  String get emptyInventoryMessage =>
      'Add a medicine to keep track of your stock and see it on your daily plan.';

  @override
  String get addMedicine => 'Add medicine';

  @override
  String get medicineFallbackTitle => 'Medicine';

  @override
  String get medicineNotFoundTitle => 'Medicine not found';

  @override
  String get medicineNotFoundMessage =>
      'It may have been reset with the demo session.';

  @override
  String get backToInventory => 'Back to inventory';

  @override
  String get editMedicine => 'Edit medicine';

  @override
  String get deleteMedicine => 'Delete medicine';

  @override
  String deleteMedicineTitle(String name) {
    return 'Delete $name?';
  }

  @override
  String get deleteMedicineMessage =>
      'It will be removed from your inventory and daily plan for this session.';

  @override
  String get deleteConfirm => 'Delete';

  @override
  String medicineDeleted(String name) {
    return '$name deleted.';
  }

  @override
  String get actionEdit => 'Edit';

  @override
  String get labelFrequency => 'Frequency';

  @override
  String get labelScheduleTimes => 'Schedule times (demo)';

  @override
  String get labelInStock => 'In stock';

  @override
  String frequencyWithCadence(String frequency, String cadence) {
    return '$frequency · $cadence';
  }

  @override
  String get detailNotice =>
      'Schedule times are entries for this demo, not dosing instructions. Follow the directions from your pharmacist or prescriber.';

  @override
  String get photoTitle => 'Photo (optional)';

  @override
  String get photoHelp =>
      'Chosen with your system photo picker. Kept in memory for this session only.';

  @override
  String get photoChoose => 'Choose photo';

  @override
  String get photoChange => 'Change';

  @override
  String get photoRemove => 'Remove';

  @override
  String get photoAddLabel => 'Add a photo';

  @override
  String get photoChangeLabel => 'Change photo';

  @override
  String pickFailed(String reason) {
    String _temp0 = intl.Intl.selectLogic(reason, {
      'accessDenied': 'Photo access is turned off for this app.',
      'invalidImage': 'That file is not a supported image.',
      'alreadyActive': 'The photo picker is already open.',
      'other': 'The photo could not be loaded.',
    });
    return '$_temp0';
  }

  @override
  String get fieldName => 'Medicine name';

  @override
  String get fieldType => 'Type';

  @override
  String get fieldFrequencyHelp => 'How often it appears on your schedule.';

  @override
  String get fieldWeekday => 'Day of the week';

  @override
  String get fieldDayOfMonth => 'Day of the month';

  @override
  String get fieldDayOfMonthHelp => 'Days 1–28, so every month includes it.';

  @override
  String dayOfMonthOption(int day) {
    return 'Day $day';
  }

  @override
  String get scheduleTimesHelp =>
      'Times you choose to see this medicine on your daily plan. Not dosing advice.';

  @override
  String get addTime => 'Add time';

  @override
  String removeTime(String time) {
    return 'Remove $time';
  }

  @override
  String maxTimes(int count) {
    return 'Up to $count times';
  }

  @override
  String get timePickerHelp => 'Select a schedule time';

  @override
  String timeAlreadyAdded(String time) {
    return '$time is already on the list.';
  }

  @override
  String get fieldQuantity => 'Quantity in stock';

  @override
  String get fieldQuantityHelp =>
      'How many you have on hand. This is not a dose.';

  @override
  String get fieldUnit => 'Stock unit';

  @override
  String get formSessionNote =>
      'Saved in memory for this session only. Nothing is written to the device or sent anywhere.';

  @override
  String get saveChanges => 'Save changes';

  @override
  String medicineFormIssue(
    String issue,
    int maxName,
    int minQuantity,
    int maxQuantity,
  ) {
    String _temp0 = intl.Intl.selectLogic(issue, {
      'nameMissing': 'Please enter a medicine name.',
      'nameTooLong': 'Please use $maxName characters or fewer for the name.',
      'timesMissing': 'Please add at least one schedule time.',
      'quantityMissing': 'Please enter the quantity in stock.',
      'quantityNotWhole': 'Please enter the quantity as a whole number.',
      'other': 'Please enter a quantity from $minQuantity to $maxQuantity.',
    });
    return '$_temp0';
  }

  @override
  String medicineAdded(String name) {
    return '$name added for this session.';
  }

  @override
  String medicineUpdated(String name) {
    return '$name updated for this session.';
  }

  @override
  String get discardTitle => 'Discard changes?';

  @override
  String get discardMessage =>
      'Your changes to this medicine will not be saved.';

  @override
  String get discardConfirm => 'Discard';

  @override
  String get keepEditing => 'Keep editing';

  @override
  String get profileTitle => 'Profile';

  @override
  String get aboutSection => 'About';

  @override
  String get termsTitle => 'Terms and Conditions';

  @override
  String get termsSubtitle => 'Placeholder';

  @override
  String get termsMessage =>
      'This prototype has no terms and conditions. Real terms would be written and reviewed before any public release.';

  @override
  String get privacyTitle => 'Privacy Policy';

  @override
  String get privacySubtitle => 'How this prototype handles data';

  @override
  String get privacyMessage =>
      'This prototype has no published privacy policy.\n\nIt has no backend, account system or analytics. Sample data and your changes are kept in memory on this device and reset when you log out or close the app.';

  @override
  String get shareTitle => 'Share App';

  @override
  String get shareSubtitle => 'Demo only';

  @override
  String get shareMessage =>
      'Sharing is not available in this prototype, and there is no store listing to share yet.';

  @override
  String get licensesTitle => 'Open-source licenses';

  @override
  String get logoutTitle => 'Log out';

  @override
  String get logoutSubtitle => 'Resets this demo session';

  @override
  String get logoutConfirmTitle => 'Log out of the demo?';

  @override
  String get logoutConfirmMessage =>
      'You will return to the welcome screen. Medicines and dose logs you changed in this session will be reset to the sample data.';

  @override
  String get loggedOut => 'Logged out. Demo changes were cleared.';

  @override
  String versionLine(String appName, String version) {
    return '$appName $version · Prototype';
  }

  @override
  String versionWithBuild(String version, String build) {
    return '$version (build $build)';
  }

  @override
  String avatarLabel(String name) {
    return 'Profile picture for $name';
  }

  @override
  String get guestName => 'Guest';

  @override
  String get guestSubtitle => 'Browsing as a guest';

  @override
  String get guestModeChip => 'Guest mode';

  @override
  String get guestAvatarLabel => 'Guest profile picture';

  @override
  String get signIn => 'Sign in';

  @override
  String get signInPromptTitle => 'Sign in to manage medicines';

  @override
  String get signInPromptMessage =>
      'Guests can view medicines and log doses. Sign in to add, edit or delete medicines.';

  @override
  String get notNow => 'Not now';

  @override
  String signedInUpgrade(String provider) {
    return 'Signed in with $provider (simulated). You can now manage medicines.';
  }

  @override
  String get inventoryGuestBanner =>
      'You\'re browsing as a guest. Sign in to add, edit or delete medicines.';

  @override
  String get exitGuestTitle => 'Exit guest mode';

  @override
  String get exitGuestSubtitle => 'Returns to the welcome screen';

  @override
  String get exitGuestConfirmTitle => 'Exit guest mode?';

  @override
  String get exitGuestConfirmMessage =>
      'You will return to the welcome screen. Doses you logged in this session will be reset.';

  @override
  String get exitedGuestMode =>
      'Exited guest mode. Session changes were cleared.';

  @override
  String demoProfileSimulated(String provider) {
    return 'Demo profile · $provider sign-in simulated';
  }

  @override
  String get notFoundTitle => 'Page not found';

  @override
  String get notFoundMessage => 'This link doesn\'t match anything in the app.';

  @override
  String get goToToday => 'Go to Today';
}
