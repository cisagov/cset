USE [CSETWeb]
GO
/****** Object:  Table [dbo].[REPORT_DETAIL_SECTIONS]    Script Date: 11/14/2018 3:57:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[REPORT_DETAIL_SECTIONS](
	[Report_Section_Id] [int] NOT NULL,
	[Display_Name] [varchar](250) NOT NULL,
	[Display_Order] [int] NOT NULL,
	[Report_Order] [int] NOT NULL,
	[Tool_Tip] [varchar](500) NULL,
 CONSTRAINT [PK_REPORT_DETAIL_SECTIONS] PRIMARY KEY CLUSTERED 
(
	[Report_Section_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [dbo].[REPORT_DETAIL_SECTIONS] ([Report_Section_Id], [Display_Name], [Display_Order], [Report_Order], [Tool_Tip]) VALUES (1, N'Site Information', 1, 1, N'The information entered under the Information tab.')
INSERT [dbo].[REPORT_DETAIL_SECTIONS] ([Report_Section_Id], [Display_Name], [Display_Order], [Report_Order], [Tool_Tip]) VALUES (2, N'Executive Summary', 2, 2, N'The text contained in the Executive Summary field.')
INSERT [dbo].[REPORT_DETAIL_SECTIONS] ([Report_Section_Id], [Display_Name], [Display_Order], [Report_Order], [Tool_Tip]) VALUES (3, N'Document Library', 3, 14, N'The list of the user added documents contained in the Document Library.')
INSERT [dbo].[REPORT_DETAIL_SECTIONS] ([Report_Section_Id], [Display_Name], [Display_Order], [Report_Order], [Tool_Tip]) VALUES (4, N'Evaluation of Selected Standards', 4, 3, N'Charts showing the combined breakout of answers for the selected standards and the overall scoring in each question category for the selected standards.')
INSERT [dbo].[REPORT_DETAIL_SECTIONS] ([Report_Section_Id], [Display_Name], [Display_Order], [Report_Order], [Tool_Tip]) VALUES (5, N'Standards Compliance', 5, 4, N'A chart giving the percent of positive answers (either marked as a Yes or Alternative) as compared with the total number of questions in each category.')
INSERT [dbo].[REPORT_DETAIL_SECTIONS] ([Report_Section_Id], [Display_Name], [Display_Order], [Report_Order], [Tool_Tip]) VALUES (6, N'Network Diagram', 6, 5, N'A scaled copy of the user created diagram of the network under assessment.')
INSERT [dbo].[REPORT_DETAIL_SECTIONS] ([Report_Section_Id], [Display_Name], [Display_Order], [Report_Order], [Tool_Tip]) VALUES (7, N'Analysis of Network Components', 7, 6, N'This section contains a chart of the answers provided for component questions in a pie chart format labeled Combined Component Summary, the number of network warnings found on the diagram, and a bar chart of component answers by component type.')
INSERT [dbo].[REPORT_DETAIL_SECTIONS] ([Report_Section_Id], [Display_Name], [Display_Order], [Report_Order], [Tool_Tip]) VALUES (8, N'Component Compliance', 8, 7, N'A chart showing the percentage of combined questions that were positively answered in each subject area or category related to network components.')
INSERT [dbo].[REPORT_DETAIL_SECTIONS] ([Report_Section_Id], [Display_Name], [Display_Order], [Report_Order], [Tool_Tip]) VALUES (9, N'Findings & Recommendations', 9, 8, N'A basic evaluation of network architectural settings with warnings of any identified weaknesses.  This is the text from the red numbered circles on the network diagram.')
INSERT [dbo].[REPORT_DETAIL_SECTIONS] ([Report_Section_Id], [Display_Name], [Display_Order], [Report_Order], [Tool_Tip]) VALUES (10, N'Security Assurance Level', 10, 9, N'The security assurance level is the level of rigor (low, moderate, high, very high) you determined based on the organizations risk tolerance and determined risk. ')
INSERT [dbo].[REPORT_DETAIL_SECTIONS] ([Report_Section_Id], [Display_Name], [Display_Order], [Report_Order], [Tool_Tip]) VALUES (11, N'Ranked Subject Areas', 15, 15, N'A chart showing the categories or subject areas that need the most attention organized with the worst areas at the top.')
INSERT [dbo].[REPORT_DETAIL_SECTIONS] ([Report_Section_Id], [Display_Name], [Display_Order], [Report_Order], [Tool_Tip]) VALUES (12, N'Summary of Ranked Questions', 16, 16, N'A list of the questions that were missed (answered No or skipped) in ranked order with the most critical questions at the top.')
INSERT [dbo].[REPORT_DETAIL_SECTIONS] ([Report_Section_Id], [Display_Name], [Display_Order], [Report_Order], [Tool_Tip]) VALUES (13, N'Questions Marked For Review', 19, 19, N'The list of questions that had the Marked for Review box checked by the user in the Question Detail panel.')
INSERT [dbo].[REPORT_DETAIL_SECTIONS] ([Report_Section_Id], [Display_Name], [Display_Order], [Report_Order], [Tool_Tip]) VALUES (14, N'Alternate Justification Comments', 20, 20, N'The list of questions that were answered “Alt” by the user and given alternate justification text.')
INSERT [dbo].[REPORT_DETAIL_SECTIONS] ([Report_Section_Id], [Display_Name], [Display_Order], [Report_Order], [Tool_Tip]) VALUES (15, N'Cybersecurity Framework Tiers', 14, 13, N'The Framework Implementation Tier levels as determined under the Standards tab.')
INSERT [dbo].[REPORT_DETAIL_SECTIONS] ([Report_Section_Id], [Display_Name], [Display_Order], [Report_Order], [Tool_Tip]) VALUES (16, N'DoD 8500.2 Security Assurance Level', 13, 12, N'The DoD Confidentiality and MAC levels as determined on the SAL screen.')
INSERT [dbo].[REPORT_DETAIL_SECTIONS] ([Report_Section_Id], [Display_Name], [Display_Order], [Report_Order], [Tool_Tip]) VALUES (17, N'FIPS 199 Security Assurance Level Guidance', 12, 11, N'The CNSSI Confidentiality, Integrity, and Availability levels as determined on the SAL screen.')
INSERT [dbo].[REPORT_DETAIL_SECTIONS] ([Report_Section_Id], [Display_Name], [Display_Order], [Report_Order], [Tool_Tip]) VALUES (18, N'Calculated General Security Assurance Levels', 11, 10, N'The general SAL as determined under the SAL tab, is based on your consideration of internal and external risks to the public, environmental, and economic impacts. ')
INSERT [dbo].[REPORT_DETAIL_SECTIONS] ([Report_Section_Id], [Display_Name], [Display_Order], [Report_Order], [Tool_Tip]) VALUES (19, N'Nerc Questions Ranked by Compliance Risk', 17, 17, N'A list of all Nerc v5 questions/answers ranked by compliance risk.')
INSERT [dbo].[REPORT_DETAIL_SECTIONS] ([Report_Section_Id], [Display_Name], [Display_Order], [Report_Order], [Tool_Tip]) VALUES (20, N'Nerc vs 5 Categories Ranked by Compliance Risk', 18, 18, N'A chart showing Nerc vs 5 categories ranked by compliance risk.')
EXEC sys.sp_addextendedproperty @name=N'BELONGS_IN_EA', @value=N'YES' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'REPORT_DETAIL_SECTIONS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'REPORT_DETAIL_SECTIONS'
GO
