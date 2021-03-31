import 'package:flutter/services.dart';

class ConstString {
  ///* Internal Storage platform android
  static const String internalPathStorageAndroid = '/storage/emulated/0/';
  static const String excludePathFile = '/android/data/';

  ///* Sorting Choice
  static const String sortChoiceByTitle = 'title';
  static const String sortChoiceByArtist = 'artist';
  static const String sortChoiceByDuration = 'duration';

  ///* PopuMenuButton Value
  static const String syncSongPMB = 'sync';
  static const String sortSongPMB = 'sort';
  static const String timerPMB = 'timer';
  static const String editSongPMB = 'edit';

  ///* LoopMode Value
  static const String loopModeAll = 'all';
  static const String loopModelSingle = 'single';
  static const String loopModelNone = 'none';

  ///* Ascending & Descending Value
  static const int ascendingValue = 0;
  static const int descendingValue = 1;

  ///* Onboarding Value
  static const bool finishedOnboarding = true;
  static const bool notFinishedOnboarding = false;

  ///* Shuffle Value
  static const bool useShuffle = true;
  static const bool notUseShuffle = false;

  ///* First Load Value
  static const bool isFirstLoad = true;
  static const bool isNotFirstLoad = false;

  ///* ID AssetAudioPlayer
  static const String idAssetAudioPlayer = 'zeffry.ganteng';

  ///* Method Channel
  static const androidMinimizeChannel = MethodChannel('channel_minimize');
  static const androidMinimizeFunction = 'minimize_app';

  ///? Setting Screen
  ///* Word [Give Rating]
  static const giveRating = 'Berikan Rating';

  static const urlFacebook = 'https://www.facebook.com/zeffry.reynando/';
  static const urlGithub = 'https://github.com/zgramming';
  static const urlGmail = 'zeffry.reynando@gmail.com';
  static const urlLinkedIn = 'https://www.linkedin.com/in/zeffry-reynando/';
  static const urlInstagram = 'https://www.instagram.com/zeffry_reynando/';
  static const subjectEmail = 'Kalmics App';
  static const bodyEmail = 'Hello Zeffry Reynando !';
}
