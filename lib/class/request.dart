class Request {
  int id;
  int idSender;
  String namaSender;
  int idReceiver;
  String namaReceiver;
  String prodiSender;
  String prodiReceiver;
  String nrpReceiver;
  String nrpSender;
  String photoReceiver;
  String photoSender;

  //required artinya field tersebut wajib diisi
  //klo gak wajib diisi, maka boleh buat gk dikasi required
  Request({required this.id,required this.idSender,required this.idReceiver,required this.namaSender,required this.namaReceiver,
  required this.prodiSender, required this.prodiReceiver, required this.nrpReceiver, required this.nrpSender, required this.photoReceiver, required this.photoSender});

//baca file json return dari WebService
factory Request.fromJson(Map<String, dynamic> json) {
  return Request(
    //kiri nama variabel yg diinisialisasiin as properties!
    //json [nama kolom di db]
    id: json['id'] as int,
    idSender: json['sender_id'] as int,
    idReceiver: json['receiver_id'] as int,
    namaSender: json['nama_sender'] as String,
    namaReceiver: json['nama_receiver'] as String,
    prodiSender: json['prodi_sender'] as String,
    prodiReceiver: json['prodi_receiver'] as String,
    nrpSender: json['nrp_sender'] as String,
    nrpReceiver: json['nrp_receiver'] as String,
    photoSender: json['photo_sender'] as String,
    photoReceiver: json['photo_receiver'] as String,
  );
 }
}
List<Request> lstRequests=[]; 
