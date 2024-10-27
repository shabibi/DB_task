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
----------------------------------------------------------------------------------

--3. Create a stored procedure that will be used in case there is an old employee
--has left the project and a new one become instead of him. The procedure should 
--take 3 parameters (old Emp. number, new Emp. number and the project number) 
--and it will be used to update works_on table. [Company DB]

create proc NewEmployee @oldEmpNum int ,@newEmpNum int, @projectNum int 
as
declare @existingEmpProj  int

select @existingEmpProj = w.Pno  from Works_for w where w.ESSn = @oldEmpNum


if(@existingEmpProj = (select top 1  pno from Works_for where ESSn = @newEmpNum and Pno = @projectNum))
	select 'This Employee is registered in the same project'
else if(@existingEmpProj = null)
	select 'The old employee is not assigned to any project.'
		
else
	begin
		update Works_for 
		set ESSn = @newEmpNum where ESSn = @oldEmpNum and Pno = @projectNum
	end 

	drop proc NewEmployee
 NewEmployee 102672, 112233, 100

  NewEmployee 102672, 512463, 100
