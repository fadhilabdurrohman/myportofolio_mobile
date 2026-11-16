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

## Tugas 7

### Pertanyaan Reflektif

> 1. Jelaskan apa yang dimaksud dengan widget tree pada Flutter dan bagaimana hubungan induk-anak (parent-child) bekerja antar-widget!

1. *Widget tree* adalah susunan widget berbentuk hierarki yang membentuk antarmuka aplikasi. Widget induk (*parent*) menampung dan mengatur tata letak widget anak (*child*). Pada proyek ini, `Padding` membungkus `Column`, kemudian `Column` menampung gambar, tabel identitas, dan bagian menu. Properti `child` menerima satu widget, sedangkan `children` menerima beberapa widget.

> 2. Sebutkan semua widget yang kamu gunakan dalam proyek ini dan jelaskan fungsinya masing-masing!

2. 
- `MyApp`: menyusun konfigurasi utama aplikasi.
- `MaterialApp`: mengatur tema, judul aplikasi, dan halaman awal.
- `MyHomePage`: menyusun halaman utama portofolio.
- `Scaffold`: menyediakan struktur dasar halaman.
- `AppBar`: menampilkan bilah judul di bagian atas.
- `Padding`: memberikan ruang di sekeliling widget anak.
- `Column`: menyusun widget secara vertikal.
- `Container`: mengatur padding, ukuran, warna, dan border.
- `Image` melalui `Image.asset()`: menampilkan foto dari aset proyek.
- `Table`: menyusun identitas dalam baris dan kolom.
- `SizedBox`: memberikan jarak atau ukuran tertentu.
- `Center`: menempatkan widget anak di tengah.
- `Text`: menampilkan teks.
- `GridView` melalui `GridView.count()`: menyusun menu dalam kisi tiga kolom.
- `ItemCard`: menampilkan satu kartu menu.
- `Material`: menyediakan permukaan berwarna dan mendukung efek tinta.
- `InkWell`: menangani ketukan serta memberikan efek visual.
- `Icon`: menampilkan ikon menu.
- `SnackBar`: menampilkan pesan sementara ketika menu ditekan.

`TableRow` merupakan konfigurasi baris tabel. `ItemHomepage` adalah kelas penyimpan data menu.

> 3. Apa fungsi dari widget `MaterialApp`? Jelaskan mengapa widget ini umumnya digunakan sebagai root widget pada aplikasi Flutter!

3. `MaterialApp` menyediakan pengaturan utama aplikasi berbasis Material Design, seperti tema, navigasi, dan halaman awal. Widget ini ditempatkan di bagian atas *widget tree* agar pengaturannya tersedia bagi widget di bawahnya. Pada proyek ini, `MyApp` mengembalikan `MaterialApp` dengan tema indigo dan `MyHomePage` sebagai halaman awal melalui properti `home`.

> 4. Jelaskan perbedaan antara `StatelessWidget` dan `StatefulWidget`! Kapan kita sebaiknya memilih `StatelessWidget` dan kapan harus menggunakan `StatefulWidget`?

4. `StatelessWidget` tidak mengelola state lokal yang berubah, sedangkan `StatefulWidget` memiliki objek `State` untuk menyimpan perubahan dan memperbarui tampilan melalui `setState()`. Gunakan `StatelessWidget` untuk komponen yang tidak membutuhkan state lokal, seperti identitas dan kartu menu pada proyek ini. Gunakan `StatefulWidget` untuk komponen seperti penghitung atau pilihan favorit. Ketukan yang hanya menampilkan `SnackBar` tidak mengharuskan `ItemCard` menjadi `StatefulWidget`.

> 5. Apa itu `BuildContext` dan mengapa penting di Flutter? Bagaimana penggunaannya di dalam metode `build`?

5. `BuildContext` menunjukkan lokasi widget dalam *widget tree* sehingga widget dapat mengakses informasi atau fasilitas dari widget leluhurnya. Flutter memberikannya melalui parameter `build(BuildContext context)`. Pada proyek ini, `Theme.of(context)` mengambil warna tema untuk `AppBar`, sedangkan `ScaffoldMessenger.of(context)` mengakses pengelola `SnackBar` untuk menampilkan pesan ketika kartu ditekan.

> 6. Jelaskan konsep hot reload di Flutter dan apa perbedaannya dengan hot restart! Kapan kita tidak bisa hanya mengandalkan hot reload dan harus melakukan hot restart atau full restart?

6. *Hot reload* menerapkan perubahan kode sambil mempertahankan state aplikasi, sehingga cocok untuk mengubah warna, teks, dan padding. *Hot restart* menjalankan ulang aplikasi Flutter dan menghapus state dalam memori. Perubahan pada kode inisialisasi seperti `main()` atau `initState()` memerlukan *hot restart* agar dijalankan kembali. Perubahan kode native seperti Kotlin atau Swift memerlukan *full restart*, yaitu menghentikan dan menjalankan kembali aplikasi.

### AI Disclosure

Pengerjaan tugas ini dibantu dengan Gen AI (ChatGPT) untuk memahami konsep Flutter, membantu implementasi tabel identitas dan gambar, menyesuaikan tampilan antarmuka, serta menyusun jawaban pertanyaan reflektif.

- [ChatGPT](https://chatgpt.com/share/6afaf88b-b120-83ec-85ec-7d5e82080c9d)

### Penggunaan AI

- Membantu memahami konsep widget tree, MaterialApp, StatelessWidget, StatefulWidget, BuildContext, serta hot reload dan hot restart.
- Membantu memahami cara membuat tabel.
- Membantu pengaturan padding, border, serta warna header dan isi tabel.
- Membantu dalam menambahkan gambar.
- menyusun jawaban pertanyaan reflektif.

### Perbaikan Manual

- Mengganti kartu identitas menjadi tabel berisi NPM, nama, dan kelas.
- Mengimplementasikan tabel pada identitas.
- Menambahkan foto profil beserta ukuran, border, dan pengaturan `BoxFit.cover`.
- Mengubah warna tombol menu menjadi kuning untuk Lihat Proyek, hijau untuk Tambah Proyek, dan merah untuk Logout.

### Referensi

- [Flutter Documentation — Building User Interfaces](https://docs.flutter.dev/ui)
- [Flutter API — StatelessWidget](https://api.flutter.dev/flutter/widgets/StatelessWidget-class.html)
- [Flutter API — StatefulWidget](https://api.flutter.dev/flutter/widgets/StatefulWidget-class.html)
- [Flutter API — BuildContext](https://api.flutter.dev/flutter/widgets/BuildContext-class.html)
- [Flutter Documentation — Hot Reload, Hot Restart, dan Full Restart](https://docs.flutter.dev/tools/hot-reload)

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
