import 'package:flutter/material.dart';

//pakai stateless widget krn tdk ada perubahan yg terjadi
//cuman showing aja!
class Detailstudent extends StatelessWidget {
  //deklarasi item yang diterima disini!
  final int id; //tampung idnya
  final String nrp;
  final String name;
  final String prodi;
  final String description;
  final String imgPath;
  //paremter yg dibutuhkan utk page ini, hrs diambil di constructor
  const Detailstudent(
    this.id,
    this.name,
    this.nrp,
    this.prodi,
    this.description,
    this.imgPath, {
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Detail Mahasiswa"),
      ),
      //buat floating action button buat addfrriends!
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //klo fabnya diklik, maka muncul notifbar!
          showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              //judul alertnya apa
              title: Text('Berhasil!'),
              content: Text('$name berhasil ditambahkan sebagai teman!'),
              actions: <Widget>[
                TextButton(
                  //klo diklik nutup popupnya
                  onPressed: () => Navigator.pop(context, 'OK'),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        },
        //kasih icon tambah teman!
        child: const Icon(Icons.person_add),
      ),
      //utk body, kita pakai singlechildscroll view
      //supaya klo datanya panjang, dia scrollable
      body: SingleChildScrollView(
        //single sroll view hny punya child,
        //makanya hrs dikasih column biar bs tampung bnyk element
        //atau children
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
              color: Colors.deepPurple.withOpacity(
                0.05,
              ), //warna background dari container
              borderRadius: BorderRadius.circular(20), //buat sudut jadi bulat!
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
                      image: AssetImage('../$imgPath'),
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
                  name,
                  style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold),
                ),
                Text(
                  "NRP: $nrp",
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.6),
                    fontSize: 24.0,
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
                      color: Colors.deepPurpleAccent.withOpacity(0.1),
                    ),
                    child: Column(
                      children: [
                        Text(
                          "Program/Lab",
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          prodi,
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.6),
                            fontSize: 20.0,
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
                      color: Colors.deepPurpleAccent.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        Text(
                          "Biografi",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          description,
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.6),
                            fontSize: 20.0,
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
      ),
    );
  }
}
