USE  [DB_HRMS]
GO
/****** Object:  StoredProcedure [dbo].[SP_HRD_SalaryProcess]    Script Date: 23/12/2022 12:16:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--   [SP_HRD_SalaryProcess] '100','MAIN UNIT' ,'2022-11-30' ,'STAFF', '','admin'                         
                
            
alter proc [dbo].[SP_HRD_SalaryProcess] 
(
@Comp_Code					Varchar(25),
@Location_Code					Varchar(25),
@SDate  	Varchar(25),
@Cat_Name				Varchar(500),

@Is_Closed				Varchar(20),
@User_Code					Varchar(15)
)
as           
--declare @Sdate as datetime       
--set @sdate='2014-07-31'       
Declare @iServerDate	Varchar(19)
Set @iServerDate=(Select Convert(VARCHAR(19),getdate(),120))
DECLARE @FROMDATE AS DATETIME      
SET @FROMDATE=DATEADD(D,1,DATEADD(D,-1*DAY(@SDATE),@SDATE))      
PRINT @FROMDATE                               
DECLARE @FDATE AS DATETIME                 
DECLARE @TDATE AS DATETIME                 
SET @FDATE =DATEADD(DAY,1,DATEADD(DAY,-1*DAY(@SDATE),@SDate))                 
SET @TDATE =@Sdate                  
                 
truncate table Tmp_TransAttendance                                    
insert into Tmp_TransAttendance select * from transattendance where sdate between @Fdate and @Tdate    
                
             
delete from Tmp_TransAttendance where Id in( select id from Tmp_TransAttendance a
left join Emp_Master as b  on   b.EmpCode =a.EmpCode and b.Location_Code=a.Location_Code
where b.ResignDate <>'1900-01-01' and a.SDate>=b.ResignDate)                  
  
delete from Tmp_TransAttendance where Id in(select id from Tmp_TransAttendance a
left join Emp_Master as b  on   b.EmpCode =a.EmpCode and b.Location_Code=a.Location_Code
where B.DOJ>A.SDate )                  
        ---new
          
truncate table tmpSalProcess                                 
insert into tmpSalProcess                                 
SELECT @Comp_Code ,@Location_Code 
, Empcode,EmpId,a.CatCode,DeptCode,DesgnCode,@Sdate                                 
,0 AS PRESENT,0,0,0 AS WOFF,0,0,0,0,0,0 as FH
,0 AS LOP, 0 AS cl,0 AS TOTALDAYS,0 as Paid_Days,0 as PaidDays
,case when c.SalaryType ='Monthly' then (( ConsWages) *66.67/100) 
when  c.SalaryType ='Daily' then (( wpday*c.SalaryDay ) *66.67/100)   else 0 end  as BAsic,0

,case when c.SalaryType ='Monthly' then (( ConsWages) *22.22/100) 
when  c.SalaryType ='Daily' then 0   else 0 end  as HRAAmount1,0
,case when c.SalaryType ='Monthly' then (( ConsWages) *11.11/100) 
when  c.SalaryType ='Daily' then 0   else 0 end  as WashAmount1,0
 
 ,0,0 as DAAmount
,0,0,0,0 as RSPERDAY,0,0,0 as EPFAmount
,0,0,0,0,0 as TotalEarnings ,0 as TotalDeductions ,0 as NetAmount,0,0,0 as Advance
 
,c.salaryType
,0,0 as Factor_ID,0,0,0,0,0, 0 as MDESI ,0,0
,0 as MinESISalary,0,0,0,0 as EarnDay ,0,0,0 as SalaryDay1 
 ,WeeklyOff  as Weekoff_Day
 ,0,0
 ,0,0,0,0,0,0   as Petrol_alow
 ,0 as Tot_Ded,0 as Net_Salary,0 as By_Bank, 0 as By_Cash

FROM EMP_MASTER  as a 
left join category_master as c on  c.location_code=a.Location_Code  and  c.CatCode  =A.CatCode  
where a.location_code=@location_code and  a.Catcode in (select catcode from Category_Master
where     location_code=@location_code and CatName = @Cat_Name  
and (ResignDate ='1900-01-01'  OR (ResignDate<>'1900-01-01' AND  ResignReason<>'TRANSFER' AND ResignDate >=@FROMDATE))
and DOJ<=@TDATE )


                                
Update TmpSalProcess set SalaryDay=(Select SalaryDay from Category_Master a where location_code=@location_code and a.CatCode=TmpSalProcess.CatCode)                                 
--select * from tmpSalProcess      
                                 
declare @SalaryDay as float                                 
set @SalaryDay =DAY(@Sdate)                                 
print @SalaryDay                                 
Update TmpSalProcess set SalaryDay= @SalaryDay where SalaryDay=0        
update tmpSalProcess set SalaryDay1=SalaryDay        
  
update tmpSalProcess set SalaryDay = case when  DATEDIFF(d,@fromdate,b.resigndate)>SalaryDay then SalaryDay else  DATEDIFF(d,@fromdate,b.resigndate)+1 end  from TmpSalProcess  a,emp_master b where a.Empcode=b.EmpCode   
AND A.Empcode IN (Select Empcode FROM Emp_Master C WHERE  location_code=@location_code and C.ResignDate between @FROMDATE and @Sdate)  
  
update tmpSalProcess set SalaryDay = case when SalaryDay-DATEDIFF(d,@fromdate,b.doj)+1>SalaryDay then SalaryDay 
else  SalaryDay-DATEDIFF(d,@fromdate,b.doj) end from TmpSalProcess  a,emp_master b where a.Empcode=b.EmpCode  
AND A.Empcode IN (Select Empcode FROM Emp_Master C WHERE C.DOJ  between @FROMDATE and @Sdate)    





;WITH THEMONTH AS (SELECT DATEADD(day,1 - DAY(@Sdate) , @Sdate) AS x
UNION ALL
SELECT DATEADD(day,1, x) FROM THEMONTH WHERE MONTH(DATEADD(day,1, x)) = MONTH(x))
Update TmpSalProcess set No_Of_Woff=(select count(*) from THEMONTH  WHERE   DATENAME(weekday, x)  = Weekoff_Day )    
Update TmpSalProcess set DaysInMonth=(select DAY(EOMONTH(@Sdate)))
 
-----attendance end                                 
-----attendance Process Starts By Rajkumar                             
  
  
UPDATE    a     
SET  
--Present=(x.Present)  

Present=   (case when CatCode not in ('1','2','13') then 
case when a.DaysInMonth-4 >= (x.Present)   then x.Present else  a.DaysInMonth-4 end 
when (CatCode  in (13) and  x.Present>=23) then '23' 
when (CatCode  in (2) and  x.Present>=26) then '26' 
else x.Present end )
 --,Absent=   case when CatCode not in (1) then 
 --case when  x.Absent+x.Weeklyoff >=4   then x.Absent-4  else 0 end 
 --else x.Absent end 
 --,Weeklyoff=   case when CatCode not in (1) then 
 --case when  x.Absent+x.Weeklyoff >=4   then 4  else  x.Absent  end 
 --else x.Weeklyoff end 
 ,Absent=   (case when CatCode not in ('13','2') then 
case when  x.Absent+x.Weeklyoff >=4   then x.Absent-4  else 0 end 
when (CatCode  in (13) and  x.Present>=23) then 0
when (CatCode  in (2) and  x.Present>=26) then 0
else 0 end )
 ,Weeklyoff=    case when  x.Absent+x.Weeklyoff >=4   then 4  else  x.Absent  end 
,Leave=(x.Leave)  
,Lop=(x.Lop)  ,NH=(x.NH)  , FH=(x.FH)  
,cl=(x.cl)
,Weekoff_Present =x.weekoff_Present 
--,Extra_work=x.Extra_Duty
,Extra_work=   case when CatCode not in (1,2,13) then 
 case when a.DaysInMonth-4 >= x.Present  then 0 else  (x.Present+4)-a.DaysInMonth end 
  when (CatCode  in (13) and  x.Present>=23) then  x.Present- 23
  when (CatCode  in (2) and  x.Present>=23) then  x.Present- 26
 else 0 end 
,TotalDays= (x.Present)+ (x.Absent)+(x.Leave)+(x.Weeklyoff)+(x.Lop)+(x.NH)  +x.weekoff_Present  +x.Extra_Duty+x.cl
from tmpSalProcess as a  
INNER JOIN (  
select  b.EmpCode,  
Present=SUM(b.Present)  
,Absent=SUM(b.Absent),Leave=SUM(b.Leave) 
,Weeklyoff=SUM(b.Weeklyoff)
,weekoff_Present=sum(b.Weekoff_Present)
,Extra_Duty=sum(b.Extra_Duty)
,Lop=SUM(b.Lop),NH=SUM(b.NH), FH=SUM(b.FH)  
,cl=sum(b.CL)
  
,TotalDays= SUM(b.Present)+ SUM(b.Absent)+SUM(b.Leave) 
+SUM(b.Weeklyoff)+SUM(b.Lop)+SUM(b.NH)+ SUM(b. FH)  +sum(b.Weekoff_Present)+sum(b.Extra_Duty)+sum(b.cl)
 FROM   
(  
select t.EmpCode,t.status  
,Present= CASE WHEN t.status in ('X','OD','P','/A', '/L','/')  
THEN   ISNULL (sum(Dayvalue),0)       ELSE 0   END   
,Absent= CASE WHEN t.status in ('A','FHA','NHA','HA','/A','/')  
THEN   ISNULL (sum(Dayvalue),0)       ELSE 0   END   
,Leave= CASE WHEN t.status in ('L','/L')  THEN ISNULL (sum(Dayvalue),0) ELSE 0   END   
 
,Weeklyoff=CASE WHEN t.status in ('W','w','Wx/')   THEN   ISNULL (sum(Dayvalue),0) ELSE 0   END   
,Weekoff_Present=CASE WHEN t.status in ('Wx','Wx/')   THEN   ISNULL (sum(Dayvalue),0) ELSE 0   END   
,Extra_Duty=CASE WHEN t.status in ('XD')   THEN   ISNULL (sum(Dayvalue),0) ELSE 0   END   
,Lop=CASE WHEN t.status in ('LOP')    THEN   ISNULL (sum(Dayvalue),0) ELSE 0   END   
,NH=CASE WHEN t.status in ('NH')    THEN   ISNULL (sum(Dayvalue),0) ELSE 0   END   
,FH=CASE WHEN t.status in ('FH')    THEN   ISNULL (sum(Dayvalue),0) ELSE 0   END   
,CL= CASE WHEN t.status in ('CL')  THEN ISNULL (sum(Dayvalue),0) ELSE 0   END   

 from  Tmp_TransAttendance  AS t  
where  
location_code=@location_code and
month (t.sdate) = month(@SDate) and year(t.sdate) = year(@SDate)  
group by t.Status ,t.EmpCode )b  
group by  b.EmpCode     )x      on x.EmpCode =a.Empcode   


declare @Present as float      
declare @Weekoff_Present as float                                 
declare @No_Of_Woff as float       
declare @DaysInMonth as float    
 

-------''HRA AMount1               		                
--exec('Update tmpSalProcess set HRAAmount1  =  isnull((select ISNULL((ConsWages)*10/100,0) from Emp_Master a
--where  a.location_code='''+@location_code +'''  
--AND a.Empcode=tmpSalProcess.Empcode  AND a.location_code=tmpSalProcess.location_code  ),0)') 

--exec('Update tmpSalProcess set WashAmount1  =  isnull((select ISNULL((ConsWages)*11/100,0) from Emp_Master a
--where  a.location_code='''+@location_code +'''  
--AND a.Empcode=tmpSalProcess.Empcode  AND a.location_code=tmpSalProcess.location_code  ),0)') 
                
				           
Update tmpSalProcess set Factor_ID=isnull((select Entry_No from PFESISettings where location_code=@location_code and IS_Active='1' ),0)   
UPDATE  tmpSalProcess  SET
PF =isnull((b.PF) ,0)
,EPF=isnull((b.EPF ),0)
,EPS=isnull((b.EPS ),0)
,ESI=isnull((b.ESI ),0)
,EmpESI=isnull((b.EmpESI ),0)
,MDESI=isnull((b.MDESI ),0)
,MaxPFSalary=isnull((b.PFMaxSalary ),0)
,MaxESISalary=isnull((b.ESIMaxSalary ),0)
,MinESISalary=isnull((b.ESIMinSalary ),0)
FROM tmpSalProcess  AS a
INNER JOIN  PFESISettings  AS B
ON a.Factor_ID  = B.Entry_No and b.IS_Active='1'  and a.location_code  =B.location_code  
where  a.location_code =@location_code and IS_Active='1'             
                                 
                          
declare cat cursor for                               
Select CatCode,PaidDay_F,EarnDay, AttnEarning_F,HRAAmount_F,Wash_amount_F,DAAmount_F,PaidDay_F,Leave_F
,GrossAmount
, PFSource, ESISource, PF, EPF, EPS, ESI, EmpESI, MDESI
, TotalEarning,TotalDeduction, NetAmount, RsPerDay   from Category_Master                        
where   location_code=@location_code and catname = @Cat_Name             
declare @CatCode as bigint                                 
declare @PaidDayF as varchar(500), @EarnDayF as varchar(500),@AttnEarning_F as varchar(500)
,@HRAAmount_F as varchar(500),@Wash_amount_F as varchar(500),@DAAmount_F as varchar(500),@PaidDay_F as varchar(500),@Leave_F as varchar(500)
,@GrossAmountF as varchar(500), @PFSourceF as varchar(500), @ESISourceF as varchar(500)               
declare @PFF as varchar(500), @EPFF as varchar(500), @EPSF as varchar(500), @ESIF as varchar(500), @EmpESIF as varchar(500)
, @MDESIF as varchar(500)                                 
declare @TotalEarningF as varchar(500), @TotalDeductionF as varchar(500), @NetAmountF as varchar(500), @RsPerDayF as varchar(500)    
 ,@LOPDayF as varchar(500)  ,@lOP_AmountF as varchar(500)      
 ,@HRA_AmountF as varchar(500)                    
open Cat                    
fetch cat into @CatCode,@PaidDayF,@EarnDayF
 
 ,@AttnEarning_F,@HRAAmount_F,@Wash_amount_F,@DAAmount_F,@PaidDay_F,@Leave_F
,@GrossAmountF, @PFSourceF, @ESISourceF, @PFF, @EPFF, @EPSF, @ESIF, @EmpESIF, @MDESIF, @TotalEarningF, @TotalDeductionF, @NetAmountF, @RsPerDayF    

 


--SELECT @CatCode,@PaidDayF,@EarnDayF, @AttnEarningF,@GrossAmountF,@LeaveEarningF, @PFSourceF, @ESISourceF, @PFF, @EPFF, @EPSF, @ESIF, @EmpESIF, @MDESIF, @TotalEarningF, @TotalDeductionF, @NetAmountF, @RsPerDayF   ,@LOPDayF,@lOP_AmountF   ,@HRA_AmountF   
  
       
declare @r as bigint  
set @r=1  
while @@fetch_status=0                                 
begin                                 
print 'rows '+cast(@r as varchar);    


--LOPDay                           
if @LOPDayF<>'-'       
begin                  
   
SELECT @LOPDayF             
exec('Update tmpSalProcess Set  LOP =round('+@LOPDayF+',2) where CatCode='+@CatCode+'')                                            
end   
                        
--PaidDay                           
if @PaidDayF<>'-'       
begin                  
   
SELECT @PaidDayF             
exec('Update tmpSalProcess Set  Paid_Days =round('+@PaidDayF+',2) where CatCode='+@CatCode+'')                                            
end   
                            
 ---EarnDay
if @EarnDayF<>'-'       
begin        
exec('Update tmpSalProcess Set EarnDay=round('+@EarnDayF+',2) where CatCode='+@CatCode+'')                          
end               
 
        
 --------------------HRA Amount  Entry End ----------------------------------

                   
--RsPerDay                                 
if @RsPerDayF<>'-'                                 
begin                                 
exec('Update tmpSalProcess Set RsPerDay= round('+@RsPerDayF+',2) where CatCode='+@CatCode+'')   
update tmpSalProcess set SalaryDay =DATEDIFF(d,@fromdate,b.resigndate)-Absent  from TmpSalProcess  a
left join emp_master as  b on a.Empcode=b.EmpCode  and b.Location_Code =a.location_code
where a.location_code=@location_code and   b.ResignDate between @FROMDATE and @Sdate AND A.CatCode =@CatCode                       
end                                 
                          
--select @AttnEarningF             
--AttnEarning                                 
if @AttnEarning_F<>'-'                       
begin                                 
exec('Update tmpSalProcess Set AttnEarning=round('+@AttnEarning_F+',2) where CatCode='+@CatCode+' AND Present>0')      
exec('Update tmpSalProcess Set AttnEarnRound=round(round(round(AttnEarning+LeaveSalary,2),0)-round(AttnEarning+LeaveSalary,2),2) where CatCode='+@CatCode+'')      
exec('update tmpSalprocess set AttnEarning=AttnEarning+AttnEarnRound where Catcode='+@catcode+' ')  
end       
   
   --AttnEarning                                 
if @HRA_AmountF<>'-'                       
begin                                 
exec('Update tmpSalProcess Set HRAAmount=round('+@HRA_AmountF+',2) where CatCode='+@CatCode+' AND Present>0')      
 end 
 if @Wash_amount_F<>'-'                       
begin                                 
exec('Update tmpSalProcess Set washamount=round('+@Wash_amount_F+',2) where CatCode='+@CatCode+' AND Present>0')      
 end 

 
------grossamount  
--SELECT @CatCode,@AttnEarningF
if @GrossAmountF<>'-'                       
begin                                 
exec('Update tmpSalProcess Set GrossAmount=round('+@GrossAmountF+',2) where CatCode='+@CatCode+'')                                 
exec('Update tmpSalProcess Set GrossRound=round(GrossAmount,0)-GrossAmount where CatCode='+@CatCode+'')                 
  exec('update tmpSalprocess set GrossAmount=GrossAmount+GrossRound where Catcode='+@catcode+'')     
    
end       
                                 
--TotalEarnign                   
if @TotalEarningF<>'-'                                 
begin                                 
exec('Update tmpSalProcess Set TotalEarnings=round('+@TotalEarningF+',2) where CatCode='+@CatCode+'')                                 
exec('Update tmpSalProcess Set EarnRound=Round(ROUND(TotalEarnings,0)-round('+@TotalEarningF+',2),2) where CatCode='+@CatCode+'')               
exec('Update tmpSalProcess Set TotalEarnings=TotalEarnings+EarnRound where CatCode='+@CatCode+'')                                 
end                  
      
                                 
----PFSource 
--if @PFSourceF<>'-'  
--begin   
--exec('Update tmpSalProcess Set PFSource=round('+@PFSourceF+',2) where CatCode='+@CatCode+'') 
--end   
 
--UPDATE TmpSalProcess set PFSource =MaxPFSalary where PFSource>MaxPFSalary   
   
----ESISource   
--if @ESISourceF<>'-'  
--begin   
--exec('Update tmpSalProcess Set ESISource=round('+@ESISourceF+',2) where CatCode='+@CatCode+'') 
--end                        
      
                        
--UPDATE TmpSalProcess set ESISource =MaxESISalary where ESISource > MaxESISalary              
     
----PF 
----SELECT @PFF, @EPSF , @EPFF 
--if @PFF<>'-' 
--begin 
--exec('Update tmpSalProcess Set PFAmount=round('+@PFF+',0) where CatCode='+@CatCode+' and Empcode in (Select Empcode from emp_master where location_code='''+@location_code +''' and ISPF=''TRUE'' )') 
--end 
----EPS 
--if @EPSF<>'-' 
--begin 
--exec('Update tmpSalProcess Set EPSAmount=round('+@EPSF+',0) where CatCode='+@CatCode+' and Empcode in (Select Empcode from emp_master where location_code='''+@location_code +''' and ISPF=''TRUE'')') 
--end                             
----EPF                                 
--if @EPFF<>'-'                         
--begin                                 
--exec('Update tmpSalProcess Set EPFAmount=round('+@EPFF+',0) where CatCode='+@CatCode+'  and Empcode in (Select Empcode from emp_master where location_code='''+@location_code +'''  and  ISPF=''TRUE'')')                        
--end                                 
----ESI                                 
--if @ESIF<>'-'                            
--begin         
   
--exec('Update tmpSalProcess Set ESIAmount=   CASE WHEN '+@TotalEarningF+' > MaxESISalary      THEN ''0''  ELSE round('+@ESIF+',0)  END      where CatCode='+@CatCode+'  and Empcode in (Select Empcode from emp_master where location_code ='''+@location_code 
--+  '''  and  ISESI=''TRUE'')')                   
--end                                 

----EmpESIF                       
--if @EmpESIF<>'-'                            
--begin                                 
                                
--exec('Update tmpSalProcess Set EmpESIAmount=   CASE WHEN '+@TotalEarningF+' > MaxESISalary      THEN ''0''  ELSE round('+@EmpESIF+',0)  END      where CatCode='+@CatCode+'  and Empcode in (Select Empcode from emp_master
-- where location_code ='''+@location_code +'''  and  ISESI=''TRUE'')')                   
--end                               
----MDESI                                 
--if @MDESIF<>'-'                           
--begin     
--exec('Update tmpSalProcess Set MDESIAmount=   CASE WHEN '+@TotalEarningF+' > MaxESISalary      THEN ''0''  ELSE round('+@MDESIF+',0)  END      where CatCode='+@CatCode+'  and Empcode in (Select Empcode from emp_master
-- where location_code ='''+@location_code +'''  and  ISESI=''TRUE'')')                   
--end 
                    
--TotalDeduction                                 
if @TotalDeductionF<>'-'                                 
begin       
exec('Update tmpSalProcess Set TotalDeductions=round('+@TotalDeductionF+',2) where CatCode='+@CatCode+'')          
end                                 
				--NetAmount                                 
if @NetAmountF<>'-'                                 
begin  
exec('Update tmpSalProcess Set NetAmount=round('+@NetAmountF+',0) where CatCode='+@CatCode+'')                      
end                                 
                                
                                 
fetch cat into @CatCode,@PaidDayF,@EarnDayF, @AttnEarning_F,@HRAAmount_F,@Wash_amount_F,@DAAmount_F,@PaidDay_F,@Leave_F
,@GrossAmountF, @Leave_F, @PFSourceF, @ESISourceF, @PFF, @EPFF, @EPSF, @ESIF, @EmpESIF, @MDESIF, @TotalEarningF, @TotalDeductionF, @NetAmountF, @RsPerDayF        
set @r=@r+1   
      
end                                 
Close Cat                                 
deallocate Cat                                 
--Update Formulas End                                 
                              
delete from SalStoreTable where location_code=@location_code and  sdate=@Sdate and CatCode in (Select CatCode from Category_Master where location_code=@location_code and  CatName = @Cat_Name)                 
insert into SalStoreTable  
select  
@Comp_Code ,@Location_Code ,
Empcode,EmpID,CatCode,DeptCode,DesignCode,SDate
,Present,Absent,Leave,WeeklyOff,Weekoff_Present,Weekoff_Paid
,Extra_work,Extra_work_paid,NH,FH,LOP,CL,TotalDays,Paid_Days
,Basic,AttnEarning,HRAAmount1,HRAAmount
,PFSource,ESISource,LeaveSalary,RsPerDay,LOPAmount
,PFAmount,EPFAmount,EPSAmount,ESIAmount,EmpESIAmount,MDESIAmount
,TotalEarnings,TotalDeductions,NetAmount
,Canteen,BankLoan,Advance
,SalaryType,SalaryDay
,Factor_ID,PF,EPF,EPS,ESI,EmpESI,MDESI,MaxPFSalary,MaxESISalary,MinESISalary
,DedRound,EarnRound,AttnEarnRound
,EarnDay,GrossAmount,GrossRound
,SalaryDay1,Weekoff_Day,No_Of_Woff,DaysInMonth
,OT_Hours,OT_SALARY
,Nightshft_ALW,Monthly_inc,Holiday_wages,Petrol_alow
,Tot_Ded,Net_Salary,By_Bank,By_Cash
,@Is_Closed

,  @User_Code,@iServerDate,@User_Code,@iServerDate
From tmpSalProcess                   
                                
select * from SalStoreTable where sdate=@Sdate     and CatCode =@CatCode   

select * From tmpSalProcess   where sdate=@Sdate     and CatCode =@CatCode   



