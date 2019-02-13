USE [CSETWeb]
GO
/****** Object:  Table [dbo].[INFORMATION]    Script Date: 11/14/2018 3:57:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[INFORMATION](
	[Id] [int] NOT NULL,
	[Assessment_Name] [nvarchar](100) NOT NULL,
	[Facility_Name] [nvarchar](100) NULL,
	[City_Or_Site_Name] [nvarchar](100) NULL,
	[State_Province_Or_Region] [nvarchar](100) NULL,
	[Assessor_Name] [nvarchar](100) NULL,
	[Assessor_Email] [nvarchar](100) NULL,
	[Assessor_Phone] [nvarchar](100) NULL,
	[Assessment_Description] [nvarchar](4000) NULL,
	[Additional_Notes_And_Comments] [nvarchar](4000) NULL,
	[Additional_Contacts] [ntext] NULL,
	[Executive_Summary] [ntext] NULL,
	[Enterprise_Evaluation_Summary] [ntext] NULL,
	[Real_Property_Unique_Id] [nvarchar](70) NULL,
	[eMass_Document_Id] [int] NULL,
 CONSTRAINT [PK__Information__000000000000023C] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[INFORMATION]  WITH CHECK ADD  CONSTRAINT [FK_INFORMATION_ASSESSMENTS] FOREIGN KEY([Id])
REFERENCES [dbo].[ASSESSMENTS] ([Assessment_Id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[INFORMATION] CHECK CONSTRAINT [FK_INFORMATION_ASSESSMENTS]
GO
ALTER TABLE [dbo].[INFORMATION]  WITH NOCHECK ADD  CONSTRAINT [FK_INFORMATION_DOCUMENT_FILE1] FOREIGN KEY([eMass_Document_Id])
REFERENCES [dbo].[DOCUMENT_FILE] ([Document_Id])
ON DELETE SET NULL
GO
ALTER TABLE [dbo].[INFORMATION] CHECK CONSTRAINT [FK_INFORMATION_DOCUMENT_FILE1]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Id is used to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INFORMATION', @level2type=N'COLUMN',@level2name=N'Id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Assessment Name is used to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INFORMATION', @level2type=N'COLUMN',@level2name=N'Assessment_Name'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Facility Name is used to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INFORMATION', @level2type=N'COLUMN',@level2name=N'Facility_Name'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The City Or Site Name is used to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INFORMATION', @level2type=N'COLUMN',@level2name=N'City_Or_Site_Name'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The State Province Or Region is used to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INFORMATION', @level2type=N'COLUMN',@level2name=N'State_Province_Or_Region'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Assessor Name is used to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INFORMATION', @level2type=N'COLUMN',@level2name=N'Assessor_Name'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Assessor Email is used to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INFORMATION', @level2type=N'COLUMN',@level2name=N'Assessor_Email'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Assessor Phone is used to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INFORMATION', @level2type=N'COLUMN',@level2name=N'Assessor_Phone'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Assessment Description is used to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INFORMATION', @level2type=N'COLUMN',@level2name=N'Assessment_Description'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Additional Notes And Comments is used to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INFORMATION', @level2type=N'COLUMN',@level2name=N'Additional_Notes_And_Comments'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Additional Contacts is used to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INFORMATION', @level2type=N'COLUMN',@level2name=N'Additional_Contacts'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Executive Summary is used to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INFORMATION', @level2type=N'COLUMN',@level2name=N'Executive_Summary'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Enterprise Evaluation Summary is used to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INFORMATION', @level2type=N'COLUMN',@level2name=N'Enterprise_Evaluation_Summary'
GO
EXEC sys.sp_addextendedproperty @name=N'BELONGS_IN_EA', @value=N'YES' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INFORMATION'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'INFORMATION'
GO
