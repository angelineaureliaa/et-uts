import 'package:flutter/material.dart';
import 'package:projectuts/class/mahasiswa.dart';
import 'package:projectuts/contacts.dart';
import 'package:projectuts/detailstudent.dart';
import 'package:projectuts/login.dart';
import 'package:projectuts/request.dart';
//dependeciesnya ada di file pubspec.yaml
import 'package:shared_preferences/shared_preferences.dart';
import 'package:projectuts/editprofile.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

String active_user = "";
String active_name = "";
String active_photo = "";
String active_email = "";

Future<String> checkUser() async {
  final prefs = await SharedPreferences.getInstance();
  String email = prefs.getString("email") ?? '';
  return email;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  checkUser().then((String result) {
    //jika result kosong artinya belum login
    if (result == '') {
      runApp(
        MaterialApp(
          home: Login(),
          routes: {
            'login': (context) => Login(),
            'main': (context) => const MyApp(),
          },
        ),
      );
    } else {
      active_user = result;
      runApp(const MyApp());
    }
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
      ),
      home: const MyHomePage(title: "Home Page"),
      //ini routes buat navbar!
      routes: {
        'login': (context) => Login(),
        'main': (context) => const MyHomePage(title: "List Mahasiswa"),
        'contact': (context) => Contact(),
        'request': (context) => Requests(),
        'edit': (context) => const EditProfile(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

//INI BUATTT LIST MAHASSIWA YAH FRENS
class _MyHomePageState extends State<MyHomePage> {
  String name = "";
  String email = "";
  String photo = "";
  List<Widget> listMahasiswa = [];

  @override
  void initState() {
    super.initState();
    _loadActiveUser();
    _loadMahasiswa();
  }

  Future<void> _loadActiveUser() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString("name") ?? "";
      email = prefs.getString("email") ?? "";
      photo = prefs.getString("photo") ?? "";
    });
  }

  Future<void> _loadMahasiswa() async {
    var data = await detailMahasiswa(context);
    setState(() {
      listMahasiswa = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Daftar Mahasiswa"),
      ),

      drawer: myDrawer(context),

      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: listMahasiswa.isEmpty
                  ? [
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    ]
                  : listMahasiswa,
            ),
          ],
        ),
      ),
    );
  }

  Widget myDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: Colors.white),
            accountName: Text(
              name,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            accountEmail: Text(
              active_email,
              style: const TextStyle(color: Color.fromARGB(255, 100, 100, 100)),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(active_photo),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              "Menu",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home, color: Colors.black),
            title: const Text("Home"),
            onTap: () {
              Navigator.pushNamed(context, 'home');
            },
          ),
          ListTile(
            leading: const Icon(Icons.contacts, color: Colors.black),
            title: const Text("Contacts"),
            onTap: () {
              Navigator.pushNamed(context, 'contact');
            },
          ),
          ListTile(
            leading: const Icon(Icons.request_quote, color: Colors.black),
            title: const Text("Request"),
            onTap: () {
              Navigator.pushNamed(context, 'request');
            },
          ),
          ListTile(
            leading: const Icon(Icons.person, color: Colors.black),
            title: const Text("Edit Profile"),
            onTap: () {
              Navigator.pushNamed(context, 'edit');
              _loadActiveUser();
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text("Log Out", style: TextStyle(color: Colors.red)),
            onTap: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.clear();

              Navigator.pushNamedAndRemoveUntil(
                context,
                'login',
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}

Future<List<Widget>> detailMahasiswa(BuildContext context) async {
  List<Widget> temp = [];

  final response = await http.get(
    Uri.parse("https://ubaya.cloud/flutter/160422026/uas/listmahasiswa.php"),
  );

  if (response.statusCode == 200) {
    var json = jsonDecode(response.body);

    if (json['result'] == 'success') {
      List data = json['data'];

      for (int i = 0; i < data.length; i++) {
        var m = data[i];

        Widget w = Container(
          margin: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: const Color.fromRGBO(128, 128, 128, 0.5),
                spreadRadius: -6,
                blurRadius: 8,
                offset: const Offset(8, 7),
              ),
            ],
          ),
          child: Card(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(
                        m['name'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        width: 100,
                        height: 100,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            m['photo'],
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.person, size: 60),
                          ),
                        ),
                      ),

                      Text(
                        "NRP: ${m['nrp']}",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color.fromARGB(255, 86, 85, 85),
                        ),
                      ),

                      Text(
                        "Prodi: ${m['prodi_name']}",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color.fromARGB(255, 86, 85, 85),
                        ),
                      ),

                      const SizedBox(height: 10),

                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Detailstudent(
                                idMahasiswa: int.parse(m['id']),
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(
                            255,
                            248,
                            188,
                            206,
                          ),
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text("Lihat Detail Profil"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );

        temp.add(w);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(json['message'] ?? "Gagal memuat data mahasiswa"),
        ),
      );
    }
  } else {
    throw Exception('Failed to read API');
  }
  return temp;
}
