import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

Future<void> toggleLocale(BuildContext context) {
  final isArabic = context.locale.languageCode == 'ar';
  return context.setLocale(Locale(isArabic ? 'en' : 'ar'));
}
