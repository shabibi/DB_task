use Company_SD

--Part1
--1.
select d.Dependent_name , d.Sex
from Dependent d 
where d.ESSN in (select SSN from Employee 
				where Sex = 'F') and  d.Sex = 'F'
union all
select d.Dependent_name , d.Sex
from Dependent d 
where d.ESSN in (select SSN from Employee 
				where Sex = 'M') and  d.Sex = 'M'
-----------------------------------------------------------------------------
--2.For each project, list the project name and the total hours per week
--(for all employees) spent on that project.
select p.Pname , sum(w.Hours) as Total_Hours
from Project p join Works_for w
on p.Pnumber = w.Pno
group by p.Pname

-----------------------------------------------------------------------------
--3.Display the data of the department which has the smallest employee 
--ID over all employees' ID.
select *
from Departments
where Dnum in (select Dno from Employee
				where ssn in (select min(ssn) 
				from Employee))
--------------------------------------------------------------------------
--4.For each department, retrieve the department name and the max, 
--min and average salary of its employees

select Dname ,max(e.salary) as Max_Salary, 
min(e.salary) as Min_Salary,
avg(e.salary) as Avg_Salary
from Departments d join Employee e on 
d.Dnum = e.Dno
group by Dname

---------------------------------------------------------------------
--5.List the full name of all managers who have no dependents.
select Fname +' ' + Lname As Full_Nmae from Employee
	where SSN in(select MGRSSN from Departments
				where MGRSSN not in (select essn from Dependent))

----------------------------------------------------------------------
--6. For each department-- if its average salary is less than the average
--salary of all employees-- display its number, name and number of its employees
select d.dnum,d.Dname ,COUNT(e.ssn) as Count
from Departments d join Employee e on d.Dnum = e.Dno
group by dnum ,Dname 
having avg(salary) <(select avg(salary) from Employee)

------------------------------------------------------------------------
--7.Retrieve a list of employees names and the projects names they are working on
--ordered by department number and within each department, ordered alphabetically 
--by last name, first name.
select Fname +' ' + Lname as Employee_Name, p.Pname as Project_Name
from Employee e join Works_for w
on e.SSN = w.ESSn join Project p 
on w.Pno = p.Pnumber 
order by p.Dnum, e.Lname, e.Fname

-------------------------------------------------------------------------------
--8.Try to get the max 2 salaries using subquery
select salary from(select * ,ROW_NUMBER() over (order by salary desc)as rn from employee) as NewTable
where rn in (1 , 2)
						

