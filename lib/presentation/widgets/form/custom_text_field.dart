import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/imc_form_provider.dart';

class TextFieldIMC extends StatelessWidget {
  const TextFieldIMC({
    super.key,
    required this.label,
    required this.icon,
    required this.isWeightField, required this.texthint,
  });

  final String   label;
  final IconData icon;
  final bool     isWeightField;   // true = peso, false = altura
  final String texthint;

  @override
  Widget build(BuildContext context) {

    final colors = Theme.of(context).colorScheme;
    final form  = context.watch<ImcFormProvider>();
    final currentUnit = isWeightField ? form.weightUnit : form.heightUnit;
    final focusNode = isWeightField
        ? form.weightFocusNode
        : form.heightFocusNode;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              style: TextStyle(fontWeight:FontWeight.w800),
              focusNode: focusNode,
              controller: isWeightField
                  ? form.weightCtrl
                  : form.heightCtrl,
              onTapUpOutside: (_)=> form.unfocusAll(),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'^\d{0,3}(\.\d{0,2})?$'),
                ),
              ],
              decoration: InputDecoration(
                hintText: texthint,
                prefixIcon: Icon(icon,color: colors.primary.withValues(alpha: 0.7),size: 30,),
                labelText: label,
                filled: true,
                fillColor: colors.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: colors.primary.withValues(alpha: 0.5)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: colors.primary),
                )
              ),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: colors.primary.withValues(alpha: 0.5), width: 1),
            ),
            child: DropdownButton<String>(
              value: currentUnit,
              underline: const SizedBox(),
              icon: Icon(Icons.arrow_drop_down, color: colors.primary),
              items: isWeightField
                  ? const [
                      DropdownMenuItem(value: 'kg', child: Text('kg. ')),
                      DropdownMenuItem(value: 'lb', child: Text('lb. ')),
                    ]
                  : const [
                      DropdownMenuItem(value: 'cm', child: Text('cm.')),
                      DropdownMenuItem(value: 'in', child: Text('in.')),
                    ],
              onChanged: (value) {
                if (value == null) return;
                isWeightField
                    ? form.setWeightUnit(value)
                    : form.setHeightUnit(value);
              },
            ),
          ),
        ],
      ),
    );
  }
}

