CREATE DATABASE IF NOT EXISTS INF2025j_Hebeisen_Maier_StreamingLibrary
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE INF2025j_Hebeisen_Maier_StreamingLibrary;

CREATE TABLE IF NOT EXISTS Genre (
    GenreID     INT             NOT NULL AUTO_INCREMENT,
    GenreName   VARCHAR(100)    NOT NULL,
    CONSTRAINT pk_Genre PRIMARY KEY (GenreID),
    CONSTRAINT uq_Genre_GenreName UNIQUE (GenreName)
);


CREATE TABLE IF NOT EXISTS Benutzer (
    BenutzerID          INT             NOT NULL AUTO_INCREMENT,
    Vorname             VARCHAR(100)    NOT NULL,
    Nachname            VARCHAR(100)    NOT NULL,
    Email               VARCHAR(255)    NOT NULL,
    Passwort            VARCHAR(255)    NOT NULL,
    Registrierungsdatum TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    IstAktiv            BOOLEAN         NOT NULL DEFAULT TRUE,
    CONSTRAINT pk_Benutzer PRIMARY KEY (BenutzerID),
    CONSTRAINT uq_Benutzer_Email UNIQUE (Email)
);


CREATE TABLE IF NOT EXISTS Film (
    FilmID          INT             NOT NULL AUTO_INCREMENT,
    Titel           VARCHAR(255)    NOT NULL,
    Beschreibung    TEXT,
    Erscheinungsjahr INT            NOT NULL,
    DauerMinuten    INT             NOT NULL,
    IstVerfuegbar   BOOLEAN         NOT NULL DEFAULT TRUE,
    CONSTRAINT pk_Film PRIMARY KEY (FilmID),
    CONSTRAINT ck_Film_Erscheinungsjahr CHECK (Erscheinungsjahr >= 1888),
    CONSTRAINT ck_Film_DauerMinuten CHECK (DauerMinuten > 0)
);

CREATE TABLE IF NOT EXISTS Serie (
    SerieID         INT             NOT NULL AUTO_INCREMENT,
    Titel           VARCHAR(255)    NOT NULL,
    Beschreibung    TEXT,
    Erscheinungsjahr INT            NOT NULL,
    IstVerfuegbar   BOOLEAN         NOT NULL DEFAULT TRUE,
    CONSTRAINT pk_Serie PRIMARY KEY (SerieID),
    CONSTRAINT ck_Serie_Erscheinungsjahr CHECK (Erscheinungsjahr >= 1888)
);

CREATE TABLE IF NOT EXISTS Episode (
    EpisodeID       INT             NOT NULL AUTO_INCREMENT,
    SerieID         INT             NOT NULL,
    Titel           VARCHAR(255)    NOT NULL,
    Staffel         INT             NOT NULL,
    EpisodenNummer  INT             NOT NULL,
    DauerMinuten    INT             NOT NULL,
    CONSTRAINT pk_Episode PRIMARY KEY (EpisodeID),
    CONSTRAINT fk_Episode_Serie FOREIGN KEY (SerieID)
        REFERENCES Serie (SerieID)
        ON DELETE CASCADE,
    CONSTRAINT ck_Episode_Staffel CHECK (Staffel >= 1),
    CONSTRAINT ck_Episode_EpisodenNummer CHECK (EpisodenNummer >= 1),
    CONSTRAINT ck_Episode_DauerMinuten CHECK (DauerMinuten > 0)
);

CREATE TABLE IF NOT EXISTS FilmGenre (
    FilmGenreID INT NOT NULL AUTO_INCREMENT,
    FilmID      INT NOT NULL,
    GenreID     INT NOT NULL,
    CONSTRAINT pk_FilmGenre PRIMARY KEY (FilmGenreID),
    CONSTRAINT fk_FilmGenre_Film FOREIGN KEY (FilmID)
        REFERENCES Film (FilmID)
        ON DELETE CASCADE,
    CONSTRAINT fk_FilmGenre_Genre FOREIGN KEY (GenreID)
        REFERENCES Genre (GenreID)
        ON DELETE NO ACTION,
    CONSTRAINT uq_FilmGenre UNIQUE (FilmID, GenreID)
);

CREATE TABLE IF NOT EXISTS SerieGenre (
    SerieGenreID    INT NOT NULL AUTO_INCREMENT,
    SerieID         INT NOT NULL,
    GenreID         INT NOT NULL,
    CONSTRAINT pk_SerieGenre PRIMARY KEY (SerieGenreID),
    CONSTRAINT fk_SerieGenre_Serie FOREIGN KEY (SerieID)
        REFERENCES Serie (SerieID)
        ON DELETE CASCADE,
    CONSTRAINT fk_SerieGenre_Genre FOREIGN KEY (GenreID)
        REFERENCES Genre (GenreID)
        ON DELETE NO ACTION,
    CONSTRAINT uq_SerieGenre UNIQUE (SerieID, GenreID)
);

CREATE TABLE IF NOT EXISTS Bewertung (
    BewertungID     INT         NOT NULL AUTO_INCREMENT,
    BenutzerID      INT         NOT NULL,
    FilmID          INT         NOT NULL,
    Bewertung       INT         NOT NULL,
    Bewertungsdatum TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_Bewertung PRIMARY KEY (BewertungID),
    CONSTRAINT fk_Bewertung_Benutzer FOREIGN KEY (BenutzerID)
        REFERENCES Benutzer (BenutzerID)
        ON DELETE CASCADE,
    CONSTRAINT fk_Bewertung_Film FOREIGN KEY (FilmID)
        REFERENCES Film (FilmID)
        ON DELETE CASCADE,
    CONSTRAINT ck_Bewertung_Wert CHECK (Bewertung BETWEEN 1 AND 5),
    CONSTRAINT uq_Bewertung UNIQUE (BenutzerID, FilmID)
);


CREATE TABLE IF NOT EXISTS WatchHistory (
    WatchID             INT         NOT NULL AUTO_INCREMENT,
    BenutzerID          INT         NOT NULL,
    FilmID              INT,
    EpisodeID           INT,
    StartZeitpunkt      TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FortschrittProzent  INT         NOT NULL DEFAULT 0,
    CONSTRAINT pk_WatchHistory PRIMARY KEY (WatchID),
    CONSTRAINT fk_WatchHistory_Benutzer FOREIGN KEY (BenutzerID)
        REFERENCES Benutzer (BenutzerID)
        ON DELETE CASCADE,
    CONSTRAINT fk_WatchHistory_Film FOREIGN KEY (FilmID)
        REFERENCES Film (FilmID)
        ON DELETE NO ACTION,
    CONSTRAINT fk_WatchHistory_Episode FOREIGN KEY (EpisodeID)
        REFERENCES Episode (EpisodeID)
        ON DELETE NO ACTION,
    CONSTRAINT ck_WatchHistory_Fortschritt CHECK (FortschrittProzent BETWEEN 0 AND 100),
    CONSTRAINT ck_WatchHistory_Inhalt CHECK (
        (FilmID IS NOT NULL AND EpisodeID IS NULL) OR
        (FilmID IS NULL AND EpisodeID IS NOT NULL)
    )
);