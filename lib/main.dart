import 'package:flutter/material.dart';
import 'package:projectuts/login.dart';
//dependeciesnya ada di file pubspec.yaml
import 'package:shared_preferences/shared_preferences.dart';

String active_user = "";
String active_name = "";
String active_photo = "";

Future<String> checkUser() async {
  final prefs = await SharedPreferences.getInstance();
  String username = prefs.getString("username") ?? '';
  return username;
}

Future<void> initUser() async {
  final prefs = await SharedPreferences.getInstance();
  active_user = prefs.getString("username") ?? "";
  active_name = prefs.getString("name") ?? "Guest";
  active_photo = prefs.getString("photo") ?? "https://i.pravatar.cc/150";
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  checkUser().then((String result) {
    //jika result kosong artinya belum login
    if (result == '') {
      runApp(
        MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Login(),
          routes: { 'login': (context) => Login(), 
                    'main': (context) => const MyApp(), },
        ),
      );
    } else {
      active_user = result;
      runApp(const MyApp());
    }
  });
}

void doLogout() async {
  final prefs = await SharedPreferences.getInstance();
  prefs.remove("username");
  main();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: "Home Page"),
      routes: {
        'login': (context) => Login(),
        'main': (context) => const MyHomePage(title: "Home Page"),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),

      drawer: myDrawer(),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[const Text('List Mahasiwa uhuy')],
        ),
      ),
    );
  }

  Widget myDrawer() {
    return Drawer(
      elevation: 16.0,
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(active_name),
            accountEmail: null,
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(active_photo),
            ),
          ),
          ListTile(
            title: const Text("List Mahasiswa"),
            leading: const Icon(Icons.people),
            onTap: () {},
          ),
          ListTile(
            title: const Text("Edit Profile"),
            leading: const Icon(Icons.edit),
            onTap: () {},
          ),
          ListTile(
            title: const Text("Log Out"),
            leading: const Icon(Icons.logout),
            onTap: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              active_user = "";
              active_name = "Guest";
              active_photo = "https://i.pravatar.cc/150";

              Navigator.pushNamed(context, 'login');
            },
          ),
        ],
      ),
    );
  }
}
