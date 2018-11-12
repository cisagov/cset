USE [CSETWeb]
GO
/****** Object:  Table [dbo].[AVAILABLE_STANDARDS]    Script Date: 6/28/2018 8:21:22 AM ******/
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
INSERT [dbo].[AVAILABLE_STANDARDS] ([Assessment_Id], [Set_Name], [Selected]) VALUES (25, N'Nerc_Cip_R5', 1)
INSERT [dbo].[AVAILABLE_STANDARDS] ([Assessment_Id], [Set_Name], [Selected]) VALUES (26, N'Key', 1)
INSERT [dbo].[AVAILABLE_STANDARDS] ([Assessment_Id], [Set_Name], [Selected]) VALUES (27, N'Tsa', 1)
INSERT [dbo].[AVAILABLE_STANDARDS] ([Assessment_Id], [Set_Name], [Selected]) VALUES (28, N'Key', 1)
INSERT [dbo].[AVAILABLE_STANDARDS] ([Assessment_Id], [Set_Name], [Selected]) VALUES (33, N'Cfats', 1)
INSERT [dbo].[AVAILABLE_STANDARDS] ([Assessment_Id], [Set_Name], [Selected]) VALUES (43, N'CSC_V6', 1)
INSERT [dbo].[AVAILABLE_STANDARDS] ([Assessment_Id], [Set_Name], [Selected]) VALUES (96, N'CSC_V6', 1)
INSERT [dbo].[AVAILABLE_STANDARDS] ([Assessment_Id], [Set_Name], [Selected]) VALUES (102, N'Key', 1)
INSERT [dbo].[AVAILABLE_STANDARDS] ([Assessment_Id], [Set_Name], [Selected]) VALUES (103, N'PCIDSS', 1)
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
