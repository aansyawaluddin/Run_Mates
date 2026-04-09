class RunningTip {
  final String content;
  final String category;
  final double? minBmi;
  final double? maxBmi;
  final int? minAge;
  final int? maxAge; 

  const RunningTip({
    required this.content,
    required this.category,
    this.minBmi,
    this.maxBmi,
    this.minAge,
    this.maxAge,
  });
}

class RunningKnowledgeBase {
  static const List<RunningTip> _database = [
    
    // KATEGORI BERAT BADAN (BMI)

    // UNDERWEIGHT (BMI <= 18.49)
    RunningTip(
      content: "Fokus Nutrisi: Karena cadangan energi minim, WAJIB makan karbohidrat kompleks (pisang/roti) 30 menit sebelum lari agar tidak pingsan atau lemas.",
      category: "nutrition",
      maxBmi: 18.49,
    ),
    RunningTip(
      content: "Kombinasi Kekuatan: Jangan hanya lari kardio. Gabungkan dengan latihan beban tubuh (push-up, squat) untuk membangun massa otot kaki agar lebih kuat menopang lari.",
      category: "strategy",
      maxBmi: 18.49,
    ),

    // NORMAL / IDEAL (BMI 18.5 - 24.9)
    RunningTip(
      content: "Optimasi Performa: Berat badan ideal adalah waktu terbaik melatih kecepatan. Coba sisipkan 'Strides' (lari cepat 15 detik) di akhir sesi lari santai.",
      category: "performance",
      minBmi: 18.5,
      maxBmi: 24.9,
    ),
    RunningTip(
      content: "Konsistensi Jarak: Tubuhmu siap menerima peningkatan jarak. Naikkan durasi lari 5-10% setiap minggu dengan aman.",
      category: "strategy",
      minBmi: 18.5,
      maxBmi: 24.9,
    ),

    // OVERWEIGHT (BMI > 25 - 27)
    RunningTip(
      content: "Manajemen Beban: Lutut menopang beban ekstra. Hindari lari di permukaan keras (beton) jika memungkinkan. Cari tanah rumput atau track lari sintetis.",
      category: "safety",
      minBmi: 25.0,
      maxBmi: 27.0,
    ),
    RunningTip(
      content: "Pencegahan Lecet: Gesekan kulit (chafing) di paha bagian dalam sering terjadi. Gunakan celana lari ketat (tights) atau pelumas anti-lecet.",
      category: "gear",
      minBmi: 25.0,
    ),
    RunningTip(
      content: "Low Impact Cardio: Ganti 1 hari lari dengan berenang atau bersepeda untuk membakar kalori tanpa membebani kaki.",
      category: "recovery",
      minBmi: 25.0,
    ),

    // OBESITAS (BMI > 27)
    RunningTip(
      content: "METODE WAJIB: Jangan lari nonstop! Gunakan rasio: Jalan Cepat 3 menit, Jogging Pelan 1 menit. Ulangi terus. Tujuannya durasi bergerak, bukan kecepatan.",
      category: "safety_critical",
      minBmi: 27.01,
    ),
    RunningTip(
      content: "Sepatu Max Cushion: Wajib gunakan sepatu dengan sol tebal maksimal untuk meredam benturan tubuh ke aspal. Lindungi tumit dan lututmu.",
      category: "gear",
      minBmi: 27.01,
    ),
    RunningTip(
      content: "Dengarkan Nyeri: Nyeri otot itu wajar, tapi nyeri tajam di sendi (lutut/engkel) adalah tanda BERHENTI. Jangan dipaksakan.",
      category: "safety",
      minBmi: 27.01,
    ),

    // KATEGORI USIA

    // ANAK-ANAK (< 10 TAHUN)
    RunningTip(
      content: "Fun Run Only: Untuk usia di bawah 10 tahun, hindari latihan terstruktur yang ketat. Jadikan lari sebagai permainan (tag, kejar-kejaran) agar tidak bosan.",
      category: "mindset",
      maxAge: 10,
    ),
    RunningTip(
      content: "Hindari Jarak Jauh: Tulang dan lempeng pertumbuhan masih berkembang. Jangan biarkan anak lari jarak jauh (>3km) secara rutin tanpa pengawasan pelatih anak.",
      category: "safety",
      maxAge: 10,
    ),

    // REMAJA (11 - 19 TAHUN)
    RunningTip(
      content: "Masa Pertumbuhan: Karena tubuh tumbuh cepat, koordinasi kaki kadang kaku. Fokus pada teknik lari (form) yang benar daripada sekadar lari kencang.",
      category: "technique",
      minAge: 11,
      maxAge: 19,
    ),
    RunningTip(
      content: "Tidur Cukup: Hormon pertumbuhan bekerja saat tidur. Remaja butuh tidur 8-9 jam untuk pemulihan otot yang optimal setelah latihan.",
      category: "recovery",
      minAge: 11,
      maxAge: 19,
    ),

    // USIA 20-an (20 - 29 TAHUN)
    RunningTip(
      content: "Puncak Performa: Ini usia emas untuk membangun VO2 Max. Tantang diri dengan interval training intensitas tinggi jika tubuh terasa bugar.",
      category: "performance",
      minAge: 20,
      maxAge: 29,
    ),
    RunningTip(
      content: "Lifestyle Balance: Hindari begadang atau alkohol berlebih sebelum hari lari panjang (Long Run).",
      category: "lifestyle",
      minAge: 20,
      maxAge: 29,
    ),

    // USIA 30-an (30 - 39 TAHUN)
    RunningTip(
      content: "Melawan 'Duduk': Usia ini sering sibuk kerja duduk. Lakukan peregangan Hip Flexor (pinggul depan) sebelum lari karena sering kaku akibat duduk lama.",
      category: "mobility",
      minAge: 30,
      maxAge: 39,
    ),
    RunningTip(
      content: "Waktu Efisien: Karena sibuk, fokus pada 'Quality over Quantity'. Lari 30 menit dengan tempo variatif lebih baik daripada 1 jam lari malas-malasan.",
      category: "strategy",
      minAge: 30,
      maxAge: 39,
    ),

    // USIA 40+)
    RunningTip(
      content: "Pemanasan Ekstra: Elastisitas otot menurun. Wajib Warm Up dinamis 10 menit sebelum lari.",
      category: "safety",
      minAge: 40,
    ),

    // ATURAN UMUM
    RunningTip(
      content: "Aturan Bicara (Talk Test): Lari santai (Easy Run) harus dilakukan pada kecepatan di mana kamu masih bisa mengobrol kalimat lengkap.",
      category: "general_rule",
    ),
    RunningTip(
      content: "Hidrasi: Minum 500ml air 1-2 jam sebelum lari. Jangan tunggu haus saat lari.",
      category: "nutrition",
    ),
  ];

  static String getRelevantTips({
    required int age,
    required double bmi,
  }) {
    List<String> results = [];

    for (var tip in _database) {
      bool isMatch = true;

      if (tip.minBmi != null && bmi < tip.minBmi!) isMatch = false;
      if (tip.maxBmi != null && bmi > tip.maxBmi!) isMatch = false;

      if (tip.minAge != null && age < tip.minAge!) isMatch = false;
      if (tip.maxAge != null && age > tip.maxAge!) isMatch = false;

      if (isMatch) {
        results.add("- [${tip.category.toUpperCase()}] ${tip.content}");
      }
    }

    results.shuffle();
    
    results.sort((a, b) => a.contains("SAFETY_CRITICAL") ? -1 : 1);

    return results.take(8).join("\n");
  }
}