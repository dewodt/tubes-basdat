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
*/

import { faker } from "@faker-js/faker";
import mariadb from "mariadb";
import { addDays, addMonths, subMonths } from "date-fns";

const Main = async () => {
  // Generate AppleID data (20 data)
  const randomEmails: string[] = [];
  for (let i = 0; i < 30; i++) {
    randomEmails.push(faker.internet.email());
  }

  // Map generate jumlah masing2 orang/apple user id
  const appleUserSubscriptionCountMap = new Map<string, number>();
  for (let email of randomEmails) {
    // Randomize subscription count 1 to 24 times
    const randomSubscriptionIds = faker.number.int({ min: 1, max: 24 });

    // Set to map
    appleUserSubscriptionCountMap.set(email, randomSubscriptionIds);
  }

  // Generate SubscriptionPlan data (3)
  const subscriptionPlans = ["pelajar", "perorangan", "keluarga"];

  // Generate label id (20)
  const labelIds = Array.from({ length: 30 }, (_, i) => i + 1);

  // ContentIDs (100)
  const contentIds = Array.from({ length: 200 }, (_, i) => i + 1);

  // Generate audio quality data (2)
  // 20% none, 40% hi-res-lossless, 30% dolby-atmos, 10% both
  const audioQualities = ["hi-res-lossless", "dolby-atmos"];

  // Generate lyrics data
  // 40% lagu ada lirik
  const lyricsLineMap = new Map<number, number>();
  for (let i = 0; i < 100; i++) {
    const randomLyricsLine = faker.number.int({ min: 1, max: 6 });
    lyricsLineMap.set(i + 1, randomLyricsLine);
  }

  // Produk komersial data
  const productComerialsIds = Array.from({ length: 60 }, (_, i) => i + 1);

  // Playlist
  const playlistIds = Array.from({ length: 60 }, (_, i) => i + 1);

  // GENERATED APPLEID
  const generatedAppleID = randomEmails.map((email) => {
    return {
      email,
      password: faker.internet.password(),
      namaPengguna: faker.person.fullName(),
      noTeleponCadangan: faker.phone.number(),
    };
  });

  // GENERATED SUBSCRIPTION_PLAN
  const generatedSubscriptionPlan = subscriptionPlans.map(
    (jenisSubscription) => {
      return {
        jenisSubscription,
        harga: faker.commerce.price(),
      };
    }
  );

  // GENERATED APPLEMUSICUSER
  const generatedAppleMusicUser = randomEmails
    .map((email) => {
      // For each generated emails / apple id

      // Get generated subscription count
      const randomSubscriptionIds = appleUserSubscriptionCountMap.get(
        email
      ) as number;

      // End date (next month / 3 months ago)
      const randomMonthCount = faker.number.int({ min: -1, max: 3 });
      const endLastSubscribeDate = subMonths(new Date(), randomMonthCount);

      return Array.from({ length: randomSubscriptionIds }, (_, i) => {
        // Start date
        // randomSubscriptionId is 1 ~ 24
        const startSubscribeDate = subMonths(
          endLastSubscribeDate,
          randomSubscriptionIds - i
        );

        // End date
        const endSubscribeDate = addMonths(startSubscribeDate, 1);

        return {
          email,
          idSubscription: i + 1,
          jenisSubscription:
            subscriptionPlans[faker.number.int({ min: 0, max: 2 })],
          tanggalSubscribe: startSubscribeDate.toISOString().split("T")[0],
          tanggalExpired: endSubscribeDate.toISOString().split("T")[0],
          status: i == randomSubscriptionIds - 1 ? "aktif" : "inaktif",
        };
      });
    })
    .flat();

  // GENERATED LABEL
  // Minimum date/year: 1960
  const generatedLabel = labelIds.map((id) => {
    return {
      idLabel: id,
      nama: faker.company.name(),
      tahunBerdiri: faker.date.past({ years: 2 }).getFullYear(),
      asalNegara: faker.location.country(),
    };
  });

  // GENERATE SONG
  const generatedSong = contentIds.map((id) => {
    // Get random artist email subscription (to determine release date)
    // random apple music user
    const randomArtistSubscription = faker.helpers.arrayElement(
      generatedAppleMusicUser
    );

    // Tanggal rilis 1-10 hari setelah artist subscribe (dari subscription yang dipilih)
    // Release date
    const releaseDate = addDays(
      new Date(randomArtistSubscription.tanggalSubscribe),
      faker.number.int({ min: 1, max: 10 })
    );

    return {
      idSong: id,
      idLabel: faker.helpers.arrayElement(labelIds),
      emailArtist: randomArtistSubscription.email,
      idSubscriptionArtist: randomArtistSubscription.idSubscription,
      judul: faker.music.songName(),
      durasi: faker.number.int({ min: 60, max: 600 }),
      tanggalRilis: releaseDate.toISOString().split("T")[0],
    };
  });

  // GENERATED MUSIC VIDE
  // generate 90% song extra video 2-3 videos for each song
  // Initialize musiv video id
  let musicVideoId = 0;
  const generatedMusicVideo = generatedSong
    .filter((_, i) => i < generatedSong.length * 0.9)
    .map((song) => {
      // Tanggal rilis 1-15 hari setelah rilis lagu
      const rilisDateVideo = addDays(
        new Date(song.tanggalRilis),
        faker.number.int({ min: 1, max: 15 })
      );

      // Generate 2-3 extra video for each song
      return Array.from(
        { length: faker.number.int({ min: 2, max: 3 }) },
        (_, i) => {
          // Increment music video id
          musicVideoId++;
          return {
            idMusicVideo: musicVideoId,
            idLabel: song.idLabel, // same label to song
            emailArtist: song.emailArtist, // equal to song email artist
            idSubscriptionArist: song.idSubscriptionArtist,
            idSong: song.idSong,
            judul: faker.music.songName() + " (Extra Video " + (i + 1) + ")",
            durasi: faker.number.int({ min: 60, max: 600 }),
            tanggalRilis: rilisDateVideo.toISOString().split("T")[0],
          };
        }
      );
    })
    .flat();

  // GENERATED EXTRA VIDEO
  const generatedExtraVideo = contentIds.map((id) => {
    // Get random artist email subscription (guest star)
    const randomArtistSubscription = faker.helpers.arrayElement(
      generatedAppleMusicUser
    );

    // Tanggal rilis 1-10 hari setelah subscribe (from selected subscription)
    const releaseDate = addDays(
      new Date(randomArtistSubscription.tanggalSubscribe),
      faker.number.int({ min: 1, max: 10 })
    );

    const randomTitle = "Interview with " + faker.lorem.sentence();

    return {
      idExtraVideo: id,
      idLabel: faker.helpers.arrayElement(labelIds),
      emailGuestStar: randomArtistSubscription.email,
      idSubscriptionGuestStar: randomArtistSubscription.idSubscription,
      judul: randomTitle,
      durasi: faker.number.int({ min: 120, max: 600 }),
      tanggalRilis: releaseDate.toISOString().split("T")[0],
    };
  });

  // GENERATED AUDIO QUALITY
  const generatedAudioQuality = generatedSong
    .filter((_, i) => i < 80) // 20% no audio quality data stored
    .map((song) => {
      return Array.from(
        { length: faker.number.int({ min: 1, max: 2 }) }, // 1 or 2 audio quality
        (_, i) => {
          return {
            idSong: song.idSong,
            jenisAudio: audioQualities[i],
          };
        }
      );
    })
    .flat();

  // GENERATED LYRICS
  const generatedLyrics = generatedSong
    .filter((_, i) => i < 40) // 60% lagu no lyrics
    .map((song) => {
      return Array.from(
        { length: lyricsLineMap.get(song.idSong) as number }, // generated lyrics line count
        (_, i) => {
          // Find artist that has subscription after song release and not the same as artist
          const validAppleMusicUsers = generatedAppleMusicUser.filter(
            (user) =>
              user.email !== song.emailArtist &&
              new Date(user.tanggalSubscribe).getTime() >
                new Date(song.tanggalRilis).getTime()
          );

          // Randomize
          const randomSelectedSubscription =
            faker.helpers.arrayElement(validAppleMusicUsers);

          return {
            idSong: song.idSong,
            line: i + 1,
            lyric: faker.lorem.sentence(),
            emailWriter: randomSelectedSubscription.email,
            idSubscriptionWriter: randomSelectedSubscription.idSubscription,
          };
        }
      );
    })
    .flat();

  // GENERATED MEMASARKAN
  const generatedMemasarkan = productComerialsIds
    // For each product commerical
    .map((productId) => {
      // Picked / selected song to be marketed (unique per product komersial id)
      const pickedSongId: number[] = [];

      // Picked songs must have same artist email in a product commercial
      const chosenArtist =
        faker.helpers.arrayElement(generatedSong).emailArtist;
      const randomSongFromSameArtist = generatedSong.filter(
        (song) => song.emailArtist === chosenArtist
      );

      return Array.from(
        {
          length: faker.number.int({
            min: 1,
            max: randomSongFromSameArtist.length,
          }),
        }, // 2-10 songs marketed each ProdukKomersial
        (_, i) => {
          // Randomize song that hasn't been picked
          const unpickedSongs = randomSongFromSameArtist.filter(
            (song) => !pickedSongId.includes(song.idSong)
          );
          const randomSelectedSong = faker.helpers.arrayElement(unpickedSongs);

          // Push to picked song
          pickedSongId.push(randomSelectedSong.idSong);

          return {
            idProdukKomersial: productId,
            idSong: randomSelectedSong.idSong,
          };
        }
      );
    })
    .flat();

  // GENERATED PRODUK KOMERSIAL
  const generatedProdukKomersial = productComerialsIds.map((id) => {
    // Product commercial email = song's artist email
    // Get song's artist email & subscription id
    const connectedRelation = generatedMemasarkan.find(
      (rel) => rel.idProdukKomersial === id
    )!;
    const sampleSong = generatedSong.find(
      (song) => song.idSong === connectedRelation.idSong
    )!;

    // Tanggal rilis 1-15 hari setelah lagu rilis
    const releaseDate = addDays(
      new Date(sampleSong.tanggalRilis),
      faker.number.int({ min: 1, max: 15 })
    );

    return {
      idProdukKomersial: id,
      emailArtist: sampleSong.emailArtist,
      idSubscriptionArtist: sampleSong.idSubscriptionArtist,
      judulProduk: faker.music.songName(),
      genre: faker.music.genre(),
      tanggalRilis: releaseDate.toISOString().split("T")[0],
      tipeProduk: faker.helpers.arrayElement(["album", "ep", "single"]),
    };
  });

  // GENERATED PLAYLIST
  const generatedPlaylist = playlistIds.map((id) => {
    // Randomize email creator
    const randomAppleMusicUser = faker.helpers.arrayElement(
      generatedAppleMusicUser
    );

    return {
      idPlaylist: id,
      emailCreator: randomAppleMusicUser.email,
      idSubscriptionCreator: randomAppleMusicUser.idSubscription,
      namaPlaylist:
        faker.science.chemicalElement().name +
        faker.music.genre() +
        faker.music.songName(),
    };
  });

  // GENERATED TERDIRI DARI
  const generatedTerdiriDari = generatedPlaylist
    .map((playlist) => {
      // Picked song id + product id
      const pickedSongIdProductId: string[] = [];

      // 5 ~ 10 songs marketed each ProdukKomersial
      return Array.from(
        { length: faker.number.int({ min: 5, max: 10 }) },
        (_, i) => {
          // Filter unpicked song id + product id
          const unpickedSongIdProductId = generatedMemasarkan.filter(
            (pasar) => {
              return !pickedSongIdProductId.includes(
                pasar.idSong + "_" + pasar.idProdukKomersial
              );
            }
          );

          // Randomize
          const randomSelectedUnpicked = faker.helpers.arrayElement(
            unpickedSongIdProductId
          );

          // Push to picked
          pickedSongIdProductId.push(
            randomSelectedUnpicked.idSong +
              "_" +
              randomSelectedUnpicked.idProdukKomersial
          );

          return {
            idPlaylist: playlist.idPlaylist,
            idSong: randomSelectedUnpicked.idSong,
            idProdukKomersial: randomSelectedUnpicked.idProdukKomersial,
          };
        }
      );
    })
    .flat();

  // GENERATED MENGHOST
  const generatedMenghost = generatedExtraVideo.map((extraVideo) => {
    // Find random apple music user except guest star
    const allExceptGuest = generatedAppleMusicUser.filter(
      (subscription) => subscription.email !== extraVideo.emailGuestStar
    );

    // Randomize
    const pickedSubscription = faker.helpers.arrayElement(allExceptGuest);

    return {
      emailHoster: pickedSubscription.email,
      idSubscriptionHoster: pickedSubscription.idSubscription,
      idExtraVideo: extraVideo.idExtraVideo,
    };
  });

  // Create mariadb pool
  const pool = mariadb.createPool({
    host: "localhost",
    user: "tubes2",
    password: "12345",
    database: "apple_music",
  });

  // INSERT TO DATABASE!
  const connection = await pool.getConnection();
  await connection.beginTransaction();

  // INSERT APPLEID
  try {
    await connection.batch(
      "INSERT INTO AppleID VALUES (?, ?, ?, ?)",
      generatedAppleID.map((appleID) => [
        appleID.email,
        appleID.password,
        appleID.namaPengguna,
        appleID.noTeleponCadangan,
      ])
    );

    // INSERT SUBSCRIPTION PLAN
    await connection.batch(
      "INSERT INTO SubscriptionPlan VALUES (?, ?)",
      generatedSubscriptionPlan.map((subscriptionPlan) => [
        subscriptionPlan.jenisSubscription,
        subscriptionPlan.harga,
      ])
    );

    // INSERT APPLEMUSICUSER
    await connection.batch(
      "INSERT INTO AppleMusicUser VALUES (?, ?, ?, ?, ?, ?)",
      generatedAppleMusicUser.map((appleMusicUser) => [
        appleMusicUser.email,
        appleMusicUser.idSubscription,
        appleMusicUser.tanggalSubscribe,
        appleMusicUser.tanggalExpired,
        appleMusicUser.status,
        appleMusicUser.jenisSubscription,
      ])
    );

    // INSERT LABEL
    await connection.batch(
      "INSERT INTO Label VALUES (?, ?, ?, ?)",
      generatedLabel.map((label) => [
        label.idLabel,
        label.nama,
        label.tahunBerdiri,
        label.asalNegara,
      ])
    );

    // INSERT EXTRA VIDEO
    await connection.batch(
      "INSERT INTO ExtraVideo VALUES (?, ?, ?, ?, ?, ?, ?)",
      generatedExtraVideo.map((extraVideo) => [
        extraVideo.idExtraVideo,
        extraVideo.idLabel,
        extraVideo.emailGuestStar,
        extraVideo.idSubscriptionGuestStar,
        extraVideo.judul,
        extraVideo.durasi,
        extraVideo.tanggalRilis,
      ])
    );

    // INSERT SONG
    await connection.batch(
      "INSERT INTO Song VALUES (?, ?, ?, ?, ?, ?, ?)",
      generatedSong.map((song) => [
        song.idSong,
        song.idLabel,
        song.emailArtist,
        song.idSubscriptionArtist,
        song.judul,
        song.durasi,
        song.tanggalRilis,
      ])
    );

    // INSERT MUSIC VIDEO
    await connection.batch(
      "INSERT INTO MusicVideo VALUES (?, ?, ?, ?, ?, ?, ?, ?)",
      generatedMusicVideo.map((musicVideo) => [
        musicVideo.idMusicVideo,
        musicVideo.idLabel,
        musicVideo.emailArtist,
        musicVideo.idSubscriptionArist,
        musicVideo.idSong,
        musicVideo.judul,
        musicVideo.durasi,
        musicVideo.tanggalRilis,
      ])
    );

    // INSERT AUDIO QUALITY
    await connection.batch(
      "INSERT INTO AudioQuality VALUES (?, ?)",
      generatedAudioQuality.map((audioQuality) => [
        audioQuality.idSong,
        audioQuality.jenisAudio,
      ])
    );

    // INSERT LYRICS
    await connection.batch(
      "INSERT INTO Lyrics VALUES (?, ?, ?, ?, ?)",
      generatedLyrics.map((lyric) => [
        lyric.idSong,
        lyric.line,
        lyric.lyric,
        lyric.emailWriter,
        lyric.idSubscriptionWriter,
      ])
    );

    // INSERT PRODUK KOMERSIAL
    await connection.batch(
      "INSERT INTO ProdukKomersial VALUES (?, ?, ?, ?, ?, ?, ?)",
      generatedProdukKomersial.map((produk) => [
        produk.idProdukKomersial,
        produk.emailArtist,
        produk.idSubscriptionArtist,
        produk.judulProduk,
        produk.genre,
        produk.tanggalRilis,
        produk.tipeProduk,
      ])
    );

    // INSERT MEMASARKAN
    await connection.batch(
      "INSERT INTO Memasarkan VALUES (?, ?)",
      generatedMemasarkan.map((pasar) => [
        pasar.idProdukKomersial,
        pasar.idSong,
      ])
    );

    // INSERT PLAYLIST
    await connection.batch(
      "INSERT INTO Playlist VALUES (?, ?, ?, ?)",
      generatedPlaylist.map((playlist) => [
        playlist.idPlaylist,
        playlist.emailCreator,
        playlist.idSubscriptionCreator,
        playlist.namaPlaylist,
      ])
    );

    // INSERT TERDIRI DARI
    await connection.batch(
      "INSERT INTO TerdiriDari VALUES (?, ?, ?)",
      generatedTerdiriDari.map((terdiri) => [
        terdiri.idPlaylist,
        terdiri.idSong,
        terdiri.idProdukKomersial,
      ])
    );

    // INSERT MENGHOST
    await connection.batch(
      "INSERT INTO Menghost VALUES (?, ?, ?)",
      generatedMenghost.map((menghost) => [
        menghost.emailHoster,
        menghost.idSubscriptionHoster,
        menghost.idExtraVideo,
      ])
    );

    await connection.commit();
  } catch (error) {
    console.error("Error inserting AppleID", error);
    await connection.rollback();
  } finally {
    await connection.release();
    console.log("done");
  }
};

Main();
