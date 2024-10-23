--SQL lab 4

use ITI

--1. Create a scalar function that takes date and returns Month name of that date.

create function gitMonth(@date date)
returns nvarchar(15) 
begin
declare @month_Name nvarchar(15)
select @month_Name = DATENAME(month, @date)
return @month_Name
end

select dbo.gitMonth('2024-8-29') as Month
--------------------------------------------------------------------------------------
--. Create a multi-statements table-valued function that 
--takes 2 integers and returns the values between them.
create function gitValue(@n1 int, @n2 int)
returns @t table( x int)
as 
begin
	declare @currentNum int = @n1
	while @currentNum < @n2
		begin 
			set @currentNum +=1
			if(@currentNum < @n2)
			insert into @t 
			select @currentNum
			else 
			break
		end 
	return
end

select * from gitValue(1,9)

---------------------------------------------------------------------------
--3. Create inline function that takes Student No and
--returns Department Name with Student full name.
create function DisplayInfo (@Student_Id int)
returns  @t table ( Full_Name nvarchar(20),dep_Name varchar(20))
as
begin
	insert into @t
	select s.St_Fname + ' '+ s.St_Lname ,s.Dept_Id
				from Student s where s.St_Id = @Student_Id
return
end

select * from DisplayInfo(1)

--------------------------------------------------------------------------------
--4. Create a scalar function that takes Student ID and returns a message to user 
create function CheckStudentName (@Student_Id int)
returns nvarchar(100)
begin
	declare @Full_name nvarchar(100)
	declare @First_name nvarchar(50) 
	declare @Last_name nvarchar(50)
	select @First_name = St_Fname ,@Last_name = St_Lname from Student
	where St_Id = @Student_Id
		if(@First_name is null and @Last_name is null)
			set @Full_name =  'First name & last name are null'
		else if (@First_name is null)
			set @Full_name =  'first name is null'
		else if ( @Last_name is null)
			set @Full_name =  'last name is null'
		else 
			set @Full_name =  'First name & last name are not null'
	return @Full_name
end
 drop function dbo.CheckStudentName
select dbo.CheckStudentName(1)
select dbo.CheckStudentName(13)
select dbo.CheckStudentName(14)