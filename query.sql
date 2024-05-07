/* 
CREATE TABLE `AppleID` (
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `namaPengguna` varchar(255) NOT NULL,
  `noTeleponCadangan` varchar(255) NOT NULL,
  PRIMARY KEY (`email`)
);

CREATE TABLE `SubscriptionPlan` (
  `jenisSubscription` ENUM('pelajar', 'perorangan', 'keluarga') NOT NULL,
  `harga` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`jenisSubscription`)
);

CREATE TABLE `AppleMusicUser` (
  `email` varchar(255) NOT NULL,
  `idSubscription` INT UNSIGNED NOT NULL,
  `tanggalSubscribe` DATE NOT NULL DEFAULT CURRENT_DATE,
  `tanggalExpired` DATE NOT NULL DEFAULT DATE_ADD(CURRENT_DATE, INTERVAL 1 MONTH),
  `status` ENUM('aktif', 'inaktif') NOT NULL,
  `jenisSubscription` ENUM('pelajar', 'perorangan', 'keluarga') NOT NULL,
  PRIMARY KEY (`email`, `idSubscription`),
  FOREIGN KEY (`email`) REFERENCES `AppleID`(`email`),
  FOREIGN KEY (`jenisSubscription`) REFERENCES `SubscriptionPlan`(`jenisSubscription`)
);


CREATE TABLE `Label` (
  `idLabel` INT UNSIGNED NOT NULL,
  `nama` varchar(255) NOT NULL,
  `tahunBerdiri` INT UNSIGNED NOT NULL,
  `asalNegara` varchar(255) NOT NULL,
  PRIMARY KEY (`idLabel`)
);

CREATE TABLE `ExtraVideo` (
  `idExtraVideo` INT UNSIGNED NOT NULL,
  `idLabel` INT UNSIGNED NOT NULL,
  `emailGuestStar` varchar(255) NOT NULL,
  `idSubscriptionGuestStar` INT UNSIGNED NOT NULL,
  `judul` varchar(255) NOT NULL,
  `durasi` INT UNSIGNED NOT NULL,
  `tanggalRilis` DATE NOT NULL DEFAULT CURRENT_DATE,
  PRIMARY KEY (`idExtraVideo`),
  FOREIGN KEY (`idLabel`) REFERENCES `Label`(`idLabel`),
  FOREIGN KEY (`emailGuestStar`, `idSubscriptionGuestStar`) REFERENCES `AppleMusicUser`(`email`, `idSubscription`)
);

CREATE TABLE `Song` (
  `idSong` INT UNSIGNED NOT NULL,
  `idLabel` INT UNSIGNED NOT NULL,
  `emailArtist` varchar(255) NOT NULL,
  `idSubscriptionArtist` INT UNSIGNED NOT NULL,
  `judul` varchar(255) NOT NULL,
  `durasi` INT UNSIGNED NOT NULL,
  `tanggalRilis` DATE NOT NULL DEFAULT CURRENT_DATE,
  PRIMARY KEY (`idSong`),
  FOREIGN KEY (`idLabel`) REFERENCES `Label`(`idLabel`),
  FOREIGN KEY (`emailArtist`, `idSubscriptionArtist`) REFERENCES `AppleMusicUser`(`email`, `idSubscription`)
);


CREATE TABLE `MusicVideo` (
  `idMusicVideo` INT UNSIGNED NOT NULL,
  `idLabel` INT UNSIGNED NOT NULL,
  `emailArtist` varchar(255) NOT NULL,
  `idSubscriptionArtist` INT UNSIGNED NOT NULL,
  `idSong` INT UNSIGNED NOT NULL,
  `judul` varchar(255) NOT NULL,
  `durasi` INT UNSIGNED NOT NULL,
  `tanggalRilis` DATE NOT NULL DEFAULT CURRENT_DATE,
  PRIMARY KEY (`idMusicVideo`),
  FOREIGN KEY (`idLabel`) REFERENCES `Label`(`idLabel`),
  FOREIGN KEY (`emailArtist`, `idSubscriptionArtist`) REFERENCES `AppleMusicUser`(`email`, `idSubscription`),
  FOREIGN KEY (`idSong`) REFERENCES `Song`(`idSong`)
);

CREATE TABLE `AudioQuality` (
  `idSong` INT UNSIGNED NOT NULL,
  `jenisAudio` ENUM('hi-res-lossless', 'dolby-atmos') NOT NULL,
  PRIMARY KEY (`idSong`, `jenisAudio`),
  FOREIGN KEY (`idSong`) REFERENCES `Song`(`idSong`)
);

CREATE TABLE `Lyrics` (
  `idSong` INT UNSIGNED NOT NULL,
  `line` INT UNSIGNED NOT NULL,
  `lyric` TEXT NOT NULL,
  `emailWriter` varchar(255) NOT NULL,
  `idSubscriptionWriter` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`idSong`, `line`),
  FOREIGN KEY (`idSong`) REFERENCES `Song`(`idSong`),
  FOREIGN KEY (`emailWriter`, `idSubscriptionWriter`) REFERENCES `AppleMusicUser`(`email`, `idSubscription`)
);

CREATE TABLE `ProdukKomersial` (
  `idProdukKomersial` INT UNSIGNED NOT NULL,
  `emailArtist` varchar(255) NOT NULL,
  `idSubscriptionArtist` INT UNSIGNED NOT NULL,
  `judulProduk` varchar(255) NOT NULL,
  `genre` varchar(255) NOT NULL,
  `tanggalRilis` DATE NOT NULL DEFAULT CURRENT_DATE,
  `tipeProduk` ENUM('album', 'ep', 'single') NOT NULL,
  PRIMARY KEY (`idProdukKomersial`),
  FOREIGN KEY (`emailArtist`, `idSubscriptionArtist`) REFERENCES `AppleMusicUser`(`email`, `idSubscription`)
);

CREATE TABLE `Memasarkan` (
  `idProdukKomersial` INT UNSIGNED NOT NULL,
  `idSong` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`idProdukKomersial`, `idSong`),
  FOREIGN KEY (`idProdukKomersial`) REFERENCES `ProdukKomersial`(`idProdukKomersial`),
  FOREIGN KEY (`idSong`) REFERENCES `Song`(`idSong`)
);

CREATE TABLE `Playlist` (
  `idPlaylist` INT UNSIGNED NOT NULL,
  `emailCreator` varchar(255) NOT NULL,
  `idSubscriptionCreator` INT UNSIGNED NOT NULL,
  `namaPlaylist` varchar(255) NOT NULL,
  PRIMARY KEY (`idPlaylist`),
  FOREIGN KEY (`emailCreator`, `idSubscriptionCreator`) REFERENCES `AppleMusicUser`(`email`, `idSubscription`)
);

CREATE TABLE `TerdiriDari` (
  `idPlaylist` INT UNSIGNED NOT NULL,
  `idSong` INT UNSIGNED NOT NULL,
  `idProdukKomersial` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`idPlaylist`, `idSong`, `idProdukKomersial`),
  FOREIGN KEY (`idPlaylist`) REFERENCES `Playlist`(`idPlaylist`),
  FOREIGN KEY (`idSong`) REFERENCES `Song`(`idSong`),
  FOREIGN KEY (`idProdukKomersial`) REFERENCES `ProdukKomersial`(`idProdukKomersial`)
);

CREATE TABLE `Menghost` (
  `emailHoster` varchar(255) NOT NULL,
  `idSubscriptionHoster` INT UNSIGNED NOT NULL,
  `idExtraVideo` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`emailHoster`, `idSubscriptionHoster`, `idExtraVideo`),
  FOREIGN KEY (`emailHoster`, `idSubscriptionHoster`) REFERENCES `AppleMusicUser`(`email`, `idSubscription`),
  FOREIGN KEY (`idExtraVideo`) REFERENCES `ExtraVideo`(`idExtraVideo`)
);

CREATE VIEW `PlaylistView` AS (
  SELECT p.idPlaylist, p.namaPlaylist, COUNT(s.idSong) AS totalLagu, SUM(s.durasi) AS totalDurasi
  FROM Playlist as p JOIN TerdiriDari as t ON p.idPlaylist = t.idPlaylist JOIN Song as s ON t.idSong = s.idSong
  GROUP BY p.idPlaylist
);

CREATE VIEW `ProdukKomersialView` AS (
  SELECT pk.idProdukKomersial, pk.judulProduk, pk.genre, pk.tanggalRilis, pk.tipeProduk, COUNT(s.idSong) AS totalLagu, SUM(s.durasi) AS totalDurasi
  FROM ProdukKomersial as pk JOIN Memasarkan as m ON pk.idProdukKomersial = m.idProdukKomersial JOIN Song as s ON m.idSong = s.idSong
  GROUP BY pk.idProdukKomersial
);

 */

/* Cari semua content creator (song artist, music video artist, extravideo host) */
-- NO 2
SELECT
  aid.namaPengguna,
  aid.noTeleponCadangan
FROM
  AppleID as aid JOIN AppleMusicUser as amu ON aid.email = amu.email JOIN Song as s ON amu.email = s.emailArtist
UNION
SELECT
  aid.namaPengguna,
  aid.noTeleponCadangan
FROM
  AppleID as aid JOIN AppleMusicUser as amu ON aid.email = amu.email JOIN MusicVideo as mv ON amu.email = mv.emailArtist 
UNION
SELECT 
  aid.namaPengguna,
  aid.noTeleponCadangan
FROM
  AppleID as aid JOIN AppleMusicUser as amu ON aid.email = amu.email JOIN ExtraVideo as ev ON amu.email = ev.emailGuestStar


-- NO 1
SELECT
  P.namaPlaylist as namaPlaylist,
  S.judul AS judulLagu,
  PK.judulProduk AS judulProdukKomersial
FROM
  Playlist AS P
  JOIN TerdiriDari AS TD ON P.idPlaylist = TD.idPlaylist
  JOIN Song AS S ON TD.idSong = S.idSong
  JOIN Memasarkan AS M ON S.idSong = M.idSong
  JOIN ProdukKomersial AS PK ON M.idProdukKomersial = PK.idProdukKomersial
ORDER BY P.namaPlaylist;
