import 'dart:async';  // Import to work with Timer
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:confetti/confetti.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pawcrastinot/helper/helper_function.dart';
import 'package:pawcrastinot/pages/Login_Page.dart';
import 'package:pawcrastinot/pages/Task_Page.dart';
import 'package:pawcrastinot/pages/pet_picker_page.dart';
import 'package:pawcrastinot/pages/store_page.dart'; // ✅ Import StorePage
import 'package:pawcrastinot/service/auth_service.dart';
import 'package:pawcrastinot/service/database_service.dart';
import 'package:pawcrastinot/widgets/widgets.dart';
import 'package:random_string/random_string.dart';
import 'package:velocity_x/velocity_x.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? petName;
  String? petImage;
  bool _isLoading = true;
  double _happyProgress = 0.5;
  double _hungerProgress = 0.7;
  double get happyProgress => _happyProgress;
  AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
    fetchPetDetails();
    startDecay();  // Call startDecay method
  }

  // Fetching pet details from the database
  Future<void> fetchPetDetails() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final dbService = DatabaseService(uid: userId);
    try {
      String? fetchedPetName = await dbService.getPetName();
      String? fetchedPetImage = await dbService.getPetImage();

      setState(() {
        petImage = fetchedPetImage;
        petName = fetchedPetName;
        _isLoading = false;
      });
    } catch (err) {
      print("Error fetching pet details: $err");
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Method to decrease the pet's happiness and hunger over time
  void startDecay() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        // Decrease happiness and hunger values (clamped to ensure no negative values)
        _happyProgress = (_happyProgress - 0.001).clamp(0.0, 1.0);
        _hungerProgress = (_hungerProgress - 0.001).clamp(0.0, 1.0);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.green,
                ),
              );
            }
            if (!snapshot.hasData) {
              return Center(
                child: "null".text.make(),
              );
            }
            var userDoc = snapshot.data!;
            _happyProgress = userDoc['happiness']?.toDouble() ?? 0.5;

            return Container(
              color: Color.fromRGBO(201, 251, 183, 1.0),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  SizedBox(height: 30),
                  CircleAvatar(
                    radius: 80,
                    backgroundImage: AssetImage(petImage!),
                    backgroundColor: Colors.white,
                  ),
                  SizedBox(height: 10),
                  Text(
                    "${petName}",
                    style: GoogleFonts.spicyRice(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(32, 70, 13, 1.00),
                    ),
                  ),
                  SizedBox(height: 20),

                  // Happiness Bar
                  Row(
                    children: [
                      Text("😄", style: TextStyle(fontSize: 20)).pOnly(left: 10),
                      Expanded(
                        child: Stack(
                          children: [
                            LinearProgressIndicator(
                              value: _happyProgress,
                              backgroundColor: Colors.grey,
                              minHeight: 15,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                            ).pOnly(left: 20, right: 20),
                            Positioned(
                              left: happyProgress * MediaQuery.of(context).size.width - 49,
                              top: 0,
                              bottom: 0,
                              child: Container(
                                child: Text(
                                  "${(_happyProgress * 100).toStringAsFixed(1)}%",
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black),
                                ),
                              ).pOnly(bottom: 1),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),

                  // Hunger Bar
                  Row(
                    children: [
                      Text("🍔", style: TextStyle(fontSize: 20)).pOnly(left: 10),
                      Expanded(
                        child: Stack(
                          children: [
                            LinearProgressIndicator(
                              value: _hungerProgress,
                              backgroundColor: Colors.grey,
                              minHeight: 15,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                            ).pOnly(left: 20, right: 20),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),

                  // Buttons Row
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          nextScreen(context, TaskPage());
                        },
                        child: _buildButton("TASKS"),
                      ).pOnly(left: 20),
                      GestureDetector(
                        onTap: () {},
                        child: _buildButton("GAMES"),
                      ).pOnly(left: 50),
                    ],
                  ),
                  SizedBox(height: 20),

                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                         nextScreen(context, StoreScreen());
                  
                        },
                        child: _buildButton("STORE"),
                      ).pOnly(left: 20),
                      GestureDetector(
                        onTap: () {},
                        child: _buildButton("LEADERBOARD"),
                      ).pOnly(left: 50),
                    ],
                  ),
                  SizedBox(height: 20),

                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: _buildButton("AVATAR"),
                      ).pOnly(left: 20),
                      GestureDetector(
                        onTap: () {},
                        child: _buildButton("MORE"),
                      ).pOnly(left: 50),
                    ],
                  ),
                ],
              ),
            );
          }),
      appBar: AppBar(
        title: Text(
          "  PawCrastiNot",
          style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              color: Color.fromRGBO(32, 70, 13, 1.00),
              shadows: [Shadow(offset: Offset(0, 2), blurRadius: 3, color: Colors.black)]),
        ),
        backgroundColor: Color.fromRGBO(149, 249, 140, 1.00),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.account_circle),
            iconSize: 30,
          )
        ],
      ),
    );
  }

  Widget _buildButton(String text) {
    return Container(
      child: Center(
        child: Text(
          text,
          style: GoogleFonts.spicyRice(
              fontWeight: FontWeight.bold, color: Color.fromRGBO(214, 255, 50, 1.00), fontSize: 20),
        ),
      ),
      height: 40,
      width: 150,
      decoration: BoxDecoration(
        color: Color.fromRGBO(96, 150, 75, 1),
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}
