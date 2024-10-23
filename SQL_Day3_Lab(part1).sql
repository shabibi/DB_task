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
						
-------------------------------------------------------------------------------
--9.Get the full name of employees that is similar to any dependent name
select  fname from Employee
where fname  in(select Dependent_name from Dependent where Fname like '%'+ Dependent_name+'%')
-------------------------------------------------------------------------------
--10.Display the employee number and name if at least one of them have dependents 
--(use exists keyword) self-search.
select ssn As Emplyee_Number, Fname As Name 
from Employee where exists --This checks if there are any rows in the Dependents table that correspond to the current employee.
				( select 1 from Dependent 
					where SSN = ESSN)
-------------------------------------------------------------------------------
--11.In the department table insert new department called "DEPT IT" , 
--with id 100, employee with SSN = 112233 as a manager for this department.
--The start date for this manager is '1-11-2006'
insert into Departments values ('DEPT IT',100,112233,'1-11-2006')

--------------------------------------------------------------------------------
--12.Do what is required if you know that : Mrs.Noha Mohamed(SSN=968574) 
--moved to be the manager of the new department (id = 100), 
--and they give you(your SSN =102672) her position (Dept. 20 manager) 

-->First try to update her record in the department table

update Departments
set  MGRSSN = null
where Dnum = 20

update Departments
set  MGRSSN = 968574
where Dnum = 100

-->Update your record to be department 20 manager.
update Departments
set  MGRSSN = 102672
where Dnum = 20

-->Update the data of employee number=102660 to be in your teamwork
--(he will be supervised by you) (your SSN =102672)
update Employee
set  Superssn = 102672
where SSN = 102660 					

--------------------------------------------------------------------------------
--13. Unfortunately the company ended the contract with Mr. Kamel Mohamed (SSN=223344) 
--so try to delete his data from your database
--in case you know that you will be temporarily in his position.
update Employee
set  Superssn = 102672
where Superssn = 223344 

update Departments
set  MGRSSN = 102672
where MGRSSN = 223344

update Works_for
set  ESSn = 102672
where ESSn = 223344

delete from Employee
where SSN = 223344

--------------------------------------------------------------------------------
--14.Try to update all salaries of employees who work in Project ‘Al Rabwah’ by 30%

update Employee
set Salary = (Salary+ Salary * 0.3)
where SSN in(  select w.ESSn from Works_for w 
			where w.Pno in (select p.Pnumber from Project p where
			p.Pname ='Al Rabwah'))
