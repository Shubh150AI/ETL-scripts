
USE SkoolDB

SELECT Date FROM dbo.root_date

--Converting the datatype of the [Date] column of dbo.root_date table in DATE from String 

--CREATE TABLE dbo.Date_table (
--          Date DATE
--);

--INSERT INTO dbo.Date_table (Date )
--SELECT CONVERT(DATE, Date, 103) AS Date_column
--FROM dbo.root_date;


SELECT * from dbo.Date_table  
;



WITH DATEDIM 
AS
(
SELECT 
 Date,
 CAST(CONVERT(VARCHAR, Date, 112) AS INT)                                       AS DateKey ,
 DAY(Date)                                                                      AS Day ,
 MONTH(Date)                                                                    AS Month ,
 YEAR(Date)                                                                     AS Year ,

 CASE   WHEN MONTH(Date) in (1,2,3)       THEN 1
        WHEN MONTH(Date) in (4,5,6)       THEN 2
        WHEN MONTH(Date) in (7,8,9)       THEN 3
        WHEN MONTH(Date) in (10,11,12)    THEN 4

        END                                                                     AS Quarter ,
 

  ROW_NUMBER() OVER 
  (PARTITION BY YEAR([Date]) 
  ORDER BY MONTH([Date]) ASC)                                                   AS Dayofyear ,
          
  CEILING(DAY([Date]) / 7.0)                                                    AS Weekofmonth,

  CEILING(ROW_NUMBER() OVER 
  (PARTITION BY YEAR([Date]) 
  ORDER BY MONTH([Date]) ASC) / 7.0)                                            AS WeekofYear,
                                                                                                                                                          
  'FY' + '-' + Cast(YEAR(Date) as nvarchar)                                     AS Fiscalyear 

  

  
 
  
FROM dbo.Date_table 
 
),

DATEDIMOPERATION AS(

SELECT 

   DateKey,
   Day,
   Month,
   Year,
   Quarter,
   Dayofyear,
   Weekofmonth,
   WeekofYear,
   Fiscalyear,
   
   ROW_NUMBER() OVER (PARTITION BY WeekofYear 
     ORDER BY Date ASC)                                                                AS Dayofweek,

   CAST(year as nvarchar)+' '+'Q'+ CAST(Quarter as nvarchar)                           AS Quarterofyear,

   ROW_NUMBER() OVER (PARTITION BY 
   CAST(year as nvarchar)+' '+'Q'+ CAST(Quarter as nvarchar) 
   ORDER BY MONTH([Date]) ASC)                                                         AS Dayofquarter,

   'FY' + '-' + (Cast(Year as nvarchar) + '-' + 'Q' + Cast([Quarter] as nvarchar))     AS Fiscalquarter,

   CAST(Month as varchar) +'-'+ 'FY'+'-'+ CAST(Year as varchar)                        AS Fiscalmonth ,
   CAST(Weekofmonth as varchar) +'-'+ 'FY'+ CAST(Year as varchar)                      AS Fiscalweekmonth,
   CAST(CEILING(Dayofyear / 7.0) as varchar) +'-'+ 'FY'+'-'+ CAST(Year as varchar)     AS Fiscalweekyear 


FROM DATEDIM

)

SELECT   

  DateKey                                                                             AS Date_key,
  Day ,
  Month ,                                          
  Year,
  Month                                                                               AS Day_of_month ,
  Quarterofyear                                                                       AS Quarter_of_year ,
  Dayofquarter                                                                        AS Day_of_quarter,
  Dayofweek                                                                           AS Day_of_week,
  Dayofyear                                                                           AS Day_of_year,    
  WeekofYear                                                                          AS Week_of_Year,
  Weekofmonth                                                                         AS Week_of_month ,
  Fiscalyear                                                                          AS Fiscalyear,
  Fiscalquarter                                                                       AS Fiscal_quarter,
  Fiscalmonth                                                                         AS Fiscal_month ,
  Fiscalweekmonth                                                                     AS Fiscal_week_month,
  Fiscalweekyear                                                                      AS Fiscal_week_year ,
   
  CASE
                WHEN [Dayofweek] in (1, 7)
                THEN 'Weekend'
                ELSE 'Weekday'
                END                                                                   AS WeekdayStatus

FROM DATEDIMOPERATION

ORDER BY Year,Month



-- LOAD INTO THE slv.Date table 





