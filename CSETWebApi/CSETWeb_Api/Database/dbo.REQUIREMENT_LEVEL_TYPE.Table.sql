USE [CSETWeb]
GO
/****** Object:  Table [dbo].[REQUIREMENT_LEVEL_TYPE]    Script Date: 6/28/2018 8:21:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[REQUIREMENT_LEVEL_TYPE](
	[Level_Type] [varchar](5) NOT NULL,
	[Level_Type_Full_Name] [varchar](50) NULL,
 CONSTRAINT [PK_REQUIREMENT_LEVEL_TYPE] PRIMARY KEY CLUSTERED 
(
	[Level_Type] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [dbo].[REQUIREMENT_LEVEL_TYPE] ([Level_Type], [Level_Type_Full_Name]) VALUES (N'A', N'Availability')
INSERT [dbo].[REQUIREMENT_LEVEL_TYPE] ([Level_Type], [Level_Type_Full_Name]) VALUES (N'C', N'Confidentiality')
INSERT [dbo].[REQUIREMENT_LEVEL_TYPE] ([Level_Type], [Level_Type_Full_Name]) VALUES (N'I', N'Integrity')
INSERT [dbo].[REQUIREMENT_LEVEL_TYPE] ([Level_Type], [Level_Type_Full_Name]) VALUES (N'NST', N'No Sub Type')
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Level Type is used to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'REQUIREMENT_LEVEL_TYPE', @level2type=N'COLUMN',@level2name=N'Level_Type'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Level Type Full Name is used to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'REQUIREMENT_LEVEL_TYPE', @level2type=N'COLUMN',@level2name=N'Level_Type_Full_Name'
GO
EXEC sys.sp_addextendedproperty @name=N'BELONGS_IN_EA', @value=N'YES' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'REQUIREMENT_LEVEL_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'REQUIREMENT_LEVEL_TYPE'
GO
