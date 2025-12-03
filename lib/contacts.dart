import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:projectuts/class/kontak.dart';
import 'package:projectuts/detailstudent.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Contact extends StatefulWidget {
  Contact({super.key});
  int idMahasiswa = 0;
  @override
  State<Contact> createState() => _ContactState();
}

class _ContactState extends State<Contact> {
  // Kontak? _kontak;
  @override
  void initState() {
    super.initState();
    //pertama di run, jalankan baca data!
    _loadUser().then((_) {
      bacaData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Daftar Kontak"),
      ),
      body: lstKontak.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height - 50,
                  child:
                      //klo misal > dari 0 munculin data, klo gak munculin tdk ada data
                      lstKontak.isNotEmpty
                      ? daftarkontak(lstKontak)
                      : Text('Tidak ada data!'),
                ),
              ],
            ),
    );
  }

  //buat method utk request ke API!
  Future<String> fetchData() async {
    final response = await http.post(
      Uri.parse("https://ubaya.cloud/flutter/160422026/uas/daftarkontak.php"),
      body: {'id_user': widget.idMahasiswa.toString()},
    );
    // print("idmhs: ${widget.idMahasiswa.toString()}");
    // print("BODY: ${response.body}");
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to read API');
    }
  }

  //method utk baca data!
  void bacaData() {
    Future<String> data = fetchData();
    data.then((value) {
      Map json = jsonDecode(value);
      //buat tempt list
      List<Kontak> tempList = [];
      if (json['result'] == 'success') {
        for (var kontak in json['data']) {
          Kontak c = Kontak.fromJson(kontak);
          tempList.add(c);
        }
      } else {
        lstKontak.clear();
      }
      setState(() {
        lstKontak = tempList;
      });
    });
  }

  //daftar kontakk!!
  Widget daftarkontak(List<Kontak> Kontaks) {
    if (Kontaks.isNotEmpty) {
      return ListView.builder(
        itemCount: Kontaks.length,
        itemBuilder: (BuildContext ctxt, int index) {
          //setiap request!!
          // return Align(
          //     //dikasih align biar dia posisinya ditengah!
          //     alignment: Alignment.center,
              return Container(
                //edge insets all itu buat margin
                margin: EdgeInsets.all(10),
                //edge insets simmetric itu padding kanan kiri
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                width: 800,
                decoration: BoxDecoration(
                  color: Color.fromARGB(
                    255,
                    246,
                    219,
                    227,
                  ), //warna background dari container
                  borderRadius: BorderRadius.circular(
                    20,
                  ), //buat sudut jadi bulat!
                ),
                //di dalam container itu diisi dgn column utk mengisi gambar, desc, dll
                child: Column(
                  children: [
                    //buat AVA BUNDAR!
                    Container(
                      //tentukan panjang, lebar
                      width: 200,
                      height: 200,
                      //kasih margin!
                      margin: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(Kontaks[index].fotoTeman),
                          //biar gambarnya memenuhi container!
                          fit: BoxFit.cover,
                        ),
                        //ubah bentuknya jadi lingkaran!
                        shape: BoxShape.circle,
                      ),
                    ),
                    //kasih pembatas kayak 20 pake divider
                    //isi text sesuai var name
                    Text(
                      Kontaks[index].namaTeman,
                      style: TextStyle(
                        fontSize: 32.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "NRP: ${Kontaks[index].nrpTeman}",
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.6),
                        fontSize: 18.0,
                      ),
                    ),
                    ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        //urutan hrs diperhatiin sesuai gimana cara declare constructornya
                        context,
                        MaterialPageRoute(
                          //karena value data berubah-ubah sesuai yg iterasi saat ini, maka jgn pake const!
                          //klo pake const dia akan error!
                          builder: (context) =>
                              Detailstudent( idMahasiswa: lstKontak[index].idTeman,)
                              
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 248, 188, 206),
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
          );
    });
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      widget.idMahasiswa = prefs.getInt("id") ?? 0;
    });
  }
}
