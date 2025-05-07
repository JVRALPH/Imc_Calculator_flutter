import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class FormCard extends StatelessWidget {
  
  const FormCard({
    super.key,
    required this.widgetlist, required this.alignment, required this.color,
  });

  final List<Widget> widgetlist;
  final CrossAxisAlignment alignment;
  final Color color; 

  @override
  Widget build(BuildContext context) {
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(5),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              colors: [
                color.withValues(alpha: 0.8),
                color,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  spacing: 5,
                  crossAxisAlignment: alignment,
                  children: [
                    ...widgetlist,
                  ],
                ),
              ),
            ],
          )
        ).animate()
        .fadeIn(duration: 500.ms,delay: 300.ms)
        .slideY(begin: 0.1,end: 0,duration: 300.ms,curve: Curves.easeOut),
      ),
    );
  }
}

                    