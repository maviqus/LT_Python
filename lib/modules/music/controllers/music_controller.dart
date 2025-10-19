import 'package:get/get.dart';
import 'package:sleep_music/models/music.dart';
import 'package:sleep_music/repositories/music_repository.dart';

class MusicController extends GetxController {
  MusicController({MusicRepository? repository})
    : _repository = repository ?? MusicRepository();

  final MusicRepository _repository;

  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final RxList<String> categories = <String>[].obs;
  final RxList<Music> items = <Music>[].obs;

  Future<void> load() async {
    try {
      isLoading.value = true;
      error.value = '';

      final all = await _repository.loadAll();
      items.assignAll(all);

      if (all.isEmpty) {
        error.value = 'No music items could be loaded from Firestore';
      }
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMusicByCategory(String category) async {
    try {
      isLoading.value = true;
      error.value = '';

      final musicList = await _repository.loadByCategory(category);
      items.assignAll(musicList);

      if (musicList.isEmpty) {
        error.value = 'No music found in category: $category';
      }
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMusicFromPath(String category, String musicId) async {
    try {
      isLoading.value = true;
      error.value = '';

      final music = await _repository.loadFromPath(category, musicId);
      if (music != null) {
        final existingIndex = items.indexWhere((item) => item.id == music.id);
        if (existingIndex == -1) {
          items.add(music);
        } else {
          items[existingIndex] = music;
        }
      } else {
        error.value =
            'Music not found at path: /categories/$category/music/$musicId';
      }
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<Music?> getMusicById(String category, String musicId) async {
    return await _repository.loadByIdFromCategory(category, musicId);
  }

  Future<List<Music>> getMusicByCategory(String category) async {
    return await _repository.loadByCategory(category);
  }
}
