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

  int? _prodiId; // simpan prodi_id (int)
  List<Map<String, dynamic>> _prodiList = [];

  bool _loading = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _initData() async {
    setState(() => _loading = true);
    await _fetchProdiList();
    await _fetchUser();
    if (mounted) setState(() => _loading = false);
  }

  Future<int?> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt("id");
  }

  // bwt ambil prodi dari tabel prodi
  Future<void> _fetchProdiList() async {
    try {
      final response = await http.get(
        Uri.parse("https://ubaya.cloud/flutter/160422026/uas/listprodi.php"),
      );
      if (response.statusCode != 200)
        throw Exception("HTTP ${response.statusCode}");

      final Map<String, dynamic> json = jsonDecode(response.body);
      if (json["result"] == "success") {
        _prodiList = List<Map<String, dynamic>>.from(json["data"]);
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(json["message"] ?? "Gagal load prodi")),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error load prodi: $e")));
    }
  }

  // bwt smbil detail
  Future<void> _fetchUser() async {
    try {
      final userId = await _getUserId();
      if (userId == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("ID user tidak ditemukan di SharedPreferences"),
          ),
        );
        return;
      }

      final response = await http.post(
        Uri.parse(
          "https://ubaya.cloud/flutter/160422026/uas/detailmahasiswa.php",
        ),
        body: {"id": userId.toString()},
      );

      if (response.statusCode != 200)
        throw Exception("HTTP ${response.statusCode}");

      final Map<String, dynamic> json = jsonDecode(response.body);

      if (json["result"] == "success") {
        final Map<String, dynamic> data = json["data"][0];

        _nameController.text = (data["name"] ?? "").toString();
        _descController.text = (data["description"] ?? "").toString();
        _prodiId = int.tryParse((data["prodi_id"] ?? "").toString());
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(json["message"] ?? "Gagal ambil data user")),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  Future<void> _updateUser() async {
    final newName = _nameController.text.trim();
    final newDesc = _descController.text.trim();
    final prodiId = _prodiId;

    if (newName.isEmpty || prodiId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Nama dan Prodi wajib diisi.")),
      );
      return;
    }

    setState(() => _saving = true);

    try {
      final userId = await _getUserId();
      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("ID user tidak ditemukan.")),
        );
        return;
      }

      final response = await http.post(
        Uri.parse("https://ubaya.cloud/flutter/160422026/uas/editprofil.php"),
        body: {
          "id": userId.toString(),
          "name": newName,
          "prodi_id": prodiId.toString(),
          "description": newDesc,
        },
      );

      if (response.statusCode != 200)
        throw Exception("HTTP ${response.statusCode}");

      final Map<String, dynamic> json = jsonDecode(response.body);

      if (json["result"] == "success") {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("name", newName);
        await prefs.setString("description", newDesc);
        await prefs.setInt("prodi_id", prodiId); // optional

        if (!mounted) return;
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Berhasil"),
            content: const Text("Data berhasil diperbarui!"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // close dialog
                  Navigator.pop(context); // balik ke halaman sebelumnya
                },
                child: const Text("OK"),
              ),
            ],
          ),
        );
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(json["message"] ?? "Update gagal")),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      if (mounted) setState(() => _saving = false);
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
                    maxLines: 10,
                    decoration: const InputDecoration(labelText: "Deskripsi"),
                  ),

                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: _saving ? null : _updateUser,
                      child: _saving
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text("Simpan"),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
