import 'package:flutter/material.dart';
import 'package:rollflix/l10n/app_localizations.dart';

/// Helper class for localized enum values
class LocalizedEnums {
  const LocalizedEnums._();

  static String preparationTimeLabel(BuildContext context, String enumValue) {
    final localizations = AppLocalizations.of(context)!;
    switch (enumValue) {
      case 'quick':
        return localizations.quick;
      case 'medium':
        return localizations.mediumTime;
      case 'long':
        return localizations.elaborate;
      case 'extended':
        return localizations.gourmet;
      default:
        return enumValue;
    }
  }

  static String cookingSkillLabel(BuildContext context, String enumValue) {
    final localizations = AppLocalizations.of(context)!;
    switch (enumValue) {
      case 'beginner':
        return localizations.beginner;
      case 'intermediate':
        return localizations.intermediate;
      case 'advanced':
        return localizations.advancedSkill;
      case 'expert':
        return localizations.expert;
      default:
        return enumValue;
    }
  }

  static String cookingSkillDescription(BuildContext context, String enumValue) {
    final localizations = AppLocalizations.of(context)!;
    switch (enumValue) {
      case 'beginner':
        return localizations.beginnerDesc;
      case 'intermediate':
        return localizations.intermediateDesc;
      case 'advanced':
        return localizations.advancedDesc;
      case 'expert':
        return localizations.expertDesc;
      default:
        return '';
    }
  }

  static String difficultyLabel(BuildContext context, String difficulty) {
    final localizations = AppLocalizations.of(context)!;
    switch (difficulty) {
      case 'Fácil':
        return localizations.easy;
      case 'Médio':
      case 'Intermediário':
        return localizations.medium;
      case 'Avançado':
        return localizations.advanced;
      default:
        return difficulty;
    }
  }
}