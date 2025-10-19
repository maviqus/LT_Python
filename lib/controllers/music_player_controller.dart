import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:just_audio/just_audio.dart';
import 'package:sleep_music/models/music.dart';

class MusicPlayerController extends GetxController {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final GetStorage _storage = GetStorage();

  static const String _keyCurrentMusic = 'current_music';
  static const String _keyIsPlayerVisible = 'is_player_visible';
  static const String _keyTitle = 'title';
  static const String _keyArtist = 'artist';
  static const String _keyCoverUrl = 'cover_url';
  static const String _keyPlaylist = 'playlist';
  static const String _keyCurrentIndex = 'current_index';

  final Rx<Music?> currentMusic = Rx<Music?>(null);
  final RxBool isPlaying = false.obs;
  final RxDouble position = 0.0.obs;
  final RxDouble duration = 0.0.obs;
  final RxBool isPlayerVisible = false.obs;

  final RxString cachedTitle = ''.obs;
  final RxString cachedArtist = ''.obs;
  final RxString cachedCoverUrl = ''.obs;

  final RxList<Music> playlist = <Music>[].obs;
  final RxInt currentIndex = 0.obs;

  String? _currentAudioUrl;

  @override
  void onInit() {
    super.onInit();
    _setupAudioPlayer();
    _loadState();
  }

  @override
  void onClose() {
    _saveState();
    _audioPlayer.dispose();
    super.onClose();
  }

  void _setupAudioPlayer() {
    _audioPlayer.playerStateStream.listen((state) {
      isPlaying.value = state.playing;

      // Auto-play
      if (state.processingState == ProcessingState.completed) {
        _autoPlayNext();
      }
    });

    _audioPlayer.positionStream.listen((pos) {
      position.value = pos.inSeconds.toDouble();
    });

    _audioPlayer.durationStream.listen((dur) {
      if (dur != null) {
        duration.value = dur.inSeconds.toDouble();
      }
    });
  }

  void _loadState() {
    try {
      isPlayerVisible.value = _storage.read(_keyIsPlayerVisible) ?? false;
      cachedTitle.value = _storage.read(_keyTitle) ?? '';
      cachedArtist.value = _storage.read(_keyArtist) ?? '';
      cachedCoverUrl.value = _storage.read(_keyCoverUrl) ?? '';
      currentIndex.value = _storage.read(_keyCurrentIndex) ?? 0;

      final playlistData = _storage.read(_keyPlaylist);
      if (playlistData != null && playlistData is List) {
        try {
          final musicList = playlistData
              .map((item) => Music.fromJson(Map<String, dynamic>.from(item)))
              .toList();
          playlist.assignAll(musicList);
        } catch (e) {
          playlist.clear();
        }
      }

      final musicData = _storage.read(_keyCurrentMusic);
      if (musicData != null) {
        currentMusic.value = Music.fromJson(musicData);
        if (isPlayerVisible.value && currentMusic.value != null) {
          _prepareAudio(currentMusic.value!.audioUrl ?? '');
        }
      }
    } catch (e) {
      _clearState();
    }
  }

  void _saveState() {
    try {
      _storage.write(_keyIsPlayerVisible, isPlayerVisible.value);
      _storage.write(_keyTitle, displayTitle);
      _storage.write(_keyArtist, displayArtist);
      _storage.write(_keyCoverUrl, displayCoverUrl);
      _storage.write(_keyCurrentIndex, currentIndex.value);

      if (playlist.isNotEmpty) {
        final playlistJson = playlist.map((music) => music.toJson()).toList();
        _storage.write(_keyPlaylist, playlistJson);
      }

      if (currentMusic.value != null) {
        _storage.write(_keyCurrentMusic, currentMusic.value!.toJson());
      }
    } catch (e) {}
  }

  Future<void> _prepareAudio(String audioUrl) async {
    if (audioUrl.isEmpty) return;
    try {
      await _audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(audioUrl)));
      _currentAudioUrl = audioUrl;
    } catch (e) {}
  }

  void _clearState() {
    _storage.remove(_keyCurrentMusic);
    _storage.remove(_keyIsPlayerVisible);
    _storage.remove(_keyTitle);
    _storage.remove(_keyArtist);
    _storage.remove(_keyCoverUrl);
    _storage.remove(_keyPlaylist);
    _storage.remove(_keyCurrentIndex);

    cachedTitle.value = '';
    cachedArtist.value = '';
    cachedCoverUrl.value = '';
    playlist.clear();
    currentIndex.value = 0;
  }

  Future<void> playMusic(Music music) async {
    try {
      currentMusic.value = music;
      isPlayerVisible.value = true;

      cachedTitle.value = music.title;
      cachedArtist.value = music.artist;
      cachedCoverUrl.value = music.coverUrl ?? '';

      if (playlist.isEmpty || !playlist.any((m) => m.id == music.id)) {
        playlist.clear();
        currentIndex.value = 0;
      } else {
        final musicIndex = playlist.indexWhere((m) => m.id == music.id);
        if (musicIndex >= 0) {
          currentIndex.value = musicIndex;
        }
      }

      _saveState();

      await _loadAndPlay(music.audioUrl ?? '');
    } catch (e) {}
  }

  Future<void> togglePlayPause() async {
    try {
      if (_audioPlayer.playing) {
        await _audioPlayer.pause();
      } else {
        final audioUrl = currentMusic.value?.audioUrl;
        if (audioUrl != null) {
          if (_currentAudioUrl != audioUrl) {
            await _loadAndPlay(audioUrl);
          } else {
            await _audioPlayer.play();
          }
        }
      }
    } catch (e) {}
  }

  Future<void> _loadAndPlay(String audioUrl) async {
    if (audioUrl.isEmpty) return;
    try {
      await _audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(audioUrl)));
      _currentAudioUrl = audioUrl;
      await _audioPlayer.play();
    } catch (e) {}
  }

  String get displayTitle => currentMusic.value?.title ?? cachedTitle.value;
  String get displayArtist => currentMusic.value?.artist ?? cachedArtist.value;
  String get displayCoverUrl =>
      currentMusic.value?.coverUrl ?? cachedCoverUrl.value;
  bool get hasData => displayTitle.isNotEmpty;

  void hide() {
    isPlayerVisible.value = false;
    _saveState();
  }

  void show() {
    isPlayerVisible.value = true;
    _saveState();
  }

  Future<void> seekTo(Duration position) async {
    try {
      await _audioPlayer.seek(position);
    } catch (e) {}
  }

  Future<void> seekToSeconds(double seconds) async {
    final duration = Duration(seconds: seconds.round());
    await seekTo(duration);
  }

  Future<void> playMusicFromPlaylist(List<Music> musicList, int index) async {
    if (musicList.isEmpty || index < 0 || index >= musicList.length) return;

    playlist.assignAll(musicList);
    currentIndex.value = index;

    // Save state immediately when setting up playlist
    _saveState();

    await playMusic(musicList[index]);
  }

  Future<void> playNext() async {
    if (playlist.isEmpty) return;

    int nextIndex = currentIndex.value + 1;
    if (nextIndex >= playlist.length) {
      nextIndex = 0;
    }

    currentIndex.value = nextIndex;
    await playMusic(playlist[nextIndex]);
    _saveState();
  }

  Future<void> playPrevious() async {
    if (playlist.isEmpty) return;

    int prevIndex = currentIndex.value - 1;
    if (prevIndex < 0) {
      prevIndex = playlist.length - 1;
    }

    currentIndex.value = prevIndex;
    await playMusic(playlist[prevIndex]);
    _saveState(); // Save updated index
  }

  void _autoPlayNext() {
    if (playlist.isNotEmpty) {
      playNext();
    }
  }

  bool get hasNext => playlist.length > 1;

  bool get hasPrevious => playlist.length > 1;

  String get playlistInfo {
    if (playlist.isEmpty) return '';
    return '${currentIndex.value + 1} of ${playlist.length}';
  }
}
