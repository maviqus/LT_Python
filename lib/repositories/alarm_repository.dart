import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sleep_music/models/alarm_model.dart';

class AlarmRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get _userId => _auth.currentUser?.uid;

  CollectionReference get _alarmCollection =>
      _firestore.collection('users').doc(_userId).collection('alarms');

  Stream<List<AlarmModel>> getActiveAlarms() {
    if (_userId == null) return Stream.value([]);

    return _alarmCollection
        .where('isActive', isEqualTo: true)
        .orderBy('scheduledTime')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map(
                (doc) => AlarmModel.fromJson({
                  'id': doc.id,
                  ...doc.data() as Map<String, dynamic>,
                }),
              )
              .toList();
        });
  }

  Future<void> createAlarm(AlarmModel alarm) async {
    if (_userId == null) return;

    await _alarmCollection.doc(alarm.id).set(alarm.toJson());
  }

  Future<void> updateAlarm(AlarmModel alarm) async {
    if (_userId == null) return;

    await _alarmCollection.doc(alarm.id).update(alarm.toJson());
  }

  Future<void> deleteAlarm(String alarmId) async {
    if (_userId == null) return;

    await _alarmCollection.doc(alarmId).delete();
  }

  Future<void> deactivateAlarm(String alarmId) async {
    if (_userId == null) return;

    await _alarmCollection.doc(alarmId).update({'isActive': false});
  }

  Future<void> deactivateExpiredAlarms() async {
    if (_userId == null) return;

    final now = DateTime.now();
    final expiredAlarms = await _alarmCollection
        .where('isActive', isEqualTo: true)
        .where('scheduledTime', isLessThan: now.millisecondsSinceEpoch)
        .get();

    final batch = _firestore.batch();
    for (final doc in expiredAlarms.docs) {
      batch.update(doc.reference, {'isActive': false});
    }
    await batch.commit();
  }
}
