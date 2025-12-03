class Kontak {
  int idTeman;
  String namaTeman;
  String fotoTeman;
  String nrpTeman;

  //required artinya field tersebut wajib diisi
  //klo gak wajib diisi, maka boleh buat gk dikasi required
  Kontak({required this.idTeman,required this.namaTeman,required this.fotoTeman,required this.nrpTeman});

//baca file json return dari WebService
factory Kontak.fromJson(Map<String, dynamic> json) {
  return Kontak(
    idTeman: json['id_teman'] as int,
    namaTeman: json['nama_teman'] as String,
    fotoTeman: json['foto_teman'] as String,
    nrpTeman: json['nrp_teman'] as String,
    
  );
 }
}
List<Kontak> lstKontak=[]; 
