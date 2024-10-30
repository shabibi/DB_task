create database HotelBookingSystem

use HotelBookingSystem

create table Hotel
(
	HID int identity primary key ,
	HotelName nvarchar(30) unique not null ,
	HLocation nvarchar(100) not null ,
	HContactNumber nvarchar(50) not null,
	HRating decimal 
)

create table Room
(
	RID int identity primary key ,
	RNumber int unique not null ,
	RoomType nvarchar(10) not null check (RoomType in('Single', 'Double', 'Suite')),
	PricePerNight decimal check (PricePerNight > 0),
	Room_status bit not null default 1,
	Hid int,
	foreign key(Hid) references Hotel(HID) on delete cascade on update cascade
)

create table Guest
(
	GID int identity primary key ,
	GName nvarchar(50) unique not null ,
	GContactNumber nvarchar(50) not null,
	id_Proof_Info nvarchar(200) not null 
)

create table Booking
(
	BID int identity primary key ,
	BDate date not null,
	CheckIn DATE NOT NULL ,
	CheckOut DATE not null ,
	BStatus nvarchar(20) not null check(BStatus in ('Pending', 'Confirmed', 'Canceled', 'Check-in', 'Check-out')),
	Total_Cost decimal not null,
	Rid int,
	foreign key(Rid) references Room(RID) on delete cascade on update cascade,
	Gid int,
	foreign key(Gid) references Guest(GID) on delete cascade on update cascade
)
alter table Booking 
add CONSTRAINT CheckOut_CheckIn 
check (CheckOut >= CheckIn )

create table Payment
(
	PDate date not null,
	amount decimal not null check (amount > 0),
	method nvarchar (100),
	BID int,
	foreign key(BID) references Booking(BID) on delete cascade on update cascade
)

create table Staff 
(
    SID int identity primary key ,
    SName NVARCHAR(100) NOT NULL,
    Position NVARCHAR(100) NOT NULL,
    SNumber NVARCHAR(50) NOT NULL,
    HID INT,
    foreign key (HID) references Hotel(HID) on delete cascade on update cascade
)

create table Review 
(
    Review_Rating int not null check (Review_Rating BETWEEN 1 AND 5),
    Comments nvarchar(300) default 'No comments',
    RDate date NOT NULL,
    HID int,
	foreign key (HID) references Hotel(HID) on delete cascade on update cascade,
	Gid int,
	foreign key(Gid) references Guest(GID) on delete cascade on update cascade
)