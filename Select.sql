USE Library;

-- ------------------------------------------------------------
-- Abfrage 1: Alle verfügbaren Filme anzeigen
-- Zeigt dem Benutzer alle Filme, die aktuell gestreamt werden können.
-- ------------------------------------------------------------
SELECT
    FilmID,
    Titel,
    Erscheinungsjahr,
    DauerMinuten
FROM Film
WHERE IstVerfuegbar = TRUE
ORDER BY Titel ASC;


-- ------------------------------------------------------------
-- Abfrage 2: Alle verfügbaren Serien anzeigen
-- Zeigt dem Benutzer alle Serien, die aktuell gestreamt werden können.
-- ------------------------------------------------------------
SELECT
    SerieID,
    Titel,
    Erscheinungsjahr
FROM Serie
WHERE IstVerfuegbar = TRUE
ORDER BY Titel ASC;


-- ------------------------------------------------------------
-- Abfrage 3: Alle Filme eines bestimmten Genres anzeigen
-- Nützlich für die Genre-Filterfunktion auf der Startseite (z.B. "Action").
-- ------------------------------------------------------------
SELECT
    f.Titel,
    f.Erscheinungsjahr,
    f.DauerMinuten,
    g.GenreName
FROM Film f
JOIN FilmGenre fg ON f.FilmID = fg.FilmID
JOIN Genre g      ON fg.GenreID = g.GenreID
WHERE g.GenreName = 'Action'
ORDER BY f.Titel ASC;


-- ------------------------------------------------------------
-- Abfrage 4: Alle Genres eines bestimmten Films anzeigen
-- Zeigt die Genre-Tags für einen Film auf der Detailseite an.
-- ------------------------------------------------------------
SELECT
    f.Titel,
    g.GenreName
FROM Film f
JOIN FilmGenre fg ON f.FilmID = fg.FilmID
JOIN Genre g      ON fg.GenreID = g.GenreID
WHERE f.Titel = 'Inception'
ORDER BY g.GenreName ASC;


-- ------------------------------------------------------------
-- Abfrage 5: Alle Episoden einer bestimmten Serie nach Staffel sortiert
-- Wird in der Serienübersicht angezeigt, damit der Benutzer Episoden wählen kann.
-- ------------------------------------------------------------
SELECT
    s.Titel        AS Serie,
    e.Staffel,
    e.EpisodenNummer,
    e.Titel        AS Episode,
    e.DauerMinuten
FROM Serie s
JOIN Episode e ON s.SerieID = e.SerieID
WHERE s.Titel = 'Breaking Bad'
ORDER BY e.Staffel ASC, e.EpisodenNummer ASC;


-- ------------------------------------------------------------
-- Abfrage 6: Watchverlauf eines bestimmten Benutzers anzeigen
-- Zeigt dem eingeloggten Benutzer seinen persönlichen Wiedergabeverlauf.
-- Enthält sowohl Filme als auch Episoden (via LEFT JOIN).
-- ------------------------------------------------------------
SELECT
    b.Vorname,
    b.Nachname,
    COALESCE(f.Titel, CONCAT(s.Titel, ' – ', e.Titel)) AS Inhalt,
    CASE WHEN w.FilmID IS NOT NULL THEN 'Film' ELSE 'Episode' END AS Typ,
    w.StartZeitpunkt,
    w.FortschrittProzent
FROM WatchHistory w
JOIN Benutzer b         ON w.BenutzerID = b.BenutzerID
LEFT JOIN Film f        ON w.FilmID = f.FilmID
LEFT JOIN Episode e     ON w.EpisodeID = e.EpisodeID
LEFT JOIN Serie s       ON e.SerieID = s.SerieID
WHERE b.Email = 'anna.mueller@example.com'
ORDER BY w.StartZeitpunkt DESC;


-- ------------------------------------------------------------
-- Abfrage 7: Durchschnittliche Bewertung aller Filme anzeigen
-- Zeigt die Community-Bewertung auf der Film-Übersichtsseite.
-- Nur Filme mit mindestens einer Bewertung werden angezeigt.
-- ------------------------------------------------------------
SELECT
    f.Titel,
    f.Erscheinungsjahr,
    ROUND(AVG(bw.Bewertung), 2) AS DurchschnittsBewertung,
    COUNT(bw.BewertungID)       AS AnzahlBewertungen
FROM Film f
JOIN Bewertung bw ON f.FilmID = bw.FilmID
GROUP BY f.FilmID, f.Titel, f.Erscheinungsjahr
ORDER BY DurchschnittsBewertung DESC;


-- ------------------------------------------------------------
-- Abfrage 8: Alle Bewertungen eines bestimmten Benutzers
-- Zeigt dem Benutzer in seinem Profil, welche Filme er bewertet hat.
-- ------------------------------------------------------------
SELECT
    b.Vorname,
    b.Nachname,
    f.Titel         AS Film,
    bw.Bewertung,
    bw.Bewertungsdatum
FROM Bewertung bw
JOIN Benutzer b ON bw.BenutzerID = b.BenutzerID
JOIN Film f     ON bw.FilmID = f.FilmID
WHERE b.Email = 'anna.mueller@example.com'
ORDER BY bw.Bewertungsdatum DESC;


-- ------------------------------------------------------------
-- Abfrage 9: Alle Serien eines bestimmten Genres anzeigen
-- Für die Genre-Filterfunktion im Serien-Bereich der Plattform.
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
-- Abfrage 10: Top-10 meistgeschaute Filme (nach Anzahl Wiedergaben)
-- Wird auf der Startseite als "Trending jetzt" angezeigt.
-- ------------------------------------------------------------
SELECT
    f.Titel,
    f.Erscheinungsjahr,
    COUNT(w.WatchID) AS AnzahlWiedergaben
FROM Film f
JOIN WatchHistory w ON f.FilmID = w.FilmID
GROUP BY f.FilmID, f.Titel, f.Erscheinungsjahr
ORDER BY AnzahlWiedergaben DESC
LIMIT 10;


-- ------------------------------------------------------------
-- Abfrage 11: Alle noch nicht vollständig geschauten Inhalte eines Benutzers
-- "Weiterschauen"-Funktion: Inhalte mit weniger als 95% Fortschritt.
-- ------------------------------------------------------------
SELECT
    b.Vorname,
    b.Nachname,
    COALESCE(f.Titel, CONCAT(s.Titel, ' – S', e.Staffel, 'E', e.EpisodenNummer, ' ', e.Titel)) AS Inhalt,
    w.FortschrittProzent,
    w.StartZeitpunkt
FROM WatchHistory w
JOIN Benutzer b         ON w.BenutzerID = b.BenutzerID
LEFT JOIN Film f        ON w.FilmID = f.FilmID
LEFT JOIN Episode e     ON w.EpisodeID = e.EpisodeID
LEFT JOIN Serie s       ON e.SerieID = s.SerieID
WHERE b.Email = 'max.meier@example.com'
  AND w.FortschrittProzent < 95
ORDER BY w.StartZeitpunkt DESC;


-- ------------------------------------------------------------
-- Abfrage 12: Anzahl Episoden pro Staffel einer bestimmten Serie
-- Nützlich für die Staffelübersicht in der Seriendetailansicht.
-- ------------------------------------------------------------
SELECT
    s.Titel     AS Serie,
    e.Staffel,
    COUNT(e.EpisodeID)          AS AnzahlEpisoden,
    SUM(e.DauerMinuten)         AS GesamtdauerMinuten
FROM Serie s
JOIN Episode e ON s.SerieID = e.SerieID
WHERE s.Titel = 'Stranger Things'
GROUP BY s.Titel, e.Staffel
ORDER BY e.Staffel ASC;


-- ------------------------------------------------------------
-- Abfrage 13: Alle Benutzer, die sich im letzten Jahr registriert haben
-- Für das Admin-Dashboard zur Übersicht neuer Benutzer.
-- ------------------------------------------------------------
SELECT
    BenutzerID,
    Vorname,
    Nachname,
    Email,
    Registrierungsdatum
FROM Benutzer
WHERE Registrierungsdatum >= DATE_SUB(NOW(), INTERVAL 1 YEAR)
  AND IstAktiv = TRUE
ORDER BY Registrierungsdatum DESC;