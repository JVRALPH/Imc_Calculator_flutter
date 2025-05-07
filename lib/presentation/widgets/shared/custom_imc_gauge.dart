import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import '../../../infrastructure/models/imc_result.dart';
import '../../providers/imc_form_provider.dart';


class CustomImcGauge extends StatelessWidget {
  
  final ImcResult imcResult;
  final bool animated;
  
  const CustomImcGauge({super.key, required this.imcResult, this.animated = true});

  @override
  
  @override
  Widget build(BuildContext context) {
    final form = context.watch<ImcFormProvider>();
    final colorScheme = Theme.of(context).colorScheme;
    Widget gauge = SfRadialGauge(
      enableLoadingAnimation: true,
      animationDuration: 2000,
      axes: <RadialAxis>[
        RadialAxis(
          minimum: 10,
          maximum: 50,
          radiusFactor: 0.9,
          showLabels: true,
          showAxisLine: true,
          axisLabelStyle: GaugeTextStyle(
            color: colorScheme.onSurface.withValues(alpha: 0.8),
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
          labelOffset: 30,
          interval: 5,
          annotations: <GaugeAnnotation>[
            GaugeAnnotation(
              widget: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 30),
                  Text(
                    imcResult.formattedImcValue,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _getCategoryColor(imcResult.category, colorScheme).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          
                          form.getCategoryLabel(form.determineImcCategory(imcResult.imcValue)),
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          form.getCategoryEmoji(imcResult.category),
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                color: _getCategoryColor(imcResult.category, colorScheme),
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              angle: 90,
              positionFactor: 0.5,
            ),
          ],
          pointers: <GaugePointer>[
            NeedlePointer(
              value: imcResult.imcValue,
              needleLength: 0.6,
              needleStartWidth: 1,
              needleEndWidth: 5,
              knobStyle: KnobStyle(
                knobRadius: 8,
                sizeUnit: GaugeSizeUnit.logicalPixel,
                color: colorScheme.primary,
              ),
              tailStyle: const TailStyle(length: 0),
              needleColor: colorScheme.primary,
              animationDuration: animated ? 1500 : 0,
              enableAnimation: animated,
            ),
          ],
          ranges: _buildGaugeRanges(colorScheme),
        ),
      ],
    );

    return animated 
        ? gauge.animate()
                    .fadeIn(duration: 500.ms, curve: Curves.easeIn)
                    .scale(begin: const Offset(0.8, 0.8), duration: 500.ms)
        : gauge;
  }

  List<GaugeRange> _buildGaugeRanges(ColorScheme colorScheme) {
    return [
      GaugeRange(
        startValue: 10,
        endValue: 16,
        color: Colors.blue.shade800,
        startWidth: 20,
        endWidth: 20,
        label: 'Severely Underweight',
        labelStyle: GaugeTextStyle(fontSize: 0),
      ),
      GaugeRange(
        startValue: 16,
        endValue: 18.5,
        color: Colors.blue.shade400,
        startWidth: 20,
        endWidth: 20,
        label: 'Underweight',
        labelStyle: GaugeTextStyle(fontSize: 0),
      ),
      GaugeRange(
        startValue: 18.5,
        endValue: 25,
        color: Colors.green,
        startWidth: 20,
        endWidth: 20,
        label: 'Normal',
        labelStyle: GaugeTextStyle(fontSize: 0),
      ),
      GaugeRange(
        startValue: 25,
        endValue: 30,
        color: Colors.orange,
        startWidth: 20,
        endWidth: 20,
        label: 'Overweight',
        labelStyle: GaugeTextStyle(fontSize: 0),
      ),
      GaugeRange(
        startValue: 30,
        endValue: 35,
        color: Colors.deepOrange,
        startWidth: 20,
        endWidth: 20,
        label: 'Obese I',
        labelStyle: GaugeTextStyle(fontSize: 0),
      ),
      GaugeRange(
        startValue: 35,
        endValue: 40,
        color: Colors.red.shade400,
        startWidth: 20,
        endWidth: 20,
        label: 'Obese II',
        labelStyle: GaugeTextStyle(fontSize: 0),
      ),
      GaugeRange(
        startValue: 40,
        endValue: 50,
        color: Colors.red.shade800,
        startWidth: 20,
        endWidth: 20,
        label: 'Obese III',
        labelStyle: GaugeTextStyle(fontSize: 0),
      ),
    ];
  }

  Color _getCategoryColor(ImcCategory category, ColorScheme colorScheme) {
    switch (category) {
      case ImcCategory.severelyUnderweight:
        return Colors.blue.shade800;
      case ImcCategory.underweight:
        return Colors.blue.shade400;
      case ImcCategory.normal:
        return Colors.green;
      case ImcCategory.overweight:
        return Colors.orange;
      case ImcCategory.obeseClassI:
        return Colors.deepOrange;
      case ImcCategory.obeseClassII:
        return Colors.red.shade400;
      case ImcCategory.obeseClassIII:
        return Colors.red.shade800;
    }
  }
}


class ImcGaugeSmall extends StatelessWidget {
  final ImcResult result;

  const ImcGaugeSmall({
    super.key,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final form = context.watch<ImcFormProvider>();

    
    return Container(
      height: 90,
      width: 90,
      margin: const EdgeInsets.only(right: 16),
      child: SfRadialGauge(
        enableLoadingAnimation: true,
        axes: <RadialAxis>[
          RadialAxis(
            minimum: 10,
            maximum: 50,
            radiusFactor: 0.9,
            showLabels: false,
            showAxisLine: false,
            showTicks: false,
            annotations: <GaugeAnnotation>[
              GaugeAnnotation(
                widget: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      result.formattedImcValue,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: colorScheme.primary,
                      ),
                    ),
                    Text(
                      form.getCategoryEmoji(result.category),
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
                angle: 90,
                positionFactor: 0.5,
              ),
            ],
            pointers: <GaugePointer>[
              NeedlePointer(
                value: result.imcValue,
                needleLength: 0.6,
                needleStartWidth: 1,
                needleEndWidth: 3,
                knobStyle: KnobStyle(
                  knobRadius: 5,
                  sizeUnit: GaugeSizeUnit.logicalPixel,
                  color: colorScheme.primary,
                ),
                tailStyle: const TailStyle(length: 0),
                needleColor: colorScheme.primary,
                enableAnimation: false,
              ),
            ],
            ranges: _buildGaugeRanges(colorScheme),
          ),
        ],
      ),
    );
  }

  List<GaugeRange> _buildGaugeRanges(ColorScheme colorScheme) {
    return [
      GaugeRange(
        startValue: 10,
        endValue: 16,
        color: Colors.blue.shade800,
        startWidth: 15,
        endWidth: 15,
      ),
      GaugeRange(
        startValue: 16,
        endValue: 18.5,
        color: Colors.blue.shade400,
        startWidth: 15,
        endWidth: 15,
      ),
      GaugeRange(
        startValue: 18.5,
        endValue: 25,
        color: Colors.green,
        startWidth: 15,
        endWidth: 15,
      ),
      GaugeRange(
        startValue: 25,
        endValue: 30,
        color: Colors.orange,
        startWidth: 15,
        endWidth: 15,
      ),
      GaugeRange(
        startValue: 30,
        endValue: 35,
        color: Colors.deepOrange,
        startWidth: 15,
        endWidth: 15,
      ),
      GaugeRange(
        startValue: 35,
        endValue: 40,
        color: Colors.red.shade400,
        startWidth: 15,
        endWidth: 15,
      ),
      GaugeRange(
        startValue: 40,
        endValue: 50,
        color: Colors.red.shade800,
        startWidth: 15,
        endWidth: 15,
      ),
    ];
  }
}
