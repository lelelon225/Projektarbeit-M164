USE Library;

-- ------------------------------------------------------------
-- Import: Genre
-- ------------------------------------------------------------
LOAD DATA LOCAL INFILE 'C:\\Lehre\\25.25-Gibb\\M164\\Projektarbeit-M164\\CSV\\Genre.csv'
INTO TABLE Genre
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(GenreID, GenreName);

-- ------------------------------------------------------------
-- Import: Benutzer
-- ------------------------------------------------------------
LOAD DATA LOCAL INFILE 'C:\\Lehre\\25.25-Gibb\\M164\\Projektarbeit-M164\\CSV\\Benutzer.csv'
INTO TABLE Benutzer
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(BenutzerID, Vorname, Nachname, Email, Passwort, Registrierungsdatum, IstAktiv);

-- ------------------------------------------------------------
-- Import: Film
-- ------------------------------------------------------------
LOAD DATA LOCAL INFILE 'C:\\Lehre\\25.25-Gibb\\M164\\Projektarbeit-M164\\CSV\\Film.csv'
INTO TABLE Film
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(FilmID, Titel, Beschreibung, Erscheinungsjahr, DauerMinuten, IstVerfuegbar);

-- ------------------------------------------------------------
-- Import: Serie
-- ------------------------------------------------------------
LOAD DATA LOCAL INFILE 'C:\\Lehre\\25.25-Gibb\\M164\\Projektarbeit-M164\\CSV\\Serie.csv'
INTO TABLE Serie
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(SerieID, Titel, Beschreibung, Erscheinungsjahr, IstVerfuegbar);

-- ------------------------------------------------------------
-- Import: Episode
-- ------------------------------------------------------------
LOAD DATA LOCAL INFILE 'C:\\Lehre\\25.25-Gibb\\M164\\Projektarbeit-M164\\CSV\\Episode.csv'
INTO TABLE Episode
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(EpisodeID, SerieID, Titel, Staffel, EpisodenNummer, DauerMinuten);

-- ------------------------------------------------------------
-- Import: FilmGenre
-- ------------------------------------------------------------
LOAD DATA LOCAL INFILE 'C:\\Lehre\\25.25-Gibb\\M164\\Projektarbeit-M164\\CSV\\FilmGenre.csv'
INTO TABLE FilmGenre
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(FilmGenreID, FilmID, GenreID);

-- ------------------------------------------------------------
-- Import: SerieGenre
-- ------------------------------------------------------------
LOAD DATA LOCAL INFILE 'C:\\Lehre\\25.25-Gibb\\M164\\Projektarbeit-M164\\CSV\\SerieGenre.csv'
INTO TABLE SerieGenre
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(SerieGenreID, SerieID, GenreID);

-- ------------------------------------------------------------
-- Import: Bewertung
-- ------------------------------------------------------------
LOAD DATA LOCAL INFILE 'C:\\Lehre\\25.25-Gibb\\M164\\Projektarbeit-M164\\CSV\\Bewertung.csv'
INTO TABLE Bewertung
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(BewertungID, BenutzerID, FilmID, Bewertung, Bewertungsdatum);

-- ------------------------------------------------------------
-- Import: WatchHistory
-- ------------------------------------------------------------
LOAD DATA LOCAL INFILE 'C:\\Lehre\\25.25-Gibb\\M164\\Projektarbeit-M164\\CSV\\WatchHistory.csv'
INTO TABLE WatchHistory
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(WatchID, BenutzerID, @FilmID, @EpisodeID, StartZeitpunkt, FortschrittProzent)
SET
    FilmID    = NULLIF(@FilmID, ''),
    EpisodeID = NULLIF(@EpisodeID, '');
