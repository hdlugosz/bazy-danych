-- 1. Utwórz now¹ bazê danych nazywaj¹c j¹ firma

CREATE DATABASE firma;

USE firma;

-- 2. Dodaj nowy schemat o nazwie rozliczenia.

CREATE SCHEMA rozliczenia;

-- 3. Dodaj do schematu rozliczenia tabele (pracownicy, godziny, pensje, premie)

CREATE TABLE rozliczenia.pracownicy(id_pracownika integer PRIMARY KEY NOT NULL, imie varchar(20) NOT NULL, nazwisko varchar(20) NOT NULL, adres varchar(60), telefon varchar(12));

CREATE TABLE rozliczenia.godziny(id_godziny integer PRIMARY KEY NOT NULL, _data date NOT NULL, liczba_godzin integer NOT NULL, id_pracownika integer NOT NULL);

CREATE TABLE rozliczenia.pensje(id_pensji integer PRIMARY KEY NOT NULL, stanowisko varchar(30), kwota float(24) NOT NULL, id_premii integer);

CREATE TABLE rozliczenia.premie(id_premii integer PRIMARY KEY NOT NULL, rodzaj varchar(30), kwota float(24) NOT NULL);

-- Dodanie kluczy obcych przy u¿yciu ALTER TABLE

ALTER TABLE rozliczenia.godziny
ADD FOREIGN KEY (id_pracownika) REFERENCES rozliczenia.pracownicy(id_pracownika);

ALTER TABLE rozliczenia.pensje
ADD FOREIGN KEY (id_premii) REFERENCES rozliczenia.premie(id_premii);

-- 4. Wype³nij ka¿d¹ tabelê 10. rekordami.

INSERT INTO rozliczenia.pracownicy VALUES
(1, 'Aleksander', 'Wilk', 'ul. Zamkowa 11', '695273827'),
(2, 'Kazimiera', 'Socha', 'ul. Waryñskiego 1b', '508704262'),
(3, 'Celina', 'Soko³owska', NULL, NULL),
(4, 'Oksana', 'Wolska', 'ul. Witosa 6a', '552801976'),
(5, 'Brygida', 'Kozio³', 'ul. Konopnickiej 1', NULL),
(6, 'Bogus³aw', 'Konieczny', 'ul. Bema 5', '702001928'),
(7, 'Wioletta', '£ukasik', 'ul. Obwodowa 136', '826491672'),
(8, 'Natalia', 'Pietrzak', 'ul. Robotnicza 172c', '684927722'),
(9, 'Arleta', 'Kaczmarczyk', 'ul. Bronowicka 12c', '725688200'),
(10, 'Zdzis³aw', 'Krupa', NULL, '649267399');

INSERT INTO rozliczenia.godziny VALUES
(1, '2019-10-15', 160, 1),
(2, '2019-10-15', 168, 2),
(3, '2019-10-16', 168, 3),
(4, '2019-10-17', 152, 4),
(5, '2019-10-18', 140, 5),
(6, '2019-10-26', 80, 6),
(7, '2019-11-01', 176, 7),
(8, '2019-11-02', 160, 8),
(9, '2019-11-02', 96, 9),
(10, '2019-11-05', 240, 10);

INSERT INTO rozliczenia.premie VALUES
(1, 'efektywnoœciowa', 280),
(2, 'uznaniowa', 800),
(3, 'motywacyjna', 2.56),
(4, 'zadaniowa', 67),
(5, 'zadaniowa', 67),
(6, NULL, 14000),
(7, NULL, 7200),
(8, 'udzia³owa', 821),
(9, 'roczna', 560.90),
(10, NULL, 12.50);

INSERT INTO rozliczenia.pensje VALUES
(1, 'monter', 2360, 1),
(2, 'ochroniarz', 2200, 2),
(3, 'kierowca', 3800, 3),
(4, 'kierowca', 4000, 4),
(5, NULL, 17000, 5),
(6, 'kierownik produkcji', 7800, 6),
(7, NULL, 2300, 7),
(8, NULL, 3680, 8),
(9, 'prezes', 8250, 9),
(10, 'brygadzista', 4100, 10);

--
SELECT * FROM rozliczenia.pracownicy
SELECT * FROM rozliczenia.godziny
SELECT * FROM rozliczenia.pensje
SELECT * FROM rozliczenia.premie
--

-- 5. Za pomoc¹ zapytania SQL wyœwietl nazwiska pracownikówi ich adresy.

SELECT nazwisko, adres FROM rozliczenia.pracownicy;

-- 6. Napisz zapytanie, które przekonwertuje datê w tabeli godziny tak, 
--    aby wyœwietlana by³a informacja jaki to dzieñ tygodnia i jaki miesi¹c (funkcja DATEPART x2).

-- Wykorzystuj¹c DATENAME(otrzymujemy nazwê dnia tygodnia oraz miesi¹ca):
SELECT id_godziny, liczba_godzin, _data, DATENAME(WEEKDAY, _data) AS dzieñ_tygodnia, DATENAME(MONTH, _data) AS miesi¹c, id_pracownika FROM rozliczenia.godziny;

-- Wykorzystuj¹c DATEPART(otrzymujemy numer dnia tygodnia oraz miesi¹ca):
SELECT id_godziny, liczba_godzin, _data, DATEPART(WEEKDAY, _data) AS dzieñ_tygodnia, DATEPART(MONTH, _data) AS miesi¹c, id_pracownika FROM rozliczenia.godziny;

-- 7. W tabeli pensje zmieñ nazwê atrybutu kwota na kwota_brutto oraz dodaj nowy o nazwie kwota_netto. Oblicz kwotê netto i zaktualizuj wartoœci w tabeli.

exec SP_RENAME 'rozliczenia.pensje.kwota', 'kwota_brutto', 'COLUMN';

ALTER TABLE rozliczenia.pensje
ADD kwota_netto float(24);

UPDATE rozliczenia.pensje
SET kwota_netto = kwota_brutto * 0.8;

SELECT * FROM rozliczenia.pensje;