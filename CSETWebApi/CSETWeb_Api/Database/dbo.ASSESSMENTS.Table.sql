USE [CSETWeb]
GO
/****** Object:  Table [dbo].[ASSESSMENTS]    Script Date: 11/14/2018 3:57:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ASSESSMENTS](
	[Assessment_Id] [int] IDENTITY(1,1) NOT NULL,
	[AssessmentCreatedDate] [datetime2](7) NOT NULL,
	[AssessmentCreatorId] [int] NULL,
	[LastAccessedDate] [datetime2](7) NULL,
	[Alias] [varchar](50) NULL,
	[Assessment_GUID] [uniqueidentifier] NOT NULL,
	[Assessment_Date] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_Aggregation_1] PRIMARY KEY CLUSTERED 
(
	[Assessment_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ASSESSMENTS] ADD  CONSTRAINT [DF_ASSESSMENTS_AssessmentCreatedDate]  DEFAULT (getdate()) FOR [AssessmentCreatedDate]
GO
ALTER TABLE [dbo].[ASSESSMENTS] ADD  CONSTRAINT [DF_ASSESSMENTS_Assessment_GUID]  DEFAULT (newid()) FOR [Assessment_GUID]
GO
ALTER TABLE [dbo].[ASSESSMENTS] ADD  CONSTRAINT [DF_ASSESSMENTS_Assessment_Date]  DEFAULT (getdate()) FOR [Assessment_Date]
GO
ALTER TABLE [dbo].[ASSESSMENTS]  WITH CHECK ADD  CONSTRAINT [FK_ASSESSMENTS_USERS] FOREIGN KEY([AssessmentCreatorId])
REFERENCES [dbo].[USERS] ([UserId])
ON DELETE SET NULL
GO
ALTER TABLE [dbo].[ASSESSMENTS] CHECK CONSTRAINT [FK_ASSESSMENTS_USERS]
GO
EXEC sys.sp_addextendedproperty @name=N'BELONGS_IN_EA', @value=N'YES' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ASSESSMENTS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ASSESSMENTS'
GO
