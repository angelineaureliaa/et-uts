class Mahasiswa {
  int id;
  String username;
  String password;
  String name;
  String prodi;
  String description;
  String photo;

  //required means this field may not be null.
  //If it is not required, either provide default value or make it nullable
  Mahasiswa({
    required this.id,
    required this.username,
    required this.password,
    required this.name,
    required this.prodi,
    required this.description,
    required this.photo,
  });
}

var mahasiswas = <Mahasiswa>[
  Mahasiswa(
    id: 1,
    username: 'budi',
    password: '123',
    name: 'Budi Santoso',
    prodi: 'Informatika',
    description: 'Suka ngoding Flutter dan machine learning.',
    photo: 'assets/budi.jpg',
  ),
  Mahasiswa(
    id: 2,
    username: 'siti',
    password: '123',
    name: 'Siti Aminah',
    prodi: 'Sistem Informasi',
    description: 'Aktif di organisasi kampus dan suka desain UI/UX.',
    photo: 'assets/siti.jpeg',
  ),
  Mahasiswa(
    id: 3,
    username: 'eko',
    password: '123',
    name: 'Eko Prasetyo',
    prodi: 'Teknik Komputer',
    description: 'Hobi utak-atik hardware dan bikin robot.',
    photo: 'assets/eko.jpeg',
  ),
  Mahasiswa(
    id: 4,
    username: 'lisa',
    password: '123',
    name: 'Lisa Marlina',
    prodi: 'Data Science',
    description: 'Fokus riset NLP dan suka main basket.',
    photo: 'assets/lisa.jpeg',
  ),
  Mahasiswa(
    id: 5,
    username: 'susi',
    password: '123',
    name: 'Susi Susanti',
    prodi: 'Cyber Security',
    description: 'Tertarik pada ethical hacking dan keamanan jaringan.',
    photo: 'assets/susi.jpg',
  ),
];
