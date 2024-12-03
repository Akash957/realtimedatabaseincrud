import 'package:flutter/material.dart';
import '../models/usermodels.dart';
import '../UserService/UserService.dart';

class AddUser extends StatefulWidget {
  const AddUser({super.key});

  @override
  _AddUserState createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  final UserService _userService = UserService();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add User"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: nameController,
              decoration:  InputDecoration(labelText: "Name",border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20)
              )),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: ageController,
              decoration:  InputDecoration(labelText: "Age",border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              )),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final String name = nameController.text.trim();
                final int age = int.tryParse(ageController.text.trim()) ?? 0;

                if (name.isNotEmpty && age > 0) {
                  final newUser = UserModel(
                    id: DateTime.now().toString(),
                    name: name,
                    age: age,
                  );
                  await _userService.addUser(newUser);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("User added")),
                  );
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please enter valid details")),
                  );
                }
              },
              child: const Text("Add User"),
            ),
          ],
        ),
      ),
    );
  }
}
