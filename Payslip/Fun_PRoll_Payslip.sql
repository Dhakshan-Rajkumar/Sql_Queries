USE Powersoft_YASOTHA
GO
/****** Object:  UserDefinedFunction [dbo].[Fun_PRoll_Payslip]    Script Date: 21/12/2022 12:21:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- ============================================================        
-- Author  : RAJKUMAR.K        
-- Create date : 03/04/2017        
-- Description : Get Employee Monthly Attendance Details       
-- =============================================================        
-- Grant Execute On sp_GetEmployeeMaster_Details To Public        
--- select *  from  Fun_PRoll_Payslip ('2022-11-30' )   


alter function [dbo].[Fun_PRoll_Payslip] (@Sdate as datetime )  returns Table

return    
(    


 
 SELECT                         
SDate,A.EmpCode,b.FingerId, EmpName ,FatherName                       
ESINo ,UanNo ,PFNo ,C.CatName,Deptname, DesgnName                        
DOJ, DOB, Sex     
,b.AcNo 
,a.Present,a.Absent,a.Leave ,a.WeeklyOff    +Weekoff_Present as    WeeklyOff                 
,a.NH +a.FH as NHFH ,a.TotalDays,a.PaidDays     
,a.TotalEarnings ,a.TotalDeductions 
,a.GrossAmount ,a.NetAmount 
,b.PHOTO  as Ph
 ,  PHOTO as PHOTO

from SalStoreTable  as a                      
LEFT JOIN Emp_Master as b  ON B.EMPCODE=A.EMPCODE  
left join category_master as c on c.CatCode  =A.CatCode   
left join Deptmaster as d on d.DeptCode =b.Deptcode    
left join designation as e on e.DesgnCode  =b.DesgnCode                      
                      
where   a.sdate =@Sdate
 
 
and b.EmpName  <> 'NONE' and b.DOJ<@Sdate   


--GROUP BY a.CatCode,c.CatName ,Datename(month, SDATE),YEAR(SDATE),MONTH(SDATE)
--,b.Sex ,b.EmpName,a.EmpCode,b.resigndate,b.doj,d.deptname
--having  SUM(TotalEarnings )<>0
 )
