use Zoo;

CREATE TABLE ZOOIDEN
(
	animal_id INT PRIMARY KEY, 
	animal_name VARCHAR(255),
	caretaker_id VARCHAR(255) UNIQUE,
	area_code INT
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
