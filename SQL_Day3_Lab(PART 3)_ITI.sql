--SQL Day3 Lab

--Part 3:
--------------------------------------------------------------------------
use ITI
--1.Display instructor Name and Department Name
select i.Ins_Name as [Instructor Name],
(select d.Dept_Name from Department d where i.Dept_Id = d.Dept_Id)As [Department]
from Instructor i

-----------------------------------------------------------------------------
--2.Display student full name and the name of the course he is taking
--For only courses which have a grade  
select s.St_Fname + ' '+ s.St_Lname As [FullName],c.Crs_Name as [Course]
from Course c join Stud_Course sc
on c.Crs_Id =sc.Crs_Id join Student s 
on sc.St_Id= s.St_Id
where sc.Grade is not null 

---------------------------------------------------------------------------------
--3. Display number of courses for each topic name
select t.Top_Name as[Topic name],
(select count(c.Top_Id) from Course c where c.Top_Id = t.Top_Id) as [Number of courses]
from  Topic t
----------------------------------------------------------------------------------

--4. Display max and min salary for instructors
select max(salary) as [max salary],min(salary) as [min salary]
from Instructor

-----------------------------------------------------------------------------------
--5. Display the Department name that contains the instructor who receives the minimum salary.
select d.Dept_Name
from Department d
where D.Dept_Id = (select I.Dept_Id  from Instructor i
where i.Salary = (select min(salary)from Instructor))

-----------------------------------------------------------------------------------
--6. Select instructor name and his salary but if there is no salary display instructor bonus keyword.
--“use coalesce Function” SELF Search

select i.Ins_Name as [instructor name],
-- (coalesce)checks if Salary is null. If it is, it returns "Instructor Bonus"; 
--otherwise, it returns the actual salary.
coalesce(i.Salary,'instructor bonus') as Salary 
from Instructor i
 ----------------------------------------------------------------------------------
 --7. Write a query to select the highest two salaries in Each Department
 --for instructors who have salaries. “using one of Ranking Functions”

 select * from( select i.Ins_Name,i.Salary,i.Dept_Id ,row_number() over (partition by i.dept_id order by salary desc)as top_salary
 from Instructor i) as newTable
 where top_salary <=2

 ---------------------------------------------------------------------------------
 --8. Write a query to select a random  student from each department.  
 --“using one of Ranking Functions”
  select * from( select S.St_Fname,S.Dept_Id,row_number() over (partition by S.dept_id order by NEWID())as RN
 from Student S WHERE S.Dept_Id IS NOT NULL) as newTable
 where RN= 1