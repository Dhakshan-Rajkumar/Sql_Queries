USE [Powersoft_NEMA]
GO
/****** Object:  UserDefinedFunction [dbo].[Fun_EmpMonthlyAttn]    Script Date: 09-Jan-2023 12:26:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ============================================================        
-- Author  : KRK       
-- Create date :15-11-2022
-- Modified date :15-11-2022   
-- Description : Get Employee Monthly Attendance Details       
-- =============================================================        
-- Grant Execute On sp_GetEmployeeMaster_Details To Public        
---  select *  from Fun_EmpMonthlyAttn ( '100','THENI' ,  '2022/12/03' , '2022/12/05')  order by resigndate


ALTER function [dbo].[Fun_EmpMonthlyAttn] (
@Comp_Code    Varchar(20),   
@Location_code    Varchar(20),  
@Fdate as datetime
,@Tdate as datetime)  returns Table
 
return    
(    
      
   
    
select  a.id,a.Sdate
  , datename(dw, a.sdate)  as WkDay
  ,   (datediff(ww,datediff(d,0,dateadd(m,datediff(m,7,SDate),0)    )/7*7,dateadd(d,-1,SDate))+1) as Week_No
--,left(datename(WEEKDAY,a.sdate),3) WkDay
 ,a.EmpCode,b.FingerId ,b.Empname ,b.sex
,c.catname,d.Deptname,e.DesgnName
,d.GroupName ,d.Sudeptgroup 
,c.catcode,d.Deptcode,e.Desgncode
,f.shiftID,f.shiftname
,f.shift,f.ShiftCode,b.SGroup,a.dayvalue, day(a.sdate) day2, 
case when a.intime<>'1900-01-01 12:00:00' then CONVERT(varchar(15),CAST(a.INTIME  AS TIME),100) else '-' end  InTime,    
case when a.outtime<>'1900-01-01 12:00:00' then CONVERT(varchar(15),CAST(a.outtime  AS TIME),100) else '-' end OutTime 


,case when a.intime<>'1900-01-01 12:00:00' then CONVERT(varchar(15),CAST(a.INTIME  AS TIME),108) else '-' end  RailInTime   
,case when a.intime<>'1900-01-01 12:00:00' then CONVERT(varchar(15),CAST(a.outtime  AS TIME),108) else '-' end  RailOutTime    
   
 , cast(cast(cast(   a.SDate    as date) as varchar(30))+' '+f.StartTime   as datetime)   as StartTime
 ,cast(cast(cast(   case when EndNxtDay=1 then dateadd(d,1,a.SDate)  else a.SDate end   as date) as varchar(30))+' '+f.EndTime  as datetime) as EndTime
  --,@fdate+ ' '+f.EndTime as EndTime   
  ,a.status,g.statusname,



  case when a.LaunchINTIME<>'1900-01-01 12:00:00' then CONVERT(varchar(15),CAST(a.LaunchINTIME  AS TIME),100) else '-' end  LaunchINTIME,    
case when a.LaunchOUTTIME<>'1900-01-01 12:00:00' then CONVERT(varchar(15),CAST(a.LaunchOUTTIME  AS TIME),100) else '-' end LaunchOUTTIME 

   ,LateMins,EarlyMins ,Total_mts ,Shift_mts ,OT_Mts ,Launch_mts 
    
,a.ETYPE
,f.PunchStartTo

  --,CONVERT(VARCHAR(8), GETDATE(), 108) 'hh:mi:ss'
,b.AttendanceStatus 

 ,b.empcodeid ,b.Empid  
,b.doj,b.ResignDate ,b.WeeklyOff
from TRANSAttendance a
left  join Emp_Master b on b.EmpCode =a.EmpCode  and b.Location_Code=a.Location_Code
 left join category_master as c on c.CatCode  =b.CatCode  and c.Location_Code=b.Location_Code
left join Deptmaster as d on d.DeptCode =b.Deptcode    and d.Location_Code=b.Location_Code
left join designation as e on e.DesgnCode  =b.DesgnCode  and e.Location_Code=b.Location_Code
left join shift_master as f on f.shiftid  =a.shiftid   and f.Location_Code=b.Location_Code
left join statusMaster as g on g.code  =a.Status   and g.Location_Code=b.Location_Code


  
where a.SDate between @Fdate and @Tdate    
 and b.EmpName  <> 'NONE'
and g.STATUSNAME<>'' 
 AND (B.resigndate='1900-01-01' or (b.resigndate<>'1900-01-01' ) and a.SDate<=b.ResignDate)
 and a.location_code=@location_code
  and b.DOJ<@Tdate 
  
 
 --and b.ResignDate<@Tdate
--and a.EmpCode =@empcode    
    
    

    
    
)













