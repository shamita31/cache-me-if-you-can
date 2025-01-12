import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:pawcrastinot/helper/helper_function.dart';
import 'package:pawcrastinot/pages/Login_Page.dart';
import 'package:pawcrastinot/pages/pet_picker_page.dart';
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
  late ConfettiController confettiController;
  AuthService authService = AuthService();
  bool suggest = false;
  TextEditingController todoController = TextEditingController();
  Stream? todoStream;

  Future<void> getOnTheLoad() async {
    todoStream = await DatabaseService().getTask("Tasks");
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getOnTheLoad();
    confettiController = ConfettiController(duration: Duration(seconds: 2));
  }

  @override
  void dispose() {
    confettiController.dispose();
  }

  @override
  Widget getWork() {
    return StreamBuilder(
      stream: todoStream,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data.docs.isEmpty) {
          return const Center(child: Text("No tasks available."));
        }

        return Expanded(
          child: ListView.builder(
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot docSnap = snapshot.data.docs[index];
              return CheckboxListTile(
                activeColor: Colors.yellow,
                title: Text(docSnap["Job"]),
                value: docSnap["Completed"],
                onChanged: (newValue) async {
                  try {
                    await DatabaseService()
                        .completeAndRemoveTask(docSnap["id"], "Tasks");
                    confettiController?.play();
                    await Future.delayed(Duration(seconds: 2));
                    setState(() {});
                  } catch (e) {
                    print("Error in upating ya removing task : $e");
                  }
                },
                controlAffinity: ListTileControlAffinity.leading,
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Colors.green, Colors.yellowAccent]),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            "Tasks".text.bold.black.center.make().pOnly(left: 180),
            getWork(),
            Center(
              child: ConfettiWidget(
                confettiController: confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                numberOfParticles: 20,
                gravity: 0.1,
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: Vx.black,
        child: const Icon(Icons.add, color: Vx.white),
        onPressed: () {
          openBox();
        },
      ),
      appBar: AppBar(
        backgroundColor: const Color(0xFF006400),
      ),
      drawer: Drawer(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 30,),
            Center(
              child: Text(
                "Drawer",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: "play",
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
            ),
            SizedBox(height: 20,),
            SizedBox( 
              height: 80,
              child: ElevatedButton.icon(
                label: Icon(Icons.logout),
                style: ElevatedButton.styleFrom(
                  elevation: 1,
                  backgroundColor: Vx.yellow100,
                  shadowColor: Vx.gray300,
                  shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(5))
                ),
              onPressed: () {
                authService.signOut();
                nextScreen(context, const LoginPage());
              },
            ).p12(),
            ),
            SizedBox(height: 20,),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 1,
                  backgroundColor: Vx.yellow100,
                  shadowColor: Vx.gray800,
                ),
                onPressed: (){nextScreen(context, PetPickerPage());}, 
                child: "Change Pet".text.bold.black.make()),
            )
            ],
          ),
        ),
      ),
    );
  }

  void openBox() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        insetPadding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.3,
            width: MediaQuery.of(context).size.width * 0.8,
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      child: const Icon(Icons.cancel, size: 30),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.amber[100],
                  ),
                  child: TextField(
                    controller: todoController,
                    autofocus: true,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Enter Task",
                      contentPadding: EdgeInsets.all(10),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: 100,
                  decoration: BoxDecoration(
                    color: Colors.greenAccent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      String id = randomAlphaNumeric(34);
                      Map<String, dynamic> userTodo = {
                        "Job": todoController.text,
                        "id": id,
                        "Completed": false,
                      };
                      DatabaseService().addTask(userTodo, id);
                      Navigator.pop(context);
                    },
                    child: "Add".text.center.black.make(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
