use Zoo;

CREATE TABLE ZOOIDEN
(
	animal_id INT PRIMARY KEY, 
	animal_name VARCHAR(255),
	caretaker_id VARCHAR(255) UNIQUE,
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
	caretaker_id PRIMARY KEY,
	caretaker_first_name VARCHAR(255),
	caretaker_last_name VARCHAR(255),
	caretaker_username VARCHAR(7) UNIQUE,
	caretaker_posn INT,
	caretaker_phone VARCHAR(255) UNIQUE
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
	feed_schedule INT UNIQUE,
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
(25, 'Frank the Python', 10, 5, 5)

INSERT INTO ZOOAREA (area_code, area_desc) VALUES 
(1, 'African Safari'),
(2, 'Jungle'),
(3, 'Tundra'),
(4, 'Aquarium'),
(5, 'Reptile Kingdom')

INSERT INTO ZOOFEED (feed_schedule_code, feed_schedule_desc) VALUES 
(1, 'Twice Daily - Morning/Evening'),
(2, 'Once Daily - Morning'),
(3, 'Once Daily - Evening'),
(4, 'Once Every Two Days - Morning'),
(5, 'Once Every Two Days - Evening')

INSERT INTO ZOOCARE (caretaker_id, caretaker_first_name, caretaker_last_name, caretaker_username, 
caretaker_posn, caretaker_salary) VALUES
(1, 'Gabriel', 'Berres', 'berresga', 1, 45000.00),
(2, 'Sarah', 'Berres', 'berressa', 1, 45000.00),
(3, 'Tonya', 'Garrett', 'garretto', 2, 55000.00),
(4, 'Aaron', 'Garrett', 'garretaa', 2, 55000.00),
(5, 'Jason', 'Tidwell', 'tidwellja', 2, 55000.00),
(5, 'Eden', 'Wallace', 'wallac33', 2, 55000.00),
(6, 'Lelo', 'Bekele', 'bekelele', 3, 65000.00),
(7, 'Travis', 'Cook', 'cooktrav', 3, 65000.00),
(8, 'Kaden', 'Scroggins', 'scroggik', 3, 65000.00),
(9, 'Joshua', 'Simmons', 'simmonsj', 4, 80000.00),
(10, 'Steven', 'Hensley', 'hensleys', 5, 100000.00)
