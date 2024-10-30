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