import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_3/config/theme/app_theme.dart';
import 'package:flutter_application_3/presentation/pages/page_start/page_start.dart';
import 'package:flutter_application_3/presentation/providers/imc_form_provider.dart';


void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ImcFormProvider(),
      child: const ImcApp(),
    ),
  );
}
class ImcApp extends StatelessWidget {
  const ImcApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'IMC App',
      theme: darkTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.dark,
      // themeMode: ThemeMode.system,
      // themeMode: ThemeMode.light,
      home: const ImcHomePage(),
    );
  }
}
