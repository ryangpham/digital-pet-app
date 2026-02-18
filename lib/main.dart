import 'package:flutter/material.dart';

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

  void _playWithPet() {
    setState(() {
      happinessLevel += 10;
      _updateHunger();
    });
  }

  void _feedPet() {
    setState(() {
      hungerLevel -= 10;
      _updateHappiness();
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
        child: Column(
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
