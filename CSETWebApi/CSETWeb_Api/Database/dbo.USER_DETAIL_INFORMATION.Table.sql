USE [CSETWeb]
GO
/****** Object:  Table [dbo].[USER_DETAIL_INFORMATION]    Script Date: 11/14/2018 3:57:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[USER_DETAIL_INFORMATION](
	[Id] [uniqueidentifier] NOT NULL,
	[CellPhone] [varchar](150) NULL,
	[FirstName] [varchar](150) NOT NULL,
	[LastName] [varchar](150) NOT NULL,
	[HomePhone] [varchar](150) NULL,
	[OfficePhone] [varchar](150) NULL,
	[ImagePath] [varchar](150) NULL,
	[JobTitle] [varchar](150) NULL,
	[Organization] [varchar](150) NULL,
	[PrimaryEmail] [varchar](150) NULL,
	[SecondaryEmail] [varchar](150) NULL,
 CONSTRAINT [PK_USER_DETAIL_INFORMATION] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[USER_DETAIL_INFORMATION] ADD  CONSTRAINT [DF_USER_DETAIL_INFORMATION_Id]  DEFAULT (newid()) FOR [Id]
GO
