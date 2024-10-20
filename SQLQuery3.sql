

USE Company_SD


--1⦁	Display all the employees Data.
select * 
from Employee


--2⦁	Display all the projects names, locations and the department which is responsible about it.

select Pname,Plocation ,Dnum 
from Project

--3⦁	If you know that the company policy is to pay an annual commission for each 
--employee with specific percent equals 10% of his/her annual salary .
--Display each employee full name and his annual commission in an ANNUAL COMM column (alias).

select (fname + ' ' + lname) as full_name,
Salary * 0.10 as ANNUAL_COMM 
from Employee  

--4⦁	Display the employees Id, name who earns more than 1000 LE monthly.
select ssn , fname
from Employee
where Salary >1000

--5⦁	Display the employees Id, name who earns more than 10000 LE annually.
select ssn , fname
from Employee
where (Salary + (Salary *0.10)) >10000 

--6⦁	Display the names and salaries of the female employees 
select fname , Salary
from Employee
where Sex = 'F'

--7⦁	Display each department id, name which managed by a manager with id equals 968574.
select dnum , Dname
from Departments
where MGRSSN = 968574

--8⦁	Dispaly the ids, names and locations of  the pojects which controled with department 10.
select Pname,Pname,Plocation 
from Project
where Dnum = 10

--9⦁	Insert your personal data to the employee table as a new employee in department number 30, 
--SSN = 102672, Superssn = 112233, salary=3000.
insert into Employee(Fname,Lname,ssn,Bdate,Address,Sex,Salary,Superssn,Dno)
values('Afra','Alshabibi',102672,'3-2-1992','Oman','F',3000,112233,30)

--10⦁	Insert another employee with personal data your friend as new employee in department number 30, SSN = 102660, 
--but don’t enter any value for salary or supervisor number to him.
insert into Employee(Fname,Lname,ssn,Bdate,Address,Sex,Dno)
values('Azza','Alshabibi',102660,'7-10-1997','Oman','F',30)

--11⦁	Upgrade your salary by 20 % of its last value.
update Employee
set Salary+=(Salary +0.2)
where ssn=102672
