# Driver WiFi RTL8189FS untuk Kernel 6.12.105

Driver ini dikompilasi khusus untuk penggunaan pada **STB2 (SixZuper-Labs)** dengan kernel versi `6.12.105-ophub`.

## Persyaratan

- Kernel headers untuk versi yang sesuai:
  ```bash
  sudo apt install linux-headers-$(uname -r) build-essential git
  ```
- Arsitektur prosesor: ARMv8 (aarch64)

## Cara Instalasi

1. Kloning repositori ini:
   ```bash
   git clone https://github.com/aboutrpk/driver-wifi-RTL8189FS-6.12.105.git
   cd driver-wifi-RTL8189FS-6.12.105
   ```

2. Kompilasi driver:
   ```bash
   make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu-
   ```

3. Instal modul ke sistem:
   ```bash
   sudo make install
   ```

4. Muat driver secara manual:
   ```bash
   sudo modprobe 8189fs
   ```

## Verifikasi

Setelah menginstal, verifikasi apakah driver sudah dimuat dengan benar:
```bash
lsmod | grep 8189fs
iwconfig
```

Jika semuanya berhasil, antarmuka `wlan0` seharusnya sudah muncul.

## Catatan Penting

- Pastikan kunci host SSH GitHub sudah ditambahkan sebelum melakukan operasi jaringan terhubung.
- Jika terjadi kesalahan kompilasi, periksa apakah versi kernel sudah sesuai dan header yang diperlukan sudah terpasang.
- Selalu backup konfigurasi jaringan sebelum mengganti driver WiFi.

## Lisensi

Driver ini mengikuti lisensi dari proyek aslinya dan dibagikan untuk tujuan edukasi dan penggunaan pribadi dalam ekosistem SixZuper-Labs By Mr. R.
