USE [CSETWeb]
GO
/****** Object:  Table [dbo].[RequirementsCustomFramework]    Script Date: 11/14/2018 3:57:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RequirementsCustomFramework](
	[Requirement_Id] [int] NOT NULL,
	[Requirement_Title] [varchar](250) NULL,
	[Requirement_Text] [varchar](max) NOT NULL,
	[Supplemental_Info] [varchar](max) NULL,
	[Question_Group_Heading] [nvarchar](250) NOT NULL,
	[Standard_Category] [varchar](250) NULL,
	[Standard_Sub_Category] [varchar](250) NULL,
	[Weight] [int] NULL,
	[Default_Standard_Level] [int] NOT NULL,
	[Implementation_Recommendations] [varchar](max) NULL,
	[Original_Set_Name] [varchar](50) NOT NULL,
	[Text_Hash] [varbinary](20) NULL,
	[NCSF_Cat_Id] [int] NULL,
	[NCSF_Number] [int] NULL,
	[Supp_Hash] [varbinary](32) NULL,
	[Ranking] [int] NULL,
	[Assessment_Id] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
