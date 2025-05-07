import 'package:flutter/material.dart';

class WaveButtonCustom extends StatefulWidget {
  final Future<void> Function()? onTap;
  final String label;

  const WaveButtonCustom({
    super.key,
    required this.onTap,
    required this.label,
  });

  @override
  State<WaveButtonCustom> createState() => _WaveButtonCustomState();
}

class _WaveButtonCustomState extends State<WaveButtonCustom>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _wave;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _wave = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);

    _ctrl.addListener(() {
      if (mounted) setState(() {});
    });
  }

  Future<void> _handleTap() async {
    await _ctrl.forward(from: 0);
    _ctrl.reset();
    if (widget.onTap != null) {
      await widget.onTap!();
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: CustomPaint(
        foregroundPainter: _ctrl.isAnimating
            ? _RingPainter(
                progress: _wave,
                waves: 4,
                maxExpansion: 40,
              )
            : null,
        child: _buildButtonContent(),
      ),
    );
  }

  Widget _buildButtonContent() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFff960b).withAlpha(180),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withAlpha(180),
          width: 2,
        ),
      ),
      child: Text(
        widget.label,
        style: const TextStyle(
          color: Colors.white,
          fontFamily: 'Onest',
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final Animation<double> progress;
  final int waves;
  final double maxExpansion;

  _RingPainter({
    required this.progress,
    this.waves = 3,
    this.maxExpansion = 6,
  }) : super(repaint: progress);

  @override
  void paint(Canvas canvas, Size size) {
    final baseRadius = size.height / 2;

    for (int i = 0; i < waves; i++) {
      final local = (progress.value + i / waves) % 1;
      final expansion = local * maxExpansion;
      final alpha = (1 - local).clamp(0.0, 1.0) * progress.value;

      final paint = Paint()
        ..color = Colors.white.withValues(alpha: alpha)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;

      final rrect = RRect.fromRectAndRadius(
        Rect.fromLTRB(
          -expansion,
          -expansion,
          size.width + expansion,
          size.height + expansion,
        ),
        Radius.circular(baseRadius + expansion),
      );

      canvas.drawRRect(rrect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _RingPainter old) =>
      old.progress != progress || old.waves != waves;
}
