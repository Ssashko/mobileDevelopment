import 'package:flutter/material.dart';
import 'package:g2048/game.dart';
import 'package:numberpicker/numberpicker.dart';

void main() {
  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  int score = 0;
  GameSizes size = GameSizes.sz4;
  ValueSetter<GameSizes>? _resetCallback;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.deepPurple,
              title: const Text('2048',
                  style: TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  )),
              actions: [
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                      margin: const EdgeInsets.all(16.0),
                      child: Text("Score: $score",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ))),
                )
              ],
            ),
            body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
              Row(
              mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Game dimension:", style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.deepPurple,
                  )),
                NumberPicker(
                  value: gameSizesToInt(size),
                  minValue: 3,
                  maxValue: 8,
                  step: 1,
                  itemHeight: 30,
                  itemWidth: 30,
                  axis: Axis.horizontal,
                  onChanged: (value) =>
                      setState(() => size = intToGameSizes(value)),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.deepPurple.withOpacity(0.75)
                  ),
                ),
                ElevatedButton(onPressed: () {
                  if(_resetCallback != null) {
                    setState(() {
                      _resetCallback!(size);
                      score = 0;
                    });
                  }
                },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple, // Background color
                  ),
                    child: const Text("restart"),
                )
              ],),
              Game(
                  callbackScore: (value) {
                    setState(() {
                      score = value;
                    });
                  },
                  callbackReset: (resetCallback) => _resetCallback = resetCallback
                  ,
                  size: size)
            ])),
        debugShowCheckedModeBanner: false);
  }
}
