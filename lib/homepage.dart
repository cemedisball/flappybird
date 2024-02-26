import 'dart:async';

import 'package:flappybirds/barrier.dart';
import 'package:flappybirds/bird.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static double birdYaxis = 0;
  double birdwidth = 0.1;
  double birdheight = 0.1;
  double time = 0;
  double height = 0;
  double initialHeight = birdYaxis;
  double gravity = -4.9;
  double velocity = 3.5;
  bool gameHasStarted = false;
  static double barrierwidth = 0.5;
  static List<double> barierX = [2, 2 + 1.5];
  List<List<double>> barrierheight = [
    [0.6, 0.4],
    [0.4, 0.6]
  ];
  int score = 0;
  int best = 0;

  void StartGame() {
    setState(() {
      score = 0; // Reset score when starting a new game
    });
    gameHasStarted = true;
    Timer.periodic(Duration(milliseconds: 10), (timer) {
      height = gravity * time * time + velocity * time;
      setState(() {
        birdYaxis = initialHeight - height;
      });
      if (birdIsDead()) {
        timer.cancel();
        _showDialog();
      }
      moveMap();
      if (birdYaxis < -1 || birdYaxis > 1) {
        timer.cancel();
        gameHasStarted = false;
      }
      time += 0.01;
    });
  }

  void moveMap() {
    for (int i = 0; i < barierX.length; i++) {
      setState(() {
        barierX[i] -= 0.005;
        if (barierX[i] < birdwidth && barierX[i] + 0.005 >= birdwidth) {
          // Increment the score when the bird passes the barrier
          score++;
        }
      });
      if (score > best) {
        setState(() {
          best = score;
        });
      }
      if (barierX[i] < -1.5) {
        barierX[i] += 3;
      }
    }
  }

  void resetGame() {
    Navigator.pop(context);
    setState(() {
      birdYaxis = 0;
      gameHasStarted = false;
      time = 0;
      initialHeight = birdYaxis;
      barierX = [2, 2 + 1.5];
    });
  }

  void _showDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.brown,
            title: Center(
              child: Text(
                "G A M E O V E R",
                style: TextStyle(color: Colors.white),
              ),
            ),
            actions: [
              GestureDetector(
                onTap: resetGame,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Container(
                    padding: EdgeInsets.all(7),
                    color: Colors.white,
                    child: Text(
                      'PLAY AGAIN',
                      style: TextStyle(color: Colors.brown),
                    ),
                  ),
                ),
              )
            ],
          );
        });
  }

  void jump() {
    setState(() {
      time = 0;
      initialHeight = birdYaxis;
    });
  }

  bool birdIsDead() {
    if (birdYaxis < -1 || birdYaxis > 1) {
      return true;
    }
    for (int i = 0; i < barierX.length; i++) {
      if (barierX[i] <= birdwidth &&
          barierX[i] + barrierwidth >= -birdwidth &&
          (birdYaxis <= -1 + barrierheight[i][0] ||
              birdYaxis + birdheight >= 1 - barrierheight[i][1])) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: gameHasStarted ? jump : StartGame,
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
                flex: 3,
                child: Container(
                  color: Colors.blue,
                  child: Center(
                    child: Stack(
                      children: [
                        MyBird(
                          birdYaxis: birdYaxis,
                          birdheight: birdheight,
                          birdwidth: birdwidth,
                        ),
                        Container(
                          alignment: Alignment(0, -0.5),
                          child: Text(
                            "T A P T O P L A Y",
                            style: TextStyle(fontSize: 30, color: Colors.white),
                          ),
                        ),
                        MyBarrier(
                          barierX: barierX[0],
                          barrierwidth: barrierwidth,
                          barrierheight: barrierheight[0][0],
                          isThisBottomBarrier: false,
                        ),
                        MyBarrier(
                          barierX: barierX[0],
                          barrierwidth: barrierwidth,
                          barrierheight: barrierheight[0][1],
                          isThisBottomBarrier: true,
                        ),
                        MyBarrier(
                          barierX: barierX[1],
                          barrierwidth: barrierwidth,
                          barrierheight: barrierheight[1][0],
                          isThisBottomBarrier: false,
                        ),
                        MyBarrier(
                          barierX: barierX[1],
                          barrierwidth: barrierwidth,
                          barrierheight: barrierheight[1][1],
                          isThisBottomBarrier: true,
                        ),
                      ],
                    ),
                  ),
                )),
            Container(
              height: 15,
              color: Colors.green,
            ),
            Expanded(
                child: Container(
              color: Colors.brown,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "SCORE",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "$score",
                        style: TextStyle(color: Colors.white, fontSize: 35),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "BEST",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "$best",
                        style: TextStyle(color: Colors.white, fontSize: 35),
                      ),
                    ],
                  )
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }
}
