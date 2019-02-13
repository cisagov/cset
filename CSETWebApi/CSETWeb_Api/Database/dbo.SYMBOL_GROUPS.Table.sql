USE [CSETWeb]
GO
/****** Object:  Table [dbo].[SYMBOL_GROUPS]    Script Date: 11/14/2018 3:57:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SYMBOL_GROUPS](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Symbol_Group_Name] [varchar](50) NOT NULL,
	[Symbol_Group_Title] [varchar](50) NOT NULL,
 CONSTRAINT [PK_SYMBOL_GROUPS] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[SYMBOL_GROUPS] ON 

INSERT [dbo].[SYMBOL_GROUPS] ([Id], [Symbol_Group_Name], [Symbol_Group_Title]) VALUES (1, N'ICSComponents', N'ICS')
INSERT [dbo].[SYMBOL_GROUPS] ([Id], [Symbol_Group_Name], [Symbol_Group_Title]) VALUES (2, N'ITComponents', N'IT')
INSERT [dbo].[SYMBOL_GROUPS] ([Id], [Symbol_Group_Name], [Symbol_Group_Title]) VALUES (3, N'RadioComponents', N'Radio')
INSERT [dbo].[SYMBOL_GROUPS] ([Id], [Symbol_Group_Name], [Symbol_Group_Title]) VALUES (4, N'MedicalComponents', N'Medical')
INSERT [dbo].[SYMBOL_GROUPS] ([Id], [Symbol_Group_Name], [Symbol_Group_Title]) VALUES (5, N'GeneralComponents', N'General')
SET IDENTITY_INSERT [dbo].[SYMBOL_GROUPS] OFF
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Id is used to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYMBOL_GROUPS', @level2type=N'COLUMN',@level2name=N'Id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Symbol Group Name is used to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYMBOL_GROUPS', @level2type=N'COLUMN',@level2name=N'Symbol_Group_Name'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Symbol Group Title is used to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYMBOL_GROUPS', @level2type=N'COLUMN',@level2name=N'Symbol_Group_Title'
GO
EXEC sys.sp_addextendedproperty @name=N'BELONGS_IN_EA', @value=N'YES' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYMBOL_GROUPS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SYMBOL_GROUPS'
GO
