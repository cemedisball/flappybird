import 'package:flutter/material.dart';

class MyBird extends StatelessWidget {
  final birdYaxis;
  final double birdwidth;
  final double birdheight;
  const MyBird({
    this.birdYaxis,
    required this.birdwidth,
    required this.birdheight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(0, (2 * birdYaxis + birdheight) / (2 - birdheight)),
      child: Image.asset(
        'lib/images/fapd.png',
        width: MediaQuery.of(context).size.height * birdheight / 2,
        height: MediaQuery.of(context).size.height * 3 / 4 * birdheight / 2,
        fit: BoxFit.fill,
      ),
    );
  }
}
