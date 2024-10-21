use Company_SD

--⦁	Joins

--⦁	Display the Department id, name and id and the name of its manager.
select d.Dnum, d.Dname, e.SSN , e.Fname
from Departments d   inner join Employee e
on d.MGRSSN = e.SSN

--⦁	Display the name of the departments and the name of the projects under its control.
select d.Dname, p.Pname
from Departments d   inner join Project p
on d.Dnum = p.Dnum

--⦁	Display the full data about all the dependence associated with the name of the employee they depend on him/her.
select e.Fname, d.Dependent_name, d.Bdate ,d.Sex 
from Dependent d left join Employee e
on d.ESSN = e.SSN

--⦁	Display the Id, name and location of the projects in Cairo or Alex city
select p.Pnumber,p.Pname, p.Plocation
from Project p
where p.City = 'Cairo' or p.City ='Alex'

--⦁	Display the Projects full data of the projects with a name starts with "a" letter.
select *
from Project
where Pname like 'a%'

--⦁	display all the employees in department 30 whose salary from 1000 to 2000 LE monthly
select *
from Employee
where Dno = 30 and Salary between 1000 and 2000

--⦁	Retrieve the names of all employees in department 10 who works more than or equal10
--hours per week on "AL Rabwah" project.

select e.Fname 
from Employee e inner join Works_for w 
on  e.SSN = w.ESSn 
 inner join Project p
 on p.Pnumber = w.Pno
where e.Dno = 10 and w.Hours >= 10 and p.Pname ='AL Rabwah'

--⦁	Find the names of the employees who directly supervised with Kamel Mohamed.
select e1.Fname
from Employee e1 inner join Employee e2
on e1.Superssn = e2.SSN
where e2.Fname = 'Kamel' and e2.Lname ='Mohamed'

--⦁	Retrieve the names of all employees and the names of the projects they
--are working on, sorted by the project name.
select p.Pname as project_name, e.Fname as Employee_name 
from Employee e inner join Works_for w
on e.SSN  = w.ESSn 
inner join Project p
on w.Pno = p.Pnumber
order by p.Pname

--⦁	For each project located in Cairo City , find the project number, the controlling department name ,
--the department manager last name ,address and birthdate
select p.Pnumber ,d.Dname, e.Lname , e.Address ,e.Bdate 
from Employee e inner join Departments d
on e.SSN = d.MGRSSN 
inner join  Project p
on d.Dnum = p.Dnum
where p.City = 'Cairo'

--⦁	Display All Data of the managers
select distinct e2. *
from Employee e1 inner join Employee e2
on e1.Superssn = e2.SSN


--⦁	Display All Employees data and the data of their dependents even if they have no dependents
select e.* ,d.Dependent_name
from Employee e left join Dependent d 
on d.ESSN = e.SSN