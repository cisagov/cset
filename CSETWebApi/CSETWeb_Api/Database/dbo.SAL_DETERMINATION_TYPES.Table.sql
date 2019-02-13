USE [CSETWeb]
GO
/****** Object:  Table [dbo].[SAL_DETERMINATION_TYPES]    Script Date: 11/14/2018 3:57:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SAL_DETERMINATION_TYPES](
	[Sal_Determination_Type] [varchar](50) NOT NULL,
 CONSTRAINT [PK_SAL_DETERMINATION_TYPES_1] PRIMARY KEY CLUSTERED 
(
	[Sal_Determination_Type] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [dbo].[SAL_DETERMINATION_TYPES] ([Sal_Determination_Type]) VALUES (N'CNSS')
INSERT [dbo].[SAL_DETERMINATION_TYPES] ([Sal_Determination_Type]) VALUES (N'FIPS')
INSERT [dbo].[SAL_DETERMINATION_TYPES] ([Sal_Determination_Type]) VALUES (N'GENERAL')
INSERT [dbo].[SAL_DETERMINATION_TYPES] ([Sal_Determination_Type]) VALUES (N'NIST')
INSERT [dbo].[SAL_DETERMINATION_TYPES] ([Sal_Determination_Type]) VALUES (N'SIMPLE')
EXEC sys.sp_addextendedproperty @name=N'BELONGS_IN_EA', @value=N'YES' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SAL_DETERMINATION_TYPES'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SAL_DETERMINATION_TYPES'
GO
