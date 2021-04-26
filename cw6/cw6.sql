-- 1. Utwórz now¹ bazê danych nazywaj¹c j¹ firma

CREATE DATABASE firma;

USE firma;

-- 2. Dodaj nowy schemat o nazwie ksiegowosc.

CREATE SCHEMA ksiegowosc;

-- 3. Dodaj do schematu ksiegowosc tabele (pracownicy, godziny, pensje, premie, wynagrodzenie)

-- tabela pracownicy zawiera dane osobowe pracownikow, kluczem glownym jest id_pracownika
CREATE TABLE ksiegowosc.pracownicy(id_pracownika integer PRIMARY KEY NOT NULL, imie varchar(20) NOT NULL, nazwisko varchar(20) NOT NULL, adres varchar(60), telefon varchar(20));

-- tabela godziny zawiera informacje nt. ilosci przepracowanych godzin przez pracownika. id_godziny pelni role klucza glownego
CREATE TABLE ksiegowosc.godziny(id_godziny integer PRIMARY KEY NOT NULL, _data date NOT NULL, liczba_godzin integer NOT NULL);

-- tabela pensje zawiera informacje nt. stanowiska, wysokosci pensji. id_pensji pelni role klucza glownego
CREATE TABLE ksiegowosc.pensje(id_pensji integer PRIMARY KEY NOT NULL, stanowisko varchar(30), kwota float(24) NOT NULL);

-- tabela premie zawiera informacje nt. rodzaju oraz wysokosci premii. id_premii pelni role klucza glownego
CREATE TABLE ksiegowosc.premie(id_premii integer PRIMARY KEY NOT NULL, rodzaj varchar(30), kwota float(24));

-- tabela wynagrodzenie laczy pozostale tabele. id_wynagrodzenia pelni role klucza glownego. klucze obce: id_pracownika -> pracownicy; id_godziny -> godziny; id_pensji -> pensje; id_premii -> premie
CREATE TABLE ksiegowosc.wynagrodzenie(id_wynagrodzenia integer PRIMARY KEY NOT NULL, _data date, id_pracownika integer NOT NULL, id_godziny integer NOT NULL, id_pensji integer NOT NULL, id_premii integer);

-- 4. Dodaj klucze obce

ALTER TABLE ksiegowosc.wynagrodzenie ADD CONSTRAINT FK_pracownicy_wynagrodzenie FOREIGN KEY (id_pracownika) REFERENCES ksiegowosc.pracownicy(id_pracownika) ON DELETE CASCADE;

ALTER TABLE ksiegowosc.wynagrodzenie ADD CONSTRAINT FK_godziny_wynagrodzenie FOREIGN KEY (id_godziny) REFERENCES ksiegowosc.godziny(id_godziny) ON DELETE CASCADE;

ALTER TABLE ksiegowosc.wynagrodzenie ADD CONSTRAINT FK_pensje_wynagrodzenie FOREIGN KEY (id_pensji) REFERENCES ksiegowosc.pensje(id_pensji) ON DELETE CASCADE;

ALTER TABLE ksiegowosc.wynagrodzenie ADD CONSTRAINT FK_premie_wynagrodzenie FOREIGN KEY (id_premii) REFERENCES ksiegowosc.premie(id_premii) ON DELETE CASCADE;


-- 5. Wype³nij ka¿d¹ tabelê 10. rekordami.

INSERT INTO ksiegowosc.pracownicy VALUES
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

INSERT INTO ksiegowosc.godziny VALUES
(1, '2019-10-15', 160),
(2, '2019-10-15', 168),
(3, '2019-10-16', 168),
(4, '2019-10-17', 152),
(5, '2019-10-18', 140),
(6, '2019-10-26', 80),
(7, '2019-11-01', 176),
(8, '2019-11-02', 160),
(9, '2019-11-02', 96),
(10, '2019-11-05', 240);

INSERT INTO ksiegowosc.premie VALUES
(1, 'efektywnoœciowa', 280),
(2, 'uznaniowa', 800),
(3, 'motywacyjna', 2.56),
(4, 'zadaniowa', 67),
(5, 'zadaniowa', 67),
(6, NULL, 14000),
(7, NULL, NULL),
(8, 'udzia³owa', 821),
(9, 'roczna', 560.90),
(10, NULL, 12.50);

INSERT INTO ksiegowosc.pensje VALUES
(1, 'monter', 2360),
(2, 'ochroniarz', 2200),
(3, 'kierowca', 3800),
(4, 'kierowca', 4000),
(5, NULL, 17000),
(6, 'kierownik produkcji', 7800),
(7, NULL, 2300),
(8, NULL, 3680),
(9, 'prezes', 8250),
(10, 'brygadzista', 4100);

INSERT INTO ksiegowosc.wynagrodzenie VALUES
(1, '2019-11-10', 1, 1, 1, 1),
(2, '2019-11-11', 2, 2, 2, 2),
(3, '2019-11-11', 3, 3, 3, 3),
(4, '2019-11-12', 4, 4, 4, 4),
(5, '2019-11-13', 5, 5, 5, 5),
(6, '2019-11-14', 6, 6, 6, 6),
(7, '2019-11-18', 7, 7, 7, 7),
(8, '2019-11-20', 8, 8, 8, 8),
(9, '2019-11-21', 9, 9, 9, 9),
(10, '2019-11-23', 10, 10, 10, 10);

-- a) Zmodyfikuj numer telefonu w tabeli pracownicy, dodaj¹c do niego kierunkowy dla Polski w nawiasie (+48)UPDATE ksiegowosc.pracownicySET telefon = CONCAT('(+48)', telefon)WHERE telefon is not NULLSELECT * FROM ksiegowosc.pracownicy-- b) Zmodyfikuj atrybut telefon w tabeli pracownicy tak, aby numer oddzielony by³ myœlnikami wg wzoru: ‘555-222-333’ 
UPDATE ksiegowosc.pracownicySET telefon = CONCAT(SUBSTRING(telefon, 1,8), '-',SUBSTRING(telefon, 9,3), '-', SUBSTRING(telefon, 10,3))WHERE telefon is not NULLSELECT * FROM ksiegowosc.pracownicy-- c) Wyœwietl dane pracownika, którego nazwisko jest najd³u¿sze, u¿ywaj¹c du¿ych literSELECT TOP 1 UPPER(imie), UPPER(nazwisko), UPPER(adres), telefon
FROM ksiegowosc.pracownicy
ORDER BY len(nazwisko) DESC

-- d) Wyœwietl dane pracowników i ich pensje zakodowane przy pomocy algorytmu md5 

SELECT HASHBYTES('MD5', imie) AS imie_md5, HASHBYTES('MD5', nazwisko) AS nazwisko_md5 , HASHBYTES('MD5', adres) AS adres_md5, HASHBYTES('MD5', telefon) telefon_md5
FROM ksiegowosc.pracownicy

-- e) Wyœwietl pracowników, ich pensje oraz premie. Wykorzystaj z³¹czenie lewostronne
SELECT id_pracownika, imie, nazwisko, pensje.kwota AS pensja, premie.kwota AS premia
	FROM ksiegowosc.pracownicy AS pracownicy
		LEFT JOIN ksiegowosc.pensje AS pensje
			ON pracownicy.id_pracownika = pensje.id_pensji
		LEFT JOIN ksiegowosc.premie AS premie
			ON pracownicy.id_pracownika = premie.id_premii

-- f) Wygeneruj raport (zapytanie), które zwróci w wyniku treœæ

SELECT CONCAT('Pracownik ', imie, ' ', nazwisko, ' w dniu ', godziny._data , ' otrzyma³ pensjê ca³kowit¹ na kwotê ', pensje.kwota + premie.kwota, ' z³, gdzie wynagrodzenie zasadnicze wynosi³o: ', pensje.kwota, 'z³, premia: ', premie.kwota, 'z³.') AS RAPORT
FROM ksiegowosc.pracownicy AS pracownicy
	JOIN ksiegowosc.wynagrodzenie AS wynagrodzenie
		ON wynagrodzenie.id_pracownika = pracownicy.id_pracownika
	JOIN ksiegowosc.pensje AS pensje
		ON pensje.id_pensji = wynagrodzenie.id_pensji
	JOIN ksiegowosc.premie AS premie
		ON premie.id_premii = wynagrodzenie.id_premii
	JOIN ksiegowosc.godziny AS godziny
		ON godziny.id_godziny = wynagrodzenie.id_godziny
