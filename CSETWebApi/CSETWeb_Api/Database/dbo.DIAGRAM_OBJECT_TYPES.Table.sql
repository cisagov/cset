USE [CSETWeb]
GO
/****** Object:  Table [dbo].[DIAGRAM_OBJECT_TYPES]    Script Date: 6/28/2018 8:21:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DIAGRAM_OBJECT_TYPES](
	[Object_Type] [varchar](100) NOT NULL,
	[Object_Type_Order] [int] NULL,
 CONSTRAINT [PK_DIAGRAM_OBJECT_TYPES] PRIMARY KEY CLUSTERED 
(
	[Object_Type] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [dbo].[DIAGRAM_OBJECT_TYPES] ([Object_Type], [Object_Type_Order]) VALUES (N'Component', 1)
INSERT [dbo].[DIAGRAM_OBJECT_TYPES] ([Object_Type], [Object_Type_Order]) VALUES (N'MultiServicesComponent', 2)
INSERT [dbo].[DIAGRAM_OBJECT_TYPES] ([Object_Type], [Object_Type_Order]) VALUES (N'Shape', 5)
INSERT [dbo].[DIAGRAM_OBJECT_TYPES] ([Object_Type], [Object_Type_Order]) VALUES (N'Text', 4)
INSERT [dbo].[DIAGRAM_OBJECT_TYPES] ([Object_Type], [Object_Type_Order]) VALUES (N'Zone', 3)
EXEC sys.sp_addextendedproperty @name=N'BELONGS_IN_EA', @value=N'YES' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DIAGRAM_OBJECT_TYPES'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DIAGRAM_OBJECT_TYPES'
GO
