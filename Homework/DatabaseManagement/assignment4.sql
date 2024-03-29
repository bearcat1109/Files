USE petAdoption;

-- DBMS Assignment 4 Gabriel Berres - Pet adoption database
-- Used Varchar(255) because sometimes the columns have long fields..
CREATE TABLE Pets (
    [pet ID] INT PRIMARY KEY,
    [Tagid] VARCHAR(255),
    [PetType] VARCHAR(255),
    [Species] VARCHAR(255),
    [Breed] VARCHAR(255),
    [PrimaryColor] VARCHAR(255),
    [Name] VARCHAR(255),
    [Gender] VARCHAR(255),
    [BirthDate] DATETIME,
    [IntakeDate] DATETIME,
    [Height] INT,
    [Weight] INT,
    [SpayedNeutered] VARCHAR(255),
    [Status] VARCHAR(255),
    [Comments] VARCHAR(MAX)
);

CREATE TABLE PotentialOwner (
    [Potential Owner ID] INT PRIMARY KEY,
    [First Name] VARCHAR(255),
    [Last Name] VARCHAR(255),
    [Address] VARCHAR(255),
    [Phone Number] VARCHAR(255),
    [Email] VARCHAR(255),
    [Comments] VARCHAR(MAX)
);

CREATE TABLE Adoption (
    [OwnerID] INT,
    [PetID] INT PRIMARY KEY,
    [AdoptionDate] DATETIME,
    [Cost] INT,
    [Comments] VARCHAR(MAX)
);

CREATE TABLE Rating (
    [UserID] INT,
    [PetID] INT PRIMARY KEY,
    [Date] DATETIME,
    [Satisfaction] INT,
    [Comments] VARCHAR(MAX)
);


USE petAdoption;
-- Insert statements - there's probably a few typos.
INSERT INTO Pets ([pet ID], [Tagid], [PetType], [Species], [Breed], [PrimaryColor], [Name], [Gender], [BirthDate], [IntakeDate], [Height], [Weight], [SpayedNeutered], [Status], [Comments]) VALUES
(1, 'A123456', 'Dog', 'Canine', 'Labrrador Retriever', 'Golden', 'Max', 'Male', '2020-05-15', '2020-06-01', 24, 65, 'Yes', 'Adopted', 'Friendly and energetic'),
(2, 'B789012', 'Cat', 'Feline', 'Siamese', 'Seal Point', 'Luna', 'Female', '2019-08-22', '2019-09-10', 12, 10, 'Yes', 'Available', 'Playful and affectionate'),
(3, 'C345678', 'Dog', 'Canine', 'German Shepherd', 'Black/Tan', 'Rocky', 'Male', '2018-02-10', '2018-03-05', 28, 80, 'No', 'On Hold', 'Requires special diet'),
(4, 'D901234', 'Cat', 'Feline', 'Persian', 'White', 'Bella', 'Female', '2021-01-07', '2021-02-01', 10, 12, 'Yes', 'Adopted', 'Loves cuddling'),
(5, 'E567890', 'Dog', 'Canine', 'Beagle', 'Tri-color', 'Daisy', 'Female', '2017-09-18', '2017-10-05', 18, 25, 'Yes', 'Available', 'Good with children'),
(6, 'F123456', 'Cat', 'Feline', 'Maine Coon', 'Tabby', 'Simba', 'Male', '2019-04-03', '2019-04-20', 16, 15, 'No', 'Adopted', 'Shy but sweet nature'),
(7, 'G789012', 'Dog', 'Canine', 'Dachshund', 'Red', 'Chloe', 'Female', '2022-06-12', '2022-07-01', 12, 18, 'Yes', 'Available', 'Loves to play fetch'),
(8, 'H345678', 'Cat', 'Feline', 'Ragdoll', 'Blue Bicolor', 'Oliver', 'Male', '2020-11-30', '2020-12-15', 14, 14, 'Yes', 'On Hold', 'Requires grooming'),
(9, 'I901234', 'Dog', 'Canine', 'Bulldog', 'Brindle', 'Rocky', 'Male', '2016-07-04', '2016-08-01', 20, 75, 'Yes', 'Adopted', 'Gentle and calm'),
(10, 'J567890', 'Cat', 'Feline', 'Bengal', 'Spotted', 'Mia', 'Female', '2020-02-14', '2020-03-01', 11, 11, 'Yes', 'Available', 'Enjoys interactive toys'),
(11, 'K123456', 'Dog', 'Canine', 'Poodle', 'Apricot', 'Teddy', 'Male', '2019-05-09', '2019-06-01', 15, 20, 'No', 'Adopted', 'Requires regular walks'),
(12, 'L789012', 'Cat', 'Feline', 'Sphynx', 'Pink', 'Gizmo', 'Male', '2017-12-25', '2018-01-10', 8, 9, 'Yes', 'Available', 'Indoor cat'),
(13, 'M345678', 'Dog', 'Canine', 'Golden Retriever', 'Cream', 'Lily', 'Female', '2020-09-03', '2020-09-20', 22, 60, 'Yes', 'Adopted', 'Loves water activities'),
(14, 'N901234', 'Cat', 'Feline', 'Scottish Fold', 'Silver Tabby', 'Whiskers', 'Female', '2018-04-17', '2018-05-01', 9, 10, 'Yes', 'On Hold', 'Requires special care'),
(15, 'O567890', 'Dog', 'Canine', 'Shih Tzu', 'White', 'Toby', 'Male', '2017-01-30', '2017-02-15', 10, 12, 'Yes', 'Adopted', 'Affectionate and playful'),
(16, 'P123456', 'Cat', 'Feline', 'Abyssinian', 'Ruddy', 'Leo', 'Male', '2019-06-08', '2019-07-01', 12, 14, 'Yes', 'Available', 'Active and curious'),
(17, 'Q789012', 'Dog', 'Canine', 'Boxer', 'Fawn', 'Zoey', 'Female', '2015-11-12', '2015-12-01', 25, 70, 'No', 'On Hold', 'Requires experienced owner'),
(18, 'R345678', 'Cat', 'Feline', 'Birman', 'Cream Point', 'Luna', 'Female', '2021-03-22', '2021-04-01', 11, 13, 'Yes', 'Adopted', 'Playful and talkative'),
(19, 'S901234', 'Dog', 'Canine', 'Rottweiler', 'Black/Brown', 'Duke', 'Male', '2018-08-07', '2018-09-01', 27, 90, 'Yes', 'Available', 'Protective and loyal'),
(20, 'T567890', 'Cat', 'Feline', 'Oriental Shorthair', 'Ebony', 'Shadow', 'Male', '2022-01-14', '2022-02-01', 10, 11, 'No', 'Adopted', 'Independent and curious');

-- Potential Owners table
USE petAdoption;
INSERT INTO PotentialOwner ([Potential Owner ID], [First Name], [Last Name], [Address], [Phone Number], [Email], [Comments]) VALUES
(1, 'John', 'Smith', '123 Main St, Anytown, CA 12345', '(555) 123-4567', 'john.smith@email.com', 'Interested in adopting a Labrador Retriever.'),
(2, 'Sarah', 'Johnson', '456 Oak Ave, Smallville, NY 67890', '(555) 234-5678', 'sarah.j@email.com', 'Prefer a hypoallergenic cat breed.'),
(3, 'Michael', 'Davis', '789 Pine Rd, Suburbia, TX 54321', '(555) 345-6789', 'michael.d@email.com', 'Enjoys outdoor activities, looking for an active dog.'),
(4, 'Emily', 'Miller', '101 Elm St, Cityville, FL 98765', '(555) 456-7890', 'emily.m@email.com', 'Interested in adopting a pair of kittens.'),
(5, 'Daniel', 'Garcia', '202 Maple Dr, Countryside, IL 87654', '(555) 567-8901', 'daniel.g@email.com', 'Currently has a cat and looking for a dog companion.'),
(6, 'Olivia', 'Martinez', '303 Cedar Ln, Seaside, CA 23456', '(555) 678-9012', 'olivia.m@email.com', 'Prefers small dog breeds.'),
(7, 'William', 'Robinson', '404 Birch Blvd, Metropolis, TX 76543', '(555) 789-0123', 'william.r@email.com', 'Experienced dog owner, open to any breed.'),
(8, 'Chloe', 'Taylor', '505 Fir St, Uptown, NY 54321', '(555) 890-1234', 'chloe.t@email.com', 'Looking for a playful and friendly cat.'),
(9, 'Ethan', 'Anderson', '606 Redwood Ave, Suburbia, CA 32109', '(555) 901-2345', 'ethan.a@email.com', 'Interested in adopting a rescue dog.'),
(10, 'Mia', 'White', '707 Oakwood Dr, Countryside, FL 87654', '(555) 123-4567', 'mia.w@email.com', 'Allergic to cats, prefers medium-sized dogs.'),
(11, 'Aiden', 'Harris', '808 Pine St, Cityville, IL 76543', '(555) 234-5678', 'aiden.h@email.com', 'Lives in an apartment, looking for a cat.'),
(12, 'Sophia', 'Nelson', '909 Elm Ave, Seaside, NY 98765', '(555) 345-6789', 'sophia.n@email.com', 'Enjoys long walks and wants an active dog.'),
(13, 'Noah', 'Carter', '010 Cedar Ln, Uptown, CA 65432', '(555) 456-7890', 'noah.c@email.com', 'Has a spacious backyard, interested in a large dog.'),
(14, 'Ava', 'Cooper', '111 Birch Blvd, Metropolis, TX 10987', '(555) 567-8901', 'ava.c@email.com', 'Previous experience with Siamese cats.'),
(15, 'Liam', 'Rivera', '212 Fir St, Suburbia, FL 23456', '(555) 678-9012', 'liam.r@email.com', 'Looking for a family-friendly dog breed.'),
(16, 'Isabella', 'Reed', '313 Redwood Ave, Cityville, IL 54321', '(555) 789-0123', 'isabella.r@email.com', 'Interested in fostering dogs temporarily.'),
(17, 'James', 'Cook', '414 Oakwood Dr, Seaside, CA 87654', '(555) 890-1234', 'james.c@email.com', 'Prefers older cats.'),
(18, 'Harper', 'Coleman', '515 Maple Dr, Countryside, NY 32109', '(555) 901-2345', 'harper.c@email.com', 'Wants a dog suitable for apartment living.'),
(19, 'Elijah', 'Bennett', '616 Cedar Ln, Uptown, TX 65432', '(555) 123-4567', 'elijah.b@email.com', 'Interested in adopting a specific breed (Golden Retriever).'),
(20, 'Addison', 'Powell', '717 Pine St, Cityville, FL 10987', '(555) 234-5678', 'addison.p@email.com', 'Enjoys outdoor activities, looking for an energetic dog.');


use petAdoption;
INSERT INTO Adoption ([OwnerID], [PetID], [AdoptionDate], [Cost], [Comments]) VALUES
(1, 3, '2020-07-15', 150, 'Happy to welcome Rocky into the family!'),
(2, 8, '2021-01-20', 200, 'Fell in love with Oliver''s charming personality.'),
(3, 5, '2018-10-03', 100, 'Daisy brings so much joy to our home.'),
(4, 14, '2018-05-15', 180, 'Whiskers needed extra care, but it''s worth it.'),
(5, 17, '2016-12-10', 120, 'Zoey is a great companion during outdoor activities.'),
(6, 2, '2019-09-25', 170, 'Luna''s graceful presence won our hearts.'),
(7, 11, '2020-06-10', 160, 'Teddy''s playful nature adds so much fun to our home.'),
(8, 16, '2019-07-15', 140, 'Leo''s curiosity matches ours perfectly.'),
(9, 19, '2019-01-05', 250, 'Duke''s protective nature is exactly what we needed.'),
(10, 4, '2022-02-28', 190, 'Bella has become the queen of our household.');

use petAdoption;
INSERT INTO Rating ([UserID], [PetID], [Date], [Satisfaction], [Comments]) VALUES
(1, 3, '2021-03-01', 9, 'Rocky is a delight, very satisfied!'),
(2, 8, '2022-04-15', 8, 'Oliver''s grooming needs were a bit challenging.'),
(3, 5, '2020-11-22', 10, 'Daisy is the best decision we''ve ever made!'),
(4, 14, '2019-08-05', 7, 'Whiskers requires extra attention but brings joy.'),
(5, 17, '2017-03-10', 9, 'Zoey''s energy matches mine perfectly.'),
(6, 2, '2021-12-18', 10, 'Luna''s affectionate nature is heartwarming.'),
(7, 11, '2020-09-30', 8, 'Teddy''s playfulness is a great stress reliever.'),
(8, 16, '2019-11-12', 9, 'Leo''s curiosity keeps life interesting.'),
(9, 19, '2022-01-20', 10, 'Duke''s loyalty and protectiveness are unmatched.'),
(10, 4, '2023-03-05', 9, 'Bella''s presence has made our home complete.');


use petAdoption;
