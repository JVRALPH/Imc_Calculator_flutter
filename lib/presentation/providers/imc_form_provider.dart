import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_3/infrastructure/models/imc_result.dart';
import 'package:flutter_application_3/infrastructure/models/user_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ImcFormProvider extends ChangeNotifier {
  final weightCtrl = TextEditingController();
  final heightCtrl = TextEditingController();
  final FocusNode weightFocusNode = FocusNode();
  final FocusNode heightFocusNode = FocusNode();

  List<ImcResult> _history = [];
  List<ImcResult> get history => _history;


  String weightUnit = 'kg';
  String heightUnit = 'cm';
  String? gender;
  double age = 25;
  double? imcResult;

  void unfocusAll() {
    weightFocusNode.unfocus();
    heightFocusNode.unfocus();
    notifyListeners();
  }

  @override
  void dispose() {
    weightFocusNode.dispose();
    heightFocusNode.dispose();
    super.dispose();
  }

  double? calculateIMC() {
    if (!isValid) return null;

    try {
      final weight = double.parse(weightCtrl.text);
      final height = double.parse(heightCtrl.text);

      final weightKg = weightUnit == 'kg' ? weight : weight * 0.453592;
      final heightMeters = heightUnit == 'cm' ? height / 100 : height * 0.0254;

      if (weightKg <= 0 || heightMeters <= 0) return null;

      final imc = weightKg / (heightMeters * heightMeters);
      imcResult = imc;
      notifyListeners();
      
      return imc;
    } catch (e) {
      return null;
    }
  }

  void setWeightUnit(String value) { 
    weightUnit = value;  
    notifyListeners(); 
  }

  void setHeightUnit(String value) { 
    heightUnit = value;  
    notifyListeners(); 
  }

  void setGender(String? value) { 
    gender = value;  
    notifyListeners(); 
  }

  void setAge(double value) { 
    age = value;  
    notifyListeners(); 
  }

  bool get isValid => gender != null && weightCtrl.text.isNotEmpty && heightCtrl.text.isNotEmpty;

  Future<void> imcSave() async {
    if (imcResult == null) return;

    final userProfile = UserProfile(
      age: age,
      gender: gender,
      weight: double.parse(weightCtrl.text),
      height: double.parse(heightCtrl.text),
      weightUnit: weightUnit,
      heightUnit: heightUnit,
    );

    final result = ImcResult(
      imcValue: imcResult!,
      category: determineImcCategory(imcResult!),
      timestamp: DateTime.now(),
      userProfile: userProfile,
    );

    _history.add(result);
    await _saveHistoryToPrefs();
    notifyListeners();
  }

  ImcCategory determineImcCategory(double imcValue) {
    if (imcValue < 16) return ImcCategory.severelyUnderweight;
    if (imcValue < 18.5) return ImcCategory.underweight;
    if (imcValue < 25) return ImcCategory.normal;
    if (imcValue < 30) return ImcCategory.overweight;
    if (imcValue < 35) return ImcCategory.obeseClassI;
    if (imcValue < 40) return ImcCategory.obeseClassII;
    return ImcCategory.obeseClassIII;
  }

  String getCategoryEmoji(ImcCategory category) {
  switch (category) {
    case ImcCategory.severelyUnderweight: return '😨';
    case ImcCategory.underweight: return '😕';
    case ImcCategory.normal: return '😊';
    case ImcCategory.overweight: return '🙁';
    case ImcCategory.obeseClassI: return '😥';
    case ImcCategory.obeseClassII: return '😩';
    case ImcCategory.obeseClassIII: return '😫';
  }
  }

  String getCategoryLabel(ImcCategory category) {
  switch (category) {
    case ImcCategory.severelyUnderweight:
      return 'Peso severamente bajo';
    case ImcCategory.underweight:
      return 'Bajo peso';
    case ImcCategory.normal:
      return 'Peso normal';
    case ImcCategory.overweight:
      return 'Sobrepeso';
    case ImcCategory.obeseClassI:
      return 'Obesidad Clase I';
    case ImcCategory.obeseClassII:
      return 'Obesidad Clase II';
    case ImcCategory.obeseClassIII:
      return 'Obesidad Clase III';
  }
}


  
  Color getResultColor(double imc) {
  if (imc < 18.5) return Colors.blue; // Bajo peso
  if (imc < 24.9) return Colors.green; // Normal
  if (imc < 29.9) return Colors.orange; // Sobrepeso
  return Colors.red; // Obeso
  }


  Future<void> _saveHistoryToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = _history.map((r) => r.toJson()).toList();
    await prefs.setString('imc_history', json.encode(historyJson));
  }

  Future<void> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = prefs.getString('imc_history');
    
    if (historyJson != null) {
      final List<dynamic> decoded = json.decode(historyJson);
      _history = decoded.map((json) => ImcResult.fromJson(json)).toList();
      notifyListeners();
    }
  }

  Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('imc_history');
    _history.clear();
    notifyListeners();
  }

  void addToHistory(ImcResult result) {
  _history.add(result);
  _saveHistoryToPrefs();
  notifyListeners();
}

  void deleteRecord(int index) {
    _history.removeAt(index);
    _saveHistoryToPrefs();
    notifyListeners();
  }

  List<String> getHealthTips(ImcResult result) {
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