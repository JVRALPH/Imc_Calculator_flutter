import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class BuildInfoCard extends StatelessWidget {
  
  const BuildInfoCard({
    super.key,
    required this.title,
    required this.description,
    required this.color,
    required this.icon,
  });

  
  final String title;
  final String description;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {

    final colors = Theme.of(context).colorScheme;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: colors.surface
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon,color: color,),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: colors.onSurface.withValues(alpha: 0.7)),
                  )
                ],
              )
            ],
          ),
        ),
      ).animate()
      .fadeIn(duration: 500.ms,delay: 300.ms)
      .slideY(begin: 0.1,end: 0,duration: 300.ms,curve: Curves.easeOut),
    );
  }
}

                    