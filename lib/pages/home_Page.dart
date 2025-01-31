import 'dart:async';  
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pawcrastinot/pages/Task_Page.dart';
import 'package:pawcrastinot/pages/friends_page.dart';
import 'package:pawcrastinot/pages/game_page.dart';
import 'package:pawcrastinot/pages/leaderboard_page.dart';
import 'package:pawcrastinot/pages/store_page.dart';
import 'package:pawcrastinot/service/auth_service.dart';
import 'package:pawcrastinot/service/database_service.dart';
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
  AuthService authService = AuthService();
  StreamSubscription<DocumentSnapshot>? happinessListener;

  @override
  void initState() {
    super.initState();
    _initializeHomePage();
  }

  Future<void> _initializeHomePage() async {
    await Future.delayed(Duration(seconds: 2)); // ⏳ Show loading spinner
    fetchPetDetails();
    startDecay();
    _listenToHappinessUpdates();
  }

  @override
  void dispose() {
    happinessListener?.cancel();
    super.dispose();
  }

  // Fetch pet details from Firestore
  Future<void> fetchPetDetails() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final dbService = DatabaseService(uid: userId);
    try {
      String? fetchedPetName = await dbService.getPetName();
      String? fetchedPetImage = await dbService.getPetImage();

      if (mounted) {
        setState(() {
          petImage = fetchedPetImage;
          petName = fetchedPetName;
          _isLoading = false;
        });
      }
    } catch (err) {
      print("Error fetching pet details: $err");
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Listen to Firebase updates for happiness
  void _listenToHappinessUpdates() {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    happinessListener = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists) {
        double newHappiness = snapshot['happiness']?.toDouble() ?? 0.5;
        if (mounted) {
          setState(() {
            _happyProgress = newHappiness;
          });
        }
      }
    });
  }

  // Decrease happiness and hunger gradually
  void startDecay() {
    Timer.periodic(Duration(seconds: 3), (timer) {
      if (mounted) {
        setState(() {
          _happyProgress = (_happyProgress - 0.005).clamp(0.0, 1.0);
          _hungerProgress = (_hungerProgress - 0.005).clamp(0.0, 1.0);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator(color: Colors.green)), // ⏳ Show loading indicator
      );
    }

    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator(color: Colors.green));
            }
            if (!snapshot.hasData) {
              return Center(child: "null".text.make());
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
                    backgroundImage: petImage != null
                        ? AssetImage(petImage!)
                        : AssetImage("assets/default_pet.png"), // ✅ Prevents null error
                    backgroundColor: Colors.white,
                  ),
                  SizedBox(height: 10),
                  Text(
                    petName ?? "Your Pet",
                    style: GoogleFonts.spicyRice(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(32, 70, 13, 1.00),
                    ),
                  ),
                  SizedBox(height: 20),

                  // Happiness Bar
                  _buildProgressBar("😄", _happyProgress),

                  SizedBox(height: 20),

                  // Hunger Bar
                  _buildProgressBar("🍔", _hungerProgress),

                  SizedBox(height: 20),

                  // Buttons
                  _buildButtonRow(context, "TASKS", "GAMES"),
                  SizedBox(height: 20),
                  _buildButtonRow(context, "STORE", "LEADERBOARD"),
                  SizedBox(height: 20),
                  _buildButtonRow(context, "FRIENDS", "MORE"),
                ],
              ),
            );
          }),
      appBar: AppBar(
        title: Text(
          "PawCrastiNot",
          style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              color: Color.fromRGBO(32, 70, 13, 1.00),
              shadows: [Shadow(offset: Offset(0, 2), blurRadius: 3, color: Colors.black)]),
        ),
        backgroundColor: Color.fromRGBO(149, 249, 140, 1.00),
        centerTitle: true,
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

  Widget _buildProgressBar(String emoji, double progress) {
    return Row(
      children: [
        Text(emoji, style: TextStyle(fontSize: 20)).pOnly(left: 10),
        Expanded(
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey,
            minHeight: 15,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
          ).pOnly(left: 20, right: 20),
        ),
      ],
    );
  }

  Widget _buildButtonRow(BuildContext context, String text1, String text2) {
    return Row(
      children: [
        _buildButton(context, text1).pOnly(left: 20),
        _buildButton(context, text2).pOnly(left: 50),
      ],
    );
  }

  Widget _buildButton(BuildContext context, String text) {
    return GestureDetector(
      onTap: () {
        if (text == "TASKS") {
          Navigator.push(context, MaterialPageRoute(builder: (context) => TaskPage()));
        } else if (text == "STORE") {
          Navigator.push(context, MaterialPageRoute(builder: (context) => StoreScreen()));
        } else if (text == "FRIENDS") {
          Navigator.push(context, MaterialPageRoute(builder: (context) => FriendsScreen()));
        } else if (text == "GAMES") {
          Navigator.push(context, MaterialPageRoute(builder: (context) => GameMenuScreen()));
        } else if (text == "LEADERBOARD") {
          Navigator.push(context, MaterialPageRoute(builder: (context) => LeaderboardScreen()));
        } 
         
      },
      child: Container(
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
      ),
    );
  }
}  