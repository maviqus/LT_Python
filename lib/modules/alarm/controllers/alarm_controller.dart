import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sleep_music/models/alarm_model.dart';
import 'package:sleep_music/repositories/alarm_repository.dart';
import 'package:sleep_music/controllers/music_player_controller.dart';

class AlarmController extends GetxController {
  final AlarmRepository _alarmRepository = AlarmRepository();

  // Observables
  final RxList<AlarmModel> activeAlarms = <AlarmModel>[].obs;
  final RxInt selectedHours = 0.obs;
  final RxInt selectedMinutes = 15.obs;
  final RxString selectedMusic = ''.obs;
  final RxBool isLoading = false.obs;
  final RxString currentTimeLeft = ''.obs; // For live countdown display

  Timer? _alarmTimer;
  Timer? _uiUpdateTimer;
  StreamSubscription? _alarmsSubscription;

  // Quick timer presets (in minutes)
  final List<Map<String, dynamic>> quickTimers = [
    {'label': '15 min', 'minutes': 15},
    {'label': '30 min', 'minutes': 30},
    {'label': '1 hour', 'minutes': 60},
    {'label': '2 hours', 'minutes': 120},
    {'label': '3 hours', 'minutes': 180},
  ];

  @override
  void onInit() {
    super.onInit();
    _loadActiveAlarms();
    _startAlarmChecker();
    _startUIUpdateTimer();
  }

  @override
  void onClose() {
    _alarmTimer?.cancel();
    _uiUpdateTimer?.cancel();
    _alarmsSubscription?.cancel();
    super.onClose();
  }

  void _loadActiveAlarms() {
    _alarmsSubscription = _alarmRepository.getActiveAlarms().listen(
      (alarms) {
        activeAlarms.assignAll(alarms);
        _updateCurrentTimeLeft(); // Update countdown when alarms change
      },
      onError: (error) {
        Get.snackbar('Error', 'Failed to load alarms: $error');
      },
    );
  }

  void _startAlarmChecker() {
    _alarmTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _checkAlarms();
    });
  }

  void _startUIUpdateTimer() {
    _uiUpdateTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      // Update countdown display every second
      _updateCurrentTimeLeft();
      update();
    });
  }

  void _updateCurrentTimeLeft() {
    if (activeAlarms.isEmpty) {
      currentTimeLeft.value = '';
      return;
    }

    final nextAlarm = activeAlarms.first;
    final now = DateTime.now();
    final difference = nextAlarm.scheduledTime.difference(now);

    if (difference.isNegative) {
      currentTimeLeft.value = '00:00:00';
    } else {
      final hours = difference.inHours;
      final minutes = (difference.inMinutes % 60);
      final seconds = (difference.inSeconds % 60);
      currentTimeLeft.value =
          '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
  }

  void _checkAlarms() async {
    if (activeAlarms.isEmpty) return;

    final now = DateTime.now();

    for (final alarm in activeAlarms) {
      if (alarm.scheduledTime.isBefore(now) && alarm.isActive) {
        await _triggerAlarm(alarm);
        break;
      }
    }

    try {
      await _alarmRepository.deactivateExpiredAlarms();
    } catch (e) {}
  }

  Future<void> _triggerAlarm(AlarmModel alarm) async {
    try {
      try {
        final musicController = Get.find<MusicPlayerController>();

        if (musicController.isPlaying.value) {
          await musicController.togglePlayPause();
          await Future.delayed(const Duration(milliseconds: 100));

          musicController.isPlaying.value = false;
          musicController.currentMusic.value = null;
          musicController.isPlayerVisible.value = false;

          musicController.playlist.clear();
          musicController.currentIndex.value = 0;
        }
      } catch (e) {}

      await _alarmRepository.deactivateAlarm(alarm.id);

      activeAlarms.removeWhere((a) => a.id == alarm.id);

      Get.snackbar(
        '⏰ Sleep Timer Completed',
        'Music stopped automatically after ${alarm.durationDisplay}',
        duration: const Duration(seconds: 5),
        backgroundColor: Colors.green.withValues(alpha: 0.8),
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        isDismissible: true,
      );
    } catch (e) {
      Get.snackbar(
        'Timer Error',
        'Failed to stop music automatically',
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    }
  }

  void setQuickTimer(int minutes) {
    final now = DateTime.now();
    final scheduledTime = now.add(Duration(minutes: minutes));

    _createAlarm(hours: 0, minutes: minutes, scheduledTime: scheduledTime);
  }

  void setCustomTimer() {
    if (selectedHours.value == 0 && selectedMinutes.value == 0) {
      Get.snackbar('Invalid Timer', 'Please select a valid time');
      return;
    }

    final now = DateTime.now();
    final totalMinutes = (selectedHours.value * 60) + selectedMinutes.value;
    final scheduledTime = now.add(Duration(minutes: totalMinutes));

    _createAlarm(
      hours: selectedHours.value,
      minutes: selectedMinutes.value,
      scheduledTime: scheduledTime,
    );
  }

  Future<void> _createAlarm({
    required int hours,
    required int minutes,
    required DateTime scheduledTime,
  }) async {
    if (isLoading.value) return;

    isLoading.value = true;

    try {
      final alarm = AlarmModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        hours: hours,
        minutes: minutes,
        scheduledTime: scheduledTime,
        selectedMusic: selectedMusic.value.isEmpty ? null : selectedMusic.value,
        isActive: true,
        createdAt: DateTime.now(),
      );

      await _alarmRepository.createAlarm(alarm);

      activeAlarms.add(alarm);

      Get.snackbar(
        'Timer Set',
        'Music will stop in ${alarm.durationDisplay}',
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.green.withValues(alpha: 0.8),
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );

      selectedHours.value = 0;
      selectedMinutes.value = 15;
    } catch (e) {
      Get.snackbar('Error', 'Failed to create alarm');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> cancelAlarm(String alarmId) async {
    try {
      await _alarmRepository.deactivateAlarm(alarmId);
      Get.snackbar(
        'Timer Cancelled',
        'Sleep timer has been cancelled',
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to cancel alarm: $e');
    }
  }

  String get currentAlarmTimeLeft => currentTimeLeft.value;

  Future<void> createTestTimer() async {
    if (isLoading.value) return;

    isLoading.value = true;

    try {
      final now = DateTime.now();
      final scheduledTime = now.add(const Duration(seconds: 5));

      final testAlarm = AlarmModel(
        id: 'test_${DateTime.now().millisecondsSinceEpoch}',
        hours: 0,
        minutes: 0,
        scheduledTime: scheduledTime,
        selectedMusic: null,
        isActive: true,
        createdAt: now,
      );

      await _alarmRepository.createAlarm(testAlarm);

      activeAlarms.add(testAlarm);

      Get.snackbar(
        '🧪 Test Timer Started',
        'Music will stop in 5 seconds',
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.orange.withValues(alpha: 0.8),
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to create test timer');
    } finally {
      isLoading.value = false;
    }
  }
}
