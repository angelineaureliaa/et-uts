class Mahasiswa {
  int id;
  String username;
  String password;
  String name;
  String nrp;
  String email;
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
    required this.nrp,
    required this.email,
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
    nrp: "160426001",
    email: "s160426001@student.ubaya.ac.id",
    prodi: 'Informatika',
    description: 'Budi Santoso adalah mahasiswa Informatika yang dikenal tekun dan penuh rasa ingin tahu. '
        'Sejak awal kuliah, ia sudah menunjukkan ketertarikan pada pemrograman, khususnya pengembangan aplikasi mobile. '
        'Ia gemar mencoba berbagai framework baru dan menjadikan Flutter sebagai keahliannya. '
        'Tidak jarang Budi membantu teman-temannya dalam mengerjakan project kuliah yang berhubungan dengan coding.\n\n'
        'Selain aktif di kelas, Budi juga sering mengikuti kompetisi pemrograman baik di tingkat kampus maupun nasional. '
        'Ia pernah meraih juara dalam hackathon dan terus mengasah kemampuannya dengan ikut komunitas developer. '
        'Di waktu luang, Budi menulis artikel teknologi di blog pribadi sebagai bentuk berbagi pengetahuan kepada orang lain.',
    photo: 'assets/budi.jpg',
  ),
  Mahasiswa(
    id: 2,
    username: 'siti',
    password: '123',
    name: 'Siti Aminah',
    nrp: "160426002",
    email: "s160426002@student.ubaya.ac.id",
    prodi: 'Sistem Informasi',
    description: 'Siti Aminah adalah mahasiswa Sistem Informasi yang dikenal aktif di berbagai kegiatan organisasi. '
        'Ia sering dipercaya menjadi ketua panitia acara besar dan memiliki keterampilan komunikasi yang baik. '
        'Dalam setiap kegiatan, Siti selalu menunjukkan sikap profesional dan mampu bekerja sama dengan berbagai pihak.\n\n'
        'Selain kegiatan organisasi, Siti juga tertarik dengan desain UI/UX. Ia kerap menghabiskan waktu luangnya '
        'untuk belajar tentang pengalaman pengguna dan tampilan aplikasi. Beberapa hasil desainnya bahkan sudah '
        'digunakan dalam project startup lokal yang ia kerjakan bersama teman-temannya.',
    photo: 'assets/siti.jpeg',
  ),
  Mahasiswa(
    id: 3,
    username: 'eko',
    password: '123',
    name: 'Eko Prasetyo',
    nrp: "160426003",
    email: "s160426003@student.ubaya.ac.id",
    prodi: 'Teknik Komputer',
    description: 'Eko Prasetyo adalah mahasiswa Teknik Komputer yang memiliki passion besar terhadap dunia perangkat keras. '
        'Sejak SMA, ia sudah gemar membongkar perangkat elektronik dan merakit komputer. Hal ini membuatnya cepat memahami '
        'materi kuliah yang berhubungan dengan arsitektur komputer dan sistem digital.\n\n'
        'Selain akademik, Eko juga aktif mengikuti kompetisi robotika dan Internet of Things (IoT). '
        'Ia pernah mewakili kampus dalam kompetisi robot tingkat nasional dan berhasil membawa pulang penghargaan. '
        'Kini ia sedang fokus pada penelitian terkait sistem otomatisasi berbasis sensor untuk membantu kegiatan sehari-hari.',
    photo: 'assets/eko.jpeg',
  ),
  Mahasiswa(
    id: 4,
    username: 'lisa',
    password: '123',
    name: 'Lisa Marlina',
    nrp: "160426004",
    email: "s160426004@student.ubaya.ac.id",
    prodi: 'Data Science',
    description: 'Lisa Marlina adalah mahasiswa Data Science yang menaruh perhatian besar pada bidang Natural Language Processing (NLP). '
        'Ketertarikannya berawal dari hobinya membaca artikel tentang kecerdasan buatan dan bagaimana teknologi ini bisa '
        'memahami bahasa manusia. Sejak saat itu, ia aktif mendalami machine learning dan analisis data teks.\n\n'
        'Selain belajar, Lisa juga menjadi asisten dosen untuk mata kuliah Analisis Data. Ia sering membantu mahasiswa lain '
        'memahami konsep machine learning dasar. Di luar dunia akademik, Lisa gemar bermain basket dan kerap mengikuti turnamen antar fakultas '
        'sebagai salah satu pemain andalan tim kampus.',
    photo: 'assets/lisa.jpeg',
  ),
  Mahasiswa(
    id: 5,
    username: 'susi',
    password: '123',
    name: 'Susi Susanti',
    nrp: "160426005",
    email: "s160426005@student.ubaya.ac.id",
    prodi: 'Cyber Security',
    description: 'Susi Susanti adalah mahasiswa Cyber Security yang sangat antusias terhadap dunia keamanan digital. '
        'Ia percaya bahwa perkembangan teknologi harus dibarengi dengan kesadaran akan risiko keamanan. '
        'Sejak awal kuliah, Susi aktif mencari informasi tentang ethical hacking dan teknik uji penetrasi jaringan.\n\n'
        'Di kampus, ia terlibat dalam komunitas cyber security yang fokus meningkatkan literasi digital di kalangan mahasiswa. '
        'Selain itu, Susi juga beberapa kali menjadi pembicara dalam workshop keamanan siber tingkat fakultas. '
        'Semangatnya dalam mempelajari hal baru membuatnya bercita-cita menjadi seorang konsultan keamanan siber profesional.',
    photo: 'assets/susi.jpg',
  ),
];
