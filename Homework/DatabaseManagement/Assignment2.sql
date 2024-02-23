USE Assignment2 

CREATE TABLE Customer 
(
	Customer_ID INT PRIMARY KEY,
	Title VARCHAR(32),
	First_Name VARCHAR(64),
	Last_Name VARCHAR(64),
	Street_Address VARCHAR(255),
	City VARCHAR(64),
	State VARCHAR(2),
	Zip_Code VARCHAR(32),
	Phone_Number VARCHAR(32),
	Email VARCHAR(64)
);

INSERT INTO Customer (Customer_ID, Title, First_Name, Last_Name, Street_Address, City, State, Zip_Code, Phone_Number, Email)
VALUES 
(1, 'Dr.', 'Tracy', 'Mikes', '12345 South Main Road', 'New York', 'NY', '74364-1123', '(918) 555-1234', 'Mikes@hotmail.com'),
(10, 'Baron', 'Ludwig', 'vonWunderkind', '12345 West Tillameeko Street', 'Chicago', 'IL', '74366-1123', '(918) 555-0123', 'Hotpants@gmail.com'),
(2, 'Mrs.', 'Ann', 'Berlin', '12345 West Third Street', 'Dyer', 'IN', '73460-1123', '(918) 555-2345', 'Berlin@yahoo.com'),
(3, 'Dr.', 'John', 'Druitt', '12345 East Main Street', 'Spring Field', 'MO', '73005-1123', '(918) 555-3456', 'Druitt@google.com'),
(4, 'Ms.', 'Annabelle', 'Smith', '12345 North Rodeo Street', 'Tulsa', 'OK', '74101-1123', '(918) 555-4567', 'Smith@bing.com'),
(5, 'Lord', 'Duke', 'Earl', '12345 South Elvis Boulevard', 'Adair', 'OK', '74330-1123', '(918) 555-5678', 'Earl@mapquest.com'),
(6, 'Duke', 'Earl', 'Smith', '12345 West Sycamore Street', 'Langley', 'OK', '74350-1123', '(918) 555-6789', 'Smith@aol.com'),
(7, 'Duchess', 'Fergie', 'Giepher', '12345 East Second Street', 'Ketchum', 'OK', '74349-1123', '(918) 555-7890', 'Giepher@dogpile.com'),
(8, NULL, 'Jack', 'Rabbit', '12345 North South Street', 'Grove', 'OK', '74344-1123', '(918) 555-8901', 'Rabbit@infoquest.com'),
(9, NULL, 'Jill', 'Hill', '12345 South Grandma Way', 'Strang', 'OK', '74367-1123', '(918) 555-9012', 'Hill@yourmom.com');


-- Used coworkers for extras
INSERT INTO Customer (Customer_ID, Title, First_Name, Last_Name, Street_Address, City, State, Zip_Code, Phone_Number, Email)
VALUES 
(11, NULL, 'Kaden', 'Scroggins', '600 N Grand', 'Tahlequah', 'OK', '74464', '(918) 444-1234', 'scroggik@nsuok.edu'),
(12, NULL, 'Eden', 'Wallace', '600 N Grand', 'Tahlequah', 'OK', '74464', '(918) 444-1234', 'wallac33@nsuok.edu'),
(13, NULL, 'Jason', 'Tidwell', '600 N Grand', 'Tahlequah', 'OK', '74464', '(918) 444-1234', 'tidwellj@nsuok.edu'),
(14, NULL, 'Jonathan', 'Petruska', '600 N Grand', 'Tahlequah', 'OK', '74464', '(918) 444-1234', 'petruska@nsuok.edu'),
(15, NULL, 'Robert', 'Moruzzi', '600 N Grand', 'Tahlequah', 'OK', '74464', '(918) 444-1234', 'moruzziw@nsuok.edu');

SELECT * FROM Customer;

CREATE TABLE Product 
(
	Product_ID INT PRIMARY KEY,
	Product_Name VARCHAR(255),
	Brand VARCHAR(64),
	Price DECIMAL(10,2),
	Stock_Quantity INT,
	Date_Added DATE
);

INSERT INTO Product (Product_ID, Product_Name, Brand, Price, Stock_Quantity, Date_Added)
VALUES 
(100, 'Radio', 'Sony', 29.99, 30, '2012-08-22'),
(101, 'Clock', 'LG', 19.99, 15, '2012-06-13'),
(102, 'Printer', 'HD', 49.99, 244, '2012-09-01'),
(103, 'Okama GameSphere', 'Wintendo', 29.99, 46, '2012-08-22'),
(104, 'Crockpot', 'Equate', 99.99, 25, '2012-02-14'),
(105, 'Widget', 'Bony', 10.99, 25, '2012-05-30'),
(106, 'Map', 'Fony', 119.99, 63, '2012-04-15'),
(107, 'Donkey', 'Brony', 22.99, 20, '2012-01-01'),
(108, 'Toaster', 'Tony', 35.99, 37, '2012-03-27'),
(109, 'Beef Wellington', 'Phat', 10.99, 47, '2012-06-16');

INSERT INTO Product (Product_ID, Product_Name, Brand, Price, Stock_Quantity, Date_Added)
VALUES 
(110, 'Microwave', 'Frigidaire', 99.99, 30, '2012-08-22'),
(111, 'Blender', 'Frigidaire', 59.99, 30, '2012-08-22'),
(112, 'Gatorade', 'Gatorade', 1.99, 30, '2012-08-22'),
(113, 'Building Set', 'Lego', 29.99, 30, '2012-08-22'),
(114, 'Calculator', 'Texas Instrument', 99.99, 30, '2012-08-22');

CREATE TABLE Transactions
(
	Customer_ID INT,
	Product_ID INT,
	Purchase_Date Date, 
	Quantity_Purchased INT,
	Payment_Method VARCHAR(32),
	Total DECIMAL(10,2)
);

INSERT INTO Transactions (Customer_ID, Product_ID, Purchase_Date, Quantity_Purchased, Payment_Method, Total)
VALUES 
(1, 101, '2022-04-13', 1, 'Visa', 30.72),
(1, 105, '2023-07-22', 2, 'Visa', 27.22),
(1, 109, '2024-01-22', 15, 'Visa', 352.01),
(4, 106, '2023-02-22', 5, 'AmEx', 704.22),
(1, 103, '2021-06-09', 3, 'AmEx', 100.55),
(3, 108, '2022-07-17', 1, 'PayPal', 42.38);

INSERT INTO Transactions (Customer_ID, Product_ID, Purchase_Date, Quantity_Purchased, Payment_Method, Total)
VALUES 
(5, 101, '2022-04-13', 1, 'Visa', 30.72),
(6, 102, '2022-04-13', 1, 'Visa', 30.72),
(7, 103, '2022-04-13', 1, 'Visa', 30.72),
(9, 104, '2022-04-13', 1, 'Visa', 30.72),
(9, 106, '2022-04-13', 1, 'Visa', 30.72);


CREATE TABLE Ratings
(
	Rating_ID INT PRIMARY KEY,
	Customer_ID INT,
	Product_ID INT,
	Rating_Date DATE,
	Rating INT,
	Comment VARCHAR(255)
);

INSERT INTO Ratings (Rating_ID, Customer_ID, Product_ID, Rating_Date, Rating, Comment)
VALUES 
(512, 1, 101, '2022-04-13', 1, 'Great!'),
(513, 1, 105, '2023-07-22', 2, 'Tastes great!'),
(514, 1, 109, '2024-01-22', 5, 'Super cool!'),
(515, 4, 106, '2023-02-22', 3, 'awesome!'),
(516, 1, 103, '2021-06-09', 5, NULL),
(517, 3, 108, '2022-07-17', 1, NULL);

INSERT INTO Ratings (Rating_ID, Customer_ID, Product_ID, Rating_Date, Rating, Comment)
VALUES 
(518, 6, 103, '2022-04-13', 1, 'Incredible, changed my life!'),
(519, 6, 103, '2022-04-13', 1, 'DBMS rocks'),
(520, 7, 103, '2022-04-13', 1, 'Spectacular'),
(521, 6, 105, '2022-04-13', 1, 'Cool'),
(522, 6, 103, '2022-04-13', 1, 'Sweet');

INSERT INTO Customer (Customer_ID, Title, First_Name, Last_Name, Street_Address, City, State, Zip_Code, Phone_Number, Email)
VALUES 
(16, NULL, 'Gabriel', 'Berres', '492 Gourd Lane', 'Tahlequah', 'OK', '74464', '(918) 360-4253', 'berresg@nsuok.edu');

SELECT 
	First_Name + ' ' + Last_Name AS Name,
	City,
	State,
	Email
FROM 
	Customer
ORDER BY
	First_Name ASC;

SELECT 
	CASE	
		WHEN
		 Title IS NOT NULL
		THEN
		 Title + ' ' + First_Name + ' ' + Last_Name
		ELSE
		 First_Name + ' ' + Last_Name
	END AS Name,
	Email
FROM 
	Customer
WHERE 
	Email LIKE '%aol.com' OR Email LIKE '%yahoo.com';

INSERT INTO Product (Product_ID, Product_Name, Brand, Price, Stock_Quantity, Date_Added)

SELECT 
	Product_Name,
	Brand,
	Price,
	Date_Added
FROM 
	Product
WHERE
	Price < 12.00 OR Price > 100.00;
