## Tugas 8

### Pertanyaan Reflektif

> 1. Jelaskan perbedaan antara `Navigator.push()`, `Navigator.pushReplacement()`, dan `Navigator.pop()`. Metode apa yang digunakan untuk membuka formulir dari kartu aksi? Jelaskan juga bagaimana opsi Home di drawer membawa pengguna kembali ke halaman utama.

1. `Navigator.push()` menambahkan halaman ke tumpukan navigasi, `pushReplacement()` mengganti halaman teratas, dan `pop()` menutup halaman teratas. Kartu **Tambah Pengalaman** menggunakan `push()` untuk membuka formulir agar pengguna dapat kembali dengan tombol kembali perangkat. Opsi **Home** di drawer menggunakan `pushReplacement()` untuk mengganti halaman aktif dengan `MyHomePage`.

> 2. Bagaimana susunan `Scaffold`, `AppBar`, dan `Drawer` membantu menjaga struktur halaman tetap konsisten? Berikan satu contoh penggunaan warna tema portofolio di lebih dari satu halaman.

2. `Scaffold` menyediakan kerangka halaman, `AppBar` menempatkan judul di bagian atas, dan `Drawer` menyediakan menu navigasi yang sama. Halaman Home menggunakan warna primer dari tema berbasis indigo, sedangkan `AppBar` formulir Experience menggunakan `Colors.indigo`.

> 3. Mengapa tata letak tersebut dipilih untuk formulir? Jelaskan peran widget pengatur jarak dan widget penggulir ketika ruang layar terbatas.

3. `Column` menyusun kolom agar mudah diisi dari atas ke bawah. `Padding` memberi jarak antarinput, sedangkan `SingleChildScrollView` memungkinkan pengguna menggulir hingga tombol **Simpan** saat layar sempit atau papan ketik terbuka.

> 4. Apa peran `GlobalKey<FormState>`, `validator`, dan `validate()` saat tombol Simpan ditekan? Berikan satu contoh nilai yang ditolak oleh validasi dan jelaskan mengapa memilih jenis input atau papan ketik saja belum cukup.

4. `GlobalKey<FormState>` memberi akses ke status formulir. Saat tombol **Simpan** ditekan, `validate()` menjalankan `validator` setiap kolom. Misalnya, nama berisi `"   "` ditolak karena kosong setelah `trim()`. Jenis papan ketik hanya memudahkan pengetikan. Aturan wajib isi dan batas panjang tetap perlu diperiksa melalui validasi. 

### AI Disclosure

Pengerjaan tugas ini dibantu dengan Gen AI (ChatGPT) untuk memahami konsep Flutter, membantu implementasi tabel identitas dan gambar, menyesuaikan tampilan antarmuka, serta menyusun jawaban pertanyaan reflektif.

-[ChatGPT](https://chatgpt.com/share/6b0409a2-c010-83ec-8925-e8c0f8ad552a)

### Penggunaan AI

- Membuat test

### Referensi

- [Flutter Documentation](https://docs.flutter.dev/)
