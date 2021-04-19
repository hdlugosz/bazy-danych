-- 1. Utwórz now¹ bazê danych nazywaj¹c j¹ firma

CREATE DATABASE firma;

USE firma;

-- 2. Dodaj nowy schemat o nazwie ksiegowosc.

CREATE SCHEMA ksiegowosc;

-- 3. Dodaj do schematu ksiegowosc tabele (pracownicy, godziny, pensje, premie, wynagrodzenie)

-- tabela pracownicy zawiera dane osobowe pracownikow, kluczem glownym jest id_pracownika
CREATE TABLE ksiegowosc.pracownicy(id_pracownika integer PRIMARY KEY NOT NULL, imie varchar(20) NOT NULL, nazwisko varchar(20) NOT NULL, adres varchar(60), telefon varchar(15));

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

-- 6. Wykonaj nastêpuj¹ce zapytania: 

-- a) Wyœwietl tylko id pracownika oraz jego nazwisko.

SELECT id_pracownika, nazwisko FROM ksiegowosc.pracownicy

-- b) Wyœwietl id pracowników, których p³aca jest wiêksza ni¿ 3000.

SELECT id_pracownika, kwota
	FROM ksiegowosc.wynagrodzenie AS wynagrodzenie
		JOIN ksiegowosc.pensje AS pensje
			ON wynagrodzenie.id_pensji = pensje.id_pensji
	WHERE kwota > 3000

-- c)  Wyœwietl id pracowników nieposiadaj¹cych premii, których p³aca jest wiêksza ni¿ 2000.

SELECT id_pracownika, pensje.kwota AS pensje_kwota, premie.kwota AS premie_kwota
	FROM ksiegowosc.wynagrodzenie AS wynagrodzenie
		JOIN ksiegowosc.pensje AS pensje
			ON wynagrodzenie.id_pensji=pensje.id_pensji
		JOIN ksiegowosc.premie AS premie
			ON wynagrodzenie.id_premii = premie.id_premii
	WHERE pensje.kwota > 2000 AND premie.kwota IS NULL

-- d) Wyœwietl pracowników, których pierwsza litera imienia zaczyna siê na literê ‘B’.

SELECT imie, nazwisko 
	FROM ksiegowosc.pracownicy
		WHERE imie LIKE 'B%'

-- e) Wyœwietl pracowników, których nazwisko zawiera literê ‘o’ oraz imiê koñczy siê na literê ‘a’.

SELECT imie, nazwisko 
	FROM ksiegowosc.pracownicy
		WHERE nazwisko LIKE '%o%'AND imie LIKE '%a'

-- f) Wyœwietl imiê i nazwisko pracowników oraz liczbê ich nadgodzin, przyjmuj¹c, i¿ standardowy czas pracy to 160 h miesiêcznie. 

SELECT imie, nazwisko, (liczba_godzin-160) AS liczba_nadgodzin
	FROM ksiegowosc.pracownicy AS pracownicy
		JOIN ksiegowosc.wynagrodzenie AS wynagrodzenie
			ON pracownicy.id_pracownika = wynagrodzenie.id_pracownika
		JOIN ksiegowosc.godziny AS godziny
			ON godziny.id_godziny = wynagrodzenie.id_godziny
	WHERE godziny.liczba_godzin > 160

-- g) Wyœwietl imiê i nazwisko pracowników, których pensja zawiera siê w przedziale 3000 – 5000 PLN.

SELECT imie, nazwisko, pensje.kwota
	FROM ksiegowosc.pracownicy AS pracownicy
		JOIN ksiegowosc.wynagrodzenie AS wynagrodzenie
			ON pracownicy.id_pracownika = wynagrodzenie.id_pracownika
		JOIN ksiegowosc.pensje AS pensje
			ON wynagrodzenie.id_pensji = pensje.id_pensji
	WHERE kwota >= 3000 AND kwota <= 5000

-- drugi sposob 
SELECT imie, nazwisko, pensje.kwota
	FROM ksiegowosc.pracownicy AS pracownicy
		JOIN ksiegowosc.wynagrodzenie AS wynagrodzenie
			ON pracownicy.id_pracownika = wynagrodzenie.id_pracownika
		JOIN ksiegowosc.pensje AS pensje
			ON wynagrodzenie.id_pensji = pensje.id_pensji
	WHERE kwota BETWEEN 3000 AND 5000
	
-- h) Wyœwietl imiê i nazwisko pracowników, którzy pracowali w nadgodzinach i nie otrzymali premii.

SELECT imie, nazwisko, liczba_godzin - 160 AS liczba_nadgodzin, premie.kwota AS wysokosc_premii
	FROM ksiegowosc.pracownicy AS pracownicy
		JOIN ksiegowosc.wynagrodzenie AS wynagrodzenie
			ON wynagrodzenie.id_pracownika = pracownicy.id_pracownika
		JOIN ksiegowosc.premie AS premie
			ON premie.id_premii = wynagrodzenie.id_premii
		JOIN ksiegowosc.godziny AS godziny
			ON godziny.id_godziny = wynagrodzenie.id_godziny
		WHERE godziny.liczba_godzin > 160 AND premie.kwota IS NULL

-- i) Uszereguj pracowników wed³ug pensji.

SELECT imie, nazwisko, pensje.kwota
	FROM ksiegowosc.pracownicy AS pracownicy
		JOIN ksiegowosc.wynagrodzenie AS wynagrodzenie
			ON pracownicy.id_pracownika = wynagrodzenie.id_pracownika
		JOIN ksiegowosc.pensje AS pensje
			ON pensje.id_pensji = wynagrodzenie.id_pensji
		ORDER BY pensje.kwota 

-- j) Uszereguj pracowników wed³ug pensji i premii malej¹co. (Jesli byloby kilka takich samych kwot pensji, wtedy sortowaloby po wysokosci premii malejaco)

SELECT imie, nazwisko, pensje.kwota AS kwota_pensji, premie.kwota kwota_premii
	FROM ksiegowosc.pracownicy AS pracownicy
		JOIN ksiegowosc.wynagrodzenie AS wynagrodzenie
			ON pracownicy.id_pracownika = wynagrodzenie.id_pracownika
		JOIN ksiegowosc.pensje AS pensje
			ON pensje.id_pensji = wynagrodzenie.id_pensji
		JOIN ksiegowosc.premie AS premie
			ON wynagrodzenie.id_premii = premie.id_premii
	ORDER BY pensje.kwota DESC, premie.kwota DESC

-- k) Zlicz i pogrupuj pracowników wed³ug pola ‘stanowisko’.

SELECT COUNT(*) AS liczba_pracownikow, stanowisko
	FROM ksiegowosc.pensje
		GROUP BY stanowisko

-- l) Policz œredni¹, minimaln¹ i maksymaln¹ p³acê dla stanowiska ‘kierowca’ 

SELECT AVG(pensje.kwota) AS srednia_pensja, MIN(pensje.kwota) AS minimalna_pensja, MAX(pensje.kwota) AS maksymalna_pensja
	FROM ksiegowosc.pensje AS pensje
	GROUP BY stanowisko
	HAVING stanowisko = 'kierowca' --HAVING to takie WHERE dla pogrupowanych danych

-- m) Policz sumê wszystkich wynagrodzeñ.

SELECT SUM(pensje.kwota) AS suma_pensji
	FROM ksiegowosc.pensje AS pensje

-- n) Policz sumê wynagrodzeñ w ramach danego stanowiska.

SELECT SUM(pensje.kwota) AS suma_pensji, pensje.stanowisko
	FROM ksiegowosc.pensje AS pensje
	GROUP BY stanowisko

-- o) Wyznacz liczbê premii przyznanych dla pracowników danego stanowiska

SELECT COUNT(premie.kwota), stanowisko
	FROM ksiegowosc.premie AS premie
		JOIN ksiegowosc.pensje AS pensje
			ON premie.id_premii = pensje.id_pensji
	GROUP BY stanowisko

-- p) Usuñ wszystkich pracowników maj¹cych pensjê mniejsz¹ ni¿ 4000 z³.

DELETE pracownicy
	FROM ksiegowosc.pracownicy AS pracownicy
		JOIN ksiegowosc.wynagrodzenie AS wynagrodzenie
			ON  wynagrodzenie.id_pracownika = pracownicy.id_pracownika
		JOIN ksiegowosc.pensje AS pensje
			ON pensje.id_pensji = wynagrodzenie.id_pensji
	WHERE pensje.kwota < 4000


SELECT imie, nazwisko, kwota 
	FROM ksiegowosc.pracownicy AS pracownicy
	JOIN ksiegowosc.wynagrodzenie AS wynagrodzenie
	ON wynagrodzenie.id_pracownika = pracownicy.id_pracownika
	JOIN ksiegowosc.pensje AS pensje
	ON wynagrodzenie.id_pensji = pensje.id_pensji

SELECT * FROM ksiegowosc.wynagrodzenie