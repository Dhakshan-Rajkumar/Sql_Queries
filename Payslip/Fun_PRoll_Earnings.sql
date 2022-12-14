USE  Powersoft_YASOTHA
GO
/****** Object:  UserDefinedFunction [dbo].[Fun_PRoll_Earnings]    Script Date: 21/12/2022 12:33:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- ============================================================        
-- Author  : RAJKUMAR.K        
-- Create date : 03/11/2022        
-- Description : Get Employee Monthly Attendance Details       
-- =============================================================        
-- Grant Execute On sp_GetEmployeeMaster_Details To Public        
--- select *  from  Fun_PRoll_Earnings ('2022-11-30' )   


ALTER function [dbo].[Fun_PRoll_Earnings] (@Sdate as datetime )  returns Table

return    
(    

	 
select a.EmpCode,b.EmpName as EmpName,'Basic' as Type ,a.Basic as Wages ,a.AttnEarning  as Amount 
from   SalStoreTable  as a   
LEFT JOIN Emp_Master as b  ON B.EMPCODE=A.EMPCODE  
where a.sdate =@Sdate  
and a.Basic  <>0
and b.EmpName  <> 'NONE' and b.DOJ<@Sdate   
union all
select a.EmpCode,b.EmpName as EmpName,'Weekoff Salary' as Type ,0 as Wages ,a.Weekoff_Salary  as Amount 
from   SalStoreTable  as a   
LEFT JOIN Emp_Master as b  ON B.EMPCODE=A.EMPCODE  
where a.sdate =@Sdate 
and Weekoff_Salary <>0
and b.EmpName  <> 'NONE' and b.DOJ<@Sdate   

union all
select a.EmpCode,b.EmpName as EmpName,'NHFH' as Type ,0 as Wages ,NHFH_Salary  as Amount 
from   SalStoreTable  as a   
LEFT JOIN Emp_Master as b  ON B.EMPCODE=A.EMPCODE  
where a.sdate =@Sdate 
and NHFH_Salary  <>0
and b.EmpName  <> 'NONE' and b.DOJ<@Sdate   

union all
select a.EmpCode,b.EmpName as EmpName,'oVERTIME' as Type ,0 as Wages , OT_SALARY  as Amount 
from   SalStoreTable  as a   
LEFT JOIN Emp_Master as b  ON B.EMPCODE=A.EMPCODE  
where a.sdate =@Sdate 
and OT_SALARY <>0
and b.EmpName  <> 'NONE' and b.DOJ<@Sdate   

union all
select a.EmpCode,b.EmpName as EmpName,'INCENTIVE' as Type ,0 as Wages ,a.Monthly_inc  as Amount 
from   SalStoreTable  as a   
LEFT JOIN Emp_Master as b  ON B.EMPCODE=A.EMPCODE  
where a.sdate =@Sdate 
and Monthly_inc  <>0
and b.EmpName  <> 'NONE' and b.DOJ<@Sdate   
 

--GROUP BY a.CatCode,c.CatName ,Datename(month, SDATE),YEAR(SDATE),MONTH(SDATE)
--,b.Sex ,b.EmpName,a.EmpCode,b.resigndate,b.doj,d.deptname
--having  SUM(TotalEarnings )<>0
 )
