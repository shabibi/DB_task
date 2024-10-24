--SQLServer Lab 5

use ITI

--Create a stored procedure without parameters to show the number of students
--per department name.[use ITI DB] 
create proc GetStudent
as 
	select d.Dept_Name as[Department Name],(select count(st_id) from student s where d.Dept_Id = s.Dept_Id )as [number of students] 
	from department d 


GetStudent
-------------------------------------------------