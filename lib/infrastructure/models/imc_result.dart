import 'package:intl/intl.dart';
import 'user_profile.dart';

enum ImcCategory {
  severelyUnderweight,
  underweight,
  normal,
  overweight,
  obeseClassI,
  obeseClassII,
  obeseClassIII,
}

class ImcResult {
  final double imcValue;
  final ImcCategory category;
  final DateTime timestamp;
  final UserProfile userProfile;

  ImcResult({
    required this.imcValue,
    required this.category,
    required this.timestamp,
    required this.userProfile,
  });

  String get formattedDate => DateFormat('MMM d, yyyy - HH:mm').format(timestamp);
  String get formattedImcValue => imcValue.toStringAsFixed(1);

  String get healthMessage {
    switch (category) {
      case ImcCategory.severelyUnderweight:
        return 'Bajo peso severo. Consulta a un nutricionista.';
      case ImcCategory.underweight:
        return 'Bajo peso. Necesitas ganar masa muscular.';
      case ImcCategory.normal:
        return 'Peso saludable. ¡Buen trabajo!';
      case ImcCategory.overweight:
        return 'Sobrepeso. Más actividad física recomendada.';
      case ImcCategory.obeseClassI:
        return 'Obesidad Clase I. Pequeños cambios ayudarán.';
      case ImcCategory.obeseClassII:
        return 'Obesidad Clase II. Consulta a un profesional.';
      case ImcCategory.obeseClassIII:
        return 'Obesidad Clase III. Necesita atención médica.';
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'imcValue': imcValue,
      'category': category.toString().split('.').last,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'userProfile': userProfile.toJson(),
    };
  }

  factory ImcResult.fromJson(Map<String, dynamic> json) {
    return ImcResult(
      imcValue: json['imcValue'] as double,
      category: categoryFromString(json['category'] as String),
      timestamp: DateTime.fromMillisecondsSinceEpoch(json['timestamp'] as int),
      userProfile: UserProfile.fromJson(json['userProfile'] as Map<String, dynamic>),
    );
  }

  static ImcCategory categoryFromString(String categoryStr) {
    return ImcCategory.values.firstWhere(
      (e) => e.toString().split('.').last == categoryStr,
      orElse: () => ImcCategory.normal,
    );
  }
}