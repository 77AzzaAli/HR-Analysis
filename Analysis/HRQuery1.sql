use HR

-- Modefi the Data type & Primary key
Begin;

-- Modefi the data type of Employees
Begin;
ALTER TABLE Employees
ALTER COLUMN EmployeeID varchar(150) Not Null;
ALTER TABLE Employees
ALTER COLUMN full_name varchar(150) Not Null;
ALTER TABLE Employees
ALTER COLUMN Gender varchar(150) ;
ALTER TABLE Employees
ALTER COLUMN Age int not null;
ALTER TABLE Employees
ALTER COLUMN TravelFrequency varchar(150);
ALTER TABLE Employees
ALTER COLUMN Department varchar(150) Not Null;
ALTER TABLE Employees
ALTER COLUMN DistanceFromHome int Not Null;
ALTER TABLE Employees
ALTER COLUMN State varchar(150) Not Null;
ALTER TABLE Employees
ALTER COLUMN Ethnicity varchar(150) Not Null;
ALTER TABLE Employees
ALTER COLUMN EducationLevel varchar(150) Not Null;
ALTER TABLE Employees
ALTER COLUMN EducationField varchar(150) Not Null;
ALTER TABLE Employees
ALTER COLUMN JobRole varchar(150) Not Null;
ALTER TABLE Employees
ALTER COLUMN MaritalStatus varchar(150) Not Null;
ALTER TABLE Employees
ALTER COLUMN Salary int not null;
ALTER TABLE Employees
ALTER COLUMN StockOptionLevel int not null;
ALTER TABLE Employees
ALTER COLUMN OverTime varchar(150) Not Null;
ALTER TABLE Employees
ALTER COLUMN HireDate Date Not Null;
ALTER TABLE Employees
ALTER COLUMN Attrition varchar(150) not null;
ALTER TABLE Employees
ALTER COLUMN YearsAtCompany int not null;
ALTER TABLE Employees
ALTER COLUMN RecentRoleYears int not null;
ALTER TABLE Employees
ALTER COLUMN PromotionGapYears int not null;
ALTER TABLE Employees
ALTER COLUMN YearsWithCurrManager int not null;
End;

--- define the Primary Key of Employees

Begin;
ALTER TABLE Employees
ADD CONSTRAINT PK_EmployeeID PRIMARY KEY (EmployeeID);
End;

--- Modefi the data type of Performance

Begin;
ALTER TABLE Performance
ALTER COLUMN PerformanceID varchar(150) Not Null;

ALTER TABLE Performance
ALTER COLUMN EmployeeID varchar(150) Not Null;

ALTER TABLE Performance
ALTER COLUMN ReviewDate Date Not Null;

ALTER TABLE Performance
ALTER COLUMN EnvironmentSatisfaction int not null;

ALTER TABLE Performance
ALTER COLUMN JobSatisfaction int not null;

ALTER TABLE Performance
ALTER COLUMN RelationshipSatisfaction int not null;

ALTER TABLE Performance
ALTER COLUMN AnnualTrainingOpportunities int not null;

ALTER TABLE Performance
ALTER COLUMN TrainingTaken int not null;

ALTER TABLE Performance
ALTER COLUMN WorkLifeBalance int not null;

ALTER TABLE Performance
ALTER COLUMN SelfRating int not null;

ALTER TABLE Performance
ALTER COLUMN ManagerRating int not null;
End;

-- define the Primary Key of Performance

Begin;

ALTER TABLE Performance
ADD CONSTRAINT PK_PerformanceID PRIMARY KEY (PerformanceID);
End;

-- Modefi the data type of Satisfaction

Begin;

ALTER TABLE Satisfied
ALTER COLUMN SatisfactionLevel varchar(150) Not Null;

ALTER TABLE Satisfied
ALTER COLUMN SatisfactionID int not null;
End;

-- define the Primary Key of Satisfaction

Begin;

ALTER TABLE Satisfied
ADD CONSTRAINT PK_SatisfactionID PRIMARY KEY (SatisfactionID);
End;

-- Modefi the data type of Rating

Begin;

ALTER TABLE Rating
ALTER COLUMN RatingLevel varchar(150) Not Null;

ALTER TABLE Rating
ALTER COLUMN RatingID int not null;
End;

-- define the Primary Key of Rating

Begin;

ALTER TABLE Rating
ADD CONSTRAINT PK_RatingID PRIMARY KEY (RatingID);
End;

End;

--create table time dimension

Begin;
/*
DECLARE @FirstDate DATE = (SELECT MIN(HireDate) FROM Employees);
DECLARE @LastDate DATE = (SELECT MAX(HireDate) FROM Employees);

CREATE TABLE TimeDimension (
    Date DATE PRIMARY KEY,
    Year INT,
    Month INT,
    Day INT,
    Quarter INT
);

WITH DateSeries AS (
    SELECT @FirstDate AS Date
    UNION ALL
    SELECT DATEADD(DAY, 1, Date)
    FROM DateSeries
    WHERE Date < @LastDate
)
INSERT INTO TimeDimension (Date, Year, Month, Day, Quarter)
SELECT 
    Date,
    YEAR(Date),
    MONTH(Date),
    DAY(Date),
    DATEPART(QUARTER, Date)  
FROM DateSeries
OPTION (MAXRECURSION 0);  
 */
 select* from TimeDimension
End;


---Creat column of Attration Year in Employees

Begin;
ALTER TABLE Employees
ADD AttritionYear INT;
UPDATE Employees
SET AttritionYear = CASE
    WHEN Attrition = 'Yes' THEN YEAR(HireDate) + YearsAtCompany
    ELSE NULL
End;
End;


---Understanding the data 

Begin;
-------------------------------    AGE
Select max(Age) as max_age,min(Age)as min_age,avg(Age)as avg_age from Employees 
----------------------------------- Travel
select count(TravelFrequency)as Travel_fr ,TravelFrequency from Employees
group by TravelFrequency	
order by Travel_fr desc
--------------------------------------- Distance
select avg(DistanceFromHome)as avg_di,max(DistanceFromHome)as max_di,min(DistanceFromHome)as min_Di  from Employees
------------------------------------------------ Salary
Select max(Salary) as max_sa,min(Salary)as min_sa,avg(Salary)as avg_sa from Employees
-------------------------------------------Hire Date
select min(HireDate) as srart,max(HireDate) as final  from Employees
-----------------------------------------------------------------------------Emp_year
select max(YearsAtCompany) as AT_max,AVG(YearsAtCompany)as avg_AT from Employees
select max(RecentRoleYears) as Recent_max,AVG(RecentRoleYears)as avg_Recent from Employees
select max(PromotionGapYears) as Pormotion_max,AVG(PromotionGapYears)as avg_Pormotion from Employees
select max(YearsWithCurrManager) as Manager_max,AVG(YearsWithCurrManager)as avg_Manager from Employees
-----------------------------------------------------------------Review data
select min(ReviewDate) as srart,max(ReviewDate) as final  from Performance
--------------------------------------------------------Job role
SELECT JobRole, COUNT(*) AS num_employees
FROM Employees
GROUP BY JobRole
order by num_employees desc
----------------------------------------------------------------Stock option level
select   distinct StockOptionLevel from Employees
 ------------------------------------------------------------------------- num has stock
 select COUNT(EmployeeID) as has_stock from Employees
  where StockOptionLevel>0
End;
------------------------------------------------------------------------------------------------------------------------------------------------------


---------------------------------------------------------------------------------------------------------------------------- Q1: outliers
Begin;
---------------------------------------------------------------------manager_count
select count(EmployeeID) from Employees
where  JobRole like '%Manager%'
---------------------------------------------------------------------manager_count_outliers
select count(EmployeeID) from Employees
where Salary>=289769 and JobRole like '%Manager%'
---------------------------------------------------------------------The Manager with hight Salary
Select JobRole,HireDate,EducationLevel,StockOptionLevel,TravelFrequency from Employees
where Salary>=289769 and JobRole like '%Manager%'
order by JobRole,HireDate desc
--------------------------------------------------------- The employees with hight Salary 
Select JobRole,HireDate,EducationLevel,StockOptionLevel,TravelFrequency from Employees
where Salary>=289769 and JobRole Not like '%Manager%'
order by JobRole,HireDate desc
End;

-----------------------------------------------------------------------------------------------------------------------------analysis Questions
Begin;
------------------------------------------------------------------------------- Q5 :HR Executive in IL
select State,JobRole,Age,DistanceFromHome,EducationLevel,Salary,StockOptionLevel,OverTime,HireDate,YearsAtCompany from Employees 
where state='IL' and JobRole='HR Executive'
order by Attrition

Select*from Performance
where EmployeeID in ( select EmployeeID from Employees 
where state='IL' and JobRole='HR Executive')
order by EmployeeID
-------------------------------------------------------------------------------------------
------------------------------------------------------------------------------- Q5 :Recruiter in Ca
select State,JobRole,Age,DistanceFromHome,EducationLevel,Salary,StockOptionLevel,OverTime,HireDate,YearsAtCompany from Employees 
where state='CA' and JobRole='Recruiter'
order by Attrition

Select*from Performance
where EmployeeID in ( select EmployeeID from Employees 
where state='Ca' and JobRole='Recruiter')
order by EmployeeID
------------------------------------------------------------------------------------
------------------------------------------------------------------------------- Q5 :Recruiter in NY
select State,JobRole,Age,DistanceFromHome,EducationLevel,Salary,StockOptionLevel,OverTime,HireDate,YearsAtCompany from Employees 
where state='Ny' and JobRole='Recruiter'
order by Attrition

Select*from Performance
where EmployeeID in ( select EmployeeID from Employees 
where state='NY' and JobRole='Recruiter')
order by EmployeeID
-------------------------------------------------------------------------------------
------------------------------------------------------------------------------- Q5 :Sales Representative in NY
select State,JobRole,Age,DistanceFromHome,EducationLevel,Salary,StockOptionLevel,OverTime,HireDate,YearsAtCompany from Employees 
where state='Ny' and JobRole='Sales Representative'
order by Attrition

Select*from Performance
where EmployeeID in ( select EmployeeID from Employees 
where state='NY' and JobRole='Sales Representative')
order by EmployeeID
------------------------------------------------------------------------------- Q5 :Sales Representative in CA
select State,JobRole,Age,DistanceFromHome,EducationLevel,Salary,StockOptionLevel,OverTime,HireDate,YearsAtCompany from Employees 
where state='CA' and JobRole='Sales Representative'
order by Attrition

Select*from Performance
where EmployeeID in ( select EmployeeID from Employees 
where state='CA' and JobRole='Sales Representative')
order by EmployeeID
END;