import 'package:flutter/material.dart';

class CustomElevatedBtn extends StatelessWidget {
  
  final String data;
  final VoidCallback onPress;
  final double elevation;
  final double borderRad;
  final IconData? icon;
  final bool isSelected;

  const CustomElevatedBtn({super.key, required this.data, required this.onPress, required this.elevation, required this.borderRad , this.icon, required this.isSelected});

  @override
  Widget build(BuildContext context) {

    final color = Theme.of(context).colorScheme;
    final textColor = Colors.white;
    
    return ElevatedButton(
      onPressed: onPress,
      style: ElevatedButton.styleFrom(
        backgroundColor: color.primary,
        foregroundColor: textColor,
        elevation: elevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRad),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
      ), 
      child: Text(data,
        style: TextStyle(
          fontFamily: 'Onest',
          fontSize: 25,
          color: textColor,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}