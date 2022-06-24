import 'package:examenparcial2software1/src/ui/utils/dark_mode_extension.dart';
import 'package:flutter/material.dart';


import 'package:provider/provider.dart';

import '../../../global/controllers/theme_controller.dart';
import '../../../global/widgets/my_icon_button.dart';
import '../../../icons/puzzle_icons.dart';
import '../../../utils/platform.dart';
import '../controller/game_controller.dart';

const whiteFlutterLogoColorFilter = ColorFilter.matrix(
  [1, 1, 1, 0, 0, 1, 1, 1, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 1, 0],
);

class GameAppBar extends StatelessWidget {
  const GameAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final logo = isIOS
        ? const Icon(
            PuzzleIcons.heart,
            color: Colors.pink,
            size: 30,
          )
        : const FlutterLogo(
            size: 40,
          );

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 10,
        ),
        child: Row(
          children: [


            if (context.isDarkMode)
              ColorFiltered(
                colorFilter: whiteFlutterLogoColorFilter,
                child: logo,
              )
            else


            Consumer<GameController>(
              builder: (_, controller, __) => Row(
                children: [
                  MyIconButton(
                    onPressed: controller.toggleVibration,
                    iconData: controller.state.vibration
                        ? PuzzleIcons.vibration
                        : PuzzleIcons.vibration_off,
                  ),
                  const SizedBox(width: 10),
                  MyIconButton(
                    onPressed: controller.toggleSound,
                    iconData: controller.state.sound ? PuzzleIcons.sound : PuzzleIcons.mute,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Consumer<ThemeController>(
              builder: (_, controller, __) => MyIconButton(
                onPressed: controller.toggle,
                iconData: controller.isDarkMode ? PuzzleIcons.dark_mode : PuzzleIcons.brightness,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
