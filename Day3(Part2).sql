 --Part 2
 
 Use ITI 

 --1. Create a view that displays student full name,
 --course name if the student has a grade more than 50. 
 create view DStudent
as
	select St_Fname + '' + St_Lname as Full_Name ,c.Crs_Name AS Course
	from Student s join Stud_Course sc on s.St_Id = sc.St_Id 
	join Course c on sc.Crs_Id= c.Crs_Id
	where sc.Grade > 50

select * from DStudent
-------------------------------------------------------------------------
--2. Create an Encrypted view that displays manager names and the topics they teach. 
create view displays_manager 
as
	select DISTINCT  i.Ins_Name,t.Top_Name 
	from Instructor i
	join Ins_Course ic on ic.Ins_Id = i.Ins_Id 
	join Course c on c.Crs_Id = ic.Crs_Id
	join  Topic t  on t.Top_Id = c.Top_Id

select * from displays_manager
----------------------------------------------------------------------------------
--3.Create a view that will display Instructor Name, 
--Department Name for the ‘SD’ or ‘Java’ Department  
create view displays_Instructor
as 
	select i.Ins_Name as [Instructor Name],d.Dept_Name as [Department Name]
	from Instructor i join Department d
	on i.Dept_Id = d.Dept_Id where d.Dept_Name in('SD' , 'Java') 

select * from displays_Instructor

----------------------------------------------------------------------------
--4.  Create a view “V1” that displays student data for
--student who lives in Alex or Cairo. 
--Note: Prevent the users to run the following query 
--Update V1 set st_address=’tanta’
--Where st_address=’alex’;
create view displays_student
as
	select * from Student
	where St_Address in ('Alex','Cairo')
	with check option

select * from displays_student
--------------------------------------------------------------------
--5. Create a view that will display the project
--name and the number of employees work on it. “Use Company DB”
use Company_SD

create view display_project (Project_Name, number_of_employees) 
as
select p.Pname  ,(select count(w.ESSn) from Works_for w where p.Pnumber = w.Pno)
from Project p

select * from display_project




