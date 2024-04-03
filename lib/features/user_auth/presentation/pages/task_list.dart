import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TaskListPage extends StatefulWidget {
  const TaskListPage({Key? key}) : super(key: key);

  @override
  _TaskListPageState createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _taskController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _taskController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tareas"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildInputField("Tarea para...", _nameController),
            _buildInputField("Tarea a realizar", _taskController),
            _buildInputField("Fecha límite para realizarla", _dateController),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _createData(UserModel(
                  name: _nameController.text,
                  task: _taskController.text,
                  date: int.tryParse(_dateController.text) ?? 0,
                ));
              },
              child: const Text("Añadir Tarea"),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _buildUserList(),
            ),
            const SizedBox(height: 20),

          ],
        ),
      ),
    );
  }

  Widget _buildInputField(String placeholder, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: placeholder,
        ),
      ),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder<List<UserModel>>(
      stream: _readData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final users = snapshot.data ?? [];
        return ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            return ListTile(
              title: Text(user.name ?? ''),
              subtitle: Text(user.task ?? ''),
              trailing: Text(user.date != null ? _formatDate(user.date!) : ''),
            );
          },
        );
      },
    );
  }

  String _formatDate(int date) {
    // Convert integer date to a DateTime object
    DateTime dateTime = DateTime.parse(date.toString().padLeft(8, '0'));

    // Format the DateTime object to a readable string
    return "${dateTime.day}/${dateTime.month}/${dateTime.year}";
  }

  Stream<List<UserModel>> _readData() {
    final userCollection = FirebaseFirestore.instance.collection("users");

    return userCollection.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList());
  }

  void _createData(UserModel userModel) {
    final userCollection = FirebaseFirestore.instance.collection("users");

    final id = userCollection.doc().id; // Use final instead of String

    final newUser = userModel.toJson();

    userCollection.doc(id).set(newUser);
  }

  void _updateData(UserModel userModel) {
    final userCollection = FirebaseFirestore.instance.collection("users");

    final newData = userModel.toJson();

    if (userModel.id != null) {
      userCollection.doc(userModel.id!).update(newData);
    }
  }

  void _deleteData(String? id) {
    if (id != null) {
      final userCollection = FirebaseFirestore.instance.collection("users");
      userCollection.doc(id).delete();
    }
  }
}

class UserModel {
  final String? name;
  final String? task;
  final int? date;
  final String? id;

  UserModel({this.id, this.name, this.task, this.date});

  static UserModel fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return UserModel(
      name: snapshot.data()?['name'],
      task: snapshot.data()?['task'],
      date: snapshot.data()?['date'],
      id: snapshot.id, // Accessing document ID directly
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "task": task,
      "id": id,
      "date": date,
    };
  }
}
