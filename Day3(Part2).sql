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
