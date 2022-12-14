USE [DB_HRMS]
GO
/****** Object:  Table [dbo].[PFESISettings]    Script Date: 05-Jan-2023 17:24:31 ******/
DROP TABLE [dbo].[PFESISettings]
GO
/****** Object:  Table [dbo].[Category_Master]    Script Date: 05-Jan-2023 17:24:31 ******/
DROP TABLE [dbo].[Category_Master]
GO
/****** Object:  Table [dbo].[Category_Master]    Script Date: 05-Jan-2023 17:24:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Category_Master](
	[Comp_Code] [varchar](20) NOT NULL,
	[Location_Code] [varchar](20) NOT NULL,
	[CatCode] [bigint] NOT NULL,
	[CatName] [varchar](50) NOT NULL,
	[Cons_Wages] [nvarchar](500) NULL,
	[Basic_F] [nvarchar](500) NULL,
	[AttnEarning_F] [varchar](500) NOT NULL,
	[HRAAmount_F] [varchar](500) NULL,
	[Wash_amount_F] [varchar](500) NULL,
	[DAAmount_F] [varchar](500) NULL,
	[PaidDay_F] [varchar](500) NOT NULL,
	[Leave_F] [varchar](500) NOT NULL,
	[PFSource] [varchar](500) NOT NULL,
	[ESISource] [varchar](500) NOT NULL,
	[PF] [varchar](500) NOT NULL,
	[EPF] [varchar](500) NOT NULL,
	[EPS] [varchar](500) NOT NULL,
	[ESI] [varchar](500) NOT NULL,
	[EmpESI] [varchar](500) NOT NULL,
	[MDESI] [varchar](500) NOT NULL,
	[TotalEarning] [varchar](500) NOT NULL,
	[TotalDeduction] [varchar](500) NOT NULL,
	[OTWages] [varchar](500) NOT NULL,
	[RsPerDay] [varchar](500) NOT NULL,
	[EarnDay] [varchar](500) NOT NULL,
	[GrossAmount] [varchar](500) NOT NULL,
	[NetAmount] [varchar](500) NOT NULL,
	[SalDate] [int] NOT NULL,
	[SalaryDay] [varchar](500) NOT NULL,
	[SalaryType] [nvarchar](50) NULL,
	[IS_Active] [int] NULL,
	[Delete_Mode] [int] NULL,
	[Created_By] [varchar](15) NULL,
	[Created_Date] [datetime] NULL,
	[Modified_By] [varchar](15) NULL,
	[Modified_Date] [datetime] NULL,
 CONSTRAINT [PK_Category_Master] PRIMARY KEY CLUSTERED 
(
	[Comp_Code] ASC,
	[Location_Code] ASC,
	[CatCode] ASC,
	[CatName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PFESISettings]    Script Date: 05-Jan-2023 17:24:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PFESISettings](
	[Comp_Code] [varchar](50) NOT NULL,
	[Location_Code] [varchar](50) NOT NULL,
	[CompName] [varchar](50) NOT NULL,
	[Entry_No] [varchar](100) NOT NULL,
	[Entry_Date] [datetime] NULL,
	[PF] [float] NOT NULL,
	[EPF] [float] NOT NULL,
	[EPS] [float] NOT NULL,
	[ESI] [float] NOT NULL,
	[EmpESI] [float] NOT NULL,
	[MDESI] [float] NOT NULL,
	[PFMaxSalary] [float] NOT NULL,
	[ESIMinSalary] [float] NOT NULL,
	[ESIMaxSalary] [float] NOT NULL,
	[CompanyPfNoSerial] [varchar](50) NULL,
	[Fom6AAdminAmountPer] [float] NULL,
	[DLIEmployerSharePer] [float] NULL,
	[EPFAdminChargePer] [float] NULL,
	[DLIAdminChargePer] [float] NULL,
	[CompAdd1] [varchar](50) NULL,
	[CompAdd2] [varchar](50) NULL,
	[CompAdd3] [varchar](50) NULL,
	[Effect_from] [datetime] NULL,
	[Effect_To] [datetime] NULL,
	[IS_Active] [int] NULL,
	[Created_By] [varchar](15) NULL,
	[Created_Date] [datetime] NULL,
	[Modified_By] [varchar](15) NULL,
	[Modified_Date] [datetime] NULL,
 CONSTRAINT [PK_PFESISettings] PRIMARY KEY CLUSTERED 
(
	[Comp_Code] ASC,
	[Location_Code] ASC,
	[Entry_No] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
INSERT [dbo].[Category_Master] ([Comp_Code], [Location_Code], [CatCode], [CatName], [Cons_Wages], [Basic_F], [AttnEarning_F], [HRAAmount_F], [Wash_amount_F], [DAAmount_F], [PaidDay_F], [Leave_F], [PFSource], [ESISource], [PF], [EPF], [EPS], [ESI], [EmpESI], [MDESI], [TotalEarning], [TotalDeduction], [OTWages], [RsPerDay], [EarnDay], [GrossAmount], [NetAmount], [SalDate], [SalaryDay], [SalaryType], [IS_Active], [Delete_Mode], [Created_By], [Created_Date], [Modified_By], [Modified_Date]) VALUES (N'100', N'MAIN UNIT', 0, N'NONE', N'', N'', N'-', NULL, NULL, NULL, N'-', N'-', N'-', N'-', N'-', N'-', N'-', N'-', N'-', N'-', N'-', N'[PFAmount] + [EmpESIAmount] ', N'-', N'-', N'1', N'-', N'-', 0, N'-', N'Monthly', 0, 1, N'ADMIN', CAST(N'2020-11-24 00:00:00.000' AS DateTime), N'ADMIN', CAST(N'2020-11-24 00:00:00.000' AS DateTime))
GO
INSERT [dbo].[Category_Master] ([Comp_Code], [Location_Code], [CatCode], [CatName], [Cons_Wages], [Basic_F], [AttnEarning_F], [HRAAmount_F], [Wash_amount_F], [DAAmount_F], [PaidDay_F], [Leave_F], [PFSource], [ESISource], [PF], [EPF], [EPS], [ESI], [EmpESI], [MDESI], [TotalEarning], [TotalDeduction], [OTWages], [RsPerDay], [EarnDay], [GrossAmount], [NetAmount], [SalDate], [SalaryDay], [SalaryType], [IS_Active], [Delete_Mode], [Created_By], [Created_Date], [Modified_By], [Modified_Date]) VALUES (N'100', N'MAIN UNIT', 1, N'STAFF', N'', N'', N'Paid_Days*([Basic]/30)', N'round(((HRAAmount1 / [SalaryDay1]) *Paid_Days) ,2)', N'round(((WashAmount1 / [SalaryDay1]) *Paid_Days) ,2)', NULL, N'CASE WHEN Present>=ABSENT THEN   ([SalaryDay]-lop)   ELSE Present   END', N'(RSPERDAY * (NH+FH))', N'CASE WHEN Present>=ABSENT THEN  (([SalaryDay]-[Absent])*([Basic]/30)) ELSE ((Present+Weeklyoff+leave+[NH]+[FH] )*([Basic]/30)) END', N'ROUND([AttnEarning]+ATTNEARNROUND+HRAAMOUNT ,0)', N'[PFSource] * PF /100', N'[PFSOURCE] *  [EPf] / 100', N'[PFSOURCE] *  [EPS] / 100', N'[ESISOURCE] * [ESI] /100', N'case when (ESISource * EmpESI /100)-cast((ESISource * EmpESI/100) as bigint)>=0.01 then cast((ESISource * EmpESI/100) as bigint)+1 else cast((ESISource * 0.75/100) as bigint) end', N'[ESIAmount] - [EmpESIAmount]', N'[AttnEarning]  + [HRAAmount]+  WashAmount+DAAmount1', N'[PFAmount] + [EmpESIAmount] ', N'-', N'CASE WHEN [SalaryType]=''MONTHLY'' THEN ([Basic]+HRAAmount1)/SalaryDay  ELSE [Basic] END', N'CASE WHEN Present=0 THEN 0 ELSE    CASE WHEN Present +[Leave]>=ABSENT THEN  [SalaryDay]-[Absent] ELSE  Present+[Leave]+[NH]+[FH]+Weeklyoff  END  END', N'round(round(AttnEarning,0)+HRAAmount,2)', N'[TotalEarnings]-[TotalDeductions]', 1, N'30', N'Monthly', 1, 0, N'ADMIN', CAST(N'2020-04-02 00:00:00.000' AS DateTime), N'ADMIN', CAST(N'2020-04-02 00:00:00.000' AS DateTime))
GO
INSERT [dbo].[Category_Master] ([Comp_Code], [Location_Code], [CatCode], [CatName], [Cons_Wages], [Basic_F], [AttnEarning_F], [HRAAmount_F], [Wash_amount_F], [DAAmount_F], [PaidDay_F], [Leave_F], [PFSource], [ESISource], [PF], [EPF], [EPS], [ESI], [EmpESI], [MDESI], [TotalEarning], [TotalDeduction], [OTWages], [RsPerDay], [EarnDay], [GrossAmount], [NetAmount], [SalDate], [SalaryDay], [SalaryType], [IS_Active], [Delete_Mode], [Created_By], [Created_Date], [Modified_By], [Modified_Date]) VALUES (N'100', N'MAIN UNIT', 2, N'WORKMEN
', N'', N'', N'((( [RSPERDAY]* 70 / 100 )* ([PAID_DAYS]) ) -([LOPAMOUNT]*70/100))', N'round(((HRAAmount1 / [SalaryDay1]) *Paid_Days) ,2)', N'round(((WashAmount1 / [SalaryDay1]) *Paid_Days) ,2)', NULL, N'[PRESENT]+[NH]+[FH]', N'(RSPERDAY * (NH+FH))', N'ROUND([AttnEarning],0)', N'ROUND([AttnEarning]+ATTNEARNROUND+HRAAMOUNT ,0)', N'[PFSource] * PF /100', N'[PFSOURCE] *  [EPf] / 100', N'[PFSOURCE] *  [EPS] / 100', N'[ESISOURCE] * [ESI] /100', N'case when (ESISource * EmpESI /100)-cast((ESISource * EmpESI/100) as bigint)>=0.01 then cast((ESISource * EmpESI/100) as bigint)+1 else cast((ESISource * 0.75/100) as bigint) end', N'[ESIAmount] - [EmpESIAmount]', N'[AttnEarning] + [LeaveSalary] + [HRAAmount]  +Grossround ', N'[PFAmount] + [EmpESIAmount] ', N'-', N'([Basic]+HRAAmount1)  / [SalaryDay1]', N'[PRESENT]+NH+FH', N'round(round(AttnEarning,0)+HRAAmount,2)', N'[TotalEarnings]-[TotalDeductions]', 0, N'26', N'Daily', 1, 0, N'ADMIN', CAST(N'2020-11-24 00:00:00.000' AS DateTime), N'ADMIN', CAST(N'2020-11-24 00:00:00.000' AS DateTime))
GO
INSERT [dbo].[PFESISettings] ([Comp_Code], [Location_Code], [CompName], [Entry_No], [Entry_Date], [PF], [EPF], [EPS], [ESI], [EmpESI], [MDESI], [PFMaxSalary], [ESIMinSalary], [ESIMaxSalary], [CompanyPfNoSerial], [Fom6AAdminAmountPer], [DLIEmployerSharePer], [EPFAdminChargePer], [DLIAdminChargePer], [CompAdd1], [CompAdd2], [CompAdd3], [Effect_from], [Effect_To], [IS_Active], [Created_By], [Created_Date], [Modified_By], [Modified_Date]) VALUES (N'100', N'MAIN UNIT', N'GK TEX', N'1', CAST(N'2021-04-01 00:00:00.000' AS DateTime), 12, 3.67, 8.33, 4, 0.75, 3.25, 15000, 100, 21000, N'29293', 0.0378, 0.005, 0.011, 1.1, N'6&7 Nakeeran street', N'Otteri', N'Chennai', CAST(N'2021-04-01 00:00:00.000' AS DateTime), CAST(N'2022-04-30 00:00:00.000' AS DateTime), 1, N'ADMIN', CAST(N'2020-04-30 00:00:00.000' AS DateTime), N'ADMIN', CAST(N'2020-04-30 00:00:00.000' AS DateTime))
GO



----[PFAmount] + [EmpESIAmount]+ insurance+Advance +Canteen +fine,others