import 'package:flutter/services.dart';

class ConstString {
  ///* Name Application
  static const String applicationName = 'Kalmics';

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

  ///* Word
  static const giveRating = 'Berikan Rating';
  static const copyrightPermission = 'Copyright Icon';
  static const lastSongPlayed = 'LAGU TERAKHIR DIPUTAR';
  static const mostSongPlayed = 'PALING BANYAK DIDENGAR';
  static const accumulateDurationListenSong =
      'Akumulasi durasi lagu yang sudah dimainkan selama ini';
  static const accumulateSongPlayed = 'Akumulasi total lagu yang sudah dimainkan selama ini';

  ///* Url Social Media
  static const urlFacebook = 'https://www.facebook.com/zeffry.reynando/';
  static const urlGithub = 'https://github.com/zgramming';
  static const urlGmail = 'zeffry.reynando@gmail.com';
  static const urlLinkedIn = 'https://www.linkedin.com/in/zeffry-reynando/';
  static const urlInstagram = 'https://www.instagram.com/zeffry_reynando/';
  static const urlIcons8 = 'https://icons8.com';

  ///* Defaul Text When Launch Email with [url_launcher]
  static const subjectEmail = 'Kalmics App';
  static const bodyEmail = 'Hello Zeffry Reynando !';

  ///* Icon Name Image
  static const assetIconGummyIpod = 'gummy-ipod.png';
  static const assetIconErrorSongNotFound = 'error.png';
  static const assetIconIcons8 = 'icons8.png';
  static const assetIconMusic = 'music.png';
  static const assetIconChart = 'chart.png';
  static const assetIconPersonListen = 'person_listen.png';

  ///* Error Text
  static const defaultErrorPlayingSong = 'Tidak dapat memainkan musik';
  static const songNotFoundInDirectory = 'Lagu tidak ditemukan di storage kamu';
  static const menuPopUpButtonNotValid = 'Pilihan tidak valid';
  static const failedRemoveSong = 'Gagal menghapus lagu dari aplikasi';

  ///* Code Error
  static const codeErrorCantOpenSong = 'OPEN';

  ///* Tooltip Message
  static const toolTipShuffle = 'Memutar lagu secara acak';
  static const toolTipPreviousSong = 'Lagu sebelumnya';
  static const toolTipPlayAndPause = 'Memainkan / menghentikan lagu';
  static const toolTipNextSong = 'Lagu berikutnya';
  static const toolTipRepeatNone = 'Tidak ada pengulangan';
  static const toolTipRepeatSingle = 'Pengulangan 1 lagu';
  static const toolTipRepeatAll = 'Pengulangan semua lagu';
  static const toolTipSendSong = 'Kirim lagu kepada temanmu';
  static const toolTipInfoCountPlaySong = 'Informasi berapa banyak pemutaran lagu';
  static const toolTipShowOffSong = 'Pamerkan lagu yang sedang dimainkan';

  ///* Timer Message
  static const messageCancelTimer = 'Timer dibatalkan';
  static const messageTimerIsEqualNow = 'Timer tidak boleh sama dengan waktu sekarang';
  static const messageTimerGo = 'Timer dijalankan';
  static const messageTimerEnd = 'Timer telah berakhir';

  ///* Watcher Message
  static const watcherAddTitleMessage = 'Menambahkan lagu';
  static const watcherRemoveTitleMessage = 'Menghapus lagu';
  static const watcherModifyTitleMessage = 'Mengubah lagu';
}
