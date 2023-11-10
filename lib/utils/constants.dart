import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Supabase client
final supabase = Supabase.instance.client;

/// Simple preloader inside a Center widget
const preloader =
    Center(child: CircularProgressIndicator(color: Colors.orange));

/// Simple sized box to space out form elements
const formSpacer = SizedBox(width: 16, height: 16);

/// Some padding for all the forms to use
const formPadding = EdgeInsets.symmetric(vertical: 20, horizontal: 16);

/// Error message to display the user when unexpected error occurs.
const unexpectedErrorMessage = 'Unexpected error occurred.';

final darkAppTheme = ThemeData.dark().copyWith(
  primaryColorDark:
      Colors.indigo, // Используйте темно-голубой оттенок вместо оранжевого
  appBarTheme: const AppBarTheme(
    elevation: 1,
    backgroundColor: Colors.black, // Фон AppBar в теме темный
    iconTheme: IconThemeData(color: Colors.white), // Цвет иконок белый
    titleTextStyle: TextStyle(
      color: Colors.white, // Цвет текста заголовка белый
      fontSize: 18,
    ),
  ),
  primaryColor: Colors.indigo, // Основной цвет темы - темно-голубой
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: Colors.indigo, // Цвет текста кнопок темно-голубой
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor:
          Colors.black, // Цвет текста кнопок поднятого состояния черный
      backgroundColor: Colors.indigo, // Фон кнопок темно-голубой
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    floatingLabelStyle: const TextStyle(
      color: Colors.indigo, // Цвет плавающего заголовка темно-голубой
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(
        color: Colors.grey,
        width: 2,
      ),
    ),
    focusColor: Colors.indigo, // Цвет фокуса темно-голубой
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(
        color: Colors.indigo,
        width: 2,
      ),
    ),
  ),
);

/// Set of extension methods to easily display a snackbar
extension ShowSnackBar on BuildContext {
  /// Displays a basic snackbar
  void showSnackBar({
    required String message,
    Color backgroundColor = Colors.black, // Фон базового Snackbar темный
  }) {
    ScaffoldMessenger.of(this).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: backgroundColor,
    ));
  }

  /// Displays a red snackbar indicating error
  void showErrorSnackBar({required String message}) {
    showSnackBar(message: message, backgroundColor: Colors.red);
  }
}
