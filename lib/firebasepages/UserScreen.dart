import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../UserService/UserService.dart';
import '../models/usermodels.dart';
import 'AddUser.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final UserService _userService = UserService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Firestore CRUD"),
        centerTitle: true,
      ),
      body: StreamBuilder<List<UserModel>>(
        stream: _userService.getUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final users = snapshot.data ?? [];
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return ListTile(
                title: Text(user.name),
                subtitle: Text("Age: ${user.age}"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _showUserDialog(user: user),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        await _userService.deleteUser(user.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("User deleted")),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    const AddUser()), // Navigate to AddUser screen
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showUserDialog({UserModel? user}) {
    final TextEditingController nameController =
        TextEditingController(text: user?.name);
    final TextEditingController ageController =
        TextEditingController(text: user?.age.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(user == null ? "Add User" : "Edit User"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                    labelText: "Name",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: ageController,
                decoration: InputDecoration(
                    labelText: "Age",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                final String name = nameController.text.trim();
                final int age = int.tryParse(ageController.text.trim()) ?? 0;

                final String id = user?.id ?? const Uuid().v4();
                final newUser = UserModel(id: id, name: name, age: age);

                if (user == null) {
                  await _userService.addUser(newUser);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("User added")),
                  );
                } else {
                  await _userService.updateUser(newUser);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("User updated")),
                  );
                }

                Navigator.pop(context);
              },
              child: Text(user == null ? "Add" : "Update"),
            ),
          ],
        );
      },
    );
  }
}
