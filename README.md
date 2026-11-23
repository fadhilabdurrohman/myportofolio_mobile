# MyPortofolio Mobile

Aplikasi portofolio mobile yang dikembangkan dengan Flutter untuk memenuhi Tutorial dan Individual Assignment pada mata kuliah Pemrograman Berbasis Platform (CSGE602022) Ganjil 2026/2027.

## Identitas

- Nama: Fadhil Abdurrohman
- NPM: 2506656690
- Kelas: PBP B

## Struktur Kode

| Berkas atau kelas | Fungsi |
| --- | --- |
| `lib/main.dart` | Menjalankan aplikasi melalui `runApp()` dan mengatur `MaterialApp` beserta temanya. |
| `lib/menu.dart` | Menyimpan implementasi halaman utama dan komponen kartu. |
| `MyHomePage` | Menyusun halaman utama menggunakan `StatelessWidget`. |
| `InfoCard` | Menampilkan judul dan isi informasi identitas. |
| `ItemHomepage` | Menyimpan nama, ikon, dan warna sebuah tombol aksi. |
| `ItemCard` | Menampilkan tombol aksi dan menangani interaksi pengguna. |

## Daftar Tugas

- [Tugas 7](./tugas/tugas7.md)
- [Tugas 8](./tugas/tugas8.md)

## Tugas 8

### Pertanyaan Reflektif

> 1. Jelaskan perbedaan antara `Navigator.push()`, `Navigator.pushReplacement()`, dan `Navigator.pop()`. Metode apa yang digunakan untuk membuka formulir dari kartu aksi? Jelaskan juga bagaimana opsi Home di drawer membawa pengguna kembali ke halaman utama.

1. `Navigator.push()` menambahkan halaman ke tumpukan navigasi, `pushReplacement()` mengganti halaman teratas, dan `pop()` menutup halaman teratas. Kartu **Tambah Pengalaman** menggunakan `push()` untuk membuka formulir agar pengguna dapat kembali dengan tombol kembali perangkat. Opsi **Home** di drawer menggunakan `pushReplacement()` untuk mengganti halaman aktif dengan `MyHomePage`.

> 2. Bagaimana susunan `Scaffold`, `AppBar`, dan `Drawer` membantu menjaga struktur halaman tetap konsisten? Berikan satu contoh penggunaan warna tema portofolio di lebih dari satu halaman.

2. `Scaffold` menyediakan kerangka halaman, `AppBar` menempatkan judul di bagian atas, dan `Drawer` menyediakan menu navigasi yang sama. Halaman Home menggunakan warna primer dari tema berbasis indigo, sedangkan `AppBar` formulir Experience menggunakan `Colors.indigo`.

> 3. Mengapa tata letak tersebut dipilih untuk formulir? Jelaskan peran widget pengatur jarak dan widget penggulir ketika ruang layar terbatas.

3. `Column` menyusun kolom agar mudah diisi dari atas ke bawah. `Padding` memberi jarak antarinput, sedangkan `SingleChildScrollView` memungkinkan pengguna menggulir hingga tombol **Simpan** saat layar sempit atau papan ketik terbuka.

> 4. Apa peran `GlobalKey<FormState>`, `validator`, dan `validate()` saat tombol Simpan ditekan? Berikan satu contoh nilai yang ditolak oleh validasi dan jelaskan mengapa memilih jenis input atau papan ketik saja belum cukup.

4.`GlobalKey<FormState>` memberi akses ke status formulir. Saat tombol **Simpan** ditekan, `validate()` menjalankan `validator` setiap kolom. Misalnya, nama berisi `"   "` ditolak karena kosong setelah `trim()`. Jenis papan ketik hanya memudahkan pengetikan. Aturan wajib isi dan batas panjang tetap perlu diperiksa melalui validasi. 

### AI Disclosure

Pengerjaan tugas ini dibantu dengan Gen AI (ChatGPT) untuk memahami konsep Flutter dan membuat test.

-[ChatGPT](https://chatgpt.com/share/6b0409a2-c010-83ec-8925-e8c0f8ad552a)

### Penggunaan AI

- Membuat test

### Referensi

- [Flutter Documentation](https://docs.flutter.dev/)

## Instalasi dan Setup

### 1. Unduh Flutter SDK

Buka [panduan instalasi Flutter](https://docs.flutter.dev/install/manual),
pilih sistem operasi dan arsitektur komputer, lalu unduh Flutter SDK.

### 2. Ekstrak Flutter SDK

Ekstrak arsip ke folder `dev` di direktori pengguna.

Contoh lokasi hasil ekstraksi:

- Windows: `C:\Users\<username>\dev\flutter`
- macOS/Linux: `~/dev/flutter`

### 3. Tambahkan Flutter ke PATH

**Windows:**

1. Buka **Environment Variables**.
2. Pada bagian **User variables**, pilih **Path**, lalu **Edit**.
3. Klik **New** dan tambahkan:

```text
C:\Users\<username>\dev\flutter\bin
```

Sesuaikan `<username>` dengan nama pengguna Windows.

**macOS/Linux:**

Tambahkan baris berikut ke konfigurasi shell:
`~/.zshrc` untuk Zsh atau `~/.bashrc` untuk Bash.

```bash
export PATH="$HOME/dev/flutter/bin:$PATH"
```

Setelah selesai, tutup dan buka kembali terminal.

### 4. Periksa Instalasi

```bash
flutter --version
dart --version
flutter doctor
```

Pastikan Flutter dan Dart dikenali oleh terminal.

### 5. Clone repository

```bash
git clone https://github.com/fadhilabdurrohman/myportofolio_mobile.git
cd myportofolio_mobile
```

### 6. Instal dependencies

```bash
flutter pub get
```

### 7. Periksa perangkat

Pastikan Google Chrome sudah terpasang, kemudian jalankan:

```bash
flutter devices
```

Pastikan perangkat `Chrome (web)` dengan ID `chrome` tersedia.

### 8. Jalankan aplikasi

```bash
flutter run -d chrome
```

### 9. Periksa kode

```bash
flutter analyze
```

Pastikan hasil analisis menunjukkan `No issues found`.
