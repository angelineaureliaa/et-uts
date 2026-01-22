import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  int? _prodiId;
  List<Map<String, dynamic>> _prodiList = [];

  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    await _fetchProdiList();
    await _fetchUser();
    setState(() => _loading = false);
  }

  // ambil daftar prodi
  Future<void> _fetchProdiList() async {
    try {
      final response = await http.get(
        Uri.parse("https://ubaya.cloud/flutter/160422026/uas/listprodi.php"),
      );

      final json = jsonDecode(response.body);

      if (json["result"] == "success") {
        _prodiList = List<Map<String, dynamic>>.from(json["data"]);
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal load prodi")));
    }
  }

  // ambil detail mahasiswa login
  Future<void> _fetchUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt("id");

      if (userId == null) return;

      final response = await http.post(
        Uri.parse(
          "https://ubaya.cloud/flutter/160422026/uas/detailmahasiswa.php",
        ),
        body: {"id": userId.toString()},
      );

      final json = jsonDecode(response.body);

      if (json["result"] == "success") {
        final data = json["data"][0];

        _nameController.text = data["name"] ?? "";
        _descController.text = data["description"] ?? "";
        _prodiId = int.parse(data["prodi_id"].toString());
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal ambil data user")));
    }
  }

  // update profile
  Future<void> _updateUser() async {
    final newName = _nameController.text.trim();
    final newDesc = _descController.text.trim();

    if (newName.isEmpty || _prodiId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Nama dan Prodi wajib diisi.")),
      );
      return;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt("id");

      if (userId == null) return;

      final response = await http.post(
        Uri.parse("https://ubaya.cloud/flutter/160422026/uas/editprofil.php"),
        body: {
          "id": userId.toString(),
          "name": newName,
          "prodi_id": _prodiId.toString(),
          "description": newDesc,
        },
      );

      final json = jsonDecode(response.body);

      if (json["result"] == "success") {
        await prefs.setString("name", newName);
        await prefs.setString("description", newDesc);
        await prefs.setInt("prodi_id", _prodiId!);

        showDialog(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: const Text("Berhasil"),
            content: const Text("Data berhasil diperbarui!"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext); // tutup dialog
                  Navigator.pop(context); // balik halaman
                },
                child: const Text("OK"),
              ),
            ],
          ),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Update gagal")));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Terjadi kesalahan saat update")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profile")),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: "Nama"),
                  ),

                  const SizedBox(height: 10),

                  DropdownButtonFormField<int>(
                    value: _prodiId,
                    items: _prodiList.map((p) {
                      return DropdownMenuItem<int>(
                        value: int.parse(p["id"].toString()),
                        child: Text(p["name"].toString()),
                      );
                    }).toList(),
                    onChanged: (value) => setState(() => _prodiId = value),
                    decoration: const InputDecoration(labelText: "Program/Lab"),
                  ),

                  const SizedBox(height: 10),

                  TextField(
                    controller: _descController,
                    maxLines: 5,
                    decoration: const InputDecoration(labelText: "Deskripsi"),
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: _updateUser,
                      child: const Text("Simpan"),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
