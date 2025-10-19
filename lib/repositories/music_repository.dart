import 'package:sleep_music/models/music.dart';
import 'package:sleep_music/repositories/api/firebase_backend.dart';

/// Music Repository

class MusicRepository {
  MusicRepository({FirebaseBackend? backend})
    : _backend = backend ?? FirebaseBackend();

  final FirebaseBackend _backend;

  Future<List<String>> listCategories() async {
    return await _backend.getCategories();
  }

  Future<Music?> loadByIdFromCategory(String category, String musicId) =>
      _backend.getMusicById(category, musicId);

  Future<List<Music>> loadByCategory(String category) =>
      _backend.getMusicByCategory(category);

  Future<List<Music>> loadAll() => _backend.getAllMusic();

  Future<Music?> loadFromPath(String category, String musicId) =>
      loadByIdFromCategory(category, musicId);
}
