import 'package:flutter/material.dart';
import 'package:pawcrastinot/widgets/widgets.dart';
import 'greeting_page.dart';

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

  String? selectedPet;

  void _selectPet(String petName) {
    setState(() {
      selectedPet = petName;
    });
  }

  void _confirmSelection() {
    if (selectedPet == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a pet to continue!')),
      );
    } else {
      nextScreen(
        context,
        GreetingPage(selectedPet: selectedPet!),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pick Your Pet'),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: pets.length,
              itemBuilder: (context, index) {
                final pet = pets[index];
                final isSelected = selectedPet == pet['name'];
                return GestureDetector(
                  onTap: () => _selectPet(pet['name']!),
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isSelected ? Colors.green : Colors.grey,
                        width: 3,
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _confirmSelection,
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
