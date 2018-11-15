USE [CSETWeb]
GO
/****** Object:  Table [dbo].[REPORT_OPTIONS]    Script Date: 11/14/2018 3:57:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[REPORT_OPTIONS](
	[Report_Option_Id] [int] NOT NULL,
	[Display_Name] [varchar](250) NOT NULL,
 CONSTRAINT [PK_REPORT_OPTIONS] PRIMARY KEY CLUSTERED 
(
	[Report_Option_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [dbo].[REPORT_OPTIONS] ([Report_Option_Id], [Display_Name]) VALUES (1, N'PrintPDF')
INSERT [dbo].[REPORT_OPTIONS] ([Report_Option_Id], [Display_Name]) VALUES (2, N'PrintDocX')
INSERT [dbo].[REPORT_OPTIONS] ([Report_Option_Id], [Display_Name]) VALUES (3, N'PrintDoc')
INSERT [dbo].[REPORT_OPTIONS] ([Report_Option_Id], [Display_Name]) VALUES (4, N'PrintExecutive')
INSERT [dbo].[REPORT_OPTIONS] ([Report_Option_Id], [Display_Name]) VALUES (5, N'PrintSummary')
INSERT [dbo].[REPORT_OPTIONS] ([Report_Option_Id], [Display_Name]) VALUES (6, N'PrintDetail')
INSERT [dbo].[REPORT_OPTIONS] ([Report_Option_Id], [Display_Name]) VALUES (7, N'PrintSecurityPlan')
EXEC sys.sp_addextendedproperty @name=N'BELONGS_IN_EA', @value=N'YES' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'REPORT_OPTIONS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'REPORT_OPTIONS'
GO
