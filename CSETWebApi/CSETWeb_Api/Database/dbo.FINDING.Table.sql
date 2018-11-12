USE [CSETWeb]
GO
/****** Object:  Table [dbo].[FINDING]    Script Date: 6/28/2018 8:21:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FINDING](
	[Answer_Id] [int] NOT NULL,
	[Finding_Id] [int] IDENTITY(1,1) NOT NULL,
	[Summary] [varchar](max) NULL,
	[Issue] [varchar](max) NULL,
	[Impact] [varchar](max) NULL,
	[Recommendations] [varchar](max) NULL,
	[Vulnerabilities] [varchar](max) NULL,
	[Resolution_Date] [datetime2](7) NULL,
	[Importance_Id] [int] NULL,
 CONSTRAINT [PK_FINDING] PRIMARY KEY CLUSTERED 
(
	[Finding_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[FINDING] ON 

INSERT [dbo].[FINDING] ([Answer_Id], [Finding_Id], [Summary], [Issue], [Impact], [Recommendations], [Vulnerabilities], [Resolution_Date], [Importance_Id]) VALUES (55, 3, N'Number 1', NULL, NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[FINDING] ([Answer_Id], [Finding_Id], [Summary], [Issue], [Impact], [Recommendations], [Vulnerabilities], [Resolution_Date], [Importance_Id]) VALUES (55, 4, NULL, NULL, NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[FINDING] ([Answer_Id], [Finding_Id], [Summary], [Issue], [Impact], [Recommendations], [Vulnerabilities], [Resolution_Date], [Importance_Id]) VALUES (27, 5, N'New test Discovery', N'issue', N'impacts', N'recommendations', N'vulnerabilites', CAST(N'2018-06-22T06:00:00.0000000' AS DateTime2), 1)
INSERT [dbo].[FINDING] ([Answer_Id], [Finding_Id], [Summary], [Issue], [Impact], [Recommendations], [Vulnerabilities], [Resolution_Date], [Importance_Id]) VALUES (78, 7, N'ZDZfdfzxcZXC', NULL, NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[FINDING] ([Answer_Id], [Finding_Id], [Summary], [Issue], [Impact], [Recommendations], [Vulnerabilities], [Resolution_Date], [Importance_Id]) VALUES (55, 8, N'bbbbb', NULL, NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[FINDING] ([Answer_Id], [Finding_Id], [Summary], [Issue], [Impact], [Recommendations], [Vulnerabilities], [Resolution_Date], [Importance_Id]) VALUES (84, 9, NULL, NULL, NULL, NULL, NULL, NULL, 1)
SET IDENTITY_INSERT [dbo].[FINDING] OFF
ALTER TABLE [dbo].[FINDING]  WITH CHECK ADD  CONSTRAINT [FK_FINDING_ANSWER] FOREIGN KEY([Answer_Id])
REFERENCES [dbo].[ANSWER] ([Answer_Id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[FINDING] CHECK CONSTRAINT [FK_FINDING_ANSWER]
GO
ALTER TABLE [dbo].[FINDING]  WITH NOCHECK ADD  CONSTRAINT [FK_FINDING_IMPORTANCE1] FOREIGN KEY([Importance_Id])
REFERENCES [dbo].[IMPORTANCE] ([Importance_Id])
ON UPDATE CASCADE
ON DELETE SET NULL
GO
ALTER TABLE [dbo].[FINDING] CHECK CONSTRAINT [FK_FINDING_IMPORTANCE1]
GO
