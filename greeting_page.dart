import 'package:flutter/material.dart';
import 'dart:async';

class GreetingPage extends StatefulWidget {
  final String selectedPet;

  GreetingPage({required this.selectedPet});

  @override
  _GreetingPageState createState() => _GreetingPageState();
}

class _GreetingPageState extends State<GreetingPage> {
  late String _displayedText = '';
  late String _fullText =
      'Ready to start your productivity journey\nwith Paw-crasti-not and your buddy ${widget.selectedPet}!\nLet’s crush those goals together!';
  late int _charIndex = 0;

  @override
  void initState() {
    super.initState();
    _startTypewriterAnimation();
  }

  // Function to start the typewriter animation
  void _startTypewriterAnimation() {
    Timer.periodic(Duration(milliseconds: 100), (timer) {
      if (_charIndex < _fullText.length) {
        setState(() {
          _displayedText += _fullText[_charIndex];
          _charIndex++;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Greetings!',
          style: TextStyle(
            fontFamily: 'play', // Correct font name (lowercase)
            fontSize: 20, // Adjust if needed
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background_image.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Display the animated text with typewriter effect
                Text(
                  _displayedText,
                  style: TextStyle(
                    fontSize: 26, // Adjusted font size for a smaller display
                    color: Colors.lightGreen,
                    fontFamily: 'play', // Correct font name (lowercase)
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30),
                // Add a horizontal arrow below the message
                Icon(
                  Icons.arrow_forward,
                  size: 50,
                  color: Colors.black26,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
