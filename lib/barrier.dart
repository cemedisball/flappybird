import 'package:flutter/material.dart';

class MyBarrier extends StatelessWidget {
  final barrierwidth;
  final barrierheight;
  final barierX;
  final bool isThisBottomBarrier;

  MyBarrier({
    this.barrierwidth,
    this.barrierheight,
    this.barierX,
    required this.isThisBottomBarrier,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment((2 * barierX + barrierwidth) / (2 - barrierwidth),
          isThisBottomBarrier ? 1 : -1),
      child: Container(
        color: Colors.green,
        width: MediaQuery.of(context).size.width * barrierwidth / 2,
        height: MediaQuery.of(context).size.height * 3 / 4 * barrierheight / 2,
      ),
    );
  }
}
