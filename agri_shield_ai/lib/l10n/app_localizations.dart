import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_gu.dart';
import 'app_localizations_hi.dart';

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
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('gu'),
    Locale('hi')
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'KAVACH'**
  String get appName;

  /// No description provided for @farmProtectionSystem.
  ///
  /// In en, this message translates to:
  /// **'Farm protection system'**
  String get farmProtectionSystem;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navLive.
  ///
  /// In en, this message translates to:
  /// **'Live'**
  String get navLive;

  /// No description provided for @navAlerts.
  ///
  /// In en, this message translates to:
  /// **'Alerts'**
  String get navAlerts;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @hiGreeting.
  ///
  /// In en, this message translates to:
  /// **'Hi, {greeting}'**
  String hiGreeting(String greeting);

  /// No description provided for @goodMorning.
  ///
  /// In en, this message translates to:
  /// **'Good Morning'**
  String get goodMorning;

  /// No description provided for @goodAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good Afternoon'**
  String get goodAfternoon;

  /// No description provided for @goodEvening.
  ///
  /// In en, this message translates to:
  /// **'Good Evening'**
  String get goodEvening;

  /// No description provided for @farmLocation.
  ///
  /// In en, this message translates to:
  /// **'Green Valley Farm'**
  String get farmLocation;

  /// No description provided for @animalsToday.
  ///
  /// In en, this message translates to:
  /// **'Animals today'**
  String get animalsToday;

  /// No description provided for @detections.
  ///
  /// In en, this message translates to:
  /// **'detections'**
  String get detections;

  /// No description provided for @detectedAroundFarm.
  ///
  /// In en, this message translates to:
  /// **'Detected around your farm today'**
  String get detectedAroundFarm;

  /// No description provided for @byAnimalType.
  ///
  /// In en, this message translates to:
  /// **'By animal type'**
  String get byAnimalType;

  /// No description provided for @cameras.
  ///
  /// In en, this message translates to:
  /// **'Cameras'**
  String get cameras;

  /// No description provided for @onlineCount.
  ///
  /// In en, this message translates to:
  /// **'{online}/{total} online'**
  String onlineCount(int online, int total);

  /// No description provided for @allOnline.
  ///
  /// In en, this message translates to:
  /// **'All online'**
  String get allOnline;

  /// No description provided for @needsCheck.
  ///
  /// In en, this message translates to:
  /// **'Needs check'**
  String get needsCheck;

  /// No description provided for @openLive.
  ///
  /// In en, this message translates to:
  /// **'Open Live'**
  String get openLive;

  /// No description provided for @deterrents.
  ///
  /// In en, this message translates to:
  /// **'Deterrents'**
  String get deterrents;

  /// No description provided for @alerts.
  ///
  /// In en, this message translates to:
  /// **'Alerts'**
  String get alerts;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @noAlerts.
  ///
  /// In en, this message translates to:
  /// **'No alerts — farm looks clear.'**
  String get noAlerts;

  /// No description provided for @alertDismissed.
  ///
  /// In en, this message translates to:
  /// **'Alert dismissed'**
  String get alertDismissed;

  /// No description provided for @allAlertsCleared.
  ///
  /// In en, this message translates to:
  /// **'All alerts cleared'**
  String get allAlertsCleared;

  /// No description provided for @aiStatus.
  ///
  /// In en, this message translates to:
  /// **'AI Status'**
  String get aiStatus;

  /// No description provided for @aiScanning.
  ///
  /// In en, this message translates to:
  /// **'Detection active'**
  String get aiScanning;

  /// No description provided for @aiReady.
  ///
  /// In en, this message translates to:
  /// **'Models ready · Watching farm'**
  String get aiReady;

  /// No description provided for @aiConfidence.
  ///
  /// In en, this message translates to:
  /// **'Confidence'**
  String get aiConfidence;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageSettings.
  ///
  /// In en, this message translates to:
  /// **'Language settings'**
  String get languageSettings;

  /// No description provided for @currentLanguage.
  ///
  /// In en, this message translates to:
  /// **'Current language: {name}'**
  String currentLanguage(String name);

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @hindi.
  ///
  /// In en, this message translates to:
  /// **'हिन्दी'**
  String get hindi;

  /// No description provided for @gujarati.
  ///
  /// In en, this message translates to:
  /// **'ગુજરાતી'**
  String get gujarati;

  /// No description provided for @profileSettings.
  ///
  /// In en, this message translates to:
  /// **'Profile & Settings'**
  String get profileSettings;

  /// No description provided for @liveFeed.
  ///
  /// In en, this message translates to:
  /// **'Live Feed'**
  String get liveFeed;

  /// No description provided for @liveFeedCamera.
  ///
  /// In en, this message translates to:
  /// **'Live Feed · Camera {index}'**
  String liveFeedCamera(int index);

  /// No description provided for @alertsTitle.
  ///
  /// In en, this message translates to:
  /// **'Alerts'**
  String get alertsTitle;

  /// No description provided for @alertsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'AI detection and equipment alerts'**
  String get alertsSubtitle;

  /// No description provided for @welcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to\nKAVACH'**
  String get welcomeTitle;

  /// No description provided for @welcomeBody.
  ///
  /// In en, this message translates to:
  /// **'See animals early, run laser, speaker, or water — and keep crops safe.'**
  String get welcomeBody;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @continueAsGuest.
  ///
  /// In en, this message translates to:
  /// **'Continue as Guest'**
  String get continueAsGuest;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

  /// No description provided for @joinKavach.
  ///
  /// In en, this message translates to:
  /// **'Join KAVACH'**
  String get joinKavach;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get welcomeBack;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get createAccount;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Login'**
  String get alreadyHaveAccount;

  /// No description provided for @newHere.
  ///
  /// In en, this message translates to:
  /// **'New here? Create account'**
  String get newHere;

  /// No description provided for @manualAlarm.
  ///
  /// In en, this message translates to:
  /// **'Manual Alarm'**
  String get manualAlarm;

  /// No description provided for @viewAllAlerts.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get viewAllAlerts;

  /// No description provided for @setupFarmLogin.
  ///
  /// In en, this message translates to:
  /// **'Set up your farm login in a minute.'**
  String get setupFarmLogin;

  /// No description provided for @loginWithPhoneOrUsername.
  ///
  /// In en, this message translates to:
  /// **'Login with phone or username.'**
  String get loginWithPhoneOrUsername;

  /// No description provided for @yourName.
  ///
  /// In en, this message translates to:
  /// **'Your name'**
  String get yourName;

  /// No description provided for @farmerNameHint.
  ///
  /// In en, this message translates to:
  /// **'Farmer name'**
  String get farmerNameHint;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get phoneNumber;

  /// No description provided for @tenDigitMobile.
  ///
  /// In en, this message translates to:
  /// **'10-digit mobile'**
  String get tenDigitMobile;

  /// No description provided for @yourUsername.
  ///
  /// In en, this message translates to:
  /// **'Your username'**
  String get yourUsername;

  /// No description provided for @enterPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter password'**
  String get enterPassword;

  /// No description provided for @demoLogin.
  ///
  /// In en, this message translates to:
  /// **'Demo login\nPhone · 9876543210 · farm1234\nUsername · ramesh · farm1234'**
  String get demoLogin;

  /// No description provided for @welcomeUser.
  ///
  /// In en, this message translates to:
  /// **'Welcome, {name}'**
  String welcomeUser(String name);

  /// No description provided for @signedInAsGuest.
  ///
  /// In en, this message translates to:
  /// **'Signed in as Guest'**
  String get signedInAsGuest;

  /// No description provided for @notSignedIn.
  ///
  /// In en, this message translates to:
  /// **'Not signed in'**
  String get notSignedIn;

  /// No description provided for @guestMode.
  ///
  /// In en, this message translates to:
  /// **'Guest mode'**
  String get guestMode;

  /// No description provided for @sectionYourDetails.
  ///
  /// In en, this message translates to:
  /// **'Your details'**
  String get sectionYourDetails;

  /// No description provided for @farmName.
  ///
  /// In en, this message translates to:
  /// **'Farm name'**
  String get farmName;

  /// No description provided for @villageArea.
  ///
  /// In en, this message translates to:
  /// **'Village / area'**
  String get villageArea;

  /// No description provided for @yourPhone.
  ///
  /// In en, this message translates to:
  /// **'Your phone'**
  String get yourPhone;

  /// No description provided for @saveProfile.
  ///
  /// In en, this message translates to:
  /// **'Save profile'**
  String get saveProfile;

  /// No description provided for @profileSaved.
  ///
  /// In en, this message translates to:
  /// **'Profile saved'**
  String get profileSaved;

  /// No description provided for @enterYourName.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get enterYourName;

  /// No description provided for @enterFarmName.
  ///
  /// In en, this message translates to:
  /// **'Enter farm name'**
  String get enterFarmName;

  /// No description provided for @enterValidPhone.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid phone number'**
  String get enterValidPhone;

  /// No description provided for @sectionEmergency.
  ///
  /// In en, this message translates to:
  /// **'Emergency contact'**
  String get sectionEmergency;

  /// No description provided for @emergencyHelp.
  ///
  /// In en, this message translates to:
  /// **'Someone we can call if animals break in or equipment fails.'**
  String get emergencyHelp;

  /// No description provided for @emergencyPhone.
  ///
  /// In en, this message translates to:
  /// **'Emergency phone'**
  String get emergencyPhone;

  /// No description provided for @saveEmergency.
  ///
  /// In en, this message translates to:
  /// **'Save emergency contact'**
  String get saveEmergency;

  /// No description provided for @emergencySaved.
  ///
  /// In en, this message translates to:
  /// **'Emergency contact saved'**
  String get emergencySaved;

  /// No description provided for @enterValidEmergency.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid emergency phone number'**
  String get enterValidEmergency;

  /// No description provided for @sectionDevices.
  ///
  /// In en, this message translates to:
  /// **'Connected devices'**
  String get sectionDevices;

  /// No description provided for @tapDeviceToggle.
  ///
  /// In en, this message translates to:
  /// **'Tap a device to toggle Online / Offline'**
  String get tapDeviceToggle;

  /// No description provided for @online.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get online;

  /// No description provided for @offline.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get offline;

  /// No description provided for @deviceNowStatus.
  ///
  /// In en, this message translates to:
  /// **'{name} is now {status}'**
  String deviceNowStatus(String name, String status);

  /// No description provided for @sectionAlertsSounds.
  ///
  /// In en, this message translates to:
  /// **'Alerts & sounds'**
  String get sectionAlertsSounds;

  /// No description provided for @pushAlerts.
  ///
  /// In en, this message translates to:
  /// **'Push alerts'**
  String get pushAlerts;

  /// No description provided for @pushAlertsSub.
  ///
  /// In en, this message translates to:
  /// **'Show alerts on your phone'**
  String get pushAlertsSub;

  /// No description provided for @alertSounds.
  ///
  /// In en, this message translates to:
  /// **'Alert sounds'**
  String get alertSounds;

  /// No description provided for @alertSoundsSub.
  ///
  /// In en, this message translates to:
  /// **'Play a sound when animals are seen'**
  String get alertSoundsSub;

  /// No description provided for @vibration.
  ///
  /// In en, this message translates to:
  /// **'Vibration'**
  String get vibration;

  /// No description provided for @vibrationSub.
  ///
  /// In en, this message translates to:
  /// **'Phone vibrates on alerts'**
  String get vibrationSub;

  /// No description provided for @equipmentOfflineAlerts.
  ///
  /// In en, this message translates to:
  /// **'Equipment offline alerts'**
  String get equipmentOfflineAlerts;

  /// No description provided for @equipmentOfflineSub.
  ///
  /// In en, this message translates to:
  /// **'Tell me if a camera or speaker stops'**
  String get equipmentOfflineSub;

  /// No description provided for @dailySummary.
  ///
  /// In en, this message translates to:
  /// **'Daily summary'**
  String get dailySummary;

  /// No description provided for @dailySummarySub.
  ///
  /// In en, this message translates to:
  /// **'One message each evening'**
  String get dailySummarySub;

  /// No description provided for @sectionDetection.
  ///
  /// In en, this message translates to:
  /// **'Detection settings'**
  String get sectionDetection;

  /// No description provided for @detectionSensitivity.
  ///
  /// In en, this message translates to:
  /// **'Detection sensitivity'**
  String get detectionSensitivity;

  /// No description provided for @sensitivityHint.
  ///
  /// In en, this message translates to:
  /// **'Higher = more alerts. Lower = fewer alerts.'**
  String get sensitivityHint;

  /// No description provided for @autoActivate.
  ///
  /// In en, this message translates to:
  /// **'Auto activate deterrents'**
  String get autoActivate;

  /// No description provided for @autoActivateSub.
  ///
  /// In en, this message translates to:
  /// **'Turn on laser / speaker / water automatically'**
  String get autoActivateSub;

  /// No description provided for @nightWatch.
  ///
  /// In en, this message translates to:
  /// **'Stronger watch at night'**
  String get nightWatch;

  /// No description provided for @nightWatchSub.
  ///
  /// In en, this message translates to:
  /// **'Extra careful after dark'**
  String get nightWatchSub;

  /// No description provided for @sectionPreferences.
  ///
  /// In en, this message translates to:
  /// **'App preferences'**
  String get sectionPreferences;

  /// No description provided for @units.
  ///
  /// In en, this message translates to:
  /// **'Units'**
  String get units;

  /// No description provided for @metric.
  ///
  /// In en, this message translates to:
  /// **'Metric'**
  String get metric;

  /// No description provided for @imperial.
  ///
  /// In en, this message translates to:
  /// **'Imperial'**
  String get imperial;

  /// No description provided for @metricHint.
  ///
  /// In en, this message translates to:
  /// **'m, °C'**
  String get metricHint;

  /// No description provided for @imperialHint.
  ///
  /// In en, this message translates to:
  /// **'ft, °F'**
  String get imperialHint;

  /// No description provided for @sectionHelp.
  ///
  /// In en, this message translates to:
  /// **'Help & support'**
  String get sectionHelp;

  /// No description provided for @howToUse.
  ///
  /// In en, this message translates to:
  /// **'How to use this app'**
  String get howToUse;

  /// No description provided for @howToUseSub.
  ///
  /// In en, this message translates to:
  /// **'Simple guide for each screen'**
  String get howToUseSub;

  /// No description provided for @howToUseTitle.
  ///
  /// In en, this message translates to:
  /// **'How to use KAVACH'**
  String get howToUseTitle;

  /// No description provided for @howToUseBody.
  ///
  /// In en, this message translates to:
  /// **'Home — farm overview, deterrents, and alerts.\nLive — watch cameras, take photos, record.\nAlerts — review detections and open manual alarm.\nProfile — your farm details and settings.'**
  String get howToUseBody;

  /// No description provided for @chatSupport.
  ///
  /// In en, this message translates to:
  /// **'Chat with support'**
  String get chatSupport;

  /// No description provided for @supportChatTitle.
  ///
  /// In en, this message translates to:
  /// **'Support chat'**
  String get supportChatTitle;

  /// No description provided for @supportChatBody.
  ///
  /// In en, this message translates to:
  /// **'Email help@kavach.app\n\nIn this demo, your message is saved locally. A real chat will open here in a future update.'**
  String get supportChatBody;

  /// No description provided for @sendMessage.
  ///
  /// In en, this message translates to:
  /// **'Send message'**
  String get sendMessage;

  /// No description provided for @supportMessageSent.
  ///
  /// In en, this message translates to:
  /// **'Support message sent'**
  String get supportMessageSent;

  /// No description provided for @callHelpline.
  ///
  /// In en, this message translates to:
  /// **'Call helpline'**
  String get callHelpline;

  /// No description provided for @callHelplineBody.
  ///
  /// In en, this message translates to:
  /// **'Helpline: 1800-123-4567\nHours: 8 AM – 8 PM\n\nThis demo cannot place a real call.'**
  String get callHelplineBody;

  /// No description provided for @copyNumber.
  ///
  /// In en, this message translates to:
  /// **'Copy number'**
  String get copyNumber;

  /// No description provided for @sectionAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get sectionAbout;

  /// No description provided for @versionFarmProtection.
  ///
  /// In en, this message translates to:
  /// **'Version 6.0.0 · Farm protection'**
  String get versionFarmProtection;

  /// No description provided for @privacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get privacy;

  /// No description provided for @privacyBody.
  ///
  /// In en, this message translates to:
  /// **'KAVACH stores your profile and settings on this device. Camera views and alerts in this demo are sample data only. We do not sell your farm information.'**
  String get privacyBody;

  /// No description provided for @termsOfUse.
  ///
  /// In en, this message translates to:
  /// **'Terms of use'**
  String get termsOfUse;

  /// No description provided for @termsBody.
  ///
  /// In en, this message translates to:
  /// **'Use deterrents carefully. Keep people and pets away from laser and water spray while active. You are responsible for safe use on your farm. KAVACH is a prototype for demonstration.'**
  String get termsBody;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOut;

  /// No description provided for @signOutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Sign out?'**
  String get signOutConfirm;

  /// No description provided for @signOutBody.
  ///
  /// In en, this message translates to:
  /// **'You will return to the login screen.'**
  String get signOutBody;

  /// No description provided for @flashOn.
  ///
  /// In en, this message translates to:
  /// **'Flash on'**
  String get flashOn;

  /// No description provided for @flashOff.
  ///
  /// In en, this message translates to:
  /// **'Flash off'**
  String get flashOff;

  /// No description provided for @flashTurnedOn.
  ///
  /// In en, this message translates to:
  /// **'Flash turned ON'**
  String get flashTurnedOn;

  /// No description provided for @flashTurnedOff.
  ///
  /// In en, this message translates to:
  /// **'Flash turned OFF'**
  String get flashTurnedOff;

  /// No description provided for @record.
  ///
  /// In en, this message translates to:
  /// **'Record'**
  String get record;

  /// No description provided for @stopRecording.
  ///
  /// In en, this message translates to:
  /// **'Stop recording'**
  String get stopRecording;

  /// No description provided for @recordingStarted.
  ///
  /// In en, this message translates to:
  /// **'Recording started'**
  String get recordingStarted;

  /// No description provided for @recordingStopped.
  ///
  /// In en, this message translates to:
  /// **'Recording stopped · clip saved'**
  String get recordingStopped;

  /// No description provided for @openActivateHint.
  ///
  /// In en, this message translates to:
  /// **'Open Activate to scare it away safely.'**
  String get openActivateHint;

  /// No description provided for @goToActivate.
  ///
  /// In en, this message translates to:
  /// **'Go to Activate'**
  String get goToActivate;

  /// No description provided for @confidenceLabel.
  ///
  /// In en, this message translates to:
  /// **'Confidence: {value}'**
  String confidenceLabel(String value);

  /// No description provided for @nothingActive.
  ///
  /// In en, this message translates to:
  /// **'Nothing active. Use Activate to turn something on.'**
  String get nothingActive;

  /// No description provided for @switchCam.
  ///
  /// In en, this message translates to:
  /// **'Switch Cam'**
  String get switchCam;

  /// No description provided for @switchedCamera.
  ///
  /// In en, this message translates to:
  /// **'Switched to Camera {index}'**
  String switchedCamera(int index);

  /// No description provided for @zoomLabel.
  ///
  /// In en, this message translates to:
  /// **'Zoom {value}x'**
  String zoomLabel(String value);

  /// No description provided for @snapshot.
  ///
  /// In en, this message translates to:
  /// **'Snapshot'**
  String get snapshot;

  /// No description provided for @photoSaved.
  ///
  /// In en, this message translates to:
  /// **'Photo saved · #{count}'**
  String photoSaved(int count);

  /// No description provided for @alarmLevelsHint.
  ///
  /// In en, this message translates to:
  /// **'Three alarm levels. Hold a level to turn it on.'**
  String get alarmLevelsHint;

  /// No description provided for @levelSoftWarning.
  ///
  /// In en, this message translates to:
  /// **'Level 1 · Soft warning'**
  String get levelSoftWarning;

  /// No description provided for @levelActiveAlert.
  ///
  /// In en, this message translates to:
  /// **'Level 2 · Active alert'**
  String get levelActiveAlert;

  /// No description provided for @levelCritical.
  ///
  /// In en, this message translates to:
  /// **'Level 3 · Critical'**
  String get levelCritical;

  /// No description provided for @alarmActiveStatus.
  ///
  /// In en, this message translates to:
  /// **'Level {level} · {name} ON · {seconds}s left'**
  String alarmActiveStatus(int level, String name, int seconds);

  /// No description provided for @stop.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get stop;

  /// No description provided for @stoppedNamed.
  ///
  /// In en, this message translates to:
  /// **'{name} stopped'**
  String stoppedNamed(String name);

  /// No description provided for @stopFirst.
  ///
  /// In en, this message translates to:
  /// **'Stop {name} first'**
  String stopFirst(String name);

  /// No description provided for @levelActivated.
  ///
  /// In en, this message translates to:
  /// **'Level {level} · {name} is ON for 15s'**
  String levelActivated(int level, String name);

  /// No description provided for @holdToActivate.
  ///
  /// In en, this message translates to:
  /// **'Hold to activate Level {level}'**
  String holdToActivate(int level);

  /// No description provided for @releaseToCancel.
  ///
  /// In en, this message translates to:
  /// **'Release to cancel'**
  String get releaseToCancel;

  /// No description provided for @keepPeopleAway.
  ///
  /// In en, this message translates to:
  /// **'Keep people away while this is active.'**
  String get keepPeopleAway;

  /// No description provided for @alreadyOn.
  ///
  /// In en, this message translates to:
  /// **'{name} already ON'**
  String alreadyOn(String name);

  /// No description provided for @statusChanged.
  ///
  /// In en, this message translates to:
  /// **'{name} → {status}'**
  String statusChanged(String name, String status);

  /// No description provided for @statusOn.
  ///
  /// In en, this message translates to:
  /// **'ON'**
  String get statusOn;

  /// No description provided for @statusOff.
  ///
  /// In en, this message translates to:
  /// **'OFF'**
  String get statusOff;

  /// No description provided for @statusReady.
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get statusReady;

  /// No description provided for @statusFault.
  ///
  /// In en, this message translates to:
  /// **'Fault'**
  String get statusFault;

  /// No description provided for @chooseLanguageTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose your language'**
  String get chooseLanguageTitle;

  /// No description provided for @chooseLanguageBody.
  ///
  /// In en, this message translates to:
  /// **'Pick the language you want to use in KAVACH. You can change it later in Profile.'**
  String get chooseLanguageBody;

  /// No description provided for @continueLabel.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueLabel;

  /// No description provided for @equipLaser.
  ///
  /// In en, this message translates to:
  /// **'Laser'**
  String get equipLaser;

  /// No description provided for @equipSpeaker.
  ///
  /// In en, this message translates to:
  /// **'Speaker'**
  String get equipSpeaker;

  /// No description provided for @equipWater.
  ///
  /// In en, this message translates to:
  /// **'Water'**
  String get equipWater;

  /// No description provided for @equipWaterFull.
  ///
  /// In en, this message translates to:
  /// **'Water Sprinkler'**
  String get equipWaterFull;

  /// No description provided for @equipLaserDesc.
  ///
  /// In en, this message translates to:
  /// **'Scares animals with light'**
  String get equipLaserDesc;

  /// No description provided for @equipSpeakerDesc.
  ///
  /// In en, this message translates to:
  /// **'Plays loud sounds to move them away'**
  String get equipSpeakerDesc;

  /// No description provided for @equipWaterDesc.
  ///
  /// In en, this message translates to:
  /// **'Sprays a strong water jet'**
  String get equipWaterDesc;

  /// No description provided for @animalCow.
  ///
  /// In en, this message translates to:
  /// **'Cow'**
  String get animalCow;

  /// No description provided for @animalBuffalo.
  ///
  /// In en, this message translates to:
  /// **'Buffalo'**
  String get animalBuffalo;

  /// No description provided for @animalGoat.
  ///
  /// In en, this message translates to:
  /// **'Goat'**
  String get animalGoat;

  /// No description provided for @animalWildPig.
  ///
  /// In en, this message translates to:
  /// **'Wild Pig'**
  String get animalWildPig;

  /// No description provided for @confidenceVerySure.
  ///
  /// In en, this message translates to:
  /// **'Very sure'**
  String get confidenceVerySure;

  /// No description provided for @alertWaterLow.
  ///
  /// In en, this message translates to:
  /// **'Water tank is getting low'**
  String get alertWaterLow;

  /// No description provided for @alertCameraOffline.
  ///
  /// In en, this message translates to:
  /// **'Camera 2 is offline'**
  String get alertCameraOffline;

  /// No description provided for @alertBatteryOk.
  ///
  /// In en, this message translates to:
  /// **'Battery is charging well (87%)'**
  String get alertBatteryOk;

  /// No description provided for @alertSpeakerCheck.
  ///
  /// In en, this message translates to:
  /// **'Speaker needs a check'**
  String get alertSpeakerCheck;

  /// No description provided for @errInvalidPhone.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid 10-digit phone number'**
  String get errInvalidPhone;

  /// No description provided for @errPasswordShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 4 characters'**
  String get errPasswordShort;

  /// No description provided for @errWrongPhonePassword.
  ///
  /// In en, this message translates to:
  /// **'Wrong phone or password'**
  String get errWrongPhonePassword;

  /// No description provided for @errInvalidUsername.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid username'**
  String get errInvalidUsername;

  /// No description provided for @errWrongUsernamePassword.
  ///
  /// In en, this message translates to:
  /// **'Wrong username or password'**
  String get errWrongUsernamePassword;

  /// No description provided for @errEnterName.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get errEnterName;

  /// No description provided for @errPhoneRegistered.
  ///
  /// In en, this message translates to:
  /// **'This phone is already registered'**
  String get errPhoneRegistered;

  /// No description provided for @errUsernameShort.
  ///
  /// In en, this message translates to:
  /// **'Username must be at least 3 characters'**
  String get errUsernameShort;

  /// No description provided for @errUsernameTaken.
  ///
  /// In en, this message translates to:
  /// **'This username is already taken'**
  String get errUsernameTaken;
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
      <String>['en', 'gu', 'hi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'gu':
      return AppLocalizationsGu();
    case 'hi':
      return AppLocalizationsHi();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
