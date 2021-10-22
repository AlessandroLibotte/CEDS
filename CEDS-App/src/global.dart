import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart' as mysql;

int themeId = 0;

List<String> themeNames = <String>["Rainbow", "Purple", "Black"];

ColorScheme _PurpleTheme = ColorScheme(
  brightness: Brightness.dark,
  background: Color(0xFF662680),
  onBackground: Color(0xFF9200CC),
  primary: Color(0xFFB700FF),
  onPrimary: Color(0xFFCC4DFF),
  primaryVariant: Color(0xFF5B0080),
  secondary: Colors.deepPurple,
  onSecondary: Colors.deepPurpleAccent,
  secondaryVariant: Color(0xFF871237),
  error: Colors.red[900],
  onError: Colors.red,
  surface: Color(0xFFB700FF),
  onSurface: Color(0xFFCC4DFF),
);

ThemeData themeDark = ThemeData(
    colorScheme: _DarkTheme,
    brightness: Brightness.dark,
    buttonTheme: ButtonThemeData(
        colorScheme: _DarkTheme
    ),
    sliderTheme: SliderThemeData(
        thumbColor: _DarkTheme.onSecondary,
        activeTrackColor: _DarkTheme.secondaryVariant,
        inactiveTrackColor: _DarkTheme.onBackground
    ),
    disabledColor: _DarkTheme.onBackground,
    errorColor: _DarkTheme.error,
    primaryColor: _DarkTheme.primary,
    primaryColorBrightness: Brightness.dark,
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith((Set<MaterialState> states) {
        const Set<MaterialState> interactiveStates = <MaterialState>{
          MaterialState.selected,
          MaterialState.dragged,
        };
        if (states.any(interactiveStates.contains)) {
          return _DarkTheme.onSecondary;
        }
        return _DarkTheme.secondaryVariant;
      }),
      trackColor: MaterialStateProperty.resolveWith((Set<MaterialState> states) {
        const Set<MaterialState> interactiveStates = <MaterialState>{
          MaterialState.selected,
          MaterialState.dragged,
        };
        if (states.any(interactiveStates.contains)) {
          return _DarkTheme.secondaryVariant;
        }
        return _DarkTheme.onBackground;
      })
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedIconTheme: IconThemeData(
          color: _DarkTheme.onSecondary,
        ),
        unselectedIconTheme: IconThemeData(
          color: _DarkTheme.onBackground
        ),
        selectedItemColor: _DarkTheme.onSecondary,
        unselectedItemColor: _DarkTheme.onBackground
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(_DarkTheme.primary),
            foregroundColor: MaterialStateProperty.all(_DarkTheme.onSecondary)
        )
    ),
    radioTheme: RadioThemeData(
      fillColor: MaterialStateProperty.all(_DarkTheme.primary),
    )
);

ColorScheme _DarkTheme = ColorScheme(
  brightness: Brightness.dark,
  background: Color(0xFF36393F),
  onBackground: Color(0xFF393C43),
  primary: Color(0xFF202225),
  onPrimary: Color(0xFF2F3136),
  primaryVariant: Color(0xFF18181C),
  secondary: Color(0xFF393C43),
  onSecondary: Color(0xFFB4B6B9),
  secondaryVariant: Color(0xFF717171),
  error: Colors.red[900],
  onError: Colors.red,
  surface: Color(0xFF202225),
  onSurface: Color(0xFF2F3136),
);

List<String> icons = <String>[
  "res/icons/cloud.png",
  "res/icons/clock.png",
  "res/icons/light.png",
  "res/icons/games.png",
  "res/icons/home.png"
];

class Alarm {
  List<String> days;
  int hour;
  int minute;
  bool enabled;
  Alarm({this.days, this.hour, this.minute, this.enabled});
}

List<Alarm> alarms = <Alarm>[];
int alarmCount;
bool clockRouteIndex = false;

String coreIP = "ND";

var conn;
bool connErr = false;
