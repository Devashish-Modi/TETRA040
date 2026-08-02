// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Gujarati (`gu`).
class AppLocalizationsGu extends AppLocalizations {
  AppLocalizationsGu([String locale = 'gu']) : super(locale);

  @override
  String get appName => 'કવચ';

  @override
  String get farmProtectionSystem => 'ખેતર સુરક્ષા સિસ્ટમ';

  @override
  String get navHome => 'હોમ';

  @override
  String get navLive => 'લાઇવ';

  @override
  String get navAlerts => 'અલર્ટ';

  @override
  String get navProfile => 'પ્રોફાઇલ';

  @override
  String hiGreeting(String greeting) {
    return 'નમસ્તે, $greeting';
  }

  @override
  String get goodMorning => 'સુપ્રભાત';

  @override
  String get goodAfternoon => 'નમસ્કાર';

  @override
  String get goodEvening => 'શુભ સાંજ';

  @override
  String get farmLocation => 'ગ્રીન વેલી ફાર્મ';

  @override
  String get animalsToday => 'આજના પ્રાણીઓ';

  @override
  String get detections => 'શોધ';

  @override
  String get detectedAroundFarm => 'આજે તમારા ખેતર આસપાસ શોધાયા';

  @override
  String get byAnimalType => 'પ્રાણી પ્રકાર પ્રમાણે';

  @override
  String get cameras => 'કૅમેરા';

  @override
  String onlineCount(int online, int total) {
    return '$online/$total ઓનલાઇન';
  }

  @override
  String get allOnline => 'બધા ઓનલાઇન';

  @override
  String get needsCheck => 'તપાસ જરૂરી';

  @override
  String get openLive => 'લાઇવ ખોલો';

  @override
  String get deterrents => 'નિવારકો';

  @override
  String get alerts => 'અલર્ટ';

  @override
  String get clear => 'સાફ કરો';

  @override
  String get noAlerts => 'કોઈ અલર્ટ નથી — ખેતર સુરક્ષિત છે.';

  @override
  String get alertDismissed => 'અલર્ટ દૂર કર્યો';

  @override
  String get allAlertsCleared => 'બધા અલર્ટ સાફ થયા';

  @override
  String get aiStatus => 'AI સ્થિતિ';

  @override
  String get aiScanning => 'શોધ સક્રિય';

  @override
  String get aiReady => 'મોડલ તૈયાર · ખેતરની દેખરેખ';

  @override
  String get aiConfidence => 'વિશ્વાસ';

  @override
  String get language => 'ભાષા';

  @override
  String get languageSettings => 'ભાષા સેટિંગ્સ';

  @override
  String currentLanguage(String name) {
    return 'વર્તમાન ભાષા: $name';
  }

  @override
  String get english => 'English';

  @override
  String get hindi => 'हिन्दी';

  @override
  String get gujarati => 'ગુજરાતી';

  @override
  String get profileSettings => 'પ્રોફાઇલ અને સેટિંગ્સ';

  @override
  String get liveFeed => 'લાઇવ ફીડ';

  @override
  String liveFeedCamera(int index) {
    return 'લાઇવ ફીડ · કૅમેરા $index';
  }

  @override
  String get alertsTitle => 'અલર્ટ';

  @override
  String get alertsSubtitle => 'AI શોધ અને સાધન અલર્ટ';

  @override
  String get welcomeTitle => 'કવચમાં\nઆપનું સ્વાગત છે';

  @override
  String get welcomeBody =>
      'પ્રાણીઓ વહેલા જુઓ, લેસર, સ્પીકર અથવા પાણી ચલાવો — પાક સુરક્ષિત રાખો.';

  @override
  String get getStarted => 'શરૂ કરો';

  @override
  String get continueAsGuest => 'અતિથિ તરીકે ચાલુ રાખો';

  @override
  String get signIn => 'સાઇન ઇન';

  @override
  String get joinKavach => 'કવચમાં જોડાઓ';

  @override
  String get welcomeBack => 'પાછા આવવા પર સ્વાગત';

  @override
  String get createAccount => 'એકાઉન્ટ બનાવો';

  @override
  String get login => 'લૉગિન';

  @override
  String get phone => 'ફોન';

  @override
  String get username => 'વપરાશકર્તા નામ';

  @override
  String get password => 'પાસવર્ડ';

  @override
  String get alreadyHaveAccount => 'પહેલેથી એકાઉન્ટ છે? લૉગિન';

  @override
  String get newHere => 'નવા છો? એકાઉન્ટ બનાવો';

  @override
  String get manualAlarm => 'મેન્યુઅલ અલાર્મ';

  @override
  String get viewAllAlerts => 'બધા જુઓ';

  @override
  String get setupFarmLogin => 'એક મિનિટમાં તમારું ખેતર લૉગિન સેટ કરો.';

  @override
  String get loginWithPhoneOrUsername => 'ફોન અથવા વપરાશકર્તા નામથી લૉગિન કરો.';

  @override
  String get yourName => 'તમારું નામ';

  @override
  String get farmerNameHint => 'ખેડૂતનું નામ';

  @override
  String get phoneNumber => 'ફોન નંબર';

  @override
  String get tenDigitMobile => '10 અંકનો મોબાઇલ';

  @override
  String get yourUsername => 'તમારું વપરાશકર્તા નામ';

  @override
  String get enterPassword => 'પાસવર્ડ દાખલ કરો';

  @override
  String get demoLogin =>
      'ડેમો લૉગિન\nફોન · 9876543210 · farm1234\nવપરાશકર્તા · ramesh · farm1234';

  @override
  String welcomeUser(String name) {
    return 'સ્વાગત છે, $name';
  }

  @override
  String get signedInAsGuest => 'અતિથિ તરીકે સાઇન ઇન';

  @override
  String get notSignedIn => 'સાઇન ઇન નથી';

  @override
  String get guestMode => 'અતિથિ મોડ';

  @override
  String get sectionYourDetails => 'તમારી વિગતો';

  @override
  String get farmName => 'ખેતરનું નામ';

  @override
  String get villageArea => 'ગામ / વિસ્તાર';

  @override
  String get yourPhone => 'તમારો ફોન';

  @override
  String get saveProfile => 'પ્રોફાઇલ સાચવો';

  @override
  String get profileSaved => 'પ્રોફાઇલ સાચવાઈ';

  @override
  String get enterYourName => 'તમારું નામ દાખલ કરો';

  @override
  String get enterFarmName => 'ખેતરનું નામ દાખલ કરો';

  @override
  String get enterValidPhone => 'માન્ય ફોન નંબર દાખલ કરો';

  @override
  String get sectionEmergency => 'કટોકટી સંપર્ક';

  @override
  String get emergencyHelp =>
      'પ્રાણી ઘૂસે અથવા સાધન નિષ્ફળ થાય ત્યારે અમે જેને કૉલ કરી શકીએ.';

  @override
  String get emergencyPhone => 'કટોકટી ફોન';

  @override
  String get saveEmergency => 'કટોકટી સંપર્ક સાચવો';

  @override
  String get emergencySaved => 'કટોકટી સંપર્ક સાચવ્યો';

  @override
  String get enterValidEmergency => 'માન્ય કટોકટી ફોન દાખલ કરો';

  @override
  String get sectionDevices => 'જોડાયેલા ઉપકરણો';

  @override
  String get tapDeviceToggle => 'ઓનલાઇન / ઑફલાઇન બદલવા માટે ટૅપ કરો';

  @override
  String get online => 'ઓનલાઇન';

  @override
  String get offline => 'ઑફલાઇન';

  @override
  String deviceNowStatus(String name, String status) {
    return '$name હવે $status છે';
  }

  @override
  String get sectionAlertsSounds => 'અલર્ટ અને અવાજ';

  @override
  String get pushAlerts => 'પુશ અલર્ટ';

  @override
  String get pushAlertsSub => 'ફોન પર અલર્ટ બતાવો';

  @override
  String get alertSounds => 'અલર્ટ અવાજ';

  @override
  String get alertSoundsSub => 'પ્રાણી દેખાય ત્યારે અવાજ વગાડો';

  @override
  String get vibration => 'કંપન';

  @override
  String get vibrationSub => 'અલર્ટ પર ફોન કંપે';

  @override
  String get equipmentOfflineAlerts => 'સાધન ઑફલાઇન અલર્ટ';

  @override
  String get equipmentOfflineSub => 'કૅમેરા અથવા સ્પીકર બંધ થાય તો કહો';

  @override
  String get dailySummary => 'દૈનિક સારાંશ';

  @override
  String get dailySummarySub => 'દર સાંજે એક સંદેશ';

  @override
  String get sectionDetection => 'શોધ સેટિંગ્સ';

  @override
  String get detectionSensitivity => 'શોધ સંવેદનશીલતા';

  @override
  String get sensitivityHint => 'વધુ = વધુ અલર્ટ. ઓછું = ઓછા અલર્ટ.';

  @override
  String get autoActivate => 'નિવારકો આપમેળે ચાલુ કરો';

  @override
  String get autoActivateSub => 'લેસર / સ્પીકર / પાણી આપમેળે ચાલુ કરો';

  @override
  String get nightWatch => 'રાત્રે વધુ દેખરેખ';

  @override
  String get nightWatchSub => 'અંધારા પછી વધારાની સાવધાની';

  @override
  String get sectionPreferences => 'એપ પસંદગીઓ';

  @override
  String get units => 'એકમો';

  @override
  String get metric => 'મેટ્રિક';

  @override
  String get imperial => 'ઇમ્પીરિયલ';

  @override
  String get metricHint => 'મી, °સે';

  @override
  String get imperialHint => 'ફૂટ, °ફ';

  @override
  String get sectionHelp => 'મદદ અને સપોર્ટ';

  @override
  String get howToUse => 'એપ કેવી રીતે વાપરવી';

  @override
  String get howToUseSub => 'દરેક સ્ક્રીનની સરળ માર્ગદર્શિકા';

  @override
  String get howToUseTitle => 'કવચ કેવી રીતે વાપરવું';

  @override
  String get howToUseBody =>
      'હોમ — ખેતરનું અવલોકન, નિવારકો અને અલર્ટ.\nલાઇવ — કૅમેરા જુઓ, ફોટો લો, રેકોર્ડ કરો.\nઅલર્ટ — શોધ જુઓ અને મેન્યુઅલ અલાર્મ ખોલો.\nપ્રોફાઇલ — તમારા ખેતરની વિગતો અને સેટિંગ્સ.';

  @override
  String get chatSupport => 'સપોર્ટ સાથે ચેટ કરો';

  @override
  String get supportChatTitle => 'સપોર્ટ ચેટ';

  @override
  String get supportChatBody =>
      'ઈમેલ help@kavach.app\n\nઆ ડેમોમાં તમારો સંદેશ સ્થાનિક રીતે સાચવાય છે. ભવિષ્યમાં વાસ્તવિક ચેટ ખુલશે.';

  @override
  String get sendMessage => 'સંદેશ મોકલો';

  @override
  String get supportMessageSent => 'સપોર્ટ સંદેશ મોકલાયો';

  @override
  String get callHelpline => 'હેલ્પલાઇન કૉલ કરો';

  @override
  String get callHelplineBody =>
      'હેલ્પલાઇન: 1800-123-4567\nસમય: સવારે 8 – સાંજે 8\n\nઆ ડેમો વાસ્તવિક કૉલ કરી શકતો નથી.';

  @override
  String get copyNumber => 'નંબર કૉપિ કરો';

  @override
  String get sectionAbout => 'વિશે';

  @override
  String get versionFarmProtection => 'સંસ્કરણ 6.0.0 · ખેતર સુરક્ષા';

  @override
  String get privacy => 'ગોપનીયતા';

  @override
  String get privacyBody =>
      'કવચ તમારી પ્રોફાઇલ અને સેટિંગ્સ આ ડિવાઇસ પર રાખે છે. આ ડેમોમાં કૅમેરા અને અલર્ટ નમૂના ડેટા છે. અમે તમારી ખેતર માહિતી વેચતા નથી.';

  @override
  String get termsOfUse => 'ઉપયોગની શરતો';

  @override
  String get termsBody =>
      'નિવારકોનો કાળજીપૂર્વક ઉપયોગ કરો. લેસર અને પાણી સ્પ્રે સક્રિય હોય ત્યારે લોકો અને પાલતુ પ્રાણીઓને દૂર રાખો. સુરક્ષિત ઉપયોગની જવાબદારી તમારી છે. કવચ પ્રદર્શન માટેનું પ્રોટોટાઇપ છે.';

  @override
  String get signOut => 'સાઇન આઉટ';

  @override
  String get signOutConfirm => 'સાઇન આઉટ કરો?';

  @override
  String get signOutBody => 'તમે લૉગિન સ્ક્રીન પર પાછા જશો.';

  @override
  String get flashOn => 'ફ્લેશ ચાલુ';

  @override
  String get flashOff => 'ફ્લેશ બંધ';

  @override
  String get flashTurnedOn => 'ફ્લેશ ચાલુ કર્યું';

  @override
  String get flashTurnedOff => 'ફ્લેશ બંધ કર્યું';

  @override
  String get record => 'રેકોર્ડ';

  @override
  String get stopRecording => 'રેકોર્ડિંગ રોકો';

  @override
  String get recordingStarted => 'રેકોર્ડિંગ શરૂ';

  @override
  String get recordingStopped => 'રેકોર્ડિંગ અટક્યું · ક્લિપ સાચવાઈ';

  @override
  String get openActivateHint => 'સુરક્ષિત રીતે હટાવવા માટે સક્રિય કરો ખોલો.';

  @override
  String get goToActivate => 'સક્રિય કરો પર જાઓ';

  @override
  String confidenceLabel(String value) {
    return 'વિશ્વાસ: $value';
  }

  @override
  String get nothingActive =>
      'કંઈ સક્રિય નથી. કંઈક ચાલુ કરવા સક્રિય કરો વાપરો.';

  @override
  String get switchCam => 'કૅમેરા બદલો';

  @override
  String switchedCamera(int index) {
    return 'કૅમેરા $index પર સ્વિચ થયું';
  }

  @override
  String zoomLabel(String value) {
    return 'ઝૂમ ${value}x';
  }

  @override
  String get snapshot => 'સ્નેપશોટ';

  @override
  String photoSaved(int count) {
    return 'ફોટો સાચવાયો · #$count';
  }

  @override
  String get alarmLevelsHint => 'ત્રણ અલાર્મ સ્તર. ચાલુ કરવા સ્તર દબાવી રાખો.';

  @override
  String get levelSoftWarning => 'સ્તર 1 · હળવી ચેતવણી';

  @override
  String get levelActiveAlert => 'સ્તર 2 · સક્રિય અલર્ટ';

  @override
  String get levelCritical => 'સ્તર 3 · ગંભીર';

  @override
  String alarmActiveStatus(int level, String name, int seconds) {
    return 'સ્તર $level · $name ચાલુ · $secondsસે બાકી';
  }

  @override
  String get stop => 'રોકો';

  @override
  String stoppedNamed(String name) {
    return '$name રોક્યું';
  }

  @override
  String stopFirst(String name) {
    return 'પહેલા $name રોકો';
  }

  @override
  String levelActivated(int level, String name) {
    return 'સ્તર $level · $name 15 સેકન્ડ માટે ચાલુ';
  }

  @override
  String holdToActivate(int level) {
    return 'સ્તર $level સક્રિય કરવા દબાવી રાખો';
  }

  @override
  String get releaseToCancel => 'રદ કરવા છોડો';

  @override
  String get keepPeopleAway => 'આ સક્રિય હોય ત્યારે લોકોને દૂર રાખો.';

  @override
  String alreadyOn(String name) {
    return '$name પહેલેથી ચાલુ છે';
  }

  @override
  String statusChanged(String name, String status) {
    return '$name → $status';
  }

  @override
  String get statusOn => 'ચાલુ';

  @override
  String get statusOff => 'બંધ';

  @override
  String get statusReady => 'તૈયાર';

  @override
  String get statusFault => 'ખામી';

  @override
  String get chooseLanguageTitle => 'તમારી ભાષા પસંદ કરો';

  @override
  String get chooseLanguageBody =>
      'કવચમાં વાપરવા માટે ભાષા પસંદ કરો. તમે પછીથી પ્રોફાઇલમાં બદલી શકો છો.';

  @override
  String get continueLabel => 'ચાલુ રાખો';

  @override
  String get equipLaser => 'લેસર';

  @override
  String get equipSpeaker => 'સ્પીકર';

  @override
  String get equipWater => 'પાણી';

  @override
  String get equipWaterFull => 'પાણી સ્પ્રિંકલર';

  @override
  String get equipLaserDesc => 'પ્રકાશથી પ્રાણીઓને ડરાવે છે';

  @override
  String get equipSpeakerDesc => 'દૂર કરવા માટે મોટો અવાજ વગાડે છે';

  @override
  String get equipWaterDesc => 'મજબૂત પાણીનો છંટકાવ કરે છે';

  @override
  String get animalCow => 'ગાય';

  @override
  String get animalBuffalo => 'ભેંસ';

  @override
  String get animalGoat => 'બકરી';

  @override
  String get animalWildPig => 'જંગલી ડુક્કર';

  @override
  String get confidenceVerySure => 'ખૂબ ચોક્કસ';

  @override
  String get alertWaterLow => 'પાણીની ટાંકી ઓછી થઈ રહી છે';

  @override
  String get alertCameraOffline => 'કૅમેરા 2 ઑફલાઇન છે';

  @override
  String get alertBatteryOk => 'બેટરી સારી રીતે ચાર્જ થઈ રહી છે (87%)';

  @override
  String get alertSpeakerCheck => 'સ્પીકરની તપાસ જરૂરી છે';

  @override
  String get errInvalidPhone => 'માન્ય 10 અંકનો ફોન નંબર દાખલ કરો';

  @override
  String get errPasswordShort => 'પાસવર્ડ ઓછામાં ઓછા 4 અક્ષરનો હોવો જોઈએ';

  @override
  String get errWrongPhonePassword => 'ફોન અથવા પાસવર્ડ ખોટો છે';

  @override
  String get errInvalidUsername => 'માન્ય વપરાશકર્તા નામ દાખલ કરો';

  @override
  String get errWrongUsernamePassword => 'વપરાશકર્તા નામ અથવા પાસવર્ડ ખોટો છે';

  @override
  String get errEnterName => 'તમારું નામ દાખલ કરો';

  @override
  String get errPhoneRegistered => 'આ ફોન પહેલેથી નોંધાયેલો છે';

  @override
  String get errUsernameShort =>
      'વપરાશકર્તા નામ ઓછામાં ઓછા 3 અક્ષરનું હોવું જોઈએ';

  @override
  String get errUsernameTaken => 'આ વપરાશકર્તા નામ પહેલેથી લેવાયેલું છે';
}
