import 'package:flutter/material.dart';
import 'package:flutter_application_3/presentation/pages/page_form/page_form.dart';
import 'package:flutter_application_3/presentation/widgets/wave_button.dart';

class ImcHomePage extends StatelessWidget {
  const ImcHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: StartWidget(),
    );
  }
}

class StartWidget extends StatelessWidget {
  const StartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/bg_start3.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "IMC - \nTracker",
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      fontSize: size.width * 0.15,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(color: Colors.white.withValues(alpha: 0.9), blurRadius: 30),
                        Shadow(color: Colors.white.withValues(alpha:0.5), blurRadius: 60),
                        Shadow(
                          color: Colors.white.withValues(alpha: 0.3),
                          blurRadius: 90,
                        ),
                      ],
                    ),
              ),
              const SizedBox(height: 40),
              WaveButtonCustom(
                label: "Comenzar",
                onTap: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const PageForm()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
