import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../controllers/quran_audio_controller.dart';

class AudioProgressBar extends GetView<QuranAudioController> {
  const AudioProgressBar({super.key});

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    final minStr = minutes.toString().padLeft(2, '0');
    final secStr = seconds.toString().padLeft(2, '0');

    if (hours > 0) {
      return '$hours:$minStr:$secStr';
    }
    return '$minStr:$secStr';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Obx(() {
        final position = controller.position.value;
        final duration = controller.duration.value;

        final double maxVal = duration.inMilliseconds.toDouble();
        double currentVal = position.inMilliseconds.toDouble();

        if (maxVal <= 0) {
          currentVal = 0;
        } else if (currentVal > maxVal) {
          currentVal = maxVal;
        }

        return Column(
          children: [
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 4.0,
                thumbShape: const RoundSliderThumbShape(
                  enabledThumbRadius: 7.0,
                ),
                overlayShape: const RoundSliderOverlayShape(
                  overlayRadius: 16.0,
                ),
                activeTrackColor: AppColors.primaryDeep,
                inactiveTrackColor: AppColors.primary.withValues(alpha: 0.2),
                thumbColor: AppColors.primaryDeep,
                overlayColor: AppColors.primary.withValues(alpha: 0.2),
              ),
              child: Slider(
                min: 0.0,
                max: maxVal > 0 ? maxVal : 1.0,
                value: currentVal,
                onChanged:
                    maxVal > 0
                        ? (val) {
                          controller.onSeeking(
                            Duration(milliseconds: val.round()),
                          );
                        }
                        : null,
                onChangeEnd:
                    maxVal > 0
                        ? (val) {
                          controller.seekTo(
                            Duration(milliseconds: val.round()),
                          );
                        }
                        : null,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _formatDuration(position),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  Text(
                    _formatDuration(duration),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
