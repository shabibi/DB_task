use HotelBookingSystem

--Database Project Part 2 

--1. Indexing Requirements 

--HOTEL
-->Add a non-clustered index on the Name column
--to optimize queries that search for hotels by name. 
CREATE NONCLUSTERED INDEX  idx_HotelName  ON Hotel(HotelName);

--Add a non-clustered index on the Rating column
--to speed up queries that filter hotels by rating. 
CREATE NONCLUSTERED INDEX  idx_HotelRating  ON Hotel(HRating);

--Room
-- Add a clustered index on the HotelID and RoomNumber columns
--to optimize room lookup within a hotel 
CREATE NONCLUSTERED INDEX  idx_Room  ON Room(HID,RNumber)

-- Add a non-clustered index on the RoomType column to improve
--searches filtering by room type. 
CREATE NONCLUSTERED INDEX  idx_RoomType  ON Room(RoomType);

--Booking
--Add a non-clustered index on GuestID to optimize guest-related
--booking searches. 
CREATE NONCLUSTERED INDEX  idx_GuestID  ON booking(GID);

--Add a non-clustered index on the Status column to improve
--filtering of bookings by status. 
CREATE NONCLUSTERED INDEX  idx_Status  ON booking(BStatus);

--Add a composite index on RoomID, CheckInDate, and CheckOutDate
--for efficient querying of booking schedules.
CREATE NONCLUSTERED INDEX  idx_composite  ON booking(RID,CheckIn,CheckOut);
-----------------------------------------------------------------------------------

--2. Views 

-->View 1: ViewTopRatedHotels 
CREATE VIEW ViewTopRatedHotels(Hotel_Name,Hotel_Rating,Total_Room,Avg_Price)
AS
	select H.HotelName,h.HRating ,
	(select count(RNumber) from Room r where r.Hid = h.HID),
	(SELECT AVG(PricePerNight) from Room r where r.Hid = h.HID )
	from Hotel H
	where h.HRating >= 4.5
	
select * from ViewTopRatedHotels
--****************************************************************

--> View 2: ViewGuestBookings 
CREATE VIEW ViewGuestBookings(Guest_Name, NumberOfBooking,Total_Cost)
AS
	SELECT G.GName ,
	(SELECT COUNT(GID) FROM Booking B where G.GID = B.GID ),
	(SELECT SUM(Total_Cost) FROM Booking B where G.GID = B.GID )
	FROM Guest G

SELECT * FROM ViewGuestBookings
--****************************************************************

-->View 3: ViewAvailableRooms 
CREATE VIEW ViewAvailableRooms(Hotel_Name, Room_Type,Price_Per_Night )
AS
	SELECT  H.HotelName,R.RoomType,R.PricePerNight
	FROM Hotel H JOIN Room R ON R.HID = H.HID
	WHERE R.Room_status = 1

SELECT * FROM ViewAvailableRooms
ORDER BY Price_Per_Night

--*********************************************************************

-->View 4: ViewBookingSummary 
CREATE VIEW ViewBookingSummary(HotelName, Number_ofBookings,Confirmed,Pending ,Canceled)
AS
	SELECT H.HotelName,COUNT(B.BID), 
	SUM (CASE WHEN B.BStatus = 'Confirmed' THEN 1 ELSE 0 END),
	SUM (CASE WHEN B.BStatus = 'Pending' THEN 1 ELSE 0 END),
	SUM (CASE WHEN B.BStatus = 'Canceled' THEN 1 ELSE 0 END)
	FROM Hotel H LEFT JOIN Room R ON H.HID = R.HID
	LEFT JOIN Booking B ON B.RID = R.RID
	GROUP BY H.HotelName

	SELECT * FROM ViewBookingSummary
--*********************************************************************
CREATE VIEW ViewPaymentHistory(HotelName,Guest_Naame,Booking_Status,Total_Payment )
AS
-->View 5: ViewPaymentHistory 
SELECT DISTINCT H.HotelName,G.GName,B.BStatus,P.amount
FROM Payment P JOIN Booking B on P.BId = B.BID
JOIN Room R on R.RID = B.RID 
JOIN Hotel H on R.HID =H.HID
JOIN Guest G ON G.GID =B.GID

select * from ViewPaymentHistory

-------------------------------------------------------------------------------------------
-->3. Functions 

--Function 1: GetHotelAverageRating 
CREATE FUNCTION GetHotelAverageRating(@HotelID INT)
RETURNS DECIMAL
BEGIN
	DECLARE @Avrge decimal 
	SELECT @Avrge = AVG(Review_Rating) FROM Review
	where HID = @HotelID
	return @Avrge
END

select dbo.GetHotelAverageRating(1) AS AverageRating
--*********************************************************************
-->Function 2: GetNextAvailableRoom 
CREATE FUNCTION GetNextAvailableRoom(@HotelID INT,@Room_type varchar(10))
RETURNS INT
BEGIN
	declare @Room_Number INT
	select  @Room_Number = RNumber 
	from Room
	where  HID = @HotelID AND RoomType = @Room_type AND Room_status = 1
	RETURN @Room_Number
END

SELECT dbo.GetNextAvailableRoom(2,'Single') as AvailableRoom

--*********************************************************************

-->• Function 3: CalculateOccupancyRate
CREATE FUNCTION CalculateOccupancyRate(@HotelID INT)
RETURNS DECIMAL 
AS
BEGIN
	DECLARE @Booked int
	DECLARE @TotalRoom int
	DECLARE @OccupancyRate decimal

	--count the total rooms in the given hotel
	select @TotalRoom = count(RID) from Room
	where Hid = @HotelID

	--count the booked room in tge given hotel whithen last 30 days
	select @Booked = count(Rid)
	from Booking
	where Rid in (select Rid from Room where Hid = @HotelID)
	and BDate >= DATE_BUCKET(day,30, getdate())

	if(@TotalRoom != 0)
		set @OccupancyRate = (@Booked *100 ) /@TotalRoom
	else 
		set @OccupancyRate = 0
	
	RETURN @OccupancyRate
END

select dbo.CalculateOccupancyRate(1) AS OccupancyRate

--------------------------------------------------------------------------------
-- Stored Procedures

-->Stored Procedure 1: sp_MarkRoomUnavailable 
CREATE PROC sp_MarkRoomUnavailable
AS
	UPDATE Room 
	SET Room_status = 0
	WHERE RID IN (select B.Rid from Booking B where B.BStatus = 'Confirmed' )

EXEC sp_MarkRoomUnavailable

--*************************************************************************

-->Stored Procedure 2: sp_UpdateBookingStatus 
CREATE PROC sp_UpdateBookingStatus
AS
	UPDATE Booking
	SET BStatus = 'Check-in' WHERE CheckIn = GETDATE()

	UPDATE Booking
	SET BStatus = 'Check-out' WHERE CheckOut < GETDATE()

	UPDATE Booking
	SET BStatus = 'Canceled' WHERE CheckIn > GETDATE()

EXEC sp_UpdateBookingStatus	

--*************************************************************************

-->Stored Procedure 3: sp_RankGuestsBySpending
CREATE PROC sp_RankGuestsBySpending
AS
	SELECT G.GName,B.Total_Cost, RANK() OVER (ORDER BY B.Total_Cost DESC)AS RN
	FROM Guest G JOIN Booking B
	ON G.GID = B.Gid
	
EXEC sp_RankGuestsBySpending

------------------------------------------------------------------------------
