import 'package:flutter/material.dart';

import 'package:flutter_application_3/presentation/widgets/shared/custom_imc_gauge.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';

import '../../../infrastructure/models/user_profile.dart';
import '../../widgets/form/custom_age_selector.dart';
import '../../widgets/form/custom_form_card.dart';
import '../../widgets/form/custom_text_field.dart';
import '../../widgets/shared/custom_elevated_btn.dart';
import '../../widgets/shared/custom_history_drawer.dart';
import '../../../infrastructure/models/imc_result.dart';
import '../../providers/imc_form_provider.dart';
import '../../widgets/shared/custom_info_card.dart';

class PageForm extends StatefulWidget {
  const PageForm({super.key});

  @override
  State<PageForm> createState() => _PageFormState();
}

class _PageFormState extends State<PageForm>{

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      // ignore: use_build_context_synchronously
      context.read<ImcFormProvider>().loadHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    
    final colors = Theme.of(context).colorScheme;
    final form = context.watch<ImcFormProvider>();
    

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        actions: [
          Builder(
            builder: (innerContext)=>Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  IconButton(
                  icon: const Icon(Icons.history, size: 30),
                  onPressed: () => Scaffold.of(innerContext).openEndDrawer(),
                  ),
                ],
              ),
            ),
          )
        ],
        iconTheme: IconThemeData(color: colors.primary),
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      endDrawer: const HistoryDrawer(),
      body: LayoutBuilder(
        builder:(context,constraints){
        
        final isWide = constraints.maxWidth > 600;
        final horizontalPadding = isWide ? constraints.maxWidth * 0.2 : 16.0;
        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Column(
            children: [
              FormCard( 
                color: colors.primary,
                alignment: CrossAxisAlignment.center,widgetlist: [ 
                  Text(
                      'Bienvenido a IMC-Tracker',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold,color:colors.onPrimary,)
                  ),
                  Text(
                    "Calcula tu índice de masa corporal (IMC) y mantén un registro de tu salud.",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: colors.onPrimary.withValues(alpha: 0.9),),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FormCard( 
                      color: colors.surface,
                      alignment: CrossAxisAlignment.center,
                      widgetlist: [ 
                        Center(
                          child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(height: 20),
                                  TextFieldIMC(
                                    label: 'Peso',
                                    texthint: 'Ingresa tu peso',
                                    icon: Icons.monitor_weight,
                                    isWeightField: true,
                                  ),
                                  TextFieldIMC(
                                    label: 'Altura',
                                    texthint: 'Ingresa tu altura',
                                    icon: Icons.height,
                                    isWeightField: false,
                                  ),
                                  SizedBox(height: 20),
                                  SegmentedButton(segments: const[
                                    ButtonSegment(
                                      value: 'female',
                                        icon: Icon(Icons.female,size: 30,),
                                        label: Text('Mujer',style: TextStyle(fontWeight: FontWeight.w700,fontSize: 18),),
                                      ),
                                      ButtonSegment(
                                        value: 'male',
                                        icon: Icon(Icons.male,size: 30),
                                        label: Text('Hombre',style: TextStyle(fontWeight: FontWeight.w700,fontSize: 18),),
                                      ),
                                    ],
                                    selected: form.gender == null ? <String>{} : {form.gender!},
                                      emptySelectionAllowed: true,
                                      showSelectedIcon: false,
                                      onSelectionChanged: (s) => form.setGender(s.isEmpty ? null : s.first),
                                      style: SegmentedButton.styleFrom(
        
                                        backgroundColor: colors.surface,
                                        foregroundColor: colors.onSurface,
                                        selectedBackgroundColor: colors.primary,
                                        selectedForegroundColor: Colors.white,
                                        side: BorderSide(
                                          color: colors.primary.withValues(alpha: 0.5)
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        padding: EdgeInsets.symmetric(horizontal: 15),
                                      ),
                                    ),
                                    const SizedBox(height: 30),
                                    AgeSelector(),
                                    const SizedBox(height: 20),
                                    CustomElevatedBtn(
                                      isSelected: form.isValid,
                                      data: 'Calcular', 
                                      onPress: () {
                                        if (form.isValid) {
                                            final imc = form.calculateIMC();
                                            if (imc != null) {
                                              // Crear ImcResult con los datos actuales
                                              final result = ImcResult(
                                                imcValue: imc,
                                                category: form.determineImcCategory(imc),
                                                timestamp: DateTime.now(),
                                                userProfile: UserProfile(
                                                  age: form.age,
                                                  gender: form.gender,
                                                  weightUnit: form.weightUnit,
                                                  heightUnit: form.heightUnit,
                                                  height: double.parse(form.heightCtrl.text),
                                                  weight: double.parse(form.weightCtrl.text),
                                                ),
                                              );
                                              showDialogWidget(context, result,form);
                                            }
                                          }
                                        else {
                                            // Determinar qué campos faltan
                                            final missingFields = <String>[];
                                            if (form.gender == null) missingFields.add('género');
                                            if (form.weightCtrl.text.isEmpty) missingFields.add('peso');
                                            if (form.heightCtrl.text.isEmpty) missingFields.add('altura');
           
                                            // Construir mensaje dinámico
                                            String message;
                                            if (missingFields.isEmpty) {
                                              message = 'Error desconocido';
                                            } else if (missingFields.length == 1) {
                                              message = 'Completa el campo de ${missingFields.first}';
                                            } else {
                                              final last = missingFields.removeLast();
                                              message = 'Completa los campos de ${missingFields.join(', ')} y $last';
                                            }
          
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text(message),
                                                duration: const Duration(seconds: 2),
                                              ),
                                            );
                                          }
                                      },
                                      elevation: 20, 
                                      borderRad: 10),
                                      SizedBox(height: 70),
                                      
                                  ],
                                ),
                              ),
                          ),
                      ],
                    ),
                    Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                        "Categorías de IMC",
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colors.onSurface,
                          ),
                        ),
                      ),
                    ),
                    BuildInfoCard(
                      title: 'Peso bajo',
                      description: 'IMC por debajo de 18.5',
                      color: Colors.blue.shade400,
                      icon: Icons.arrow_downward_rounded,
                    ),
                    BuildInfoCard(
                      title: 'Peso normal',
                      description: 'IMC entre 18.5 y 24.9',
                      color: Colors.green,
                      icon: Icons.check_circle_outline_rounded,
                    ),
                    BuildInfoCard(
                      title: 'Sobrepeso',
                      description: 'IMC entre 25 y 29.9',
                      color: Colors.orange,
                      icon: Icons.warning_amber_rounded,
                    ),
                    BuildInfoCard(
                      title: 'Obesidad',
                      description: 'IMC mayor de 30',
                      color: Colors.red,
                      icon: Icons.priority_high_rounded,
                    ),
                    Center(
                      child: TextButton.icon(
                        icon: Icon(Icons.info_outline, size: 18),
                        label: Text("¿Qué es el IMC?"),
                        onPressed: () => _showIMCInfo(context),
                      ),
                    ),
                    SizedBox(height: 20,)
                  ],
                )
                
              ),
            ],
          ),
        );
        }
      ), 
    );
  }

  void _showIMCInfo(BuildContext context) async {
  final colors = Theme.of(context).colorScheme;

  await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      icon: Icon(Icons.public, color: colors.primary),
      title: Text("Información del IMC", style: TextStyle(color: colors.onSurface)),
      content: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              "El Índice de Masa Corporal (IMC) es un indicador...",
              style: TextStyle(color: colors.onSurface),
            ),
            const SizedBox(height: 15),
            InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () {
                launchUrl(
                  Uri.parse("https://www.cdc.gov/healthyweight/spanish/assessing/bmi/adult_bmi/index.html"), 
                  mode: LaunchMode.externalApplication
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Icon(Icons.open_in_new, size: 18, color: colors.primary),
                    const SizedBox(width: 8),
                    Text(
                      "Consulta en la OMS",
                      style: TextStyle(
                        color: colors.primary,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: Text("Cerrar", style: TextStyle(color: colors.primary)),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    ),
  );
}

  Future<dynamic> showDialogWidget(BuildContext context, ImcResult result, ImcFormProvider form) {
  final colors = Theme.of(context).colorScheme;
  final parentContext = context; // Guardamos el contexto original

  return showDialog(
    context: context,
    builder: (dialogContext) => Dialog(
      backgroundColor: colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomImcGauge(imcResult:result,animated: true,),
            const SizedBox(height: 5),
            Text(
              "IMC: ${result.formattedImcValue}",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: form.getResultColor(result.imcValue),
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              result.healthMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: form.getResultColor(result.imcValue),
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.surface,
                    foregroundColor: colors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                  ),
                  child: const Text("Cerrar",style: TextStyle(fontSize: 18),),
                ),
                const SizedBox(width: 15),
                ElevatedButton.icon(
                  icon: Icon(Icons.save, color: colors.onPrimary),
                  onPressed: () {
                    form.imcSave();
                    Navigator.pop(dialogContext); // 1. Cierra el diálogo
                    
                    // 2. Muestra SnackBar en el contexto padre
                    ScaffoldMessenger.of(parentContext).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Registro guardado exitosamente",
                          style: TextStyle(
                            color: colors.primary
                            ),
                          ),
                        backgroundColor: colors.surface,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        duration: const Duration(seconds: 2),
                        margin: const EdgeInsets.all(20),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.primary.withValues(alpha: 0.85),
                    foregroundColor: colors.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                  ),
                  label: const Text("Guardar"),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
}


