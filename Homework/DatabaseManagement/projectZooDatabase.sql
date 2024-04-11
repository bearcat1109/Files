use Zoo;

CREATE TABLE ZOOIDEN
(
	animal_id INT PRIMARY KEY, 
	animal_name VARCHAR(255),
	caretaker_id VARCHAR(255),
	area_code INT,
	feed_schedule_code INT
);



CREATE TABLE ZOOAREA
(
	area_code INT UNIQUE, 
	area_desc VARCHAR(255)
);

CREATE TABLE ZOOCARE
(
	caretaker_id INT PRIMARY KEY,
	caretaker_first_name VARCHAR(255),
	caretaker_last_name VARCHAR(255),
	caretaker_username VARCHAR(8) UNIQUE,
	caretaker_posn INT,
	caretaker_salary MONEY
);

CREATE TABLE ZOOPOSN
(
	caretaker_posn INT UNIQUE,
	caretaker_posn_desc	VARCHAR(255),
	caretaker_weekly_hrs INT,
	caretaker_posn_salary MONEY,
);

CREATE TABLE ZOOFEED
(
	feed_schedule_code INT UNIQUE,
	feed_schedule_desc VARCHAR(255) 
);


-- Insert
INSERT INTO ZOOIDEN (animal_id, animal_name, caretaker_id, area_code, feed_schedule_code) VALUES 
(1, 'Simba the Lion', 1, 1, 1),  -- Area code African Safari
(2, 'Dumbo the Elephant', 1, 1, 1),
(3, 'Tallulah the Giraffe', 1, 1, 1),
(4, 'Ziggy the Zebra', 2, 1, 1),  
(5, 'Imbubo the Meerkat', 2, 1, 1),
(6, 'Stripes the Tiger', 3, 2, 1), -- Area code Jungle
(7, 'Kong the Gorilla', 3, 2, 1),
(8, 'Rusty the Red Panda', 3, 2, 1),
(9, 'Charlie the Chimpanzee', 4, 2, 1),
(10, 'Luna the Lemur', 4, 2, 2),
(11, 'Usain the Sloth', 4, 2, 2),
(12, 'Ollie the Orangutan', 4, 2, 3),
(13, 'Paul the Polar Bear', 5, 3, 1),  -- Area code Tundra
(14, 'Saoirse the SEal', 5, 3, 1),
(15, 'Penny the Penguin', 5, 3, 1),
(16, 'Peter the Penguin', 6, 3, 1),
(17, 'Eli the Eel', 7, 4, 4),   -- Area Code Aquarium
(18, 'Ursula the Octopus', 7, 4, 4),
(19, 'Alex the Axolotl', 7, 4, 4),
(20, 'Sydney the Squid', 8, 4, 4),
(22, 'Yoink the Leopard Gecko', 9, 5, 5),      -- Area code Reptile Kingdom
(23, 'Drake the Komodo Dragon', 9, 5, 5),
(24, 'Skyler the Blue-Tongued Skink', 10, 5, 5),
(25, 'Frank the Python', 10, 5, 5);

INSERT INTO ZOOAREA (area_code, area_desc) VALUES 
(1, 'African Safari'),
(2, 'Jungle'),
(3, 'Tundra'),
(4, 'Aquarium'),
(5, 'Reptile Kingdom');

INSERT INTO ZOOFEED (feed_schedule_code, feed_schedule_desc) VALUES 
(1, 'Twice Daily - Morning/Evening'),
(2, 'Once Daily - Morning'),
(3, 'Once Daily - Evening'),
(4, 'Once Every Two Days - Morning'),
(5, 'Once Every Two Days - Evening');

INSERT INTO ZOOCARE (caretaker_id, caretaker_first_name, caretaker_last_name, caretaker_username, 
caretaker_posn, caretaker_salary) VALUES
(1, 'Gabriel', 'Berres', 'berresga', 1, 45000.00),
(2, 'Sarah', 'Berres', 'berressa', 1, 45000.00),
(3, 'Tonya', 'Garrett', 'garretto', 2, 55000.00),
(4, 'Aaron', 'Garrett', 'garretaa', 2, 55000.00),
(5, 'Jason', 'Tidwell', 'tidwellj', 2, 55000.00),
(6, 'Eden', 'Wallace', 'wallac33', 2, 55000.00),
(7, 'Lelo', 'Bekele', 'bekelele', 3, 65000.00),
(8, 'Travis', 'Cook', 'cooktrav', 3, 65000.00),
(9, 'Kaden', 'Scroggins', 'scroggik', 3, 65000.00),
(10, 'Joshua', 'Simmons', 'simmonsj', 4, 80000.00),
(11, 'Steven', 'Hensley', 'hensleys', 5, 100000.00);

INSERT INTO ZOOPOSN (caretaker_posn, caretaker_posn_desc, caretaker_weekly_hrs, caretaker_posn_salary) VALUES
(1, 'Caretaker I', 30, 45000.00),
(2, 'Caretaker II', 35, 55000.00),
(3, 'Caretaker III', 40, 65000.00),
(4, 'Caretaker & Assistant Director', 40, 80000.00),
(5, 'Caretaker & Director', 40, 100000.00);



USE Zoo;

-- Join between two tables
SELECT
    zi.animal_name name,
    za.area_desc area
FROM  
    zooiden zi
    JOIN zooarea za ON za.area_code = zi.area_code;

USE Zoo;
-- Aggregates - Group By
USE Zoo
SELECT
	zp.caretaker_posn_desc posn,
	COUNT(*) as caretaker_count
FROM
	zoocare zc
	JOIN zooposn zp ON zp.caretaker_posn = zc.caretaker_posn
GROUP BY
	zp.caretaker_posn_desc;

USE Zoo
-- Count of animals inside each area
SELECT
	za.area_code,
	za.area_desc,
	COUNT(zi.animal_id) AS animal_count
FROM
	zooiden zi
JOIN
	zooarea za ON zi.area_code = za.area_code
GROUP BY
	za.area_code, za.area_desc
ORDER BY
	za.area_code;

-- Join operations on three tables
USE Zoo
SELECT
    zi.animal_name    animal,
    zc.caretaker_last_name + ', ' + caretaker_first_name caretaker,
    zf.feed_schedule_desc feeding_time
FROM
    zooiden zi
    JOIN zoocare zc ON zc.caretaker_id = zi.caretaker_id
    JOIN zoofeed zf ON zf.feed_schedule_code = zi.feed_schedule_code;

-- Employees and their areas where they work
USE Zoo
SELECT DISTINCT
	zc.caretaker_id id,
	zc.caretaker_first_name + ' ' + zc.caretaker_last_name caretaker,
    za.area_desc area_worked

FROM
	zoocare zc
    JOIN zooiden zi ON zc.caretaker_id = zi.caretaker_id
    JOIN zooarea za ON zi.area_code = za.area_code
ORDER BY
	zc.caretaker_id;
    
-- Find caretakers who earn above average
USE Zoo
SELECT
    caretaker_id id,
    caretaker_first_name + ' ' + caretaker_last_name c_name,
    caretaker_salary
FROM
    zoocare
WHERE
    caretaker_salary >
    (
   	 SELECT
   		 AVG(caretaker_salary)
   	 FROM
   		 zoocare
    );

-- Animals cared for by the caretakers of Posn 'Caretaker I'
USE Zoo
SELECT
    animal_name
FROM
    zooiden
WHERE
    caretaker_id IN
    (
   	 SELECT
   		 caretaker_id
   	 FROM
   		 zoocare
   	 WHERE caretaker_salary IN
   		 (
   			 SELECT
   				 MIN(caretaker_salary)
   			 FROM
   				 zoocare)
    );

-- Caretakers whose last name starts with B
USE Zoo
SELECT
    *
FROM
    zoocare
WHERE
    caretaker_last_name LIKE 'B%';


--Animals whose name starts with char S
USE Zoo
SELECT
    *
FROM
    zooiden
WHERE
    zooiden.animal_name LIKE 'S%'
