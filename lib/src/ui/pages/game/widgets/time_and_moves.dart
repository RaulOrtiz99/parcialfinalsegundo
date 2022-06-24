import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../../../../generated/l10n.dart';
import '../../../global/widgets/max_text_scale_factor.dart';
import '../../../icons/puzzle_icons.dart';
import '../../../utils/time_parser.dart';
import '../controller/game_controller.dart';

/// widget to show the time and the moves counter
class TimeAndMoves extends StatelessWidget {
  const TimeAndMoves({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(
      fontSize: 25,
      fontWeight: FontWeight.w600,
    );

    final time = Provider.of<GameController>(context, listen: false).time;
    return MaxTextScaleFactor(
      max: 1,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 500,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ValueListenableBuilder<int>(
              valueListenable: time,
              builder: (_, time, icon) {
                return Row(
                  children: [
                    Icon(Icons.timer_outlined,),
                    Text(
                      " ${parseTime(time)}",
                      style: TextStyle(color: Colors.white,),
                    ),
                  ],
                );
              },
              child: const Icon(
                PuzzleIcons.watch,
                size: 25,
              ),
            ),
            Selector<GameController, int>(
              builder: (_, moves, icon) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    icon!,
                    const SizedBox(width: 5),
                    Text(
                      "$moves ${S.current.movements}",
                      style: textStyle,
                    ),
                  ],
                );
              },
              selector: (_, controller) => controller.state.moves,
              child: const Icon(
                Icons.multiple_stop_rounded,
                size: 27,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
