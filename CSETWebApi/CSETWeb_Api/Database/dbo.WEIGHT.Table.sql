USE [CSETWeb]
GO
/****** Object:  Table [dbo].[WEIGHT]    Script Date: 6/28/2018 8:21:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WEIGHT](
	[Weight] [int] NOT NULL,
	[Question_Normalized_Weight] [decimal](18, 2) NOT NULL,
	[Requirement_Normalized_Weight] [decimal](18, 2) NOT NULL,
	[Category_Normalized_Weight] [decimal](18, 2) NULL,
 CONSTRAINT [PK_QUESTION_WEIGHT] PRIMARY KEY CLUSTERED 
(
	[Weight] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [dbo].[WEIGHT] ([Weight], [Question_Normalized_Weight], [Requirement_Normalized_Weight], [Category_Normalized_Weight]) VALUES (1, CAST(2.66 AS Decimal(18, 2)), CAST(14.02 AS Decimal(18, 2)), CAST(8.02 AS Decimal(18, 2)))
INSERT [dbo].[WEIGHT] ([Weight], [Question_Normalized_Weight], [Requirement_Normalized_Weight], [Category_Normalized_Weight]) VALUES (2, CAST(8.73 AS Decimal(18, 2)), CAST(18.17 AS Decimal(18, 2)), CAST(15.16 AS Decimal(18, 2)))
INSERT [dbo].[WEIGHT] ([Weight], [Question_Normalized_Weight], [Requirement_Normalized_Weight], [Category_Normalized_Weight]) VALUES (3, CAST(21.13 AS Decimal(18, 2)), CAST(27.98 AS Decimal(18, 2)), CAST(18.70 AS Decimal(18, 2)))
INSERT [dbo].[WEIGHT] ([Weight], [Question_Normalized_Weight], [Requirement_Normalized_Weight], [Category_Normalized_Weight]) VALUES (4, CAST(34.92 AS Decimal(18, 2)), CAST(37.87 AS Decimal(18, 2)), CAST(20.00 AS Decimal(18, 2)))
INSERT [dbo].[WEIGHT] ([Weight], [Question_Normalized_Weight], [Requirement_Normalized_Weight], [Category_Normalized_Weight]) VALUES (5, CAST(41.13 AS Decimal(18, 2)), CAST(43.00 AS Decimal(18, 2)), NULL)
INSERT [dbo].[WEIGHT] ([Weight], [Question_Normalized_Weight], [Requirement_Normalized_Weight], [Category_Normalized_Weight]) VALUES (6, CAST(48.53 AS Decimal(18, 2)), CAST(48.90 AS Decimal(18, 2)), NULL)
INSERT [dbo].[WEIGHT] ([Weight], [Question_Normalized_Weight], [Requirement_Normalized_Weight], [Category_Normalized_Weight]) VALUES (7, CAST(54.51 AS Decimal(18, 2)), CAST(53.51 AS Decimal(18, 2)), NULL)
INSERT [dbo].[WEIGHT] ([Weight], [Question_Normalized_Weight], [Requirement_Normalized_Weight], [Category_Normalized_Weight]) VALUES (8, CAST(57.71 AS Decimal(18, 2)), CAST(57.71 AS Decimal(18, 2)), NULL)
INSERT [dbo].[WEIGHT] ([Weight], [Question_Normalized_Weight], [Requirement_Normalized_Weight], [Category_Normalized_Weight]) VALUES (9, CAST(59.04 AS Decimal(18, 2)), CAST(58.23 AS Decimal(18, 2)), NULL)
INSERT [dbo].[WEIGHT] ([Weight], [Question_Normalized_Weight], [Requirement_Normalized_Weight], [Category_Normalized_Weight]) VALUES (10, CAST(60.00 AS Decimal(18, 2)), CAST(60.00 AS Decimal(18, 2)), NULL)
EXEC sys.sp_addextendedproperty @name=N'BELONGS_IN_EA', @value=N'YES' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'WEIGHT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'WEIGHT'
GO
