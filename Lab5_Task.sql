--SQLServer Lab 5

use ITI

--1.Create a stored procedure without parameters to show the number of students
--per department name.[use ITI DB] 
create proc GetStudent
as 
	select d.Dept_Name as[Department Name],(select count(st_id) from student s where d.Dept_Id = s.Dept_Id )as [number of students] 
	from department d 


GetStudent
-------------------------------------------------
--2.Create a stored procedure that will check for the # of employees in the project
--p1 if they are more than 3 print message to the user “'The number of employees 
--in the project p1 is 3 or more'” if they are less display a message to the user
--“'The following employees work for the project p1'” in addition to the first name 
--and last name of each one. [Company DB] 
use Company_SD


create proc CheckEmployee
as
declare @NoOfEmp int
select @NoOfEmp =count(essn) from Works_for where Pno =100
	if(@NoOfEmp >= 3)
		select 'The number of employees in the project p1 is 3 or more'
	else 
	begin
		select 'The following employees work for the project p1' 
		select Fname + ' '+ Lname as Emplyee_Name from Employee 
		where SSN in (select essn from Works_for where Pno =100)
	end

CheckEmployee