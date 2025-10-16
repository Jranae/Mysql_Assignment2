-- Beason_Jaleah_3.sql
-- CS300 Homework Assignment 3
-- Author: Jaleah Beason

-- ===========================
-- PART 1: DEALERSHIP DATABASE
-- ===========================

CREATE DATABASE IF NOT EXISTS dealership;
USE dealership;

-- Drop existing tables to allow re-runs
DROP TABLE IF EXISTS VTRANSACTION;
DROP TABLE IF EXISTS CUSTOMER;
DROP TABLE IF EXISTS ASSOCIATE;
DROP TABLE IF EXISTS VEHICLE;

-- =====================
-- Table: VEHICLE
-- =====================
CREATE TABLE VEHICLE (
    VID INT PRIMARY KEY,
    Make VARCHAR(50) NOT NULL,
    Model VARCHAR(50) NOT NULL,
    MDate DATE NOT NULL,
    Color VARCHAR(50) NOT NULL
);

-- =====================
-- Table: ASSOCIATE
-- =====================
CREATE TABLE ASSOCIATE (
    AID CHAR(10) PRIMARY KEY,
    AName VARCHAR(100) NOT NULL,
    Position VARCHAR(25) NOT NULL,
    Salary DECIMAL(10,2) NOT NULL,
    SuperAID CHAR(10),
    FOREIGN KEY (SuperAID) REFERENCES ASSOCIATE(AID)
);

-- =====================
-- Table: CUSTOMER
-- =====================
CREATE TABLE CUSTOMER (
    Ssn CHAR(9) PRIMARY KEY,
    CName VARCHAR(100) NOT NULL,
    Details VARCHAR(250)
);

-- =====================
-- Table: VTRANSACTION
-- =====================
CREATE TABLE VTRANSACTION (
    TID INT PRIMARY KEY,
    TTime DATETIME NOT NULL,
    VID INT NOT NULL,
    AID CHAR(10) NOT NULL,
    Ssn CHAR(9) NOT NULL,
    Price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (VID) REFERENCES VEHICLE(VID),
    FOREIGN KEY (AID) REFERENCES ASSOCIATE(AID),
    FOREIGN KEY (Ssn) REFERENCES CUSTOMER(Ssn)
);

-- =========================
-- QUERIES FOR DEALERSHIP DB
-- =========================

-- Q1: Find the CName, TID, and VID identifying each CUSTOMER, VTRANSACTION, and VEHICLE pairing involving a 'Burnt Orange' vehicle.
SELECT c.CName, vtr.TID, v.VID
FROM CUSTOMER c
JOIN VTRANSACTION vtr ON c.Ssn = vtr.Ssn
JOIN VEHICLE v ON vtr.VID = v.VID
WHERE v.Color = 'Burnt Orange';

-- Q2: Pair every ASSOCIATE with the TID, TTime, and Price of every transaction with which he/she is paired. If none, still appear once with NULLs.
SELECT a.AName, vtr.TID, vtr.TTime, vtr.Price
FROM ASSOCIATE a
LEFT JOIN VTRANSACTION vtr ON a.AID = vtr.AID;

-- Q3: Find the total amount of money passed through the dealership (absolute sum of Price values).
SELECT SUM(ABS(Price)) AS TotalMoneyPassed
FROM VTRANSACTION;

-- Q4: Find total count of associates who have had at least one purchase transaction (Price < 0).
SELECT COUNT(DISTINCT AID) AS AssociatesWithPurchases
FROM VTRANSACTION
WHERE Price < 0;

-- Q5: Find vehicle id, associate name, and transaction price for the highest total sales (positive only).
SELECT v.VID, a.AName, vtr.Price
FROM VTRANSACTION vtr
JOIN ASSOCIATE a ON vtr.AID = a.AID
JOIN VEHICLE v ON vtr.VID = v.VID
WHERE vtr.Price = (
    SELECT MAX(Price)
    FROM VTRANSACTION
    WHERE Price > 0
);

-- ===========================
-- PART 2: LAHMAN BASEBALL DB
-- ===========================

USE lahmansbaseballdb;

-- Q6: The name of every player born in 1990 (combined first and last name)
SELECT CONCAT(nameFirst, ' ', nameLast) AS PlayerName
FROM people
WHERE YEAR(birthYear) = 1990;

-- Q7: Total count of players who debuted in 2005 season
SELECT COUNT(playerID) AS PlayersDebuted2005
FROM people
WHERE YEAR(debut) = 2005;

-- Q8: Highest salary paid to a player in the NL in 2015
SELECT MAX(s.salary) AS HighestSalary_NL_2015
FROM salaries s
JOIN teams t ON s.teamID = t.teamID AND s.yearID = t.yearID
WHERE t.lgID = 'NL' AND s.yearID = 2015;

-- Q9: Player IDs of individuals who won an award in at least 10 different years
SELECT playerID
FROM awardsplayers
GROUP BY playerID
HAVING COUNT(DISTINCT yearID) >= 10;

-- Q10: TeamID and losses for every team in 2014 with more losses than the average, ordered by increasing losses
SELECT teamID, L AS Losses
FROM teams
WHERE yearID = 2014 AND L > (
    SELECT AVG(L)
    FROM teams
    WHERE yearID = 2014
)
ORDER BY Losses ASC;
