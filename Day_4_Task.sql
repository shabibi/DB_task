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
----------------------------------------------------------------------------

use Company_SD
--5. Create inline function that takes integer which represents manager
--ID and displays department name, Manager Name and hiring date
create function DisplayData(@manager_Id int)
returns table as 
return 
(
	select e.Fname ,d.Dname as Department_Name,d.[MGRStart Date] as Hiring_date 
	from Employee e join Departments d on d.MGRSSN = e.SSN 
	
	where(e.SSN = @manager_Id)

)

SELECT * FROM DisplayData(512463)

----------------------------------------------------------------------------
--6. Create multi-statements table-valued function that takes a string 
--If string='first name' returns student first name 
--If string='last name' returns student last name  
--If string='full name' returns Full Name from student table 
--Note: Use “ISNULL” function
create function GetStudentInfo (@StuInfo nvarchar(100))
returns @t table(StudentName nvarchar(100))
begin

	
		if(@StuInfo ='first name' )
		begin
		insert into @t
		select (ISNULL(St_Fname, ' '))
		from Student
		end

		else if(@StuInfo ='last name' )
		begin
		insert into @t
		select (ISNULL(St_Lname, ' '))
		from Student
		end

		else if (@StuInfo ='full name' )
		begin
		insert into @t
		select (ISNULL(St_Fname, ' ') +' '+ ISNULL(St_Lname, ' ') )
		from Student
		end
		  else
		  begin
        INSERT INTO @t
        VALUES ('Invalid InfoType');
		end
	
	return 
end

select* from GetStudentInfo('full name')

select* from GetStudentInfo('first name')
select* from GetStudentInfo('last name')
----------------------------------------------------------------------------
use Company_SD
--7. Create a cursor for Employee table that increases Employee salary by 
--10% if Salary <3000 and increases it by 20% if Salary >=3000. Use company DB 

declare c1 Cursor
for select salary
    from Employee
for update
declare @sal int
open c1
fetch next from c1 into @sal
while @@fetch_status=0
    begin
        if @sal<3000
            update Employee
                set salary += @sal * 0.1
            where current of c1
        else
            update Employee
                set Salary += @sal * 0.2
            where current of c1
        fetch c1 into @sal
    end
close c1
deallocate c1
------------------------------------------------------------------------
--8. Display Department name with its manager name using cursor.
declare @Dep_Name nvarchar(20)
declare @Man_Name nvarchar(20)
declare @Man_Id int
declare c1 Cursor
for select d.Dname, d.MGRSSN
    from Departments d


open c1
fetch next from c1 into @Dep_Name,@Man_Id
while @@fetch_status=0
    begin
		select @Man_Name = e.Fname  from Employee e where e.SSN = @Man_Id
		select @Dep_Name as [Department Name] , @Man_Name As [Manager Name]
        fetch c1 into @Dep_Name,@Man_Id
    end
close c1
deallocate c1
------------------------------------------------------------------------
--9. Try to display all instructor names in one cell separated by comma. Using Cursor
use ITI
declare c1 cursor
for select distinct Ins_Name
    from Instructor
    where Ins_Name is not null
for read only
declare @name varchar(20),@all_names varchar(500)='' --> initial value
open c1
fetch c1 into @name
while @@FETCH_STATUS=0
    begin
        set @all_names=concat(@all_names,',',@name)
        fetch c1 into @name   
    end
select @all_names
close c1
deallocate C1