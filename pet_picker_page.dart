import 'package:flutter/material.dart';
import 'greeting_page.dart'; // Import the Greeting page

class PetPickerPage extends StatefulWidget {
  @override
  _PetPickerPageState createState() => _PetPickerPageState();
}

class _PetPickerPageState extends State<PetPickerPage> {
  final List<Map<String, String>> pets = [
    {"name": "Simba", "image": "assets/simba.jpg"},
    {"name": "Shelly", "image": "assets/shelly.jpg"},
    {"name": "Bambi", "image": "assets/bambi.jpg"},
    {"name": "Bunny", "image": "assets/bunny.jpg"},
    {"name": "Bruno", "image": "assets/bruno.jpg"},
    {"name": "Whispers", "image": "assets/whispers.jpg"},
  ];

  String? selectedPet; // To store the selected pet name

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pick Your Pet'),
        backgroundColor: Colors.green, // Adjust as per theme
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Two pets per row
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: pets.length,
              itemBuilder: (context, index) {
                final pet = pets[index];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedPet = pet['name']; // Store selected pet
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: selectedPet == pet['name']
                            ? Colors.green // Highlight selected pet
                            : Colors.grey,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: AssetImage(pet['image']!),
                        fit: BoxFit.cover,
                      ),
                    ),
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      color: Colors.black54,
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        pet['name']!,
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // Button to proceed after selection
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: selectedPet != null
                  ? () {
                      // When the user selects a pet and confirms:
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              GreetingPage(selectedPet: selectedPet!),
                        ),
                      );
                    }
                  : null, // Disable button if no pet selected
              child: Text('Confirm Selection'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                disabledBackgroundColor: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
