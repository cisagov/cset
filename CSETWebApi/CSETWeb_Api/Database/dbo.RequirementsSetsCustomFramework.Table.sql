USE [CSETWeb]
GO
/****** Object:  Table [dbo].[RequirementsSetsCustomFramework]    Script Date: 11/14/2018 3:57:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RequirementsSetsCustomFramework](
	[Requirement_Id] [int] NOT NULL,
	[Set_Name] [varchar](50) NOT NULL,
	[Question_Set_Id] [int] NULL,
	[Requirement_Sequence] [int] NOT NULL,
	[Assessment_Id] [int] NULL
) ON [PRIMARY]
GO
