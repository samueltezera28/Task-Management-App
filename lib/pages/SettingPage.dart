import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_management_app/model/themeProvider.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      body: Center(
        child: TweenAnimationBuilder(
          tween: ColorTween(
            begin: themeProvider.isDarkMode ? Colors.black : Colors.white,
            end: themeProvider.isDarkMode ? Colors.black : Colors.white,
          ),
          duration: const Duration(milliseconds: 500),
          builder: (context, Color? color, child) {
            return Container(
              color: color,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Dark Mode'),
                    const SizedBox(height: 10),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      transitionBuilder:
                          (Widget child, Animation<double> animation) {
                        return ScaleTransition(scale: animation, child: child);
                      },
                      child: Icon(
                        themeProvider.isDarkMode
                            ? Icons.lightbulb_outline
                            : Icons.lightbulb,
                        key: ValueKey<bool>(themeProvider.isDarkMode),
                        color: themeProvider.isDarkMode
                            ? Colors.yellow
                            : Colors.grey,
                        size: 45,
                      ),
                    ),
                    const SizedBox(height: 10),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      transitionBuilder:
                          (Widget child, Animation<double> animation) {
                        return ScaleTransition(scale: animation, child: child);
                      },
                      child: Switch(
                        key: ValueKey<bool>(themeProvider.isDarkMode),
                        value: themeProvider.isDarkMode,
                        onChanged: (value) {
                          themeProvider.toggleTheme(value);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
