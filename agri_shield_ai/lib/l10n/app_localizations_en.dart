// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'KAVACH';

  @override
  String get farmProtectionSystem => 'Farm protection system';

  @override
  String get navHome => 'Home';

  @override
  String get navLive => 'Live';

  @override
  String get navAlerts => 'Alerts';

  @override
  String get navProfile => 'Profile';

  @override
  String hiGreeting(String greeting) {
    return 'Hi, $greeting';
  }

  @override
  String get goodMorning => 'Good Morning';

  @override
  String get goodAfternoon => 'Good Afternoon';

  @override
  String get goodEvening => 'Good Evening';

  @override
  String get farmLocation => 'Green Valley Farm';

  @override
  String get animalsToday => 'Animals today';

  @override
  String get detections => 'detections';

  @override
  String get detectedAroundFarm => 'Detected around your farm today';

  @override
  String get byAnimalType => 'By animal type';

  @override
  String get cameras => 'Cameras';

  @override
  String onlineCount(int online, int total) {
    return '$online/$total online';
  }

  @override
  String get allOnline => 'All online';

  @override
  String get needsCheck => 'Needs check';

  @override
  String get openLive => 'Open Live';

  @override
  String get deterrents => 'Deterrents';

  @override
  String get alerts => 'Alerts';

  @override
  String get clear => 'Clear';

  @override
  String get noAlerts => 'No alerts — farm looks clear.';

  @override
  String get alertDismissed => 'Alert dismissed';

  @override
  String get allAlertsCleared => 'All alerts cleared';

  @override
  String get aiStatus => 'AI Status';

  @override
  String get aiScanning => 'Detection active';

  @override
  String get aiReady => 'Models ready · Watching farm';

  @override
  String get aiConfidence => 'Confidence';

  @override
  String get language => 'Language';

  @override
  String get languageSettings => 'Language settings';

  @override
  String currentLanguage(String name) {
    return 'Current language: $name';
  }

  @override
  String get english => 'English';

  @override
  String get hindi => 'हिन्दी';

  @override
  String get gujarati => 'ગુજરાતી';

  @override
  String get profileSettings => 'Profile & Settings';

  @override
  String get liveFeed => 'Live Feed';

  @override
  String liveFeedCamera(int index) {
    return 'Live Feed · Camera $index';
  }

  @override
  String get alertsTitle => 'Alerts';

  @override
  String get alertsSubtitle => 'AI detection and equipment alerts';

  @override
  String get welcomeTitle => 'Welcome to\nKAVACH';

  @override
  String get welcomeBody =>
      'See animals early, run laser, speaker, or water — and keep crops safe.';

  @override
  String get getStarted => 'Get Started';

  @override
  String get continueAsGuest => 'Continue as Guest';

  @override
  String get signIn => 'Sign in';

  @override
  String get joinKavach => 'Join KAVACH';

  @override
  String get welcomeBack => 'Welcome back';

  @override
  String get createAccount => 'Create account';

  @override
  String get login => 'Login';

  @override
  String get phone => 'Phone';

  @override
  String get username => 'Username';

  @override
  String get password => 'Password';

  @override
  String get alreadyHaveAccount => 'Already have an account? Login';

  @override
  String get newHere => 'New here? Create account';

  @override
  String get manualAlarm => 'Manual Alarm';

  @override
  String get viewAllAlerts => 'View all';

  @override
  String get setupFarmLogin => 'Set up your farm login in a minute.';

  @override
  String get loginWithPhoneOrUsername => 'Login with phone or username.';

  @override
  String get yourName => 'Your name';

  @override
  String get farmerNameHint => 'Farmer name';

  @override
  String get phoneNumber => 'Phone number';

  @override
  String get tenDigitMobile => '10-digit mobile';

  @override
  String get yourUsername => 'Your username';

  @override
  String get enterPassword => 'Enter password';

  @override
  String get demoLogin =>
      'Demo login\nPhone · 9876543210 · farm1234\nUsername · ramesh · farm1234';

  @override
  String welcomeUser(String name) {
    return 'Welcome, $name';
  }

  @override
  String get signedInAsGuest => 'Signed in as Guest';

  @override
  String get notSignedIn => 'Not signed in';

  @override
  String get guestMode => 'Guest mode';

  @override
  String get sectionYourDetails => 'Your details';

  @override
  String get farmName => 'Farm name';

  @override
  String get villageArea => 'Village / area';

  @override
  String get yourPhone => 'Your phone';

  @override
  String get saveProfile => 'Save profile';

  @override
  String get profileSaved => 'Profile saved';

  @override
  String get enterYourName => 'Enter your name';

  @override
  String get enterFarmName => 'Enter farm name';

  @override
  String get enterValidPhone => 'Enter a valid phone number';

  @override
  String get sectionEmergency => 'Emergency contact';

  @override
  String get emergencyHelp =>
      'Someone we can call if animals break in or equipment fails.';

  @override
  String get emergencyPhone => 'Emergency phone';

  @override
  String get saveEmergency => 'Save emergency contact';

  @override
  String get emergencySaved => 'Emergency contact saved';

  @override
  String get enterValidEmergency => 'Enter a valid emergency phone number';

  @override
  String get sectionDevices => 'Connected devices';

  @override
  String get tapDeviceToggle => 'Tap a device to toggle Online / Offline';

  @override
  String get online => 'Online';

  @override
  String get offline => 'Offline';

  @override
  String deviceNowStatus(String name, String status) {
    return '$name is now $status';
  }

  @override
  String get sectionAlertsSounds => 'Alerts & sounds';

  @override
  String get pushAlerts => 'Push alerts';

  @override
  String get pushAlertsSub => 'Show alerts on your phone';

  @override
  String get alertSounds => 'Alert sounds';

  @override
  String get alertSoundsSub => 'Play a sound when animals are seen';

  @override
  String get vibration => 'Vibration';

  @override
  String get vibrationSub => 'Phone vibrates on alerts';

  @override
  String get equipmentOfflineAlerts => 'Equipment offline alerts';

  @override
  String get equipmentOfflineSub => 'Tell me if a camera or speaker stops';

  @override
  String get dailySummary => 'Daily summary';

  @override
  String get dailySummarySub => 'One message each evening';

  @override
  String get sectionDetection => 'Detection settings';

  @override
  String get detectionSensitivity => 'Detection sensitivity';

  @override
  String get sensitivityHint => 'Higher = more alerts. Lower = fewer alerts.';

  @override
  String get autoActivate => 'Auto activate deterrents';

  @override
  String get autoActivateSub => 'Turn on laser / speaker / water automatically';

  @override
  String get nightWatch => 'Stronger watch at night';

  @override
  String get nightWatchSub => 'Extra careful after dark';

  @override
  String get sectionPreferences => 'App preferences';

  @override
  String get units => 'Units';

  @override
  String get metric => 'Metric';

  @override
  String get imperial => 'Imperial';

  @override
  String get metricHint => 'm, °C';

  @override
  String get imperialHint => 'ft, °F';

  @override
  String get sectionHelp => 'Help & support';

  @override
  String get howToUse => 'How to use this app';

  @override
  String get howToUseSub => 'Simple guide for each screen';

  @override
  String get howToUseTitle => 'How to use KAVACH';

  @override
  String get howToUseBody =>
      'Home — farm overview, deterrents, and alerts.\nLive — watch cameras, take photos, record.\nAlerts — review detections and open manual alarm.\nProfile — your farm details and settings.';

  @override
  String get chatSupport => 'Chat with support';

  @override
  String get supportChatTitle => 'Support chat';

  @override
  String get supportChatBody =>
      'Email help@kavach.app\n\nIn this demo, your message is saved locally. A real chat will open here in a future update.';

  @override
  String get sendMessage => 'Send message';

  @override
  String get supportMessageSent => 'Support message sent';

  @override
  String get callHelpline => 'Call helpline';

  @override
  String get callHelplineBody =>
      'Helpline: 1800-123-4567\nHours: 8 AM – 8 PM\n\nThis demo cannot place a real call.';

  @override
  String get copyNumber => 'Copy number';

  @override
  String get sectionAbout => 'About';

  @override
  String get versionFarmProtection => 'Version 6.0.0 · Farm protection';

  @override
  String get privacy => 'Privacy';

  @override
  String get privacyBody =>
      'KAVACH stores your profile and settings on this device. Camera views and alerts in this demo are sample data only. We do not sell your farm information.';

  @override
  String get termsOfUse => 'Terms of use';

  @override
  String get termsBody =>
      'Use deterrents carefully. Keep people and pets away from laser and water spray while active. You are responsible for safe use on your farm. KAVACH is a prototype for demonstration.';

  @override
  String get signOut => 'Sign out';

  @override
  String get signOutConfirm => 'Sign out?';

  @override
  String get signOutBody => 'You will return to the login screen.';

  @override
  String get flashOn => 'Flash on';

  @override
  String get flashOff => 'Flash off';

  @override
  String get flashTurnedOn => 'Flash turned ON';

  @override
  String get flashTurnedOff => 'Flash turned OFF';

  @override
  String get record => 'Record';

  @override
  String get stopRecording => 'Stop recording';

  @override
  String get recordingStarted => 'Recording started';

  @override
  String get recordingStopped => 'Recording stopped · clip saved';

  @override
  String get openActivateHint => 'Open Activate to scare it away safely.';

  @override
  String get goToActivate => 'Go to Activate';

  @override
  String confidenceLabel(String value) {
    return 'Confidence: $value';
  }

  @override
  String get nothingActive =>
      'Nothing active. Use Activate to turn something on.';

  @override
  String get switchCam => 'Switch Cam';

  @override
  String switchedCamera(int index) {
    return 'Switched to Camera $index';
  }

  @override
  String zoomLabel(String value) {
    return 'Zoom ${value}x';
  }

  @override
  String get snapshot => 'Snapshot';

  @override
  String photoSaved(int count) {
    return 'Photo saved · #$count';
  }

  @override
  String get alarmLevelsHint =>
      'Three alarm levels. Hold a level to turn it on.';

  @override
  String get levelSoftWarning => 'Level 1 · Soft warning';

  @override
  String get levelActiveAlert => 'Level 2 · Active alert';

  @override
  String get levelCritical => 'Level 3 · Critical';

  @override
  String alarmActiveStatus(int level, String name, int seconds) {
    return 'Level $level · $name ON · ${seconds}s left';
  }

  @override
  String get stop => 'Stop';

  @override
  String stoppedNamed(String name) {
    return '$name stopped';
  }

  @override
  String stopFirst(String name) {
    return 'Stop $name first';
  }

  @override
  String levelActivated(int level, String name) {
    return 'Level $level · $name is ON for 15s';
  }

  @override
  String holdToActivate(int level) {
    return 'Hold to activate Level $level';
  }

  @override
  String get releaseToCancel => 'Release to cancel';

  @override
  String get keepPeopleAway => 'Keep people away while this is active.';

  @override
  String alreadyOn(String name) {
    return '$name already ON';
  }

  @override
  String statusChanged(String name, String status) {
    return '$name → $status';
  }

  @override
  String get statusOn => 'ON';

  @override
  String get statusOff => 'OFF';

  @override
  String get statusReady => 'Ready';

  @override
  String get statusFault => 'Fault';

  @override
  String get chooseLanguageTitle => 'Choose your language';

  @override
  String get chooseLanguageBody =>
      'Pick the language you want to use in KAVACH. You can change it later in Profile.';

  @override
  String get continueLabel => 'Continue';

  @override
  String get equipLaser => 'Laser';

  @override
  String get equipSpeaker => 'Speaker';

  @override
  String get equipWater => 'Water';

  @override
  String get equipWaterFull => 'Water Sprinkler';

  @override
  String get equipLaserDesc => 'Scares animals with light';

  @override
  String get equipSpeakerDesc => 'Plays loud sounds to move them away';

  @override
  String get equipWaterDesc => 'Sprays a strong water jet';

  @override
  String get animalCow => 'Cow';

  @override
  String get animalBuffalo => 'Buffalo';

  @override
  String get animalGoat => 'Goat';

  @override
  String get animalWildPig => 'Wild Pig';

  @override
  String get confidenceVerySure => 'Very sure';

  @override
  String get alertWaterLow => 'Water tank is getting low';

  @override
  String get alertCameraOffline => 'Camera 2 is offline';

  @override
  String get alertBatteryOk => 'Battery is charging well (87%)';

  @override
  String get alertSpeakerCheck => 'Speaker needs a check';

  @override
  String get errInvalidPhone => 'Enter a valid 10-digit phone number';

  @override
  String get errPasswordShort => 'Password must be at least 4 characters';

  @override
  String get errWrongPhonePassword => 'Wrong phone or password';

  @override
  String get errInvalidUsername => 'Enter a valid username';

  @override
  String get errWrongUsernamePassword => 'Wrong username or password';

  @override
  String get errEnterName => 'Enter your name';

  @override
  String get errPhoneRegistered => 'This phone is already registered';

  @override
  String get errUsernameShort => 'Username must be at least 3 characters';

  @override
  String get errUsernameTaken => 'This username is already taken';
}
