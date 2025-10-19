import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sleep_music/models/music.dart';

class FirebaseBackend {
  static final FirebaseBackend _instance = FirebaseBackend._internal();
  factory FirebaseBackend() => _instance;
  FirebaseBackend._internal();

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId:
        '684753848387-gv6eh7kvuv6s21esc8397iqi25c6748i.apps.googleusercontent.com',
    scopes: ['email', 'profile'],
  );
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<String>> getCategories() async {
    try {
      final snapshot = await _firestore.collection('categories').get();
      return snapshot.docs.map((doc) => doc.id).toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<Music>> getAllMusic() async {
    try {
      final List<Music> allMusic = [];
      final categoriesSnapshot = await _firestore
          .collection('categories')
          .get();

      for (final categoryDoc in categoriesSnapshot.docs) {
        final categoryName = categoryDoc.id;
        final musicSnapshot = await _firestore
            .collection('categories')
            .doc(categoryName)
            .collection('music')
            .get();

        for (final musicDoc in musicSnapshot.docs) {
          final music = Music.fromFirestore(
            musicDoc.id,
            musicDoc.data(),
            category: categoryName,
          );
          allMusic.add(music);
        }
      }

      return allMusic;
    } catch (e) {
      return [];
    }
  }
  

  Future<Music?> getMusicById(String category, String musicId) async {
    try {
      final doc = await _firestore
          .collection('categories')
          .doc(category)
          .collection('music')
          .doc(musicId)
          .get();

      if (!doc.exists || doc.data() == null) {
        return null;
      }

      return Music.fromFirestore(doc.id, doc.data()!, category: category);
    } catch (e) {
      return null;
    }
  }

  Future<List<Music>> getMusicByCategory(String category) async {
    try {
      final snapshot = await _firestore
          .collection('categories')
          .doc(category)
          .collection('music')
          .get();

      return snapshot.docs.map((doc) {
        return Music.fromFirestore(doc.id, doc.data(), category: category);
      }).toList();
    } catch (e) {
      return [];
    }
  }

  // Authentication methods

  /// Login with Google
  Future<User?> loginWithGoogle() async {
    try {
      final GoogleSignInAccount? silentUser = await _googleSignIn
          .signInSilently();
      GoogleSignInAccount? googleUser = silentUser;

      if (googleUser == null) {
        googleUser = await _googleSignIn.signIn();
        if (googleUser == null) {
          return null;
        }
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      if (googleAuth.accessToken == null || googleAuth.idToken == null) {
        return null;
      }

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );
      return userCredential.user;
    } catch (e) {
      return null;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }
}
