-- make sure database can be created
DROP DATABASE IF EXISTS movie_rental;

-- create db and set language
CREATE DATABASE movie_rental;
USE movie_rental;
SET NAMES utf8;
SET character_set_client = utf8;

-- create tables and fill them with data
CREATE TABLE clients (
    client_id INT(11) NOT NULL AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    address VARCHAR(100) NOT NULL,
    city VARCHAR(100) NOT NULL,
    phone VARCHAR(9) NOT NULL CHECK (LENGTH(phone) = 9),
    PRIMARY KEY (client_id),
    CONSTRAINT unique_phone UNIQUE (phone)
);
INSERT INTO clients (first_name, last_name, address, city, phone)
VALUES
    ('Jan', 'Kowalski', 'ul. Bukietowa 1', 'Torun', '123456789'),
    ('Marian', 'Marianowski', 'ul. Lotna 1', 'Lodz', '565656565'),
    ('Jozef', 'Poniatowski', 'ul. Marszalkowska 107G', 'Warszawa', '456456456'),
    ('Jaroslaw', 'Gesiowski', 'ul. Farysa 99', 'Warszawa', '678678678'),
    ('Wladyslaw', 'Warnenczyk', 'ul. Wenecka 4', 'Poznan', '123123123'),
    ('Adam', 'Szczurowski', 'ul. Korporacyjna 4', 'Wroclaw', '234234234'),
    ('Krzysztof', 'Kononowiczowski', 'ul. Szkolna 117', 'Bialystok', '745745745'),
    ('Joanna', 'Nowak', 'ul. Nowa 2', 'Krakow', '987654321'),
    ('Abraham', 'Linkoln', 'ul. Amerykanska 2', 'Warszawa', '345634568');

CREATE TABLE movies (
    movie_id INT(11) NOT NULL AUTO_INCREMENT,
    title VARCHAR(100) NOT NULL,
    genre VARCHAR(50) NOT NULL,
    director VARCHAR(50) NOT NULL,
    release_year INT(4) NOT NULL,
	price DECIMAL(10,2) NOT NULL DEFAULT 0,
    PRIMARY KEY (movie_id)
);
INSERT INTO movies (title, genre, director, release_year, price)
VALUES
    ('Inception', 'Sci-Fi', 'Christopher Nolan', 2010, DEFAULT),
    ('Se7en', 'Thriller', 'David Fincher', 1995, 14.0),
    ('Shawshank Redemption', 'Tragedy', 'Frank Darabont', 1994, 35.5),
    ('The Lion King', 'Animated', 'Rob Minkoff, Roger Allers', 1994, 24.0),
    ('Pulp fiction', 'Crime film', 'Quentin Tarantino', 1994, 18.0),
    ('Forrest Gump', 'Comedy Drama', 'Robert Zemeckis', 1994, 17.0),
    ('Leon', 'Tragedy', 'Luc Besson', 1994, 12.5),
    ('Braveheart', 'Tragedy', 'Mel Gibson', 1995, 13.5),
    ('Heat', 'Sensacyjny', 'Michael Mann', 1995, 15.0),
    ('Inglorious Bastards', 'War film', 'Quentin Tarantino', 2009, 18.5),
    ('Django Unchained', 'Western', 'Quentin Tarantino', 2012, 19.5),
    ('Once Upon a Time... in Hollywood', 'Tragedy, Crime film', 'Quentin Tarantino', 2019, 22.5),
    ('Avatar', 'Sci-Fi', 'James Cameron', 2009, 20.5),
    ('Avatar: The Way of Water', 'Sci-Fi', 'James Cameron', 2022, 34.5),
    ('Shrek', 'Animated', 'Andrew Adamson, Vicky Jenson', 2001, 15.0),
    ('Avengers', 'Sci-Fun', 'Joss Whedon', 2012, 10.0),
    ('Iron Man', 'Sci-Fun', 'Jon Favreau', 2008, 12.0);

CREATE TABLE rentals (
    rental_id INT(11) NOT NULL AUTO_INCREMENT,
    client_id INT(11) NOT NULL,
    movie_id INT(11) NOT NULL,
    rental_date DATE NOT NULL,
    return_date DATE DEFAULT NULL,
    PRIMARY KEY (rental_id),
    FOREIGN KEY (client_id) REFERENCES clients(client_id),
    FOREIGN KEY (movie_id) REFERENCES movies(movie_id)
);
INSERT INTO rentals (client_id, movie_id, rental_date, return_date)
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

CREATE TABLE payments (
  payment_id INT(11) NOT NULL AUTO_INCREMENT,
  rental_id INT(11) NOT NULL,
  amount DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (payment_id),
  FOREIGN KEY (rental_id) REFERENCES rentals(rental_id)
);
INSERT INTO payments (rental_id, amount)
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

-- creating indexes
CREATE INDEX idx_clients_first_name ON clients(first_name);
CREATE INDEX idx_movies_title ON movies(title);
CREATE INDEX idx_rentals_rental_date ON rentals(rental_date);

-- procedures
-- 1)
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE add_client(
    IN p_first_name VARCHAR(50),
    IN p_last_name VARCHAR(50),
    IN p_address VARCHAR(100),
    IN p_city VARCHAR(100),
    IN p_phone VARCHAR(9)
)
BEGIN
    INSERT INTO clients (first_name, last_name, address, city, phone)
    VALUES (p_first_name, p_last_name, p_address, p_city, p_phone);
END $$
DELIMITER ;

-- 2)
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE delete_client(IN p_client_id INT)
BEGIN
    -- check for not returned movies
    IF EXISTS (
        SELECT 1
        FROM rentals
        WHERE client_id = p_client_id AND return_date IS NULL
        LIMIT 1
    ) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Client has movies that havent been returned.';
    ELSE
        -- delete history of rentals
        DELETE FROM rentals WHERE client_id = p_client_id;
        
        -- delete client
        DELETE FROM clients WHERE client_id = p_client_id;
    END IF;
END $$
DELIMITER ;

-- 3)
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE display_movie_details(IN p_movie_id INT)
BEGIN
    SELECT m.title, m.genre, m.director, m.release_year, COUNT(w.rental_id) AS rental_count
    FROM movies m
    LEFT JOIN rentals r ON m.movie_id = r.movie_id
    WHERE m.movie_id = p_movie_id
    GROUP BY m.movie_id;
END $$
DELIMITER ;

-- 4)
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE client_rental_history(IN p_client_id INT)
BEGIN
    SELECT c.first_name, c.last_name, m.title, r.rental_date, COALESCE(w.return_date, 'not returned') AS return_date
    FROM clients c
    JOIN rentals r ON c.client_id = r.client_id
    JOIN movies m ON r.movie_id = m.movie_id
    WHERE c.client_id = p_client_id;
END $$
DELIMITER ;

-- utworzenie wyzwalaczy
-- 1)
DELIMITER $$
CREATE TRIGGER `set_return_date` BEFORE UPDATE ON `rentals`
 FOR EACH ROW BEGIN
    DECLARE price_copy DECIMAL(10, 2);
    DECLARE interest DECIMAL(10, 2);
    DECLARE days INT;
    
    SELECT m.price INTO price_copy
    FROM movies m
    WHERE m.movie_id = NEW.movie_id;

    IF NEW.return_date < NEW.rental_date THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Rental date is not before return date';
    END IF;
    
    SET days = DATEDIFF(NEW.return_date, NEW.rental_date);
    SET interest = days * 0.1;
    
   -- dodaj platnosc
    IF days > 3 THEN
    	INSERT INTO payments (rental_id, amount)
		VALUES (NEW.rental_id, price_copy + interest);
	ELSE
    	INSERT INTO payments (rental_id, amount)
		VALUES (NEW.rental_id, price_copy);
    END IF;
END $$
DELIMITER ;

-- 2)
DELIMITER $$
CREATE TRIGGER `check_return_date` BEFORE INSERT ON `rentals`
 FOR EACH ROW BEGIN
    IF NEW.return_date IS NOT NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Movie cannot be returned at the rental date';
    END IF;
END $$
DELIMITER ;

-- 3)
DELIMITER $$
CREATE TRIGGER `check_phone_number` BEFORE INSERT ON `clients`
 FOR EACH ROW BEGIN
    IF EXISTS (SELECT * FROM clients WHERE phone = NEW.phone AND client_id != NEW.client_id) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'There is another client using the same phone number';
    END IF;
END $$
DELIMITER ;

-- various queries
-- 1) WHERE - list all rentals that clients from Warsaw has made
SELECT CONCAT(c.first_name, ' ', c.last_name) AS client, m.title, r.rental_date
FROM clients c
JOIN rentals r USING (client_id)
JOIN movies m USING (movie_id)
WHERE c.city = 'Warszawa';

-- 2) NATURAL JOIN - list all rentals of clients with corresponding amounts 
SELECT CONCAT(c.first_name, ' ', c.last_name) AS client, r.rental_date, p.amount
FROM clients c
NATURAL JOIN rentals r
NATURAL JOIN payments p;

-- 3) INNER JOIN - list all tragedy film that are not returned
SELECT CONCAT(c.first_name, ' ', c.last_name) AS client, m.title, m.genre, r.return_date
FROM clients c
INNER JOIN rentals r USING (client_id)
INNER JOIN movies m USING (movie_id)
WHERE m.genre = 'Tragedy' AND r.return_date IS NULL;

-- 4) LEFT OUTER JOIN - list all rentals of Tarantino's movies
SELECT CONCAT(c.first_name, ' ', c.last_name) AS client, m.title, r.rental_date
FROM clients c
LEFT JOIN rentals r USING (client_id)
LEFT JOIN movies m USING (movie_id)
WHERE m.director = 'Quentin Tarantino';

-- 5) RIGHT OUTER JOIN - list all rentals as well as clients without any rentals
SELECT CONCAT(c.first_name, ' ', c.last_name) AS client, COALESCE(m.title, '-') AS title, COALESCE(p.amount, 0) AS amount
FROM movies m
RIGHT JOIN rentals r USING (movie_id)
RIGHT JOIN payments p USING (rental_id)
RIGHT JOIN clients c USING (client_id);

-- various queries using GROUP BY, HAVING, BETWEEN, LIKE, ORDER BY and functions SUM, COUNT
-- 1) Which genres has more than two rentals?
SELECT m.genre, COUNT(*) AS movie_count
FROM movies m
GROUP BY m.genre
HAVING COUNT(*) > 2
ORDER BY movie_count DESC;

-- 2) How many times does each of the clients rented a movie?
SELECT CONCAT(first_name, ' ', last_name) AS client, COUNT(*) AS rental_count
FROM clients c
JOIN rentals r USING(client_id)
GROUP BY client
ORDER BY rental_count DESC;

-- 3) What is chronologic order of rentals in 2023?
SELECT r.rental_date, m.title, CONCAT(first_name, ' ', last_name) AS client
FROM clients c
JOIN rentals r USING (client_id)
JOIN movies m USING (movie_id)
WHERE r.rental_date BETWEEN '2023-01-01' AND CURRENT_DATE
ORDER BY r.rental_date ASC;

-- 4) How many films of each release year are there?
SELECT release_year, COUNT(*) AS movie_count
FROM movies
GROUP BY release_year
ORDER BY release_year ASC;

-- 5) Which genre made the most income?
SELECT m.genre, SUM(p.amount) AS income_total
FROM movies m
JOIN rentals r USING (movie_id)
JOIN payments p USING (rental_id)
GROUP BY m.genre
ORDER BY income_total DESC;

-- 6) How many films where rented each year?
SELECT YEAR(rental_date) AS year_rental, COUNT(*) AS rental_count
FROM rentals
GROUP BY YEAR(rental_date)
ORDER BY year_rental ASC;
