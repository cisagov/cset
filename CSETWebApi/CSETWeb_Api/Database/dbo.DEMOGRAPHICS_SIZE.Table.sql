USE [CSETWeb]
GO
/****** Object:  Table [dbo].[DEMOGRAPHICS_SIZE]    Script Date: 11/14/2018 3:57:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DEMOGRAPHICS_SIZE](
	[DemographicId] [int] IDENTITY(1,1) NOT NULL,
	[Size] [varchar](50) NOT NULL,
	[Description] [varchar](50) NULL,
	[ValueOrder] [int] NULL,
 CONSTRAINT [PK_DemographicsSize] PRIMARY KEY CLUSTERED 
(
	[Size] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[DEMOGRAPHICS_SIZE] ON 

INSERT [dbo].[DEMOGRAPHICS_SIZE] ([DemographicId], [Size], [Description], [ValueOrder]) VALUES (3, N'Large', N'Large (3+ days)', 3)
INSERT [dbo].[DEMOGRAPHICS_SIZE] ([DemographicId], [Size], [Description], [ValueOrder]) VALUES (2, N'Medium', N'Medium (1-2 days)', 2)
INSERT [dbo].[DEMOGRAPHICS_SIZE] ([DemographicId], [Size], [Description], [ValueOrder]) VALUES (1, N'Small', N'Small (1-2 hour) assessment', 1)
SET IDENTITY_INSERT [dbo].[DEMOGRAPHICS_SIZE] OFF
