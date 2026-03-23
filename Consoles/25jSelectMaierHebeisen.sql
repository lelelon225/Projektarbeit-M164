-- ============================================================
-- Skript 3: Abfragen (SELECT-Befehle)
-- Projekt: Streaming-Plattform
-- ============================================================

USE INF2025j_Hebeisen_Maier_StreamingLibrary;

-- ------------------------------------------------------------
-- Abfrage 1: Alle verfügbaren Genres anzeigen
-- Zeigt dem Benutzer die komplette Genre-Liste für den Filterbereich.
-- Tabellen: Genre
-- ------------------------------------------------------------
SELECT
    GenreID,
    GenreName
FROM Genre
ORDER BY GenreName ASC;


-- ------------------------------------------------------------
-- Abfrage 2: Alle verfügbaren Serien anzeigen
-- Zeigt alle aktiven Serien auf der Plattform.
-- Tabellen: Serie
-- ------------------------------------------------------------
SELECT
    SerieID,
    Titel,
    Erscheinungsjahr
FROM Serie
WHERE IstVerfuegbar = TRUE
ORDER BY Erscheinungsjahr DESC;


-- ------------------------------------------------------------
-- Abfrage 3: Alle Filme des Genres "Science-Fiction" anzeigen
-- Filtert Filme nach einem bestimmten Genre – typische Benutzeranfrage.
-- Tabellen: Film, FilmGenre, Genre
-- ------------------------------------------------------------
SELECT
    f.Titel,
    f.Erscheinungsjahr,
    f.DauerMinuten,
    g.GenreName
FROM Film f
JOIN FilmGenre fg ON f.FilmID = fg.FilmID
JOIN Genre g      ON fg.GenreID = g.GenreID
WHERE g.GenreName = 'Science-Fiction'
  AND f.IstVerfuegbar = TRUE
ORDER BY f.Erscheinungsjahr DESC;


-- ------------------------------------------------------------
-- Abfrage 4: Alle Serien des Genres "Drama" anzeigen
-- Filtert Serien nach einem bestimmten Genre.
-- Tabellen: Serie, SerieGenre, Genre
-- ------------------------------------------------------------
SELECT
    s.Titel,
    s.Erscheinungsjahr,
    g.GenreName
FROM Serie s
JOIN SerieGenre sg ON s.SerieID = sg.SerieID
JOIN Genre g       ON sg.GenreID = g.GenreID
WHERE g.GenreName = 'Drama'
ORDER BY s.Titel ASC;


-- ------------------------------------------------------------
-- Abfrage 5: Alle Episoden von "Breaking Bad" sortiert nach Staffel und Nummer
-- Zeigt die vollständige Episodenliste einer Serie.
-- Tabellen: Serie, Episode
-- ------------------------------------------------------------
SELECT
    s.Titel           AS Serie,
    e.Staffel,
    e.EpisodenNummer,
    e.Titel           AS Episode,
    e.DauerMinuten
FROM Episode e
JOIN Serie s ON e.SerieID = s.SerieID
WHERE s.Titel = 'Breaking Bad'
ORDER BY e.Staffel ASC, e.EpisodenNummer ASC;


-- ------------------------------------------------------------
-- Abfrage 6: Watchverlauf von Tobias Fischer (inkl. Filme und Episoden)
-- Zeigt dem eingeloggten Benutzer seinen persönlichen Wiedergabeverlauf.
-- Tabellen: WatchHistory, Benutzer, Film, Episode, Serie
-- ------------------------------------------------------------
SELECT
    b.Vorname,
    b.Nachname,
    COALESCE(f.Titel, CONCAT(s.Titel, ' - S', e.Staffel, 'E', e.EpisodenNummer)) AS Inhalt,
    CASE WHEN w.FilmID IS NOT NULL THEN 'Film' ELSE 'Episode' END                 AS Typ,
    w.FortschrittProzent,
    w.StartZeitpunkt
FROM WatchHistory w
JOIN Benutzer b       ON w.BenutzerID = b.BenutzerID
LEFT JOIN Film f      ON w.FilmID = f.FilmID
LEFT JOIN Episode e   ON w.EpisodeID = e.EpisodeID
LEFT JOIN Serie s     ON e.SerieID = s.SerieID
WHERE b.Email = 'tobias.fischer@example.com'
ORDER BY w.StartZeitpunkt DESC;


-- ------------------------------------------------------------
-- Abfrage 7: Alle Bewertungen von Lukas Wagner
-- Zeigt dem Benutzer im Profil, welche Filme er bewertet hat.
-- Tabellen: Bewertung, Benutzer, Film
-- ------------------------------------------------------------
SELECT
    b.Vorname,
    b.Nachname,
    f.Titel           AS Film,
    bw.Bewertung,
    bw.Bewertungsdatum
FROM Bewertung bw
JOIN Benutzer b ON bw.BenutzerID = b.BenutzerID
JOIN Film f     ON bw.FilmID = f.FilmID
WHERE b.Email = 'lukas.wagner@example.com'
ORDER BY bw.Bewertungsdatum DESC;


-- ------------------------------------------------------------
-- Abfrage 8: Durchschnittliche Bewertung pro Film (min. 2 Bewertungen)
-- Zeigt die Community-Bewertung – nur Filme mit genug Stimmen werden angezeigt.
-- Tabellen: Film, Bewertung
-- ------------------------------------------------------------
SELECT
    f.Titel,
    f.Erscheinungsjahr,
    ROUND(AVG(bw.Bewertung), 2) AS DurchschnittsBewertung,
    COUNT(bw.BewertungID)       AS AnzahlBewertungen
FROM Film f
JOIN Bewertung bw ON f.FilmID = bw.FilmID
GROUP BY f.FilmID, f.Titel, f.Erscheinungsjahr
HAVING COUNT(bw.BewertungID) >= 2
ORDER BY DurchschnittsBewertung DESC;


-- ------------------------------------------------------------
-- Abfrage 9: Alle Inhalte, die nicht vollständig angeschaut wurden (plattformweit)
-- Grundlage für die "Weiterschauen"-Funktion auf der Startseite.
-- Tabellen: WatchHistory, Benutzer, Film, Episode, Serie
-- ------------------------------------------------------------
SELECT
    b.Vorname,
    b.Nachname,
    COALESCE(f.Titel, CONCAT(s.Titel, ' - S', e.Staffel, 'E', e.EpisodenNummer)) AS Inhalt,
    CASE WHEN w.FilmID IS NOT NULL THEN 'Film' ELSE 'Episode' END                 AS Typ,
    w.FortschrittProzent,
    w.StartZeitpunkt
FROM WatchHistory w
JOIN Benutzer b       ON w.BenutzerID = b.BenutzerID
LEFT JOIN Film f      ON w.FilmID = f.FilmID
LEFT JOIN Episode e   ON w.EpisodeID = e.EpisodeID
LEFT JOIN Serie s     ON e.SerieID = s.SerieID
WHERE w.FortschrittProzent < 95
ORDER BY w.FortschrittProzent ASC;


-- ------------------------------------------------------------
-- Abfrage 10: Alle Filme, die nach 2015 erschienen sind
-- Nützlich für den Filter "Neuerscheinungen" auf der Plattform.
-- Tabellen: Film
-- ------------------------------------------------------------
SELECT
    Titel,
    Erscheinungsjahr,
    DauerMinuten
FROM Film
WHERE Erscheinungsjahr > 2015
  AND IstVerfuegbar = TRUE
ORDER BY Erscheinungsjahr DESC, Titel ASC;


-- ------------------------------------------------------------
-- Abfrage 11: Alle Genres eines bestimmten Films anzeigen ("Inception")
-- Zeigt die Genre-Tags auf der Filmdetailseite.
-- Tabellen: Film, FilmGenre, Genre
-- ------------------------------------------------------------
SELECT
    f.Titel,
    f.Erscheinungsjahr,
    g.GenreName
FROM Film f
JOIN FilmGenre fg ON f.FilmID = fg.FilmID
JOIN Genre g      ON fg.GenreID = g.GenreID
WHERE f.Titel = 'Inception'
ORDER BY g.GenreName ASC;


-- ------------------------------------------------------------
-- Abfrage 12: Alle aktiven Benutzer, die sich 2024 registriert haben
-- Für das Admin-Dashboard zur Übersicht neuer Benutzer.
-- Tabellen: Benutzer
-- ------------------------------------------------------------
SELECT
    Vorname,
    Nachname,
    Email,
    Registrierungsdatum
FROM Benutzer
WHERE YEAR(Registrierungsdatum) = 2024
  AND IstAktiv = TRUE
ORDER BY Registrierungsdatum ASC;


-- ------------------------------------------------------------
-- Abfrage 13: Alle Filme mit Bewertung 5 Sterne anzeigen
-- Zeigt dem Benutzer die Top-bewerteten Filme der Community.
-- Tabellen: Film, Bewertung, Benutzer
-- ------------------------------------------------------------
SELECT
    f.Titel,
    f.Erscheinungsjahr,
    b.Vorname,
    b.Nachname,
    bw.Bewertungsdatum
FROM Bewertung bw
JOIN Film f     ON bw.FilmID = f.FilmID
JOIN Benutzer b ON bw.BenutzerID = b.BenutzerID
WHERE bw.Bewertung = 5
ORDER BY f.Titel ASC, bw.Bewertungsdatum DESC;


-- ------------------------------------------------------------
-- Abfrage 14: Anzahl Episoden und Gesamtdauer pro Serie
-- Gibt einen Überblick über den Umfang jeder Serie auf der Plattform.
-- Tabellen: Serie, Episode
-- ------------------------------------------------------------
SELECT
    s.Titel                     AS Serie,
    s.Erscheinungsjahr,
    COUNT(e.EpisodeID)          AS AnzahlEpisoden,
    SUM(e.DauerMinuten)         AS GesamtdauerMinuten,
    ROUND(AVG(e.DauerMinuten))  AS DurchschnittsdauerMinuten
FROM Serie s
JOIN Episode e ON s.SerieID = e.SerieID
GROUP BY s.SerieID, s.Titel, s.Erscheinungsjahr
ORDER BY AnzahlEpisoden DESC;