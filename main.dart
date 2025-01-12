import 'package:flutter/material.dart';
import 'login_page.dart'; // Import the login page

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Animation controller for the pop animation
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    // Scale animation from 0 (invisible) to 1 (normal size) and then to 1.2 (pop effect)
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.2)
        .chain(CurveTween(curve: Curves.elasticOut)) // Elastic effect for a pop
        .animate(_animationController);

    _animationController.forward(); // Start the animation
  }

  @override
  void dispose() {
    _animationController.dispose(); // Dispose the animation controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Image.asset(
            'assets/main_image1.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          // Pop animation applied to the text
          Center(
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Image.asset(
                'assets/pawtext.png',
                width: 300, // Adjust width as per your design
                height: 300, // Adjust height as per your design
              ),
            ),
          ),
          // Positioned arrow to navigate to the login page
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: GestureDetector(
              onTap: () {
                // Navigate to the Login Page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: Icon(
                Icons.arrow_forward,
                size: 65,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false, // Disable debug banner
      home: MyHomePage(),
      theme: ThemeData(
        primarySwatch: Colors.green, // Add a custom theme if needed
      ),
    ),
  );
}
