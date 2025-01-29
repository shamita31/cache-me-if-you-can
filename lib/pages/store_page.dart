import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const PawcrastinotStore());
}

class PawcrastinotStore extends StatelessWidget {
  const PawcrastinotStore({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StoreScreen(),
    );
  }
}

class StoreScreen extends StatefulWidget {
  @override
  _StoreScreenState createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  int selectedItemIndex = -1;

  final List<Map<String, dynamic>> items = [
    {"image": "assets/cookies.png", "price": "\$100"},
    {"image": "assets/egg.png", "price": "\$150"},
    {"image": "assets/hotdoggg.png", "price": "\$200"},
    {"image": "assets/friess.png", "price": "\$300"},
    {"image": "assets/burgerrr.png", "price": "\$400"},
    {"image": "assets/pizzaaa.png", "price": "\$500"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFE5B4),
      appBar: AppBar(
        title: Text(
          "PawCrastiNot",
          style: GoogleFonts.sansita(
            fontSize:40,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
            color: Color.fromARGB(255, 68, 47, 12),
            shadows: [Shadow(offset: Offset(0, 2), blurRadius: 3, color: Colors.black)],
          ),
        ),
        backgroundColor: Color.fromRGBO(227, 175, 64, 1),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.account_circle),
            iconSize: 30,
          )
        ],
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 30),
            Text(
              "STORE",
              style: GoogleFonts.spicyRice(
                fontSize:35,
                
                fontStyle: FontStyle.italic,
                color: const Color.fromARGB(255, 71, 38, 3),
                shadows: [Shadow(offset: Offset(0, 2), blurRadius: 3, color: Colors.black)],
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Center(
                  child: GridView.builder(
                    shrinkWrap: true,
                    itemCount: items.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.7,
                    ),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedItemIndex = index;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: selectedItemIndex == index
                                ? Border.all(color: Colors.black, width: 2)
                                : null,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 4,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Center(
                                  child: Image.asset(items[index]["image"], height: 110),
                                ),
                              ),
                              const SizedBox(height: 3),
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                                decoration: BoxDecoration(
                                  color: Colors.brown,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  items[index]["price"],
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: selectedItemIndex == -1 ? null : () {},
                  child: const Text(
                    "BUY",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}