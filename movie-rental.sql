-- usuniecie bazy danych jesli istnieje
DROP DATABASE IF EXISTS wypozyczalnia_filmow;

-- utworzenie bazy danych
CREATE DATABASE wypozyczalnia_filmow;
USE wypozyczalnia_filmow;

SET NAMES utf8;
SET character_set_client = utf8;

-- utworzenie tabel i wypelnienie wartosciami
CREATE TABLE klienci (
    id_klienta INT(11) NOT NULL AUTO_INCREMENT,
    imie VARCHAR(50) NOT NULL,
    nazwisko VARCHAR(50) NOT NULL,
    adres VARCHAR(100) NOT NULL,
    miasto VARCHAR(100) NOT NULL,
    telefon VARCHAR(9) NOT NULL CHECK (LENGTH(telefon) = 9),
    PRIMARY KEY (id_klienta),
    CONSTRAINT unikalny_telefon UNIQUE (telefon)
);
INSERT INTO klienci (imie, nazwisko, adres, miasto, telefon)
VALUES
    ('Jan', 'Kowalski', 'ul. Bukietowa 1', 'Torun', '123456789'),
    ('Marian', 'Marianowski', 'ul. Lotna 1', 'Lodz', '565656565'),
    ('Jozef', 'Poniatowski', 'ul. Marszalkowska 107G', 'Warszawa', '456456456'),
    ('Jaroslaw', 'Gesiowski', 'ul. Farysa 99', 'Warszawa', '678678678'),
    ('Wladyslaw', 'Warnenczyk', 'ul. Wenecka 4', 'Poznan', '123123123'),
    ('Adam', 'Szczurowski', 'ul. Korporacyjna 4', 'Wroclaw', '234234234'),
    ('Krzysztof', 'Kononowicz', 'ul. Szkolna 17', 'Bialystok', '745745745'),
    ('Joanna', 'Nowak', 'ul. Nowa 2', 'Krakow', '987654321'),
    ('Abraham', 'Linkoln', 'ul. Amerykanska 2', 'Warszawa', '345634568');

CREATE TABLE filmy (
    id_filmu INT(11) NOT NULL AUTO_INCREMENT,
    tytul VARCHAR(100) NOT NULL,
    gatunek VARCHAR(50) NOT NULL,
    rezyser VARCHAR(50) NOT NULL,
    rok_produkcji INT(4) NOT NULL,
	cena DECIMAL(10,2) NOT NULL DEFAULT 0,
    PRIMARY KEY (id_filmu)
);
INSERT INTO filmy (tytul, gatunek, rezyser, rok_produkcji, cena)
VALUES
    ('Incepcja', 'Sci-Fi', 'Christopher Nolan', 2010, DEFAULT),
    ('Siedem', 'Thriller', 'David Fincher', 1995, 14.0),
    ('Skazani na Shawshank', 'Dramat', 'Frank Darabont', 1994, 35.5),
    ('Krol Lew', 'Animowany', 'Rob Minkoff, Roger Allers', 1994, 24.0),
    ('Pulp fiction', 'Kryminalny', 'Quentin Tarantino', 1994, 18.0),
    ('Forrest Gump', 'Komediodramat', 'Robert Zemeckis', 1994, 17.0),
    ('Leon zawodowiec', 'Dramat', 'Luc Besson', 1994, 12.5),
    ('Braveheart Waleczne Serce', 'Dramat', 'Mel Gibson', 1995, 13.5),
    ('Goraczka', 'Sensacyjny', 'Michael Mann', 1995, 15.0),
    ('Bekarty wojny', 'Wojenny', 'Quentin Tarantino', 2009, 18.5),
    ('Django', 'Western', 'Quentin Tarantino', 2012, 19.5),
    ('Pewnego razu w Hollywood', 'Dramat, kryminal', 'Quentin Tarantino', 2019, 22.5),
    ('Avatar', 'Sci-Fi', 'James Cameron', 2009, 20.5),
    ('Avatar: Istota Wody', 'Sci-Fi', 'James Cameron', 2022, 34.5),
    ('Shrek', 'Animowany', 'Andrew Adamson, Vicky Jenson', 2001, 15.0),
    ('Avengers', 'Sci-Fun', 'Joss Whedon', 2012, 10.0),
    ('Iron Man', 'Sci-Fun', 'Jon Favreau', 2008, 12.0);

CREATE TABLE wypozyczenia (
    id_wypozyczenia INT(11) NOT NULL AUTO_INCREMENT,
    id_klienta INT(11) NOT NULL,
    id_filmu INT(11) NOT NULL,
    data_wypozyczenia DATE NOT NULL,
    data_zwrotu DATE DEFAULT NULL,
    PRIMARY KEY (id_wypozyczenia),
    FOREIGN KEY (id_klienta) REFERENCES klienci(id_klienta),
    FOREIGN KEY (id_filmu) REFERENCES filmy(id_filmu)
);
INSERT INTO wypozyczenia (id_klienta, id_filmu, data_wypozyczenia, data_zwrotu)
VALUES
    (1, 1, '2023-05-01', DEFAULT),
    (2, 2, '2023-04-12', '2023-04-26'),
    (3, 2, '2023-05-02', '2023-05-03'),
    (3, 4, '2023-03-23', DEFAULT),
    (5, 7, '2023-01-06', '2023-01-09'),
    (8, 10, '2023-05-03', DEFAULT),
    (8, 11, '2022-11-04', '2022-11-13'),
    (7, 13, '2023-05-02', '2023-05-09'),
    (6, 14, '2023-05-03', '2023-05-06'),
    (2, 5, '2023-06-02', DEFAULT),
    (2, 8, '2023-06-03', DEFAULT),
    (1, 15, '2023-06-01', '2023-06-03'),
    (5, 17, '2023-05-30', '2023-06-01'),
    (8, 16, '2023-05-27', '2023-06-02'),
	(9, 5, '2023-06-01', DEFAULT),
    (9, 8, '2023-05-31', DEFAULT);

CREATE TABLE platnosci (
  id_platnosci INT(11) NOT NULL AUTO_INCREMENT,
  id_wypozyczenia INT(11) NOT NULL,
  kwota DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (id_platnosci),
  FOREIGN KEY (id_wypozyczenia) REFERENCES wypozyczenia(id_wypozyczenia)
);
INSERT INTO platnosci (id_wypozyczenia, kwota)
VALUES
    (2, 14.00),
    (3, 14.00),
    (5, 12.50),
    (7, 19.50),
    (8, 20.50),
    (9, 34.50),
    (12, 15.00),
    (13, 12.00),
    (14, 10.00);

-- utworzenie indeksow
CREATE INDEX idx_klienci_imie ON klienci(imie);
CREATE INDEX idx_filmy_tytul ON filmy(tytul);
CREATE INDEX idx_wypozyczenia_data_wyp ON wypozyczenia(data_wypozyczenia);

-- utworzenie procedur 
-- 1)
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE dodaj_klienta(
    IN p_imie VARCHAR(50),
    IN p_nazwisko VARCHAR(50),
    IN p_adres VARCHAR(100),
    IN p_miasto VARCHAR(100),
    IN p_telefon VARCHAR(9)
)
BEGIN
    INSERT INTO klienci (imie, nazwisko, adres, miasto, telefon)
    VALUES (p_imie, p_nazwisko, p_adres, p_miasto, p_telefon);
END $$
DELIMITER ;

-- 2)
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE usun_klienta(IN p_id_klienta INT)
BEGIN
    -- sprawdzenie, czy klient posiada wypozyczenia z nieoddanymi filmami
    IF EXISTS (
        SELECT 1
        FROM wypozyczenia
        WHERE id_klienta = p_id_klienta AND data_zwrotu IS NULL
        LIMIT 1
    ) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Klient posiada niezwrócone filmy. Nie można usunąć klienta.';
    ELSE
        -- usuniecie rekordow wypozyczen
        DELETE FROM wypozyczenia WHERE id_klienta = p_id_klienta;
        
        -- usuniecie klienta
        DELETE FROM klienci WHERE id_klienta = p_id_klienta;
    END IF;
END $$
DELIMITER ;

-- 3)
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE wyswietl_szczegolu_filmu(IN film_id INT)
BEGIN
    SELECT f.tytul, f.gatunek, f.rezyser, f.rok_produkcji, COUNT(w.id_wypozyczenia) AS liczba_wypozyczen
    FROM filmy AS f
    LEFT JOIN wypozyczenia AS w ON f.id_filmu = w.id_filmu
    WHERE f.id_filmu = film_id
    GROUP BY f.id_filmu;
END $$
DELIMITER ;

-- 4)
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE wyswietl_historie_wypozyczonych_filmow_klienta(IN klient_id INT)
BEGIN
    SELECT k.imie, k.nazwisko, f.tytul, w.data_wypozyczenia, COALESCE(w.data_zwrotu, 'nie zostal zwrocony') AS data_zwrotu
    FROM klienci AS k
    JOIN wypozyczenia AS w ON k.id_klienta = w.id_klienta
    JOIN filmy AS f ON w.id_filmu = f.id_filmu
    WHERE k.id_klienta = klient_id;
END $$
DELIMITER ;

-- utworzenie wyzwalaczy
-- 1)
DELIMITER $$
CREATE TRIGGER `dodaj_date_zwrotu` BEFORE UPDATE ON `wypozyczenia`
 FOR EACH ROW BEGIN
    DECLARE cena_kopia DECIMAL(10, 2);
    DECLARE odsetki DECIMAL(10, 2);
    DECLARE roznica_dni INT;
    
    SELECT f.cena INTO cena_kopia
    FROM filmy f
    WHERE f.id_filmu = NEW.id_filmu;

    IF NEW.data_zwrotu < NEW.data_wypozyczenia THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Data zwrotu nie moze byc wczesniejsza niz data wypozyczenia.';
    END IF;
    
    SET roznica_dni = DATEDIFF(NEW.data_zwrotu, NEW.data_wypozyczenia);
    SET odsetki = roznica_dni * 0.1;
    
   -- dodaj platnosc
    IF roznica_dni > 3 THEN
    	INSERT INTO platnosci (id_wypozyczenia, kwota)
		VALUES (NEW.id_wypozyczenia, cena_kopia + odsetki);
	ELSE
    	INSERT INTO platnosci (id_wypozyczenia, kwota)
		VALUES (NEW.id_wypozyczenia, cena_kopia);
    END IF;
END $$
DELIMITER ;

-- 2)
DELIMITER $$
CREATE TRIGGER `sprawdz_date_zwrotu` BEFORE INSERT ON `wypozyczenia`
 FOR EACH ROW BEGIN
    IF NEW.data_zwrotu IS NOT NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Nie mozna wypozyczyc filmu i od razu go zwrocic.';
    END IF;
END $$
DELIMITER ;

-- 3)
DELIMITER $$
CREATE TRIGGER `sprawdz_numer_telefonu` BEFORE INSERT ON `klienci`
 FOR EACH ROW BEGIN
    IF EXISTS (SELECT * FROM klienci WHERE telefon = NEW.telefon AND id_klienta != NEW.id_klienta) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Istnieje juz klient o takim samym numerze telefonu.';
    END IF;
END $$
DELIMITER ;

-- zapytania laczace minimum 3 tabele
-- 1) WHERE - wypisz wszystkie wypozyczenia dokonane przez klientow z Warszawy
SELECT CONCAT(k.imie, ' ', k.nazwisko) AS klient, f.tytul, w.data_wypozyczenia
FROM klienci k
JOIN wypozyczenia w USING (id_klienta)
JOIN filmy f USING (id_filmu)
WHERE k.miasto = 'Warszawa';

-- 2) NATURAL JOIN - wypisz wypozyczenia wszystkich klientow wraz z kwotami
SELECT CONCAT(k.imie, ' ', k.nazwisko) AS klient, w.data_wypozyczenia, p.kwota
FROM klienci k
NATURAL JOIN wypozyczenia w
NATURAL JOIN platnosci p;

-- 3) INNER JOIN - wypisz wszystkie wypozyczenia dramatow, ktore sa wypozyczone
SELECT CONCAT(k.imie, ' ', k.nazwisko) AS klient, f.tytul, f.gatunek, w.data_zwrotu
FROM klienci k
INNER JOIN wypozyczenia w USING (id_klienta)
INNER JOIN filmy f USING (id_filmu)
WHERE f.gatunek = 'Dramat' AND w.data_zwrotu IS NULL;

-- 4) LEFT OUTER JOIN - wypisz wszystkie wypozyczenia filmow Tarantino wraz ze wszystkimi ich wypozyczajacymi i datami
SELECT CONCAT(k.imie, ' ', k.nazwisko) AS klient, f.tytul, w.data_wypozyczenia
FROM klienci k
LEFT JOIN wypozyczenia w USING (id_klienta)
LEFT JOIN filmy f USING (id_filmu)
WHERE f.rezyser = 'Quentin Tarantino';

-- 5) RIGHT OUTER JOIN - wypisz wszystkie wypozyczenia wraz z klientami oraz klientow, ktorzy nie wypozyczyli niczego
SELECT CONCAT(k.imie, ' ', k.nazwisko) AS klient, COALESCE(f.tytul, '-') AS tytul, COALESCE(p.kwota, 0) AS kwota
FROM filmy f
RIGHT JOIN wypozyczenia w USING (id_filmu)
RIGHT JOIN platnosci p USING (id_wypozyczenia)
RIGHT JOIN klienci k USING (id_klienta);

-- zapytania wykorzystujace klauzule GROUP BY, HAVING, BETWEEN, LIKE, ORDER BY oraz funkcje SUM i COUNT
-- 1) Jakie sa gatunki filmow w bazie danych, ktore maja wiecej niz dwa filmy?
SELECT f.gatunek, COUNT(*) AS liczba_filmow
FROM filmy f
GROUP BY f.gatunek
HAVING COUNT(*) > 2
ORDER BY liczba_filmow DESC;

-- 2) Ile razy w historii kazdy klient wypozyczyl film?
SELECT CONCAT(imie, ' ', nazwisko) AS klient, COUNT(*) AS liczba_wypozyczen
FROM klienci k
JOIN wypozyczenia w USING(id_klienta)
GROUP BY klient
ORDER BY liczba_wypozyczen DESC;

-- 3) Jak chronologicznie rozkladaja sie wypozyczenia filmow od poczatku 2023 roku?
SELECT w.data_wypozyczenia, f.tytul, CONCAT(imie, ' ', nazwisko) AS klient
FROM klienci k
JOIN wypozyczenia w USING (id_klienta)
JOIN filmy f USING (id_filmu)
WHERE w.data_wypozyczenia BETWEEN '2023-01-01' AND CURRENT_DATE
ORDER BY w.data_wypozyczenia ASC;

-- 4) Ile jest filmow z kazdego rocznika?
SELECT rok_produkcji, COUNT(*) AS liczba_filmow
FROM filmy
GROUP BY rok_produkcji
ORDER BY rok_produkcji ASC;

-- 5) Ktory z gatunkow filmow wygenerowal najwiekszy zysk?
SELECT f.gatunek, SUM(p.kwota) AS suma_przychodow
FROM filmy f
JOIN wypozyczenia w USING (id_filmu)
JOIN platnosci p USING (id_wypozyczenia)
GROUP BY f.gatunek
ORDER BY suma_przychodow DESC;

-- 6) Ile wypozyczono filmow w kazdym z lat dzialania wypozyczalni?
SELECT YEAR(data_wypozyczenia) AS rok, COUNT(*) AS liczba_wypozyczen
FROM wypozyczenia
GROUP BY YEAR(data_wypozyczenia)
ORDER BY rok ASC;
