--SQL Day3 Lab

--Part 3:
-- Use AdventureWorks DB
----------------------------------------------------------------------
use AdventureWorks2012

--1.  Display any Product with a Name starting with the letter B
select *
from Production.Product 
where Name like 'B%'

----------------------------------------------------------------------
--2. Run the following Query
--UPDATE Production.ProductDescription
--SET Description = 'Chromoly steel_High of defects'
--WHERE ProductDescriptionID = 3
update Production.ProductDescription 
set Description = 'Chromoly steel_High of defects'
where ProductDescriptionID = 3

--Then write a query that displays any Product description with underscore
--value in its description.
select * 
from Production.ProductDescription 
where Description like '%\_%' ESCAPE '\'
 ------------------------------------------------------------------------

--3. Calculate sum of TotalDue for each OrderDate in Sales.SalesOrderHeader
--table for the period between  '7/1/2001' and '7/31/2014'
select OrderDate, sum(TotalDue) as TotalDue from Sales.SalesOrderHeader
where OrderDate between '7/1/2001' and '7/31/2014'
group by OrderDate

---------------------------------------------------------------------------

--4. Calculate the average of the unique ListPrices in the Product table
select AVG(distinct ListPrice) As [average ListPrices]
from Production.Product 

----------------------------------------------------------------------------
--5. Display the Product Name and its ListPrice within the values
--of 100 and 120 the list should has the following format "The 
--[product name] is only! [List price]" (the list will be sorted
--according to its ListPrice value)
select Name as [product name], ListPrice as [List price]
from Production.Product 
where ListPrice between 100 and 200
order by ListPrice

------------------------------------------------------------------------------
--6. Using union statement, retrieve the today’s date in different
--styles using convert or format funtion.
SELECT CONVERT(VARCHAR(10), GETDATE(), 101) AS DateStyle 
UNION
SELECT CONVERT(VARCHAR(10), GETDATE(), 103) 
UNION
SELECT CONVERT(VARCHAR(10), GETDATE(), 110) 
UNION
SELECT FORMAT(GETDATE(), 'dd MMMM yyyy')