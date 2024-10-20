create database  SQL_Lab1 

use SQL_Lab1

create table Instructor 
(
	ID int primary key identity(1,1 ) ,
	fname nvarchar(20),
	Lname nvarchar(20),
	BD date,
	Salary int  CONSTRAINT CK_Salary check(Salary between 1000 and 5000) default 3000, 
	overTime int unique,
	hiredate date default getdate(),
	Iaddress nvarchar(100) CHECK (Iaddress IN ('cairo ', 'alex ')),
	age AS DATEDIFF(YEAR,  GETDATE(),BD),
	Netsalary  as (Salary + overTime)
)

create table Course
(
	CID int primary key identity(1,1 ) ,
	CName nvarchar(30),
	Duration int unique
)

create table Lab
(
	LID int primary key identity(1,1 ) ,
	LLocation nvarchar(30),
	capacity int check (capacity < 20),
	CID int,
	foreign key (CID) references Course(CID)
)
create table Instructor_Course
(
	IID int,
	CID int,
	foreign key (IID) references Instructor(ID),
	foreign key (CID) references Course(CID),
	primary key (IID, CID)
)


