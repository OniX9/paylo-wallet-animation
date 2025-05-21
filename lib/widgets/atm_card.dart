import 'package:flutter/material.dart';

class AtmCard extends StatelessWidget {
  final double? width;
  final double? height;
  final BoxFit? fit;

  const AtmCard({
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.fitHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "ATM",
      flightShuttleBuilder: (flightContext, animation, flightDirection,
          fromHeroContext, toHeroContext) {
        return RotationTransition(
          turns: animation.drive(
            Tween<double>(
              begin: 0.0,
              end: 0.25,
            ).chain(CurveTween(curve: Curves.easeInOut)),
          ),
          child: Image.asset('assets/card.png'),
        );
      },
      child: Image.asset(
        'assets/card.png',
        fit: fit,
        width: width,
        height: height,
        alignment: Alignment.centerRight,
      ),
    );
  }
}
