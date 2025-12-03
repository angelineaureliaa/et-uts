import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:projectuts/class/request.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Requests extends StatefulWidget {
  int idMahasiswaLogin = 0;
  Requests({super.key});
  @override
  State<Requests> createState() => _RequestsState();
}

class _RequestsState extends State<Requests> {
  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Permintaan Pertemanan"),
      ),
      body: lstRequests.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: <Widget>[
                SizedBox(
                  //buat container dimana isinya itu sesuai dgn daftar popmovie
                  height: MediaQuery.of(context).size.height - 200,
                  child:
                      //klo misal > dari 0 munculin data, klo gak munculin tdk ada data
                      //DaftarPopMovie(PMs)
                      lstRequests.isNotEmpty
                      ? DaftarRequests(lstRequests)
                      : Text('Tidak ada data!'),
                ),
              ],
            ),
    );
  }

  //cek user
  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      widget.idMahasiswaLogin = prefs.getInt("id") ?? 0;
    });
  }

  //panggil API!
  Future<String> fetchData() async {
    final response = await http.post(
      Uri.parse("https://ubaya.cloud/flutter/160422026/uas/bacarequest.php"),
      //kirimin parameter key nya di webservice itu cari, valuenya txtCari
      body: {'id': widget.idMahasiswaLogin.toString()},
    );
    print(response.body);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to read API');
    }
  }

  //baca data!!
  void bacaData() {
    Future<String> data = fetchData();
    data.then((value) {
      Map json = jsonDecode(value);
      //buat tempt list
      List<Request> tempList = [];
      if (json['result'] == 'success') {
        for (var req in json['data']) {
          Request rq = Request.fromJson(req);
          tempList.add(rq);
        }
      } else {
        lstRequests.clear();
      }
      setState(() {
        lstRequests = tempList;
      });
    });
  }

  //daftar requests!
  //buat function utk tampilin daftar movie dalam card list
  Widget DaftarRequests(List<Request> ReqFriends) {
    if (ReqFriends.isNotEmpty) {
      return ListView.builder(
        itemCount: ReqFriends.length,
        itemBuilder: (BuildContext ctxt, int index) {
          //setiap request!!
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  margin: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage(ReqFriends[index].photoSender),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10.0,
                          vertical: 5.0,
                        ),
                        child: Text(
                          ReqFriends[index].namaSender,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10.0,
                          vertical: 5.0,
                        ),
                        child: Text("NRP: ${ReqFriends[index].nrpSender}"),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10.0,
                          vertical: 5.0,
                        ),
                        child: Text(ReqFriends[index].prodiReceiver),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: ElevatedButton(
                              onPressed: () {
                                //panggil api terima
                                confirmFriend(ReqFriends[index].idSender);
                              },
                              style: ElevatedButton.styleFrom(
                                //atur css utk elevated button
                                backgroundColor: Colors.deepPurple,
                                foregroundColor:
                                    Colors.white, //utk warna teks di dlmnya
                              ),
                              child: Text(
                                'Terima',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: ElevatedButton(
                              onPressed: () {
                                //panggil api tolak
                                rejectFriend(ReqFriends[index].idSender);
                              },
                              child: Text(
                                'Tolak',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }

  Future<void> init() async {
    await loadUser();
    bacaData();
  }

  //API UNTUK TERIMA TEMAN
  void confirmFriend(friendId) async {
    final response = await http.post(
      Uri.parse(
        "https://ubaya.cloud/flutter/160422026/uas/terimapertemanan.php",
      ),
      //kirimin parameter key nya di webservice itu cari, valuenya txtCari
      body: {
        'friend_id': widget.idMahasiswaLogin.toString(),
        'id_user': friendId.toString(),
      },
    );
    print('id_user: ${friendId}, id_teman: ${widget.idMahasiswaLogin.toString()}');
    //asumsi pertemanan ini adalah user_id >> nama org yg request dan friend_id itu nama org yg acc!
    if (response.statusCode == 200) {
      //klo berhasil
      print(response.body); //buat debugging
      Map json = jsonDecode(response.body);
      if (json['result'] == "success") {
        ScaffoldMessenger.of(
          context,
          //munculin notif berhasil hapus genre
        ).showSnackBar(SnackBar(content: Text('Sukses berteman!')));
        setState(() {
          bacaData(); //baca ulang data!!
        });
      }
    } else {
      throw Exception('Failed to read API');
    }
  }


  void rejectFriend(friendId) async {
    final response = await http.post(
      Uri.parse(
        "https://ubaya.cloud/flutter/160422026/uas/tolakpertemanan.php",
      ),
      //kirimin parameter key nya di webservice itu cari, valuenya txtCari
      body: {
        'id_user': widget.idMahasiswaLogin.toString(),
        'id_friend_request': friendId.toString(),
      },
    );
    print('id_user: ${friendId}, id_teman: ${widget.idMahasiswaLogin.toString()}');
    //asumsi pertemanan ini adalah user_id >> nama org yg request dan friend_id itu nama org yg acc!
    if (response.statusCode == 200) {
      //klo berhasil
      // print(response.body); //buat debugging
      Map json = jsonDecode(response.body);
      if (json['result'] == "success") {
        ScaffoldMessenger.of(
          context,
          //munculin notif berhasil hapus genre
        ).showSnackBar(SnackBar(content: Text('Berhasil tolak permintaan!')));
        setState(() {
          bacaData(); //baca ulang data!!
        });
      }
    } else {
      throw Exception('Failed to read API');
    }
  }
}
