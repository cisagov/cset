USE [CSETWeb]
GO
/****** Object:  Table [dbo].[NCSF_FUNCTIONS]    Script Date: 11/14/2018 3:57:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NCSF_FUNCTIONS](
	[NCSF_Function_ID] [varchar](2) NOT NULL,
	[NCSF_Function_Name] [varchar](50) NULL,
	[NCSF_Function_Order] [int] NULL,
	[NCSF_ID] [int] NOT NULL,
 CONSTRAINT [PK_NCSF_FUNCTIONS] PRIMARY KEY CLUSTERED 
(
	[NCSF_Function_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [dbo].[NCSF_FUNCTIONS] ([NCSF_Function_ID], [NCSF_Function_Name], [NCSF_Function_Order], [NCSF_ID]) VALUES (N'DE', N'Detect', 3, 3)
INSERT [dbo].[NCSF_FUNCTIONS] ([NCSF_Function_ID], [NCSF_Function_Name], [NCSF_Function_Order], [NCSF_ID]) VALUES (N'ID', N'Identify', 1, 1)
INSERT [dbo].[NCSF_FUNCTIONS] ([NCSF_Function_ID], [NCSF_Function_Name], [NCSF_Function_Order], [NCSF_ID]) VALUES (N'PR', N'Protect', 2, 2)
INSERT [dbo].[NCSF_FUNCTIONS] ([NCSF_Function_ID], [NCSF_Function_Name], [NCSF_Function_Order], [NCSF_ID]) VALUES (N'RC', N'Recover', 5, 5)
INSERT [dbo].[NCSF_FUNCTIONS] ([NCSF_Function_ID], [NCSF_Function_Name], [NCSF_Function_Order], [NCSF_ID]) VALUES (N'RS', N'Respond', 4, 4)
EXEC sys.sp_addextendedproperty @name=N'BELONGS_IN_EA', @value=N'YES' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NCSF_FUNCTIONS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NCSF_FUNCTIONS'
GO
