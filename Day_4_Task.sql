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

