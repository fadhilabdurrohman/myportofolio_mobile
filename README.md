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
