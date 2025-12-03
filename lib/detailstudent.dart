import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:projectuts/class/mahasiswa.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Detailstudent extends StatefulWidget {
  final int idMahasiswa;
  int idMahasiswaLogin = 0;
  Detailstudent({super.key, required this.idMahasiswa});
  @override
  State<Detailstudent> createState() => _DetailstudentState();
}

class _DetailstudentState extends State<Detailstudent> {
  //inisialisasi object mahasiswa
  Mahasiswa? _mhs;
  bool _statusPengajuan =
      false; //initial value utk cek apakah dia udh teman/udh ngajuin!
  String message =
      ""; //ini itu buat tampung klo dia pertemanannya gk muncul dia statusnya apa
  //apakah udah teman atau sdg mengajukan atau dia udh ajuin ke kita!
  @override
  void initState() {
    super.initState();
    //pertama di run, jalankan baca data!
    _loadUser().then((_) {
      bacaData();
      cekStatusPertemenan();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Detail Mahasiswa"),
      ),
      //tambahin fab disini! >> ada gaknya fab ditentuin oleh statusPengajuan
      floatingActionButton: _statusPengajuan
          ? FloatingActionButton(
              onPressed: () {
                sendRequest();
              },
              //kasih icon tambah teman!
              child: const Icon(Icons.person_add),
            )
          : null,
      body: ListView(children: <Widget>[tampilData()]),
    );
  }

  //buat method utk request ke API!
  Future<String> fetchData() async {
    final response = await http.post(
      Uri.parse(
        "https://ubaya.cloud/flutter/160422026/uas/detailmahasiswa.php",
      ),
      body: {'id': widget.idMahasiswa.toString()},
    );
    // print("BODY: ${response.body}");
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to read API');
    }
  }

  //method utk baca data!
  bacaData() {
    fetchData().then((value) {
      Map json = jsonDecode(value);
      //baca data mahasiswa yg disimpen di key data!
      //krn disimpan di list, jadi ambil indeks ke 0 nya
      _mhs = Mahasiswa.fromJson(json['data'][0]);
      setState(() {});
    });
  }

  //urus tampil datanya disini!!
  Widget tampilData() {
    //klo mahasiswa ditemukan
    if (_mhs == null) {
      return Center(child: CircularProgressIndicator());
    } else {
      return SingleChildScrollView(
        child: Align(
          //dikasih align biar dia posisinya ditengah!
          alignment: Alignment.center,
          child: Container(
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
              borderRadius: BorderRadius.circular(20), //buat sudut jadi bulat!
            ),
            //di dalam container itu diisi dgn column utk mengisi gambar, desc, dll
            child: Column(
              children: [
                //jika messagenya gk kosong maka tampilin chipnya!
                message != ""
                    ? InputChip(label: Text(message))
                    : SizedBox.shrink(),
                //buat AVA BUNDAR!
                Container(
                  //tentukan panjang, lebar
                  width: 200,
                  height: 200,
                  //kasih margin!
                  margin: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('${_mhs!.photo}'),
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
                  _mhs!.name,
                  style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold),
                ),
                Text(
                  "NRP: ${_mhs!.nrp}",
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.6),
                    fontSize: 18.0,
                  ),
                ),
                SingleChildScrollView(
                  child: Container(
                    //tentukan panjang, lebar
                    width: 700,
                    //kasih margin!
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Color.fromARGB(255, 248, 188, 206),
                    ),
                    child: Column(
                      children: [
                        Text(
                          "Program/Lab",
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          _mhs!.prodi,
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.6),
                            fontSize: 18.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SingleChildScrollView(
                  child: Container(
                    //tentukan panjang, lebar
                    width: 700,
                    //kasih margin!
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 248, 188, 206),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        Text(
                          "Biografi",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          _mhs!.description,
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.6),
                            fontSize: 18.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      widget.idMahasiswaLogin = prefs.getInt("id") ?? 0;
    });
  }

  //cek status pertemanan!!
  void cekStatusPertemenan() async {
    final response = await http.post(
      Uri.parse("https://ubaya.cloud/flutter/160422026/uas/cekstatusteman.php"),
      body: {
        //id user itu yg mengajukan!!
        'id_user': widget.idMahasiswaLogin.toString(),
        'id_teman': widget.idMahasiswa.toString(),
      },
    );
    //print('id_user: ${widget.idMahasiswaLogin}, id_teman: ${widget.idMahasiswa}');

    //baca status codenya!
    //print(response.body);
    if (response.statusCode == 200) {
      // print(response.body);
      Map json = jsonDecode(response.body);
      //klo udh berteman, maka yaudah ubah statusnya jadi friend!
      if (json['status'] == "success") {
        //cek apakah dia itu user yg sama dengan yg login gk
        //klo gk sama bru statusnya true!
        if (widget.idMahasiswaLogin != widget.idMahasiswa) {
          setState(() {
            _statusPengajuan = true;
            bacaData();
          });
        }
      } else {
        //selain ini set messagenya sesuai statusnya!
        setState(() {
          //perubahan hrs di dlm setstate!
          message = json['status'];
          bacaData();
        });
      }
    } else {
      throw Exception('Failed to read API');
    }
  }

  //kirim friend request
  void sendRequest() async {
    final response = await http.post(
      Uri.parse(
        "https://ubaya.cloud/flutter/160422026/uas/tambahpertemanan.php",
      ),
      body: {
        'id_user': widget.idMahasiswaLogin.toString(),
        'id_teman': widget.idMahasiswa.toString(),
      },
    );
    //baca status codenya!
    if (response.statusCode == 200) {
      print(response.body);
      Map json = jsonDecode(response.body);
      //klo json resultnya ok!!
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Permintaan pertemanan Anda sedang diajukan!")),
      );
      setState(() {
        bacaData();
      });
    } else {
      throw Exception('Failed to read API');
    }
  }
}
