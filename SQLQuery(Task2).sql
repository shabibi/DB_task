use Company_SD 

--1. For each project, list the project name and 
--the total hours per week (for all employees) spent on that project

select sum( w.Hours) as Total_Hours, p.Pname as Project_Name
from Works_for w join Project p on w.Pno =  p.Pnumber
group by p.Pname


--2.For each department, retrieve the department name and the maximum,
--minimum and average salary of its employees.
select d.Dname as Department_name,max(e.Salary) as Max_Salary,min(e.Salary) as Min_Salary,avg(e.Salary) as Avg_Salary
from Employee e join Departments d on e.Dno = d.Dnum
group by d.Dname

