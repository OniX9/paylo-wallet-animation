import 'package:flutter/material.dart';

class AtmCard extends StatelessWidget {
  final int index;
  final double? width;
  final double? height;
  final BoxFit? fit;

  const AtmCard({
    super.key,
    this.width,
    this.height,
    required this.index,
    this.fit = BoxFit.fitHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "ATM${index+1}",
      flightShuttleBuilder: (flightContext, animation, flightDirection,
          fromHeroContext, toHeroContext) {
        return RotationTransition(
          turns: animation.drive(
            Tween<double>(
              begin: 0.0,
              end: 0.25,
            ).chain(CurveTween(curve: Curves.easeInOut)),
          ),
          child: Image.asset('assets/card${index+1}.png'),
        );
      },
      child: Image.asset(
        'assets/card${index+1}.png',
        fit: fit,
        width: width,
        height: height,
        alignment: Alignment.centerRight,
      ),
    );
  }
}
