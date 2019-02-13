USE [CSETWeb]
GO
/****** Object:  Table [dbo].[CSET_VERSION]    Script Date: 11/14/2018 3:57:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CSET_VERSION](
	[Id] [int] NOT NULL,
	[Version_Id] [decimal](18, 4) NOT NULL,
	[Cset_Version] [varchar](50) NOT NULL,
	[Build_Number] [varchar](500) NULL,
 CONSTRAINT [PK_CSET_VERSION] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [dbo].[CSET_VERSION] ([Id], [Version_Id], [Cset_Version], [Build_Number]) VALUES (1, CAST(9.0000 AS Decimal(18, 4)), N'9.0', NULL)
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Id is used to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CSET_VERSION', @level2type=N'COLUMN',@level2name=N'Id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Version Id is used to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CSET_VERSION', @level2type=N'COLUMN',@level2name=N'Version_Id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Cset Version is used to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CSET_VERSION', @level2type=N'COLUMN',@level2name=N'Cset_Version'
GO
EXEC sys.sp_addextendedproperty @name=N'BELONGS_IN_EA', @value=N'YES' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CSET_VERSION'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CSET_VERSION'
GO
