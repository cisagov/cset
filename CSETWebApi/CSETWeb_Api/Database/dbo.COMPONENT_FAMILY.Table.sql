USE [CSETWeb]
GO
/****** Object:  Table [dbo].[COMPONENT_FAMILY]    Script Date: 6/28/2018 8:21:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[COMPONENT_FAMILY](
	[Component_Family_Name] [varchar](150) NOT NULL,
 CONSTRAINT [PK_ComponentFamily] PRIMARY KEY CLUSTERED 
(
	[Component_Family_Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [dbo].[COMPONENT_FAMILY] ([Component_Family_Name]) VALUES (N'Comm/Network')
INSERT [dbo].[COMPONENT_FAMILY] ([Component_Family_Name]) VALUES (N'Control Units')
INSERT [dbo].[COMPONENT_FAMILY] ([Component_Family_Name]) VALUES (N'Non-Question')
INSERT [dbo].[COMPONENT_FAMILY] ([Component_Family_Name]) VALUES (N'Other')
INSERT [dbo].[COMPONENT_FAMILY] ([Component_Family_Name]) VALUES (N'Security')
INSERT [dbo].[COMPONENT_FAMILY] ([Component_Family_Name]) VALUES (N'Servers')
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Component Family Name is used to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COMPONENT_FAMILY', @level2type=N'COLUMN',@level2name=N'Component_Family_Name'
GO
EXEC sys.sp_addextendedproperty @name=N'BELONGS_IN_EA', @value=N'YES' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COMPONENT_FAMILY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'COMPONENT_FAMILY'
GO
