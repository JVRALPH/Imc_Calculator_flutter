import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_application_3/infrastructure/models/imc_result.dart';
import 'package:flutter_application_3/presentation/providers/imc_form_provider.dart';
import 'package:flutter_application_3/presentation/widgets/form/custom_form_card.dart';
import 'package:flutter_application_3/presentation/widgets/shared/custom_imc_gauge.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_3/presentation/providers/tips_salud.dart';

class PageCheck extends StatelessWidget {
  final ImcResult result;

  const PageCheck({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final form = context.watch<ImcFormProvider>();
    final colors = Theme.of(context).colorScheme;
    final tips = HealthTipsUtils.getHealthTips(result);
    final size = MediaQuery.of(context).size;
    final textScale = size.width / 375;

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: colors.primary,
            size: 24 * textScale,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        iconTheme: IconThemeData(color: colors.primary),
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20 * textScale, vertical: 20 * textScale),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FormCard(
                widgetlist: [
                  Text(
                    'Registro IMC',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: colors.onPrimary,
                          fontSize: 22 * textScale,
                        ),
                  )
                ],
                alignment: CrossAxisAlignment.center,
                color: colors.primary,
              ),
              SizedBox(height: 20 * textScale),
              FormCard(
                widgetlist: [
                  CustomImcGauge(imcResult: result, animated: true),
                  Container(
                    padding: EdgeInsets.all(15 * textScale),
                    decoration: BoxDecoration(
                      color: form.getResultColor(result.imcValue).withAlpha(30),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.info_outline_rounded, color: form.getResultColor(result.imcValue), size: 24 * textScale),
                            SizedBox(width: 8 * textScale),
                            Text(
                              'Estado de Salud',
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16 * textScale,
                                    color: form.getResultColor(result.imcValue),
                                  ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8 * textScale),
                        Text(
                          result.healthMessage,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 14 * textScale),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 15 * textScale),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildDataItem(context, 'Altura', '${result.userProfile.height} ${form.heightUnit}', Icons.height_rounded, textScale),
                      _buildDataItem(context, 'Peso', '${result.userProfile.weight} ${form.weightUnit}', Icons.monitor_weight_outlined, textScale),
                      _buildDataItem(context, 'Edad', '${result.userProfile.age.toInt()} años', Icons.calendar_today_rounded, textScale),
                    ],
                  )
                ],
                alignment: CrossAxisAlignment.center,
                color: colors.surface,
              ),
              SizedBox(height: 24 * textScale),
              Text(
                'Tips para mejorar tu salud',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 20 * textScale,
                      color: colors.onSurface,
                    ),
              ).animate().fadeIn(duration: 500.ms, delay: 200.ms),
              SizedBox(height: 16 * textScale),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: tips.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 0,
                    margin: EdgeInsets.only(bottom: 12 * textScale),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    color: colors.surface,
                    child: Padding(
                      padding: EdgeInsets.all(16 * textScale),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.all(8 * textScale),
                            decoration: BoxDecoration(
                              color: colors.primary.withAlpha(30),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.lightbulb_outline, color: colors.primary, size: 20 * textScale),
                          ),
                          SizedBox(width: 16 * textScale),
                          Expanded(
                            child: Text(
                              tips[index],
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 14 * textScale),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ).animate().fadeIn(duration: 400.ms, delay: 300.ms + (index * 100).ms).slideY(begin: 0.1, end: 0, duration: 400.ms, delay: 300.ms + (index * 100).ms);
                },
              ),
              SizedBox(height: 16 * textScale),
              Container(
                padding: EdgeInsets.all(16 * textScale),
                decoration: BoxDecoration(
                  color: colors.secondary.withAlpha(30),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.calendar_today_outlined, color: colors.secondary, size: 20 * textScale),
                        SizedBox(width: 8 * textScale),
                        Text(
                          'Fecha de registro',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 16 * textScale,
                                color: colors.secondary,
                              ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8 * textScale),
                    Text(
                      result.formattedDate,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 14 * textScale),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 500.ms, delay: 500.ms),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDataItem(BuildContext context, String title, String value, IconData icon, double scale) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16 * scale, vertical: 12 * scale),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: colorScheme.primary, size: 24 * scale),
          SizedBox(height: 4 * scale),
          Text(value, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold, fontSize: 14 * scale)),
          Text(title, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: colorScheme.onSurface.withValues(alpha: 0.7), fontSize: 12 * scale)),
        ],
      ),
    );
  }
}
