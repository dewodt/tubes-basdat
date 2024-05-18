-- MariaDB dump 10.19  Distrib 10.6.16-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: apple_music
-- ------------------------------------------------------
-- Server version	10.6.16-MariaDB-0ubuntu0.22.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `AppleID`
--

DROP TABLE IF EXISTS `AppleID`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `AppleID` (
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `namaPengguna` varchar(255) NOT NULL,
  `noTeleponCadangan` varchar(255) NOT NULL,
  PRIMARY KEY (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `AppleID`
--

LOCK TABLES `AppleID` WRITE;
/*!40000 ALTER TABLE `AppleID` DISABLE KEYS */;
/*!40000 ALTER TABLE `AppleID` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `AppleMusicUser`
--

DROP TABLE IF EXISTS `AppleMusicUser`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `AppleMusicUser` (
  `email` varchar(255) NOT NULL,
  `idSubscription` int(10) unsigned NOT NULL,
  `tanggalSubscribe` date NOT NULL DEFAULT curdate(),
  `tanggalExpired` date NOT NULL DEFAULT (curdate() + interval 1 month),
  `status` enum('aktif','inaktif') NOT NULL,
  `jenisSubscription` enum('pelajar','perorangan','keluarga') NOT NULL,
  PRIMARY KEY (`email`,`idSubscription`),
  KEY `jenisSubscription` (`jenisSubscription`),
  CONSTRAINT `AppleMusicUser_ibfk_1` FOREIGN KEY (`email`) REFERENCES `AppleID` (`email`),
  CONSTRAINT `AppleMusicUser_ibfk_2` FOREIGN KEY (`jenisSubscription`) REFERENCES `SubscriptionPlan` (`jenisSubscription`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `AppleMusicUser`
--

LOCK TABLES `AppleMusicUser` WRITE;
/*!40000 ALTER TABLE `AppleMusicUser` DISABLE KEYS */;
/*!40000 ALTER TABLE `AppleMusicUser` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `AudioQuality`
--

DROP TABLE IF EXISTS `AudioQuality`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `AudioQuality` (
  `idSong` int(10) unsigned NOT NULL,
  `jenisAudio` enum('hi-res-lossless','dolby-atmos') NOT NULL,
  PRIMARY KEY (`idSong`,`jenisAudio`),
  CONSTRAINT `AudioQuality_ibfk_1` FOREIGN KEY (`idSong`) REFERENCES `Song` (`idSong`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `AudioQuality`
--

LOCK TABLES `AudioQuality` WRITE;
/*!40000 ALTER TABLE `AudioQuality` DISABLE KEYS */;
/*!40000 ALTER TABLE `AudioQuality` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ExtraVideo`
--

DROP TABLE IF EXISTS `ExtraVideo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ExtraVideo` (
  `idExtraVideo` int(10) unsigned NOT NULL,
  `idLabel` int(10) unsigned NOT NULL,
  `emailGuestStar` varchar(255) NOT NULL,
  `idSubscriptionGuestStar` int(10) unsigned NOT NULL,
  `judul` varchar(255) NOT NULL,
  `durasi` int(10) unsigned NOT NULL,
  `tanggalRilis` date NOT NULL DEFAULT curdate(),
  PRIMARY KEY (`idExtraVideo`),
  KEY `idLabel` (`idLabel`),
  KEY `emailGuestStar` (`emailGuestStar`,`idSubscriptionGuestStar`),
  CONSTRAINT `ExtraVideo_ibfk_1` FOREIGN KEY (`idLabel`) REFERENCES `Label` (`idLabel`),
  CONSTRAINT `ExtraVideo_ibfk_2` FOREIGN KEY (`emailGuestStar`, `idSubscriptionGuestStar`) REFERENCES `AppleMusicUser` (`email`, `idSubscription`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ExtraVideo`
--

LOCK TABLES `ExtraVideo` WRITE;
/*!40000 ALTER TABLE `ExtraVideo` DISABLE KEYS */;
/*!40000 ALTER TABLE `ExtraVideo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Label`
--

DROP TABLE IF EXISTS `Label`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Label` (
  `idLabel` int(10) unsigned NOT NULL,
  `nama` varchar(255) NOT NULL,
  `tahunBerdiri` int(10) unsigned NOT NULL,
  `asalNegara` varchar(255) NOT NULL,
  PRIMARY KEY (`idLabel`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Label`
--

LOCK TABLES `Label` WRITE;
/*!40000 ALTER TABLE `Label` DISABLE KEYS */;
/*!40000 ALTER TABLE `Label` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Lyrics`
--

DROP TABLE IF EXISTS `Lyrics`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Lyrics` (
  `idSong` int(10) unsigned NOT NULL,
  `line` int(10) unsigned NOT NULL,
  `lyric` text NOT NULL,
  `emailWriter` varchar(255) NOT NULL,
  `idSubscriptionWriter` int(10) unsigned NOT NULL,
  PRIMARY KEY (`idSong`,`line`),
  KEY `emailWriter` (`emailWriter`,`idSubscriptionWriter`),
  CONSTRAINT `Lyrics_ibfk_1` FOREIGN KEY (`idSong`) REFERENCES `Song` (`idSong`),
  CONSTRAINT `Lyrics_ibfk_2` FOREIGN KEY (`emailWriter`, `idSubscriptionWriter`) REFERENCES `AppleMusicUser` (`email`, `idSubscription`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Lyrics`
--

LOCK TABLES `Lyrics` WRITE;
/*!40000 ALTER TABLE `Lyrics` DISABLE KEYS */;
/*!40000 ALTER TABLE `Lyrics` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Memasarkan`
--

DROP TABLE IF EXISTS `Memasarkan`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Memasarkan` (
  `idProdukKomersial` int(10) unsigned NOT NULL,
  `idSong` int(10) unsigned NOT NULL,
  PRIMARY KEY (`idProdukKomersial`,`idSong`),
  KEY `idSong` (`idSong`),
  CONSTRAINT `Memasarkan_ibfk_1` FOREIGN KEY (`idProdukKomersial`) REFERENCES `ProdukKomersial` (`idProdukKomersial`),
  CONSTRAINT `Memasarkan_ibfk_2` FOREIGN KEY (`idSong`) REFERENCES `Song` (`idSong`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Memasarkan`
--

LOCK TABLES `Memasarkan` WRITE;
/*!40000 ALTER TABLE `Memasarkan` DISABLE KEYS */;
/*!40000 ALTER TABLE `Memasarkan` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Menghost`
--

DROP TABLE IF EXISTS `Menghost`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Menghost` (
  `emailHoster` varchar(255) NOT NULL,
  `idSubscriptionHoster` int(10) unsigned NOT NULL,
  `idExtraVideo` int(10) unsigned NOT NULL,
  PRIMARY KEY (`emailHoster`,`idSubscriptionHoster`,`idExtraVideo`),
  KEY `idExtraVideo` (`idExtraVideo`),
  CONSTRAINT `Menghost_ibfk_1` FOREIGN KEY (`emailHoster`, `idSubscriptionHoster`) REFERENCES `AppleMusicUser` (`email`, `idSubscription`),
  CONSTRAINT `Menghost_ibfk_2` FOREIGN KEY (`idExtraVideo`) REFERENCES `ExtraVideo` (`idExtraVideo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Menghost`
--

LOCK TABLES `Menghost` WRITE;
/*!40000 ALTER TABLE `Menghost` DISABLE KEYS */;
/*!40000 ALTER TABLE `Menghost` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `MusicVideo`
--

DROP TABLE IF EXISTS `MusicVideo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `MusicVideo` (
  `idMusicVideo` int(10) unsigned NOT NULL,
  `idLabel` int(10) unsigned NOT NULL,
  `emailArtist` varchar(255) NOT NULL,
  `idSubscriptionArtist` int(10) unsigned NOT NULL,
  `idSong` int(10) unsigned NOT NULL,
  `judul` varchar(255) NOT NULL,
  `durasi` int(10) unsigned NOT NULL,
  `tanggalRilis` date NOT NULL DEFAULT curdate(),
  PRIMARY KEY (`idMusicVideo`),
  KEY `idLabel` (`idLabel`),
  KEY `emailArtist` (`emailArtist`,`idSubscriptionArtist`),
  KEY `idSong` (`idSong`),
  CONSTRAINT `MusicVideo_ibfk_1` FOREIGN KEY (`idLabel`) REFERENCES `Label` (`idLabel`),
  CONSTRAINT `MusicVideo_ibfk_2` FOREIGN KEY (`emailArtist`, `idSubscriptionArtist`) REFERENCES `AppleMusicUser` (`email`, `idSubscription`),
  CONSTRAINT `MusicVideo_ibfk_3` FOREIGN KEY (`idSong`) REFERENCES `Song` (`idSong`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `MusicVideo`
--

LOCK TABLES `MusicVideo` WRITE;
/*!40000 ALTER TABLE `MusicVideo` DISABLE KEYS */;
/*!40000 ALTER TABLE `MusicVideo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Playlist`
--

DROP TABLE IF EXISTS `Playlist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Playlist` (
  `idPlaylist` int(10) unsigned NOT NULL,
  `emailCreator` varchar(255) NOT NULL,
  `idSubscriptionCreator` int(10) unsigned NOT NULL,
  `namaPlaylist` varchar(255) NOT NULL,
  PRIMARY KEY (`idPlaylist`, `emailCreator`),
  KEY `emailCreator` (`emailCreator`,`idSubscriptionCreator`),
  CONSTRAINT `Playlist_ibfk_1` FOREIGN KEY (`emailCreator`, `idSubscriptionCreator`) REFERENCES `AppleMusicUser` (`email`, `idSubscription`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Playlist`
--

LOCK TABLES `Playlist` WRITE;
/*!40000 ALTER TABLE `Playlist` DISABLE KEYS */;
/*!40000 ALTER TABLE `Playlist` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ProdukKomersial`
--

DROP TABLE IF EXISTS `ProdukKomersial`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ProdukKomersial` (
  `idProdukKomersial` int(10) unsigned NOT NULL,
  `emailArtist` varchar(255) NOT NULL,
  `idSubscriptionArtist` int(10) unsigned NOT NULL,
  `judulProduk` varchar(255) NOT NULL,
  `genre` varchar(255) NOT NULL,
  `tanggalRilis` date NOT NULL DEFAULT curdate(),
  `tipeProduk` enum('album','ep','single') NOT NULL,
  PRIMARY KEY (`idProdukKomersial`),
  KEY `emailArtist` (`emailArtist`,`idSubscriptionArtist`),
  CONSTRAINT `ProdukKomersial_ibfk_1` FOREIGN KEY (`emailArtist`, `idSubscriptionArtist`) REFERENCES `AppleMusicUser` (`email`, `idSubscription`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ProdukKomersial`
--

LOCK TABLES `ProdukKomersial` WRITE;
/*!40000 ALTER TABLE `ProdukKomersial` DISABLE KEYS */;
/*!40000 ALTER TABLE `ProdukKomersial` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Song`
--

DROP TABLE IF EXISTS `Song`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Song` (
  `idSong` int(10) unsigned NOT NULL,
  `idLabel` int(10) unsigned NOT NULL,
  `emailArtist` varchar(255) NOT NULL,
  `idSubscriptionArtist` int(10) unsigned NOT NULL,
  `judul` varchar(255) NOT NULL,
  `durasi` int(10) unsigned NOT NULL,
  `tanggalRilis` date NOT NULL DEFAULT curdate(),
  PRIMARY KEY (`idSong`),
  KEY `idLabel` (`idLabel`),
  KEY `emailArtist` (`emailArtist`,`idSubscriptionArtist`),
  CONSTRAINT `Song_ibfk_1` FOREIGN KEY (`idLabel`) REFERENCES `Label` (`idLabel`),
  CONSTRAINT `Song_ibfk_2` FOREIGN KEY (`emailArtist`, `idSubscriptionArtist`) REFERENCES `AppleMusicUser` (`email`, `idSubscription`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Song`
--

LOCK TABLES `Song` WRITE;
/*!40000 ALTER TABLE `Song` DISABLE KEYS */;
/*!40000 ALTER TABLE `Song` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SubscriptionPlan`
--

DROP TABLE IF EXISTS `SubscriptionPlan`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SubscriptionPlan` (
  `jenisSubscription` enum('pelajar','perorangan','keluarga') NOT NULL,
  `harga` int(10) unsigned NOT NULL,
  PRIMARY KEY (`jenisSubscription`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SubscriptionPlan`
--

LOCK TABLES `SubscriptionPlan` WRITE;
/*!40000 ALTER TABLE `SubscriptionPlan` DISABLE KEYS */;
/*!40000 ALTER TABLE `SubscriptionPlan` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `TerdiriDari`
--

DROP TABLE IF EXISTS `TerdiriDari`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `TerdiriDari` (
  `idPlaylist` int(10) unsigned NOT NULL,
  `idSong` int(10) unsigned NOT NULL,
  `idProdukKomersial` int(10) unsigned NOT NULL,
  PRIMARY KEY (`idPlaylist`,`idSong`,`idProdukKomersial`),
  KEY `idSong` (`idSong`),
  KEY `idProdukKomersial` (`idProdukKomersial`),
  CONSTRAINT `TerdiriDari_ibfk_1` FOREIGN KEY (`idPlaylist`) REFERENCES `Playlist` (`idPlaylist`),
  CONSTRAINT `TerdiriDari_ibfk_2` FOREIGN KEY (`idSong`) REFERENCES `Song` (`idSong`),
  CONSTRAINT `TerdiriDari_ibfk_3` FOREIGN KEY (`idProdukKomersial`) REFERENCES `ProdukKomersial` (`idProdukKomersial`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `TerdiriDari`
--

LOCK TABLES `TerdiriDari` WRITE;
/*!40000 ALTER TABLE `TerdiriDari` DISABLE KEYS */;
/*!40000 ALTER TABLE `TerdiriDari` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-05-06  0:39:17
