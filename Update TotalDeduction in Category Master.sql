/****** Script for SelectTopNRows command from SSMS  ******/
SELECT  *
  FROM [Powersoft_YASOTHA].[dbo].[Category_Master]


update [Powersoft_YASOTHA].[dbo].[Category_Master]
set
TotalDeduction= '[PFAmount]+[EmpESIAmount]+[Canteen]+[BankLoan]+[Advance]+Late_Amout+Permission_Amout'
where catcode not in ('0')