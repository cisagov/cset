USE [CSETWeb]
GO
/****** Object:  Table [dbo].[AVAILABLE_STANDARDS]    Script Date: 11/14/2018 3:57:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AVAILABLE_STANDARDS](
	[Assessment_Id] [int] NOT NULL,
	[Set_Name] [varchar](50) NOT NULL,
	[Selected] [bit] NOT NULL,
 CONSTRAINT [PK_AVAILABLE_STANDARDS] PRIMARY KEY CLUSTERED 
(
	[Assessment_Id] ASC,
	[Set_Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AVAILABLE_STANDARDS] ADD  CONSTRAINT [DF_AVAILABLE_STANDARDS_Selected]  DEFAULT ((0)) FOR [Selected]
GO
ALTER TABLE [dbo].[AVAILABLE_STANDARDS]  WITH CHECK ADD  CONSTRAINT [FK_AVAILABLE_STANDARDS_ASSESSMENTS] FOREIGN KEY([Assessment_Id])
REFERENCES [dbo].[ASSESSMENTS] ([Assessment_Id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AVAILABLE_STANDARDS] CHECK CONSTRAINT [FK_AVAILABLE_STANDARDS_ASSESSMENTS]
GO
ALTER TABLE [dbo].[AVAILABLE_STANDARDS]  WITH CHECK ADD  CONSTRAINT [FK_AVAILABLE_STANDARDS_SETS] FOREIGN KEY([Set_Name])
REFERENCES [dbo].[SETS] ([Set_Name])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AVAILABLE_STANDARDS] CHECK CONSTRAINT [FK_AVAILABLE_STANDARDS_SETS]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Old Entity Name is used to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AVAILABLE_STANDARDS', @level2type=N'COLUMN',@level2name=N'Set_Name'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Selected is used to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AVAILABLE_STANDARDS', @level2type=N'COLUMN',@level2name=N'Selected'
GO
EXEC sys.sp_addextendedproperty @name=N'BELONGS_IN_EA', @value=N'YES' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AVAILABLE_STANDARDS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AVAILABLE_STANDARDS'
GO
