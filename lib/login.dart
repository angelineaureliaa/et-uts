import 'package:flutter/material.dart';
import 'package:projectuts/class/mahasiswa.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart'; // supaya bisa akses main() & active_user

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LoginState();
  }
}

class _LoginState extends State<Login> {
  String _username = "";
  String _password = "";

  //simpan data mahasiswa ke SharedPreferences
  void doLogin() async {
    bool valid = false;

    for (var m in mahasiswas) {
      if (m.username == _username && m.password == _password) {
        final prefs = await SharedPreferences.getInstance();
        prefs.setString("username", m.username);
        prefs.setString("name", m.name);
        prefs.setString("photo", m.photo);

        active_user = m.username;
        active_name = m.name;
        active_photo = m.photo;
        valid = true;

        Navigator.pushNamed(context, 'main');
        break;
      }
    }

    if (!valid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Username atau password salah")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Container(
        height: 300,
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(30)),
          border: Border.all(width: 1),
          color: Colors.white,
          boxShadow: const [BoxShadow(blurRadius: 20)],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Username',
                  hintText: 'Enter valid username',
                ),
                onChanged: (v) {
                  _username = v;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                obscureText: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                  hintText: 'Enter secure password',
                ),
                onChanged: (v) {
                  _password = v;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: SizedBox(
                height: 50,
                width: 300,
                child: ElevatedButton(
                  onPressed: doLogin,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: const Text(
                    'Login',
                    style: TextStyle(fontSize: 25, color: Colors.white),
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
