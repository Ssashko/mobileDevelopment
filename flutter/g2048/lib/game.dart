import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:g2048/gamelib/game.dart';

enum GameSizes { sz3, sz4, sz5, sz6, sz7, sz8 }

int gameSizesToInt(GameSizes sz) {
  int size = 0;
  switch (sz) {
    case GameSizes.sz3:
      size = 3;
      break;
    case GameSizes.sz4:
      size = 4;
      break;
    case GameSizes.sz5:
      size = 5;
      break;
    case GameSizes.sz6:
      size = 6;
      break;
    case GameSizes.sz7:
      size = 7;
      break;
    case GameSizes.sz8:
      size = 8;
  }
  return size;
}

GameSizes intToGameSizes(int i) {
  return GameSizes.values[i - 3];
}

class Game extends StatefulWidget {
  const Game(
      {super.key,
      required this.callbackScore,
      required this.callbackReset,
      required this.size});
  final ValueSetter<int> callbackScore;
  final ValueSetter<ValueSetter<GameSizes>> callbackReset;
  final GameSizes size;

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  bool delayed = false;
  final double sensitivity = 1.5;
  final int coolDown = 300;
  double get cellWidth => 80 * (4.0 / game.size);
  static const colorMap = [
    0xffffffff,
    0xffeee4da,
    0xffeee1c9,
    0xfff3b27a,
    0xfff69664,
    0xfff77c5f,
    0xfff75f3b,
    0xffedd073,
    0xffedcc62,
    0xffedc950,
    0xffedc53f,
    0xffedc22e
  ];
  late GameLogic2048 game = GameLogic2048(gameSizesToInt(widget.size), 3);

  @override
  void initState() {
    super.initState();
    widget.callbackReset((GameSizes sz) => setState(() {
          game.clear(gameSizesToInt(sz));
        }));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onVerticalDragUpdate: (details) {
          if (!delayed) {
            SwipeSide? side;
            if (details.delta.dy > sensitivity) {
              side = SwipeSide.bottom;
            } else if (details.delta.dy < -sensitivity) {
              side = SwipeSide.top;
            }
            if (side != null) {
              delayed = true;
              setState(() {
                game.step(side!);
                widget.callbackScore(game.score);
              });
              Timer(Duration(milliseconds: coolDown), () => delayed = false);
            }
          }
        },
        onHorizontalDragUpdate: (details) {
          if (!delayed) {
            SwipeSide? side;
            if (details.delta.dx > sensitivity) {
              side = SwipeSide.right;
            } else if (details.delta.dx < -sensitivity) {
              side = SwipeSide.left;
            }
            if (side != null) {
              delayed = true;
              setState(() {
                game.step(side!);
                widget.callbackScore(game.score);
              });
              Timer(Duration(milliseconds: coolDown), () => delayed = false);
            }

          }
        },
        child: Align(
            alignment: Alignment.center,
            child: Table(
                columnWidths: {
                  for (var v in List.generate(game.size, (i) => i))
                    v: FixedColumnWidth(cellWidth)
                },
                children: game.state
                    .map((gameRow) => TableRow(
                        children: gameRow
                            .map((element) => TableCell(
                                    child: Container(
                                  margin: const EdgeInsets.all(3),
                                  height: cellWidth,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10.0)),
                                    border: Border.all(
                                      color: Colors.deepPurple,
                                      width: 3.0,
                                    ),
                                    color: Color(
                                        colorMap[element % colorMap.length]),
                                  ),
                                  child: Center(
                                      child: Text(
                                    "${element == 0 ? 0 : pow(2, element)}",
                                    style: const TextStyle(
                                        decoration: TextDecoration.none,
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  )),
                                )))
                            .toList()))
                    .toList())));
  }
}
