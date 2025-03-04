import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/theme_provider.dart';

class ThemeButton extends StatelessWidget {
  const ThemeButton({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    return IconButton(
      icon: Selector<ThemeProvider, bool>(
        selector: (context, themeProvider) => themeProvider.isDarkMode(context),
        builder: (context, isDarkMode, child) {
          return Icon(isDarkMode ? Icons.wb_sunny : Icons.nightlight_round);
        },
      ),
      onPressed: () {
        themeProvider.toggleTheme();
      },
    );
  }
}
