// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appName => 'कवच';

  @override
  String get farmProtectionSystem => 'खेत सुरक्षा प्रणाली';

  @override
  String get navHome => 'होम';

  @override
  String get navLive => 'लाइव';

  @override
  String get navAlerts => 'अलर्ट';

  @override
  String get navProfile => 'प्रोफ़ाइल';

  @override
  String hiGreeting(String greeting) {
    return 'नमस्ते, $greeting';
  }

  @override
  String get goodMorning => 'सुप्रभात';

  @override
  String get goodAfternoon => 'नमस्कार';

  @override
  String get goodEvening => 'शुभ संध्या';

  @override
  String get farmLocation => 'ग्रीन वैली फार्म';

  @override
  String get animalsToday => 'आज के जानवर';

  @override
  String get detections => 'पहचान';

  @override
  String get detectedAroundFarm => 'आज आपके खेत के आसपास पहचाने गए';

  @override
  String get byAnimalType => 'जानवर के प्रकार से';

  @override
  String get cameras => 'कैमरे';

  @override
  String onlineCount(int online, int total) {
    return '$online/$total ऑनलाइन';
  }

  @override
  String get allOnline => 'सभी ऑनलाइन';

  @override
  String get needsCheck => 'जाँच आवश्यक';

  @override
  String get openLive => 'लाइव खोलें';

  @override
  String get deterrents => 'निवारक';

  @override
  String get alerts => 'अलर्ट';

  @override
  String get clear => 'साफ़ करें';

  @override
  String get noAlerts => 'कोई अलर्ट नहीं — खेत सुरक्षित है।';

  @override
  String get alertDismissed => 'अलर्ट हटाया गया';

  @override
  String get allAlertsCleared => 'सभी अलर्ट साफ़ किए गए';

  @override
  String get aiStatus => 'एआई स्थिति';

  @override
  String get aiScanning => 'पहचान सक्रिय';

  @override
  String get aiReady => 'मॉडल तैयार · खेत की निगरानी';

  @override
  String get aiConfidence => 'विश्वास';

  @override
  String get language => 'भाषा';

  @override
  String get languageSettings => 'भाषा सेटिंग्स';

  @override
  String currentLanguage(String name) {
    return 'वर्तमान भाषा: $name';
  }

  @override
  String get english => 'English';

  @override
  String get hindi => 'हिन्दी';

  @override
  String get gujarati => 'ગુજરાતી';

  @override
  String get profileSettings => 'प्रोफ़ाइल और सेटिंग्स';

  @override
  String get liveFeed => 'लाइव फ़ीड';

  @override
  String liveFeedCamera(int index) {
    return 'लाइव फ़ीड · कैमरा $index';
  }

  @override
  String get alertsTitle => 'अलर्ट';

  @override
  String get alertsSubtitle => 'एआई पहचान और उपकरण अलर्ट';

  @override
  String get welcomeTitle => 'कवच में\nआपका स्वागत है';

  @override
  String get welcomeBody =>
      'जानवर जल्दी देखें, लेज़र, स्पीकर या पानी चलाएँ — फसल सुरक्षित रखें।';

  @override
  String get getStarted => 'शुरू करें';

  @override
  String get continueAsGuest => 'अतिथि के रूप में जारी रखें';

  @override
  String get signIn => 'साइन इन';

  @override
  String get joinKavach => 'कवच से जुड़ें';

  @override
  String get welcomeBack => 'वापसी पर स्वागत है';

  @override
  String get createAccount => 'खाता बनाएँ';

  @override
  String get login => 'लॉगिन';

  @override
  String get phone => 'फ़ोन';

  @override
  String get username => 'उपयोगकर्ता नाम';

  @override
  String get password => 'पासवर्ड';

  @override
  String get alreadyHaveAccount => 'पहले से खाता है? लॉगिन';

  @override
  String get newHere => 'नए हैं? खाता बनाएँ';

  @override
  String get manualAlarm => 'मैन्युअल अलार्म';

  @override
  String get viewAllAlerts => 'सभी देखें';

  @override
  String get setupFarmLogin => 'एक मिनट में अपना खेत लॉगिन सेट करें।';

  @override
  String get loginWithPhoneOrUsername =>
      'फ़ोन या उपयोगकर्ता नाम से लॉगिन करें।';

  @override
  String get yourName => 'आपका नाम';

  @override
  String get farmerNameHint => 'किसान का नाम';

  @override
  String get phoneNumber => 'फ़ोन नंबर';

  @override
  String get tenDigitMobile => '10 अंकों का मोबाइल';

  @override
  String get yourUsername => 'आपका उपयोगकर्ता नाम';

  @override
  String get enterPassword => 'पासवर्ड दर्ज करें';

  @override
  String get demoLogin =>
      'डेमो लॉगिन\nफ़ोन · 9876543210 · farm1234\nउपयोगकर्ता · ramesh · farm1234';

  @override
  String welcomeUser(String name) {
    return 'स्वागत है, $name';
  }

  @override
  String get signedInAsGuest => 'अतिथि के रूप में साइन इन';

  @override
  String get notSignedIn => 'साइन इन नहीं है';

  @override
  String get guestMode => 'अतिथि मोड';

  @override
  String get sectionYourDetails => 'आपका विवरण';

  @override
  String get farmName => 'खेत का नाम';

  @override
  String get villageArea => 'गाँव / क्षेत्र';

  @override
  String get yourPhone => 'आपका फ़ोन';

  @override
  String get saveProfile => 'प्रोफ़ाइल सहेजें';

  @override
  String get profileSaved => 'प्रोफ़ाइल सहेजी गई';

  @override
  String get enterYourName => 'अपना नाम दर्ज करें';

  @override
  String get enterFarmName => 'खेत का नाम दर्ज करें';

  @override
  String get enterValidPhone => 'वैध फ़ोन नंबर दर्ज करें';

  @override
  String get sectionEmergency => 'आपातकालीन संपर्क';

  @override
  String get emergencyHelp =>
      'जानवर घुसने या उपकरण खराब होने पर हम जिसे कॉल कर सकें।';

  @override
  String get emergencyPhone => 'आपातकालीन फ़ोन';

  @override
  String get saveEmergency => 'आपातकालीन संपर्क सहेजें';

  @override
  String get emergencySaved => 'आपातकालीन संपर्क सहेजा गया';

  @override
  String get enterValidEmergency => 'वैध आपातकालीन फ़ोन दर्ज करें';

  @override
  String get sectionDevices => 'जुड़े हुए उपकरण';

  @override
  String get tapDeviceToggle => 'ऑनलाइन / ऑफ़लाइन बदलने के लिए टैप करें';

  @override
  String get online => 'ऑनलाइन';

  @override
  String get offline => 'ऑफ़लाइन';

  @override
  String deviceNowStatus(String name, String status) {
    return '$name अब $status है';
  }

  @override
  String get sectionAlertsSounds => 'अलर्ट और ध्वनि';

  @override
  String get pushAlerts => 'पुश अलर्ट';

  @override
  String get pushAlertsSub => 'फ़ोन पर अलर्ट दिखाएँ';

  @override
  String get alertSounds => 'अलर्ट ध्वनि';

  @override
  String get alertSoundsSub => 'जानवर दिखने पर आवाज़ चलाएँ';

  @override
  String get vibration => 'कंपन';

  @override
  String get vibrationSub => 'अलर्ट पर फ़ोन कंपन करे';

  @override
  String get equipmentOfflineAlerts => 'उपकरण ऑफ़लाइन अलर्ट';

  @override
  String get equipmentOfflineSub => 'कैमरा या स्पीकर बंद होने पर बताएँ';

  @override
  String get dailySummary => 'दैनिक सारांश';

  @override
  String get dailySummarySub => 'हर शाम एक संदेश';

  @override
  String get sectionDetection => 'पहचान सेटिंग्स';

  @override
  String get detectionSensitivity => 'पहचान संवेदनशीलता';

  @override
  String get sensitivityHint => 'अधिक = अधिक अलर्ट। कम = कम अलर्ट।';

  @override
  String get autoActivate => 'निवारक स्वतः चालू करें';

  @override
  String get autoActivateSub => 'लेज़र / स्पीकर / पानी स्वतः चालू करें';

  @override
  String get nightWatch => 'रात में अधिक निगरानी';

  @override
  String get nightWatchSub => 'अंधेरे के बाद अतिरिक्त सावधानी';

  @override
  String get sectionPreferences => 'ऐप प्राथमिकताएँ';

  @override
  String get units => 'इकाइयाँ';

  @override
  String get metric => 'मीट्रिक';

  @override
  String get imperial => 'इंपीरियल';

  @override
  String get metricHint => 'मी, °से';

  @override
  String get imperialHint => 'फीट, °फ़';

  @override
  String get sectionHelp => 'सहायता और समर्थन';

  @override
  String get howToUse => 'ऐप कैसे उपयोग करें';

  @override
  String get howToUseSub => 'हर स्क्रीन की सरल गाइड';

  @override
  String get howToUseTitle => 'कवच कैसे उपयोग करें';

  @override
  String get howToUseBody =>
      'होम — खेत का अवलोकन, निवारक और अलर्ट।\nलाइव — कैमरे देखें, फ़ोटो लें, रिकॉर्ड करें।\nअलर्ट — पहचान देखें और मैन्युअल अलार्म खोलें।\nप्रोफ़ाइल — आपके खेत का विवरण और सेटिंग्स।';

  @override
  String get chatSupport => 'सहायता से चैट करें';

  @override
  String get supportChatTitle => 'सहायता चैट';

  @override
  String get supportChatBody =>
      'ईमेल help@kavach.app\n\nइस डेमो में आपका संदेश स्थानीय रूप से सहेजा जाता है। भविष्य में वास्तविक चैट खुलेगा।';

  @override
  String get sendMessage => 'संदेश भेजें';

  @override
  String get supportMessageSent => 'सहायता संदेश भेजा गया';

  @override
  String get callHelpline => 'हेल्पलाइन कॉल करें';

  @override
  String get callHelplineBody =>
      'हेल्पलाइन: 1800-123-4567\nसमय: सुबह 8 – शाम 8\n\nयह डेमो वास्तविक कॉल नहीं कर सकता।';

  @override
  String get copyNumber => 'नंबर कॉपी करें';

  @override
  String get sectionAbout => 'के बारे में';

  @override
  String get versionFarmProtection => 'संस्करण 6.0.0 · खेत सुरक्षा';

  @override
  String get privacy => 'गोपनीयता';

  @override
  String get privacyBody =>
      'कवच आपके प्रोफ़ाइल और सेटिंग्स इस डिवाइस पर रखता है। इस डेमो में कैमरा और अलर्ट नमूना डेटा हैं। हम आपकी खेत जानकारी नहीं बेचते।';

  @override
  String get termsOfUse => 'उपयोग की शर्तें';

  @override
  String get termsBody =>
      'निवारकों का सावधानी से उपयोग करें। लेज़र और पानी स्प्रे सक्रिय होने पर लोगों और पालतू जानवरों को दूर रखें। सुरक्षित उपयोग की ज़िम्मेदारी आपकी है। कवच प्रदर्शन के लिए एक प्रोटोटाइप है।';

  @override
  String get signOut => 'साइन आउट';

  @override
  String get signOutConfirm => 'साइन आउट करें?';

  @override
  String get signOutBody => 'आप लॉगिन स्क्रीन पर वापस जाएँगे।';

  @override
  String get flashOn => 'फ़्लैश चालू';

  @override
  String get flashOff => 'फ़्लैश बंद';

  @override
  String get flashTurnedOn => 'फ़्लैश चालू किया गया';

  @override
  String get flashTurnedOff => 'फ़्लैश बंद किया गया';

  @override
  String get record => 'रिकॉर्ड';

  @override
  String get stopRecording => 'रिकॉर्डिंग रोकें';

  @override
  String get recordingStarted => 'रिकॉर्डिंग शुरू';

  @override
  String get recordingStopped => 'रिकॉर्डिंग रुकी · क्लिप सहेजी गई';

  @override
  String get openActivateHint =>
      'सुरक्षित रूप से भगाने के लिए सक्रिय करें खोलें।';

  @override
  String get goToActivate => 'सक्रिय करें पर जाएँ';

  @override
  String confidenceLabel(String value) {
    return 'विश्वास: $value';
  }

  @override
  String get nothingActive =>
      'कुछ सक्रिय नहीं। कुछ चालू करने के लिए सक्रिय करें उपयोग करें।';

  @override
  String get switchCam => 'कैमरा बदलें';

  @override
  String switchedCamera(int index) {
    return 'कैमरा $index पर स्विच किया';
  }

  @override
  String zoomLabel(String value) {
    return 'ज़ूम ${value}x';
  }

  @override
  String get snapshot => 'स्नैपशॉट';

  @override
  String photoSaved(int count) {
    return 'फ़ोटो सहेजी गई · #$count';
  }

  @override
  String get alarmLevelsHint =>
      'तीन अलार्म स्तर। चालू करने के लिए स्तर दबाकर रखें।';

  @override
  String get levelSoftWarning => 'स्तर 1 · हल्का चेतावनी';

  @override
  String get levelActiveAlert => 'स्तर 2 · सक्रिय अलर्ट';

  @override
  String get levelCritical => 'स्तर 3 · गंभीर';

  @override
  String alarmActiveStatus(int level, String name, int seconds) {
    return 'स्तर $level · $name चालू · $secondsसे शेष';
  }

  @override
  String get stop => 'रोकें';

  @override
  String stoppedNamed(String name) {
    return '$name रोका गया';
  }

  @override
  String stopFirst(String name) {
    return 'पहले $name रोकें';
  }

  @override
  String levelActivated(int level, String name) {
    return 'स्तर $level · $name 15 सेकंड के लिए चालू';
  }

  @override
  String holdToActivate(int level) {
    return 'स्तर $level सक्रिय करने के लिए दबाए रखें';
  }

  @override
  String get releaseToCancel => 'रद्द करने के लिए छोड़ें';

  @override
  String get keepPeopleAway => 'यह सक्रिय होने पर लोगों को दूर रखें।';

  @override
  String alreadyOn(String name) {
    return '$name पहले से चालू है';
  }

  @override
  String statusChanged(String name, String status) {
    return '$name → $status';
  }

  @override
  String get statusOn => 'चालू';

  @override
  String get statusOff => 'बंद';

  @override
  String get statusReady => 'तैयार';

  @override
  String get statusFault => 'दोष';

  @override
  String get chooseLanguageTitle => 'अपनी भाषा चुनें';

  @override
  String get chooseLanguageBody =>
      'कवच में उपयोग करने के लिए भाषा चुनें। आप बाद में प्रोफ़ाइल से बदल सकते हैं।';

  @override
  String get continueLabel => 'जारी रखें';

  @override
  String get equipLaser => 'लेज़र';

  @override
  String get equipSpeaker => 'स्पीकर';

  @override
  String get equipWater => 'पानी';

  @override
  String get equipWaterFull => 'पानी स्प्रिंकलर';

  @override
  String get equipLaserDesc => 'रोशनी से जानवरों को डराता है';

  @override
  String get equipSpeakerDesc => 'उन्हें भगाने के लिए तेज़ आवाज़ बजाता है';

  @override
  String get equipWaterDesc => 'तेज़ पानी का छिड़काव करता है';

  @override
  String get animalCow => 'गाय';

  @override
  String get animalBuffalo => 'भैंस';

  @override
  String get animalGoat => 'बकरी';

  @override
  String get animalWildPig => 'जंगली सुअर';

  @override
  String get confidenceVerySure => 'बहुत निश्चित';

  @override
  String get alertWaterLow => 'पानी की टंकी कम हो रही है';

  @override
  String get alertCameraOffline => 'कैमरा 2 ऑफ़लाइन है';

  @override
  String get alertBatteryOk => 'बैटरी अच्छी तरह चार्ज हो रही है (87%)';

  @override
  String get alertSpeakerCheck => 'स्पीकर की जाँच आवश्यक है';

  @override
  String get errInvalidPhone => 'वैध 10 अंकों का फ़ोन नंबर दर्ज करें';

  @override
  String get errPasswordShort => 'पासवर्ड कम से कम 4 अक्षर का होना चाहिए';

  @override
  String get errWrongPhonePassword => 'फ़ोन या पासवर्ड गलत है';

  @override
  String get errInvalidUsername => 'वैध उपयोगकर्ता नाम दर्ज करें';

  @override
  String get errWrongUsernamePassword => 'उपयोगकर्ता नाम या पासवर्ड गलत है';

  @override
  String get errEnterName => 'अपना नाम दर्ज करें';

  @override
  String get errPhoneRegistered => 'यह फ़ोन पहले से पंजीकृत है';

  @override
  String get errUsernameShort =>
      'उपयोगकर्ता नाम कम से कम 3 अक्षर का होना चाहिए';

  @override
  String get errUsernameTaken => 'यह उपयोगकर्ता नाम पहले से लिया जा चुका है';
}
