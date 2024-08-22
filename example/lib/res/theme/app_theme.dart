import 'package:call_qwik_example/main.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:isometrik_call_flutter/isometrik_call_flutter.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData get theme => ThemeData.dark().copyWith(
          primaryColor: CallColors.primary,
          scaffoldBackgroundColor: CallColors.background,
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: CallColors.secondary.withOpacity(0.2),
            alignLabelWithHint: true,
            isDense: true,
            iconColor: CallColors.white,
            prefixIconColor: CallColors.white,
            suffixIconColor: CallColors.white,
            labelStyle: const TextStyle(fontSize: 14),
            hintStyle: const TextStyle(fontSize: 14),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: CallColors.card,
            scrolledUnderElevation: 0,
          ),
          cardColor: CallColors.secondary,
          canvasColor: CallColors.card,
          dividerColor: CallColors.cardLight,
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: CallColors.card,
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: false,
            showUnselectedLabels: false,
          ),
          textTheme: GoogleFonts.interTextTheme().apply(
            bodyColor: CallColors.white,
            displayColor: CallColors.white,
          ),
          extensions: [
            const IsmCallExtension(
              properties: IsmCallPropertiesData(

                  // pipView: IsmChatPageView(),
                  ),
            ),
          ]);
}
