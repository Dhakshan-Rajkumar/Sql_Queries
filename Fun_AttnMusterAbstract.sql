USE [PowerERP_ACV]
GO
/****** Object:  UserDefinedFunction [dbo].[Fun_AttendancenAbstract]    Script Date: 16/12/2022 15:29:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- ============================================================        
-- Author  : RAJKUMAR.K        
-- Create date : 03/04/2017  
-- Modified date : 11/11/2022        
      
-- Description : Get Employee Monthly Attendance Details       
-- =============================================================        
-- Grant Execute On sp_GetEmployeeMaster_Details To Public        
--- select *  from [Fun_AttnMusterAbstract]  ('theni','2022-11-01','2022-11-30')     order by catname


create function [dbo].[Fun_AttnMusterAbstract] (@Location as varchar(20) ,@Fdate as datetime,@Tdate as datetime)  returns Table
 
return    
(  
 
 
 select    x.empid ,  x.empcode,x.FingerId, x.Empname,x.sex
 ,x.catname,x.Deptname,x.DesgnName 
   ,sum(Present) as Present
   ,sum(ABLV) as ABLV
   ,sum(woff) as woff
   ,sum(NHFH) as NHFH
   ,sum(Woff_Psent) as Woff_Psent
 
   --,sum(Woff_Present) as Woff_Psent
   --,SUM(Woff_nhfh) AS Woff_NHFH
   --,sum(Woff_HDAY) as Woff_HDAY
   ,x.WeeklyOff
   ,x.Months,x.years,x.DEPTCODE,x.doj
   ,X.CatCode
      ,conswages,wpday 
   
  from
  
   
   (
    
   select p.empid , p.empcode,p.FingerId ,p.Empname,p.catname,p.deptname,p.DesgnName ,p.sex
,case when  p.Status in ('x','/','/L','/CL','/PL','od','p')  then  sum(p.dayvalue) 
else 0
end as  Present
,case when   p. Status in ('A','/','L','/L','CL','PL','/CL','/PL')    then  sum(p.dayvalue)   
else 0 end as ABLV   
,case when   p. Status in ('W')    then  sum(p.dayvalue)   
else 0 end as woff 
,case when   p. Status in ('Wx')    then  sum(p.dayvalue)   
else 0 end as Woff_Psent   
,case when   p. Status in ('NH','FH','H')    then  sum(p.dayvalue)   
else 0 end as NHFH  
--,sum(p.Woff_Present) as Woff_Present  ,sum(Woff_HDAY ) as Woff_HDAY,SUM(Woff_nhfh) AS Woff_nhfh

,p.WeeklyOff,p.Months,p.years,p.DEPTCODE  ,p.doj,P.CatCode ,p.SHIFT 
,conswages,wpday 
 
from    (

select  a.Sdate
,left(datename(WEEKDAY,a.sdate),3) WkDay
 ,a.EmpCode,b.Empname ,b.sex
,c.catname,d.Deptname,e.DesgnName
,f.shift,f.ShiftCode,b.SGroup,a.status,g.statusname,a.dayvalue, day(a.sdate) day2, 
case when a.intime<>'1900-01-01 12:00:00' then CONVERT(varchar(15),CAST(a.INTIME  AS TIME),100) else '-' end  InTime,    
case when a.outtime<>'1900-01-01 12:00:00' then CONVERT(varchar(15),CAST(a.outtime  AS TIME),100) else '-' end OutTime  
 
  
 
,b.AttendanceStatus 

 ,b.empcodeid ,b.Empid ,b.FingerId 
,b.doj,b.ResignDate,b.WeeklyOff
,month(a.sdate) as Months,year(a.sdate) as years
,b.Deptcode  ,C.CatCode 
  ,b.conswages,b.wpday 
 

from Temp_MusterAttendance a
left  join Emp_Master b on b.EmpCode =a.EmpCode 
 left join category_master as c on c.CatCode  =b.CatCode 
left join Deptmaster as d on d.DeptCode =b.Deptcode  
left join designation as e on e.DesgnCode  =b.DesgnCode
left join shift_master as f on f.shiftid  =a.shiftid 
left join statusMaster as g on g.code  =a.Status 


  
where a.SDate between @Fdate and @Tdate      
--and b.Location_Code ='spinning'
 and b.EmpName  <> 'NONE'
and g.STATUSNAME<>'' 
 --and month( a.SDate)<>'4'
--or (ResignDate <>'1900-01-01' and  ResignDate > @fdate))  
 --AND (B.resigndate='1900-01-01' or (b.resigndate<>'1900-01-01' and b.ResignDate<=@Tdate) and a.SDate<=b.ResignDate)
  and ( b.ResignDate ='1900-01-01' or (b.ResignDate<>'1900-01-01'   and b.ResignDate >=@Fdate ))
  and b.DOJ<= @Tdate    
 
   
 ) p
 
 group by  p.empid , p.empcode,p.FingerId ,p.catname,p.DesgnName ,p.Status,p.Empname,p.sex,p.WeeklyOff,p.Months,p.years
 ,p.Deptname,p.deptcode   ,p.DOJ,P.CatCode ,p.SHIFT 
 ,conswages,wpday 
  ) x
group by   x.empid , x.empcode,x.FingerId ,x.catname,x.DesgnName ,x.Empname,x.sex,x.WeeklyOff,x.Deptname,x.deptcode
,  x.doj,X.CATCODE,x.years,x.Months,conswages,wpday 
--ORDER BY x.Deptname,x.empcode,x.years,x.Months

)
