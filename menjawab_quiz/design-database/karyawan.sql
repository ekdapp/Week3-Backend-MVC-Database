CREATE TABLE Karyawan (
	id_karyawan INT PRIMARY KEY,
  	nama VARCHAR(50) NOT NULL,
  	jabatan VARCHAR(20) NOT NULL,
  	gaji INT
);

CREATE TABLE Absensi (
	id_absen INT PRIMARY KEY,
  	id_karyawan INT,
  	waktu_masuk DATETIME,
  	waktu_keluar DATETIME,
  FOREIGN KEY (id_karyawan) REFERENCES Karyawan(id_karyawan)
);

CREATE TABLE Proyek (
	id_proyek INT PRIMARY KEY,
  	nama_proyek VARCHAR(50),
  	keuntungan INT
);

CREATE TABLE ManajemenTugas (
	id_manajemen INT PRIMARY KEY,
  	id_karyawan INT,
  	id_proyek INT,
  	deskripsi_tugas TEXT NOT NULL,
  	status VARCHAR(10) NOT NULL,
 	FOREIGN KEY (id_proyek) REFERENCES Proyek(id_proyek),
 	FOREIGN KEY (id_karyawan) REFERENCES Karyawan(id_karyawan)
);



INSERT INTO Karyawan (id_karyawan, nama, jabatan, gaji) VALUES 
	(1, 'Anang', 'Manajer', 150),
	(2, 'Lucky', 'Drafter', 70),
	(3, 'Sultan', 'Surveyor', 50),
	(4, 'Rofiq', 'Supervisor', 80),
	(5, 'Casmadi', 'HSE', 40);
   

INSERT INTO Proyek (id_proyek, nama_proyek, keuntungan) VALUES
	(001, 'Meikarta T60007', 2000),
	(002, 'Meikarta T39021', 5000);




INSERT INTO ManajemenTugas (id_manajemen, id_karyawan, id_proyek, deskripsi_tugas, status) VALUES
    (1, 1, 1, 'Mengatur Jalannya Proyek', 'berjalan'),
    (2, 2, 1, 'Revisi ShopDrawing', 'berjalan'),
    (3, 3, 1, 'Marking Level Lantai 23', 'selesai'),
    (4, 4, 1, 'Mengawas Lantai 19', 'berjalan'),
    (5, 5, 1, 'Tidur', 'selesai');

INSERT INTO ManajemenTugas (id_manajemen, id_karyawan, id_proyek, deskripsi_tugas, status) VALUES
    (6, 1, 2, 'Mengatur Jalannya Proyek', 'selesai'),
    (7, 2, 2, 'Membuat As-Built Drawing', 'selesai');

    
--YYYY-MM-DD HH:MM:SS
INSERT INTO Absensi (id_absen, id_karyawan, waktu_masuk, waktu_keluar) VALUES
	(4, 4, '2025-02-10 07:56:01', '2025-02-10 17:07:02'),
	(1, 1, '2025-02-10 08:00:00', '2025-02-10 17:34:21'),
    (5, 5, '2025-02-10 08:01:11', '2025-02-10 17:56:57'),
	(2, 2, '2025-02-10 08:05:54', '2025-02-10 17:16:43'),
	(3, 3, '2025-02-10 08:12:01', '2025-02-10 17:56:00');



--Pengeluaran Gaji
SELECT ManajemenTugas.id_proyek,
	Proyek.nama_proyek,
    COUNT(DISTINCT ManajemenTugas.id_karyawan) AS banyak_karyawan,
    SUM(DISTINCT Karyawan.gaji) AS total_gaji
FROM ManajemenTugas
JOIN Proyek ON ManajemenTugas.id_proyek = Proyek.id_proyek
JOIN Karyawan ON ManajemenTugas.id_karyawan = Karyawan.id_karyawan
WHERE ManajemenTugas.id_proyek = 1;

SELECT ManajemenTugas.id_proyek,
	Proyek.nama_proyek,
    COUNT(DISTINCT ManajemenTugas.id_karyawan) AS banyak_karyawan,
    SUM(DISTINCT Karyawan.gaji) AS total_gaji
FROM ManajemenTugas
JOIN Proyek ON ManajemenTugas.id_proyek = Proyek.id_proyek
JOIN Karyawan ON ManajemenTugas.id_karyawan = Karyawan.id_karyawan
WHERE ManajemenTugas.id_proyek = 1;






SELECT ManajemenTugas.id_proyek,
	Proyek.nama_proyek,
    Proyek.keuntungan AS omset,
    SUM(DISTINCT Karyawan.gaji) AS total_gaji,
    Proyek.keuntungan - SUM(DISTINCT Karyawan.gaji) AS laba
FROM ManajemenTugas
JOIN Proyek ON ManajemenTugas.id_proyek = Proyek.id_proyek
JOIN Karyawan ON ManajemenTugas.id_karyawan = Karyawan.id_karyawan
WHERE ManajemenTugas.id_proyek = 1;