import 'package:flutter/material.dart';
import 'package:flutter_application_3/presentation/providers/imc_form_provider.dart';
import 'package:provider/provider.dart';

class AgeSelector extends StatefulWidget {
  const AgeSelector({super.key});

  @override
  State<AgeSelector> createState() => AgeSelectorState();
}

class AgeSelectorState extends State<AgeSelector> {
  double _age = 25.0;          // ahora es double porque el Slider trabaja con double
  static const double _min = 0;
  static const double _max = 100;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final form = context.watch<ImcFormProvider>();


    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        //--- Título ---
        const Text(
          'Edad',
          style: TextStyle(
            fontFamily: 'Onest',
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 10),

        //--- Etiqueta con el valor actual ---
        Container(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 30),
          decoration: BoxDecoration(
            color: colors.primary,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: colors.primary, width: 2),
            boxShadow: [
              BoxShadow(
                color: colors.primary.withAlpha(80),
                blurRadius: 20,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Text(
            _age.round().toString(),
            style: const TextStyle(
              fontFamily: 'Onest',
              fontSize: 36,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        //--- Slider ---
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: colors.primary,
            inactiveTrackColor: colors.primary.withValues(alpha: 0.3),
            thumbColor: colors.primary,
            overlayColor: colors.primary.withValues(alpha: 0.2),
            valueIndicatorColor: colors.primary,
            showValueIndicator: ShowValueIndicator.never,
          ),
          child: Slider(
            padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 30),
            value: _age,
            min: _min,
            max: _max,
            divisions: _max.toInt(),
            onChanged: (value) {
                setState(() => _age = value);
                context.read<ImcFormProvider>().setAge(value); 
              },
            ),
        ),
      ],
    );
  }
}
