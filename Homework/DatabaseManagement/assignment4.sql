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
