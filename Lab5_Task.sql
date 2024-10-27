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

  --------------------------------------------------------------------------
  --4. add column budget in project table and insert any draft values in it 
  alter table project 
  add Budget int
  --set fraft values
  update Project
  set Budget = 50000

  --then Create an Audit table with the following structure 
  create table Audit 
  (
	ProjectNo  int
	foreign key (ProjectNo) references Project(pnumber),
	UserName nvarchar(100) ,
	ModifiedDate date,
	Budget_Old int,
	Budget_New int 

  )
  --This table will be used to audit the update trials on the Budget column
  --(Project table, Company DB)
  create trigger insertAudit
  on project
  after update
  as
  begin
  if update (Budget)
  begin
	insert into Audit(ProjectNo, UserName, ModifiedDate, Budget_Old, Budget_New)
	select i.Pnumber, SYSTEM_USER ,GETDATE(), d.Budget ,i.Budget
	from inserted i join deleted d on i.Pnumber = d.Pnumber
  end
  end

  update Project 
  set Budget = 20000
  where Pnumber = 100
  ------------------------------------------------------------------------

  --5.Create a trigger to prevent anyone from inserting a new record in 
  --the Department table [ITI DB]“Print a message for user to tell him 
  --that he can’t insert a new record in that table”

  use ITI 

  create trigger InsertDepartment
  on Department
  instead of insert
  as 
  select 'Can’t insert a new record in Department table'

  insert into Department values (10,'SD','System' ,'Cairo',1,'2000-01-01')
  --------------------------------------------------------------------------------------

  --6. Create a trigger that prevents the insertion Process for 
  --Employee table in March [Company DB].
    use Company_SD

	create trigger PreventInsert
	on employee
	instead of insert 
	as
	begin
		if MONTH(getdate()) = 3
			RAISERROR('Inserts to the Employee table are not allowed in March.', 16, 1);
	end 

	-----------------------------------------------------------------------------
	--7. Create a trigger on student table after insert to add Row 
	--in Student Audit table (Server User Name , Date, Note) where 
	--note will be “[username] Insert New Row with Key=[Key Value] in table [table name]”

create table StudentAudit 
  (
	
	UserName nvarchar(100) ,
	InsertDate  date,
	Note nvarchar (200)

  )

  create trigger InsertStudent
  on Student
  after insert
  as
  declare @note nvarchar  =  'Insert New Row in table Student'

  begin
	insert into StudentAudit 
	values (SYSTEM_USER, GETDATE(),@note)
  end


  insert into Student values(17,'Said','Ali','Alex',24,30,9)