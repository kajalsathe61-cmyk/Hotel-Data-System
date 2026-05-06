CREATE DATABASE Hotel_Management_SystemDB;

USE Hotel_Management_SystemDB;

CREATE TABLE 
Guests (GuestID INT PRIMARY KEY,FirstName VARCHAR(50),LastName VARCHAR(50),Email VARCHAR(100),Phone VARCHAR(15));

CREATE TABLE 
Rooms (RoomID INT PRIMARY KEY,RoomNumber VARCHAR(10),RoomType VARCHAR(50),PricePerNight DECIMAL(10,2));

CREATE TABLE 
Bookings (BookingID INT PRIMARY KEY,GuestID INT,RoomID INT,CheckInDate DATE,CheckOutDate DATE,
FOREIGN KEY (GuestID) REFERENCES Guests(GuestID),FOREIGN KEY (RoomID) REFERENCES Rooms(RoomID));

CREATE TABLE 
Services (ServiceID INT PRIMARY KEY,ServiceName VARCHAR(100),Price DECIMAL(10,2));

CREATE TABLE 
BookingServices (BookingServiceID INT PRIMARY KEY,BookingID INT,ServiceID INT,Quantity INT,
FOREIGN KEY (BookingID) REFERENCES Bookings(BookingID),FOREIGN KEY (ServiceID) REFERENCES Services(ServiceID));

CREATE TABLE 
Payments (PaymentID INT PRIMARY KEY,BookingID INT,PaymentDate DATE,Amount DECIMAL(10,2),
FOREIGN KEY (BookingID) REFERENCES Bookings(BookingID));



INSERT INTO Guests VALUES
(1,'Kajal','Sathe','kajal@example.com','5551111111'),
(2,'Rahul','Sharma','rahul@example.com','5552222222'),
(3,'Priya','Patil','priya@gmail.com','4443333333'),
(4,'Amit','Joshi','amit@example.com','5554444444'),
(5,'Sneha','Kulkarni','sneha@example.com','5555555555'),
(6,'Rohit','Patel','rohit@gmail.com','4446666666'),
(7,'Neha','Singh','neha@example.com','5557777777'),
(8,'Vikas','Gupta','vikas@gmail.com','4448888888'),
(9,'Anjali','Deshmukh','anjali@example.com','5559999999'),
(10,'Suresh','Yadav','suresh@example.com','5550000000');


INSERT INTO Rooms VALUES
(1,'101','Single',100),
(2,'102','Double',150),
(3,'103','Suite',250),
(4,'104','Deluxe Suite',300),
(5,'105','Single',120),
(6,'106','Double',180),
(7,'107','Suite',260),
(8,'108','Deluxe',220),
(9,'109','Suite',280),
(10,'110','Single',110);


INSERT INTO Bookings VALUES
(1,1,3,'2024-01-02','2024-01-05'),
(2,2,2,'2024-02-01','2024-02-03'),
(3,3,1,'2023-12-20','2023-12-25'),
(4,4,4,'2024-03-10','2024-03-15'),
(5,5,5,'2024-04-01','2024-04-05'),
(6,6,6,'2024-05-01','2024-05-06'),
(7,7,7,'2024-06-01','2024-06-04'),
(8,8,8,'2024-07-01','2024-07-05'),
(9,9,9,'2024-08-01','2024-08-06'),
(10,10,10,'2024-09-01','2024-09-03');


INSERT INTO Services VALUES
(1,'Room Service',50),
(2,'Laundry',30),
(3,'Spa',100),
(4,'Breakfast',20),
(5,'Airport Pickup',80),
(6,'Gym',40),
(7,'Dinner',60),
(8,'WiFi',10),
(9,'Parking',15),
(10,'Mini Bar',70);


INSERT INTO BookingServices VALUES
(1,1,1,2),
(2,2,2,1),
(3,3,3,1),
(4,4,4,3),
(5,5,5,1),
(6,6,6,2),
(7,7,7,1),
(8,8,8,4),
(9,9,9,2),
(10,10,10,1);


INSERT INTO Payments VALUES
(1,1,'2024-01-05',500),
(2,2,'2024-02-03',300),
(3,3,'2023-12-25',200),
(4,4,'2024-03-15',700),
(5,5,'2024-04-05',400),
(6,6,'2024-05-06',600),
(7,7,'2024-06-04',350),
(8,8,'2024-07-05',450),
(9,9,'2024-08-06',650),
(10,10,'2024-09-03',250);


SELECT * FROM Bookings
WHERE CheckOutDate > '2024-01-01';


SELECT *FROM Guests
WHERE Phone LIKE '555%' AND Email LIKE '%example.com%';


SELECT *FROM Rooms
WHERE RoomType LIKE '%Suite%';

SELECT RoomNumber,
CASE WHEN PricePerNight > 200 THEN PricePerNight * 0.8 ELSE PricePerNight
 END AS DiscountedPrice FROM Rooms;


SELECT *FROM Guests
WHERE GuestID IN (SELECT B.GuestID FROM Bookings B JOIN Payments P
 ON B.BookingID = P.BookingID GROUP BY B.GuestID HAVING SUM(P.Amount) > 500);
 
 
 SELECT R.RoomType,COUNT(B.BookingID) AS TotalRoomsBooked FROM Rooms R
JOIN Bookings B ON R.RoomID = B.RoomID GROUP BY R.RoomType;


SELECT BookingID,SUM(Amount) AS TotalAmount FROM Payments
GROUP BY BookingID HAVING SUM(Amount) > 100;


SELECT G.FirstName,G.LastName,SUM(DATEDIFF(B.CheckOutDate, B.CheckInDate))
AS TotalNights FROM Guests G JOIN Bookings B ON G.GuestID = B.GuestID
GROUP BY G.GuestID ORDER BY TotalNights DESC LIMIT 5;


SELECT G.FirstName,G.LastName,B.CheckInDate,B.CheckOutDate
FROM Bookings B INNER JOIN Guests G ON B.GuestID = G.GuestID;


SELECT R.RoomNumber,B.BookingID,B.CheckInDate,
B.CheckOutDate FROM Rooms R LEFT JOIN Bookings 
B ON R.RoomID = B.RoomID;


SELECT R.RoomType,SUM(P.Amount) AS TotalRevenue
FROM Rooms R INNER JOIN Bookings B ON R.RoomID = B.RoomID
INNER JOIN Payments P ON B.BookingID = P.BookingID
GROUP BY R.RoomType;


SELECT B.BookingID FROM Bookings B
JOIN BookingServices BS ON B.BookingID = BS.BookingID
JOIN Services S ON BS.ServiceID = S.ServiceID
GROUP BY B.BookingID HAVING SUM(S.Price * BS.Quantity)
 > (SELECT AVG(Price) FROM Services);
 
 
 SELECT R.RoomNumber,CONCAT(G.FirstName, ' ', G.LastName) 
AS GuestName,S.ServiceName FROM Bookings B
INNER JOIN Guests G ON B.GuestID = G.GuestID
INNER JOIN Rooms R ON B.RoomID = R.RoomID
LEFT JOIN BookingServices BS ON B.BookingID = BS.BookingID
LEFT JOIN Services S ON BS.ServiceID = S.ServiceID
WHERE BS.BookingID IS NOT NULL;
