USE [CSETWeb]
GO
/****** Object:  Table [dbo].[GENERAL_SAL]    Script Date: 11/14/2018 3:57:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GENERAL_SAL](
	[Assessment_Id] [int] NOT NULL,
	[Sal_Name] [varchar](50) NOT NULL,
	[Slider_Value] [int] NOT NULL,
 CONSTRAINT [PK_GENERAL_SAL_1] PRIMARY KEY CLUSTERED 
(
	[Assessment_Id] ASC,
	[Sal_Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[GENERAL_SAL]  WITH CHECK ADD  CONSTRAINT [FK_GENERAL_SAL_ASSESSMENTS] FOREIGN KEY([Assessment_Id])
REFERENCES [dbo].[ASSESSMENTS] ([Assessment_Id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[GENERAL_SAL] CHECK CONSTRAINT [FK_GENERAL_SAL_ASSESSMENTS]
GO
ALTER TABLE [dbo].[GENERAL_SAL]  WITH CHECK ADD  CONSTRAINT [FK_GENERAL_SAL_GEN_SAL_NAMES] FOREIGN KEY([Sal_Name])
REFERENCES [dbo].[GEN_SAL_NAMES] ([Sal_Name])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[GENERAL_SAL] CHECK CONSTRAINT [FK_GENERAL_SAL_GEN_SAL_NAMES]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Id is used to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'GENERAL_SAL', @level2type=N'COLUMN',@level2name=N'Assessment_Id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Sal Weight Id is used to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'GENERAL_SAL', @level2type=N'COLUMN',@level2name=N'Sal_Name'
GO
EXEC sys.sp_addextendedproperty @name=N'BELONGS_IN_EA', @value=N'YES' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'GENERAL_SAL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'GENERAL_SAL'
GO
