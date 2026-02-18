import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(MaterialApp(
    home: DigitalPetApp(),
  ));
}

class DigitalPetApp extends StatefulWidget {
  @override
  _DigitalPetAppState createState() => _DigitalPetAppState();
}

class _DigitalPetAppState extends State<DigitalPetApp> {
  String petName = "Your Pet";
  int happinessLevel = 50;
  int hungerLevel = 50;
  TextEditingController _nameController = TextEditingController();
  Timer? _timer;
  Timer? _winTimer;
  bool _gameOver = false;
  bool _gameWon = false;
  int _happySeconds = 0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 30), (Timer t) {
      setState(() {
        hungerLevel += 2;
        if (hungerLevel > 100) {
          hungerLevel = 100;
        }
        _checkLossCondition();
      });
    });
    _winTimer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      if (_gameOver || _gameWon) return;
      setState(() {
        if (happinessLevel > 80) {
          _happySeconds++;
          if (_happySeconds >= 180) {
            _gameWon = true;
            _timer?.cancel();
            _winTimer?.cancel();
          }
        } else {
          _happySeconds = 0;
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _winTimer?.cancel();
    _nameController.dispose();
    super.dispose();
  }

  void _checkLossCondition() {
    if (hungerLevel >= 100 && happinessLevel <= 10) {
      _gameOver = true;
      _timer?.cancel();
      _winTimer?.cancel();
    }
  }

  void _playWithPet() {
    if (_gameOver || _gameWon) return;
    setState(() {
      happinessLevel += 10;
      _updateHunger();
      _checkLossCondition();
    });
  }

  void _feedPet() {
    if (_gameOver || _gameWon) return;
    setState(() {
      hungerLevel -= 10;
      _updateHappiness();
      _checkLossCondition();
    });
  }

  void _updateHappiness() {
    if (hungerLevel < 30) {
      happinessLevel -= 20;
    } else {
      happinessLevel += 10;
    }
  }

  void _updateHunger() {
    setState(() {
      hungerLevel += 5;
      if (hungerLevel > 100) {
        hungerLevel = 100;
        happinessLevel -= 20;
      }
    });
  }

  Color _moodColor(double happinesslevel) {
    if (happinessLevel > 70) {
      return Colors.green;
    } else if (happinessLevel >= 30) {
      return Colors.yellow;
    } else {
      return Colors.red;
    }
  }

  String _moodText(double happinessLevel) {
    if (happinessLevel > 70) {
      return "Happy";
    } else if (happinessLevel >= 30) {
      return "Neutral";
    } else {
      return "Sad";
    }
  }

  String _moodEmoji(double happinessLevel) {
    if (happinessLevel > 70) {
      return "😊";
    } else if (happinessLevel >= 30) {
      return "😐";
    } else {
      return "😢";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Digital Pet'),
      ),
      body: Center(
        child: _gameOver
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Game Over!', style: TextStyle(fontSize: 36.0, fontWeight: FontWeight.bold, color: Colors.red)),
                SizedBox(height: 16.0),
                Text('Your pet\'s hunger reached 100 and happiness dropped to 10.', style: TextStyle(fontSize: 16.0), textAlign: TextAlign.center),
              ],
            )
          : _gameWon
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('You Win!', style: TextStyle(fontSize: 36.0, fontWeight: FontWeight.bold, color: Colors.green)),
                  SizedBox(height: 16.0),
                  Text('Your pet stayed happy for 3 minutes!', style: TextStyle(fontSize: 16.0)),
                ],
              )
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Name: $petName', style: TextStyle(fontSize: 20.0)),
            SizedBox(height: 16.0),
            Text('Happiness Level: $happinessLevel', style: TextStyle(fontSize: 20.0)),
            SizedBox(height: 16.0),
            Text('Hunger Level: $hungerLevel', style: TextStyle(fontSize: 20.0)),
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: _playWithPet,
              child: Text('Play with Your Pet'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _feedPet,
              child: Text('Feed Your Pet'),
            ),
            ColorFiltered(
              colorFilter: ColorFilter.mode(
                _moodColor(happinessLevel.toDouble()),
                BlendMode.modulate,
              ),
              child: Image.asset('assets/pet_image.png', height: 120),
            ),
            SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(_moodText(happinessLevel.toDouble()), style: TextStyle(fontSize: 18.0)),
                SizedBox(width: 8.0),
                Text(_moodEmoji(happinessLevel.toDouble()), style: TextStyle(fontSize: 18.0)),
              ],
            ),
            SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: "Enter Pet Name",
                      ),
                    ),
                  ),
                  SizedBox(width: 8.0),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        petName = _nameController.text;
                      });
                    },
                    child: Text('Set Name'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
