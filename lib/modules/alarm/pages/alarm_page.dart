import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sleep_music/controllers/root_controller.dart';
import 'package:sleep_music/modules/alarm/controllers/alarm_controller.dart';
import 'package:sleep_music/controllers/music_player_controller.dart';
import 'package:sleep_music/widgets/alarm/index.dart';

class AlarmPage extends GetView<AlarmController> {
  const AlarmPage({super.key});

  @override
  Widget build(BuildContext context) {
    final RootController rootController = Get.find<RootController>();
    final MusicPlayerController player = Get.find<MusicPlayerController>();
    final bottomInset = MediaQuery.of(context).padding.bottom;
    final extraBottom = 70 + 56 + bottomInset;

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/background.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: SingleChildScrollView(
        controller: rootController.scrollController,
        padding: EdgeInsets.fromLTRB(16, 24, 16, 24 + extraBottom),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sleep Timer',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                shadows: [
                  Shadow(
                    blurRadius: 10.0,
                    color: Colors.black26,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Current music card
            MusicCardWidget(player: player),

            const SizedBox(height: 24),

            Obx(
              () =>
                  TimerDisplayWidget(timeLeft: controller.currentAlarmTimeLeft),
            ),

            const SizedBox(height: 32),

            QuickTimersWidget(controller: controller),

            const SizedBox(height: 32),

            CustomTimerWidget(controller: controller),

            const SizedBox(height: 32),

            MusicSelectionWidget(controller: controller),

            const SizedBox(height: 32),

            // Active alarms
            Obx(
              () => ActiveAlarmsWidget(
                alarms: controller.activeAlarms,
                controller: controller,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
