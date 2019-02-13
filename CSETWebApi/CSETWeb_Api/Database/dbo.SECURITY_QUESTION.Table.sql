USE [CSETWeb]
GO
/****** Object:  Table [dbo].[SECURITY_QUESTION]    Script Date: 11/14/2018 3:57:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SECURITY_QUESTION](
	[SecurityQuestionId] [int] IDENTITY(1,1) NOT NULL,
	[SecurityQuestion] [varchar](500) NOT NULL,
	[IsCustomQuestion] [bit] NOT NULL,
 CONSTRAINT [PK_SECURITY_QUESTION] PRIMARY KEY CLUSTERED 
(
	[SecurityQuestionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[SECURITY_QUESTION] ON 

INSERT [dbo].[SECURITY_QUESTION] ([SecurityQuestionId], [SecurityQuestion], [IsCustomQuestion]) VALUES (1, N'What was the house number and street name you lived in as a child?', 0)
INSERT [dbo].[SECURITY_QUESTION] ([SecurityQuestionId], [SecurityQuestion], [IsCustomQuestion]) VALUES (2, N'What were the last four digits of your childhood telephone number?', 0)
INSERT [dbo].[SECURITY_QUESTION] ([SecurityQuestionId], [SecurityQuestion], [IsCustomQuestion]) VALUES (3, N'What primary school did you attend?', 0)
INSERT [dbo].[SECURITY_QUESTION] ([SecurityQuestionId], [SecurityQuestion], [IsCustomQuestion]) VALUES (4, N'In what town or city was your first full time job?', 0)
INSERT [dbo].[SECURITY_QUESTION] ([SecurityQuestionId], [SecurityQuestion], [IsCustomQuestion]) VALUES (5, N'In what town or city did you meet your spouse/partner?', 0)
INSERT [dbo].[SECURITY_QUESTION] ([SecurityQuestionId], [SecurityQuestion], [IsCustomQuestion]) VALUES (6, N'What is the middle name of your oldest child?', 0)
INSERT [dbo].[SECURITY_QUESTION] ([SecurityQuestionId], [SecurityQuestion], [IsCustomQuestion]) VALUES (7, N'What are the last five digits of your driver''s licence number?', 0)
INSERT [dbo].[SECURITY_QUESTION] ([SecurityQuestionId], [SecurityQuestion], [IsCustomQuestion]) VALUES (8, N'What is your grandmother''s (on your mother''s side) maiden name?', 0)
INSERT [dbo].[SECURITY_QUESTION] ([SecurityQuestionId], [SecurityQuestion], [IsCustomQuestion]) VALUES (9, N'What is your spouse or partner''s mother''s maiden name?', 0)
INSERT [dbo].[SECURITY_QUESTION] ([SecurityQuestionId], [SecurityQuestion], [IsCustomQuestion]) VALUES (10, N'In what town or city did your mother and father meet?', 0)
INSERT [dbo].[SECURITY_QUESTION] ([SecurityQuestionId], [SecurityQuestion], [IsCustomQuestion]) VALUES (11, N'What time of the day were you born? (hh:mm)', 0)
INSERT [dbo].[SECURITY_QUESTION] ([SecurityQuestionId], [SecurityQuestion], [IsCustomQuestion]) VALUES (12, N'What time of the day was your first child born? (hh:mm)', 0)
SET IDENTITY_INSERT [dbo].[SECURITY_QUESTION] OFF
ALTER TABLE [dbo].[SECURITY_QUESTION] ADD  CONSTRAINT [DF_SECURITY_QUESTION_IsCustomQuestion]  DEFAULT ((1)) FOR [IsCustomQuestion]
GO
