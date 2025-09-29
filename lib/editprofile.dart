import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'class/mahasiswa.dart';
import 'package:projectuts/main.dart';

//pakai stateful widget biar bisa melakukan perubahan pada data!
class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfile();
}

class _EditProfile extends State<EditProfile> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  String? _prodi;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nameController.text = prefs.getString("name") ?? "";
      _descController.text = prefs.getString("description") ?? "";
      _prodi = prefs.getString("prodi");
    });
  }

  Future<void> _saveUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("name", _nameController.text);
    await prefs.setString("prodi", _prodi ?? "");
    await prefs.setString("description", _descController.text);

    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text("Berhasil"),
        content: const Text("Data berhasil diperbarui!"),
        actions: [
          TextButton(
            onPressed: () {
              //Navigator.pop(context); // tutup dialog
              Navigator.popAndPushNamed(context, 'main'); // balik ke Home
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profile")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "Nama"),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              initialValue: _prodi,
              items: const [
                DropdownMenuItem(
                  value: "Informatika",
                  child: Text("Informatika"),
                ),
                DropdownMenuItem(
                  value: "Sistem Informasi",
                  child: Text("Sistem Informasi"),
                ),
                DropdownMenuItem(
                  value: "Teknik Komputer",
                  child: Text("Teknik Komputer"),
                ),
                DropdownMenuItem(
                  value: "Data Science",
                  child: Text("Data Science"),
                ),
                DropdownMenuItem(
                  value: "Cyber Security",
                  child: Text("Cyber Security"),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _prodi = value;
                });
              },
              decoration: const InputDecoration(labelText: "Program/Lab"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _descController,
              maxLines: 4,
              decoration: const InputDecoration(labelText: "Deskripsi"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveUserData,
              child: const Text("Simpan"),
            ),
          ],
        ),
      ),
    );
  }
}
