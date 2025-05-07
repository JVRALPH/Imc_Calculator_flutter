import 'package:flutter_application_3/infrastructure/models/imc_result.dart';

class HealthTipsUtils {
  static List<String> getHealthTips(ImcResult result) {
    final tips = <String>[];
    final category = result.category;
    final profile = result.userProfile;

    // Consejos comunes para todas las categorías
    tips.add('Bebe suficiente agua durante el día.');
    tips.add('Duerme entre 7 y 9 horas de calidad cada noche.');

    // Consejos específicos por categoría
    switch (category) {
      case ImcCategory.severelyUnderweight:
      case ImcCategory.underweight:
        tips.add('Consume alimentos ricos en nutrientes como nueces, aguacates y productos integrales.');
        tips.add('Considera añadir batidos o licuados de proteínas entre comidas.');
        tips.add('El entrenamiento de fuerza puede ayudarte a ganar masa muscular.');
        break;

      case ImcCategory.normal:
        tips.add('Mantén una dieta equilibrada y una rutina regular de ejercicio.');
        tips.add('Fija objetivos de condición física más allá del peso, como fuerza o resistencia.');
        tips.add('Realízate chequeos médicos regulares para cuidar tu salud.');
        break;

      case ImcCategory.overweight:
        tips.add('Incluye más frutas y verduras en tu alimentación diaria.');
        tips.add('Aumenta tu actividad física — apúntate a 150 minutos de ejercicio moderado por semana.');
        tips.add('Lleva un registro de tu alimentación para identificar áreas de mejora.');
        break;

      case ImcCategory.obeseClassI:
      case ImcCategory.obeseClassII:
      case ImcCategory.obeseClassIII:
        tips.add('Consulta a un profesional de la salud para obtener orientación personalizada.');
        tips.add('Enfócate en cambios sostenibles a largo plazo, no soluciones rápidas.');
        tips.add('Caminar es un excelente ejercicio de bajo impacto para comenzar.');
        tips.add('Llevar un diario alimenticio puede ayudarte a tomar conciencia de tus hábitos.');
        break;
    }

    // Consejos específicos por edad
    if (profile.age < 18) {
      tips.add('Tu cuerpo aún está creciendo — prioriza alimentos nutritivos en lugar de restringir calorías.');
    } else if (profile.age > 60) {
      tips.add('Es importante mantener la masa muscular con la edad — incluye ejercicios de fuerza.');
    }

    return tips;
  }
}
