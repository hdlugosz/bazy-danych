-- tabela geochronologiczna znormalizowana

CREATE TABLE GeoEon(id_eon int PRIMARY KEY NOT NULL, nazwa_eon varchar(20));
CREATE TABLE GeoEra(id_era int PRIMARY KEY NOT NULL, id_eon int, nazwa_era varchar(20));
CREATE TABLE GeoOkres(id_okres int PRIMARY KEY NOT NULL, id_era int, nazwa_okres varchar(20));
CREATE TABLE GeoEpoka(id_epoka int PRIMARY KEY NOT NULL, id_okres int, nazwa_epoka varchar(20));
CREATE TABLE GeoPietro(id_pietro int PRIMARY KEY NOT NULL, id_epoka int, nazwa_pietro varchar(20));

ALTER TABLE GeoEra ADD FOREIGN KEY (id_eon) REFERENCES GeoEon(id_eon);
ALTER TABLE GeoOkres ADD FOREIGN KEY (id_era) REFERENCES GeoEra(id_era);
ALTER TABLE GeoEpoka ADD FOREIGN KEY (id_okres) REFERENCES GeoOkres(id_okres);
ALTER TABLE GeoPietro ADD FOREIGN KEY (id_epoka) REFERENCES GeoEpoka(id_epoka);
-- wprowadzenie danych do tabel

INSERT INTO GeoEon VALUES
(1, 'Fanerozoik');

SELECT * FROM GeoEon


INSERT INTO GeoEra VALUES
(1, 1, 'Kenozoik'),
(2, 1, 'Mezozoik'),
(3, 1, 'Paleozoik');

SELECT * FROM GeoEra


INSERT INTO GeoOkres VALUES
(1, 1, 'Czwartorząd'),
(2, 1, 'Neogen'),
(3, 1, 'Paleogen'),
(4, 2, 'Kreda'),
(5, 2, 'Jura'),
(6, 2, 'Trias'),
(7, 3, 'Perm'),
(8, 3, 'Karbon'),
(9, 3, 'Dewon');

SELECT * FROM GeoOkres


INSERT INTO GeoEpoka VALUES
(1, 1, 'Holocen'),
(2, 1, 'Plejstocen'),
(3, 2, 'Pliocen'),
(4, 2, 'Miocen'),
(5, 3, 'Oligocen'),
(6, 3, 'Eocen'),
(7, 3, 'Paleocen'),
(8, 4, 'Górna Kreda'),
(9, 4, 'Dolna Kreda'),
(10, 5, 'Górna Jura'),
(11, 5, 'Środkowa Jura'),
(12, 5, 'Dolna Jura'),
(13, 6, 'Górny Trias'),
(14, 6, 'Środkowy Trias'),
(15, 6, 'Dolny Trias'),
(16, 7, 'Górny Perm'),
(17, 7, 'Dolny Perm'),
(18, 8, 'Górny Karbon'),
(19, 8, 'Dolny Karbon'),
(20, 9, 'Górny Dewon'),
(21, 9, 'Środkowy Dewon'),
(22, 9, 'Dolny Dewon');

SELECT * FROM GeoEpoka

INSERT INTO GeoPietro VALUES
(1, 1, 'megalaj'),
(2, 1, 'northgrip'),
(3, 1, 'grenland'),
(4, 2, 'późny'),
(5, 2, 'chiban'),
(6, 2, 'kalabr'),
(7, 2, 'gelas'),
(8, 3, 'piacent'),
(9, 3, 'zankl'),\
(10, 4, 'messyn'),
(11, 4, 'torton'),
(12, 4, 'serrawal'),
(13, 4, 'lang'),
(14, 4, 'burdygał'),
(15, 4, 'akwitan'),
(16, 5, 'szat'),
(17, 5, 'rupel'),
(18, 6, 'priabon'),
(19, 6, 'barton'),
(20, 6, 'lutet'),
(21, 6, 'iprez'),
(22, 7, 'tanet'),
(23, 7, 'zeland'),
(24, 7, 'dan'),
(25, 8, 'mastrycht'),
(26, 8, 'kampan'),
(27, 8, 'santon'),
(28, 8, 'koniak'),
(29, 8, 'turon'),
(30, 8, 'cenoman'),
(31, 9, 'alb'),
(32, 9, 'apt'),
(33, 9, 'barrem'),
(34, 9, 'hoteryw'),
(35, 9, 'walanżyn'),
(36, 9, 'berrias'),
(37, 10, 'tyton'),
(38, 10, 'kimeryd'),
(39, 10, 'oksford'),
(40, 11, 'kelowej'),
(41, 11, 'baton'),
(42, 11, 'bajos'),
(43, 11, 'aalen'),
(44, 12, 'toark'),
(45, 12, 'pliensbach'),
(46, 12, 'synemur'),
(47, 12, 'hettang'),
(48, 13, 'retyk'),
(49, 13, 'noryk'),
(50, 13, 'karnik'),
(51, 14, 'ladyn'),
(52, 14, 'anizyk'),
(53, 15, 'olenek'),
(54, 15, 'ind'),
(55, 16, 'czangsing'),
(56, 16, 'wucziaping'),
(57, 16, 'kapitan'),
(58, 16, 'word'),
(59, 16, 'road'),
(60, 17, 'kungur'),
(61, 17, 'artinsk'),
(62, 17, 'sakmar'),
(63, 17, 'assel'),
(64, 18, 'gżel'),
(65, 18, 'kasimow'),
(66, 18, 'moskow'),
(67, 18, 'baszkir'),
(68, 19, 'serpuchow'),
(69, 19, 'wizen'),
(70, 19, 'turnej'),
(71, 20, 'famen'),
(72, 20, 'fran'),
(73, 21, 'żywet'),
(74, 21, 'eifel'),
(75, 22, 'ems'),
(76, 22, 'prag'),
(77, 22, 'lochkow');

SELECT * FROM GeoPietro

-- tabela geochronologiczna zdenormalizowana


SELECT id_pietro, nazwa_pietro, epoka.id_epoka, nazwa_epoka, okres.id_okres, nazwa_okres, era.id_era, nazwa_era, eon.id_eon, nazwa_eon INTO GeoTabela
FROM GeoPietro as pietro
		JOIN GeoEpoka as epoka
			ON pietro.id_epoka = epoka.id_epoka
		JOIN GeoOkres as okres
			ON okres.id_okres = epoka.id_okres
		JOIN GeoEra as era
			ON era.id_era = okres.id_era
		JOIN GeoEon as eon
			ON eon.id_eon = era.id_eon;


ALTER TABLE GeoTabela
ADD PRIMARY KEY (id_pietro)

SELECT * FROM GeoTabela

-- tabela milion wypelniona kolejnymi liczbami naturalnymi od 0 do 999 999

CREATE TABLE Milion(liczba int,cyfra int, bit int);

CREATE TABLE Dziesiec(cyfra int, bit int);

INSERT INTO Dziesiec VALUES
(1,1),
(2,1),
(3,1),
(4,1),
(5,1),
(6,1),
(7,1),
(8,1),
(9,1),
(0,1);

INSERT INTO Milion SELECT a1.cyfra + 10*a2.cyfra + 100*a3.cyfra + 1000*a4.cyfra + 10000*a5.cyfra + 100000*a6.cyfra 
AS liczba , a1.cyfra AS cyfra, a1.bit AS bit
FROM Dziesiec a1, Dziesiec a2, Dziesiec a3, Dziesiec a4, Dziesiec a5, Dziesiec a6 ;


SELECT * FROM Milion ORDER BY liczba

--DELETE FROM Milion WHERE bit = 1;
