import 'package:flutter/material.dart';
import 'package:projectuts/class/mahasiswa.dart';
import 'package:projectuts/detailstudent.dart';
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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  checkUser().then((String result) {
    //jika result kosong artinya belum login
    if (result == '') {
      runApp(
        MaterialApp(
          debugShowCheckedModeBanner: false,
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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: "Home Page"),
      //ini routes buat navbar!
      routes: {
        'login': (context) => Login(),
        'main': (context) => const MyHomePage(title: "List Mahasiswa"),
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
        title: Text("Daftar Mahasiswa"),
      ),

      drawer: myDrawer(),

      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              //isi listviewnya apa aja!
              //panggil dari method detailMahasiswa, tampilan diatur di method ini
              //kirim parameter berupa context, biar nnti dia bisa direct ke page detail student!
              children: detailMahasiswa(context),
            ),
          ],
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
              prefs.clear();
              Navigator.pushNamed(context, 'login');
            },
          ),
        ],
      ),
    );
  }
}

//method dummy buat testing ke detail student!
//kasih parameter, supaya dia bs terima context!
List<Widget> detailMahasiswa(BuildContext context) {
  //utk menampung data sementara
  List<Widget> temp = [];

  //set initial value utk i >> var counter
  int _counter = 0;

  while (_counter < mahasiswas.length) {
    //utk tiap data di mahasiswa,
    //buat button yang mengarahkan ke nnti detail mahasiswa!
    //pertama buat containernya dulu!
    //setiap kali loop nilai value current index sama kayak counter saat itu!
    final int _currentIndex = _counter;

    Widget w = Container(
      margin: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(128, 128, 128, 0.5),
            spreadRadius: -6,
            blurRadius: 8,
            offset: const Offset(8, 7),
          ),
        ],
      ),

      child: Card(
        //krn card itu cmn bs punya 1 child aja, jadi dia hrs pake column
        //baru columnya pny children!
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    mahasiswas[_currentIndex].name,
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
                      child: Image.asset(
                        mahasiswas[_currentIndex].photo,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  Text(
                    "NRP: ${mahasiswas[_currentIndex].nrp}",
                    style: const TextStyle(fontSize: 14, color: Color.fromARGB(255, 94, 93, 93)),
                  ),

                  const SizedBox(height: 10),

                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        //urutan hrs diperhatiin sesuai gimana cara declare constructornya
                        context,
                        MaterialPageRoute(
                          //karena value data berubah-ubah sesuai yg iterasi saat ini, maka jgn pake const!
                          //klo pake const dia akan error!
                          builder: (context) =>
                              Detailstudent
                              //kirim data urut berupa id, name, prodi, desc, photo
                              (
                                mahasiswas[_currentIndex].id,
                                mahasiswas[_currentIndex].name,
                                mahasiswas[_currentIndex].nrp,
                                mahasiswas[_currentIndex].prodi,
                                mahasiswas[_currentIndex].description,
                                mahasiswas[_currentIndex].photo,
                              ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
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
    //klo udh selesai maka add widgetnya ke list
    temp.add(w);
    _counter += 1;
  }
  return temp;
}
