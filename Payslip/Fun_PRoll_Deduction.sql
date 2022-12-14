USE  Powersoft_YASOTHA
GO
/****** Object:  UserDefinedFunction [dbo].[Fun_PRoll_Deduction]    Script Date: 21/12/2022 12:33:41 ******/
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
--- select *  from  Fun_PRoll_Deduction ('2022-11-30' )   order by empcode,sno


alter function [dbo].[Fun_PRoll_Deduction] (@Sdate as datetime )  returns Table

return    
(    


 
select a.EmpCode,b.EmpName as EmpName,'PFAmount' as Type ,a.PFAmount  as Amount ,1 as Sno
from   SalStoreTable  as a   
LEFT JOIN Emp_Master as b  ON B.EMPCODE=A.EMPCODE  
where a.sdate =@Sdate 
and a.PFAmount  <>0
and b.EmpName  <> 'NONE' and b.DOJ<@Sdate   
union all
select a.EmpCode,b.EmpName as EmpName,'ESIAmount' as Type   ,a.EmpESIAmount  as Amount  ,2 as Sno
from   SalStoreTable  as a   
LEFT JOIN Emp_Master as b  ON B.EMPCODE=A.EMPCODE  
where a.sdate =@Sdate
and EmpESIAmount <>0
and b.EmpName  <> 'NONE' and b.DOJ<@Sdate   

union all
select a.EmpCode,b.EmpName as EmpName,'Advance' as Type   ,a.Advance  as Amount   ,3 as Sno
from   SalStoreTable  as a   
LEFT JOIN Emp_Master as b  ON B.EMPCODE=A.EMPCODE  
where a.sdate =@Sdate
and Advance  <>0
and b.EmpName  <> 'NONE' and b.DOJ<@Sdate   


union all
select a.EmpCode,b.EmpName as EmpName,'BankLoan' as Type   ,a.BankLoan  as Amount   ,3 as Sno
from   SalStoreTable  as a   
LEFT JOIN Emp_Master as b  ON B.EMPCODE=A.EMPCODE  
where a.sdate =@Sdate
and BankLoan <>0
and b.EmpName  <> 'NONE' and b.DOJ<@Sdate   

union all
select a.EmpCode,b.EmpName as EmpName,'Canteen' as Type  ,a.Canteen  as Amount   ,4 as Sno
from   SalStoreTable  as a   
LEFT JOIN Emp_Master as b  ON B.EMPCODE=A.EMPCODE  
where a.sdate =@Sdate
and Canteen  <>0
and b.EmpName  <> 'NONE' and b.DOJ<@Sdate   
 
  

union all
select a.EmpCode,b.EmpName as EmpName,'Leave_Salary' as Type  ,a.Leave_Salary  as Amount   ,5 as Sno
from   SalStoreTable  as a   
LEFT JOIN Emp_Master as b  ON B.EMPCODE=A.EMPCODE  
where a.sdate =@Sdate
and Leave_Salary  <>0
and b.EmpName  <> 'NONE' and b.DOJ<@Sdate   
union all
select a.EmpCode,b.EmpName as EmpName,'Absent_Salary' as Type  ,a.Absent_Salary  as Amount   ,5 as Sno
from   SalStoreTable  as a   
LEFT JOIN Emp_Master as b  ON B.EMPCODE=A.EMPCODE  
where a.sdate =@Sdate
and Absent_Salary <>0
and b.EmpName  <> 'NONE' and b.DOJ<@Sdate   




union all
select a.EmpCode,b.EmpName as EmpName,'Late_Amout' as Type  ,a.Late_Amout  as Amount   ,5 as Sno
from   SalStoreTable  as a   
LEFT JOIN Emp_Master as b  ON B.EMPCODE=A.EMPCODE  
where a.sdate =@Sdate
and Late_Amout <>0
and b.EmpName  <> 'NONE' and b.DOJ<@Sdate   
union all
select a.EmpCode,b.EmpName as EmpName,'Early_Amout' as Type  ,a.Early_Amout  as Amount   ,5 as Sno
from   SalStoreTable  as a   
LEFT JOIN Emp_Master as b  ON B.EMPCODE=A.EMPCODE  
where a.sdate =@Sdate
and Early_Amout <>0
and b.EmpName  <> 'NONE' and b.DOJ<@Sdate   

union all
select a.EmpCode,b.EmpName as EmpName,'Permission_Amout' as Type  ,a.Permission_Amout  as Amount   ,5 as Sno
from   SalStoreTable  as a   
LEFT JOIN Emp_Master as b  ON B.EMPCODE=A.EMPCODE  
where a.sdate =@Sdate
and Permission_Amout <>0
and b.EmpName  <> 'NONE' and b.DOJ<@Sdate   
 



--GROUP BY a.CatCode,c.CatName ,Datename(month, SDATE),YEAR(SDATE),MONTH(SDATE)
--,b.Sex ,b.EmpName,a.EmpCode,b.resigndate,b.doj,d.deptname
--having  SUM(TotalEarnings )<>0
 )
