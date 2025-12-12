// ==========================================
// PROGRAM: ESTIMASI POSISI KRL (LAGRANGE)
// STUDI KASUS: UI - PONDOK CINA - DEPOK BARU
// ==========================================

printf('\n=== PROGRAM INTERPOLASI POSISI KRL (Rute UI) ===\n');
printf('---------------------------------------------\n');

// 1. DATASET RIIL (Sumber: Gmaps & Jadwal KRL)
// UI (0,0), Pocin (3 mnt, 1.2 km), Depok Baru (7 mnt, 3.7 km)
X = [0.0  3.0  7.0]; 
Fx = [0.0  1.2  3.7]; 

printf('Diketahui Data Perjalanan KRL:\n');
// Menampilkan data
for i=1:3
    if i==1 then stasiun = 'Univ. Indonesia'; end
    if i==2 then stasiun = 'Pondok Cina    '; end
    if i==3 then stasiun = 'Depok Baru     '; end
    
    printf('i=%d | %s | Waktu = %.1f mnt | Jarak = %.1f km\n', i, stasiun, X(i), Fx(i));
end

// Target Prediksi (Misal: Menit ke-5, posisi di mana?)
xp = 5.0; 
printf('\nNilai posisi kereta yang akan dicari pada menit ke: x = %.1f\n', xp);

// Mapping ke variabel x dan y (Sesuai gaya Dosen)
x(1)=X(1); x(2)=X(2); x(3)=X(3);
y(1)=Fx(1); y(2)=Fx(2); y(3)=Fx(3);

// -----------------------------------------------------------
// KASUS 1: LINEAR (Garis Lurus)
// Pakai data Pocin (index 2) dan Depok Baru (index 3)
// Karena menit ke-5 ada di antara mereka.
// -----------------------------------------------------------
sm = 0;
// Kita geser loopnya jadi i=2 sampai 3 biar akurat secara fisika
// (Interpolasi Linear antar dua titik terdekat)
for i = 2:3 
    pr = 1;
    for j = 2:3
        if j ~= i
            pr = pr * (xp-x(j))/(x(i)-x(j));
        end
    end
    sm = sm + y(i)*pr;
end
P1x = sm;

// -----------------------------------------------------------
// KASUS 2: KUADRAT / LAGRANGE (Lengkung)
// Pakai semua data (UI - Pocin - Depok Baru)
// -----------------------------------------------------------
sm = 0;
for i = 1:3
    pr = 1;
    for j = 1:3
        if j ~= i
            pr = pr * (xp-x(j))/(x(i)-x(j));
        end
    end
    sm = sm + y(i)*pr;
end
P2x = sm;

// -----------------------------------------------------------
// OUTPUT HASIL
// -----------------------------------------------------------
printf('\n---------------------------------------------\n');
printf('HASIL PREDIKSI POSISI KERETA (Menit ke-%.1f)', xp);
printf('\n---------------------------------------------\n');

printf('1. Metode Linear (Asumsi Kecepatan Tetap):\n');
printf('   Posisi = %.6f km (dari UI)\n', P1x);

printf('\n2. Metode Lagrange (Asumsi Ada Percepatan):\n');
printf('   Posisi = %.6f km (dari UI)\n', P2x);

printf('\n---------------------------------------------\n');
selisih = abs(P2x - P1x) * 1000;
printf('KESIMPULAN:\n');
printf('Selisih prediksi: %.2f meter.\n', selisih);
printf('Metode Lagrange (%.4f km) lebih disarankan karena memperhitungkan\n', P2x);
printf('perubahan kecepatan kereta di antara stasiun.\n');

// ==========================================
// TAMBAHAN: PLOT GRAFIK (VISUALISASI)
// ==========================================

clf(); // Bersihkan grafik lama
plot(X, Fx, 'r*', 'MarkerSize', 10); // Gambar titik stasiun (Bintang Merah)
xlabel("Waktu (menit)");
ylabel("Jarak (km)");
title("Grafik Interpolasi Posisi KRL (UI - Depok Baru)");
xgrid(1); // Tampilkan garis grid

// Gambar Garis Linear (Putus-putus Biru)
plot([X(2) X(3)], [Fx(2) Fx(3)], 'b--'); 

// Gambar Titik Prediksi Kita (Bulatan Hijau)
plot(xp, P2x, 'go', 'MarkerSize', 10, 'Thickness', 3); 
legend(['Stasiun Asli'; 'Jalur Linear'; 'Prediksi Lagrange (Menit 5)'], 4);
