import '../models/farm_models.dart';
import 'app_localizations.dart';

extension EquipmentIdL10n on EquipmentId {
  String shortName(AppLocalizations l10n) {
    switch (this) {
      case EquipmentId.laser:
        return l10n.equipLaser;
      case EquipmentId.speaker:
        return l10n.equipSpeaker;
      case EquipmentId.water:
        return l10n.equipWater;
    }
  }

  String fullName(AppLocalizations l10n) {
    switch (this) {
      case EquipmentId.laser:
        return l10n.equipLaser;
      case EquipmentId.speaker:
        return l10n.equipSpeaker;
      case EquipmentId.water:
        return l10n.equipWaterFull;
    }
  }

  String localizedDescription(AppLocalizations l10n) {
    switch (this) {
      case EquipmentId.laser:
        return l10n.equipLaserDesc;
      case EquipmentId.speaker:
        return l10n.equipSpeakerDesc;
      case EquipmentId.water:
        return l10n.equipWaterDesc;
    }
  }
}

extension AnimalTypeL10n on AnimalType {
  String localizedName(AppLocalizations l10n) {
    switch (this) {
      case AnimalType.cow:
        return l10n.animalCow;
      case AnimalType.buffalo:
        return l10n.animalBuffalo;
      case AnimalType.goat:
        return l10n.animalGoat;
      case AnimalType.wildPig:
        return l10n.animalWildPig;
    }
  }
}

String localizeAlertMessage(AppLocalizations l10n, String key) {
  switch (key) {
    case 'alert_water_low':
      return l10n.alertWaterLow;
    case 'alert_camera_offline':
      return l10n.alertCameraOffline;
    case 'alert_battery_ok':
      return l10n.alertBatteryOk;
    case 'alert_speaker_check':
      return l10n.alertSpeakerCheck;
    default:
      return key;
  }
}

String localizeAnimalChartKey(AppLocalizations l10n, String key) {
  switch (key) {
    case 'cow':
      return l10n.animalCow;
    case 'buffalo':
      return l10n.animalBuffalo;
    case 'goat':
      return l10n.animalGoat;
    case 'wild_pig':
      return l10n.animalWildPig;
    default:
      return key;
  }
}
