USE [CSETWeb]
GO
/****** Object:  Table [dbo].[NIST_SAL_QUESTION_ANSWERS]    Script Date: 6/28/2018 8:21:24 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NIST_SAL_QUESTION_ANSWERS](
	[Assessment_Id] [int] NOT NULL,
	[Question_Id] [int] NOT NULL,
	[Question_Answer] [varchar](50) NOT NULL,
 CONSTRAINT [PK_NIST_SAL_QUESTION_ANSWERS] PRIMARY KEY CLUSTERED 
(
	[Assessment_Id] ASC,
	[Question_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [dbo].[NIST_SAL_QUESTION_ANSWERS] ([Assessment_Id], [Question_Id], [Question_Answer]) VALUES (25, 16338, N'No')
INSERT [dbo].[NIST_SAL_QUESTION_ANSWERS] ([Assessment_Id], [Question_Id], [Question_Answer]) VALUES (25, 16342, N'No')
INSERT [dbo].[NIST_SAL_QUESTION_ANSWERS] ([Assessment_Id], [Question_Id], [Question_Answer]) VALUES (25, 16346, N'No')
INSERT [dbo].[NIST_SAL_QUESTION_ANSWERS] ([Assessment_Id], [Question_Id], [Question_Answer]) VALUES (25, 16350, N'No')
INSERT [dbo].[NIST_SAL_QUESTION_ANSWERS] ([Assessment_Id], [Question_Id], [Question_Answer]) VALUES (25, 16354, N'No')
INSERT [dbo].[NIST_SAL_QUESTION_ANSWERS] ([Assessment_Id], [Question_Id], [Question_Answer]) VALUES (25, 16358, N'No')
INSERT [dbo].[NIST_SAL_QUESTION_ANSWERS] ([Assessment_Id], [Question_Id], [Question_Answer]) VALUES (25, 16362, N'No')
INSERT [dbo].[NIST_SAL_QUESTION_ANSWERS] ([Assessment_Id], [Question_Id], [Question_Answer]) VALUES (25, 16366, N'No')
INSERT [dbo].[NIST_SAL_QUESTION_ANSWERS] ([Assessment_Id], [Question_Id], [Question_Answer]) VALUES (26, 16338, N'No')
INSERT [dbo].[NIST_SAL_QUESTION_ANSWERS] ([Assessment_Id], [Question_Id], [Question_Answer]) VALUES (26, 16342, N'No')
INSERT [dbo].[NIST_SAL_QUESTION_ANSWERS] ([Assessment_Id], [Question_Id], [Question_Answer]) VALUES (26, 16346, N'Yes')
INSERT [dbo].[NIST_SAL_QUESTION_ANSWERS] ([Assessment_Id], [Question_Id], [Question_Answer]) VALUES (26, 16350, N'Yes')
INSERT [dbo].[NIST_SAL_QUESTION_ANSWERS] ([Assessment_Id], [Question_Id], [Question_Answer]) VALUES (26, 16354, N'Yes')
INSERT [dbo].[NIST_SAL_QUESTION_ANSWERS] ([Assessment_Id], [Question_Id], [Question_Answer]) VALUES (26, 16358, N'Yes')
INSERT [dbo].[NIST_SAL_QUESTION_ANSWERS] ([Assessment_Id], [Question_Id], [Question_Answer]) VALUES (26, 16362, N'Yes')
INSERT [dbo].[NIST_SAL_QUESTION_ANSWERS] ([Assessment_Id], [Question_Id], [Question_Answer]) VALUES (26, 16366, N'Yes')
INSERT [dbo].[NIST_SAL_QUESTION_ANSWERS] ([Assessment_Id], [Question_Id], [Question_Answer]) VALUES (27, 16338, N'No')
INSERT [dbo].[NIST_SAL_QUESTION_ANSWERS] ([Assessment_Id], [Question_Id], [Question_Answer]) VALUES (27, 16342, N'No')
INSERT [dbo].[NIST_SAL_QUESTION_ANSWERS] ([Assessment_Id], [Question_Id], [Question_Answer]) VALUES (27, 16346, N'No')
INSERT [dbo].[NIST_SAL_QUESTION_ANSWERS] ([Assessment_Id], [Question_Id], [Question_Answer]) VALUES (27, 16350, N'No')
INSERT [dbo].[NIST_SAL_QUESTION_ANSWERS] ([Assessment_Id], [Question_Id], [Question_Answer]) VALUES (27, 16354, N'No')
INSERT [dbo].[NIST_SAL_QUESTION_ANSWERS] ([Assessment_Id], [Question_Id], [Question_Answer]) VALUES (27, 16358, N'No')
INSERT [dbo].[NIST_SAL_QUESTION_ANSWERS] ([Assessment_Id], [Question_Id], [Question_Answer]) VALUES (27, 16362, N'No')
INSERT [dbo].[NIST_SAL_QUESTION_ANSWERS] ([Assessment_Id], [Question_Id], [Question_Answer]) VALUES (27, 16366, N'No')
INSERT [dbo].[NIST_SAL_QUESTION_ANSWERS] ([Assessment_Id], [Question_Id], [Question_Answer]) VALUES (32, 16338, N'No')
INSERT [dbo].[NIST_SAL_QUESTION_ANSWERS] ([Assessment_Id], [Question_Id], [Question_Answer]) VALUES (32, 16342, N'No')
INSERT [dbo].[NIST_SAL_QUESTION_ANSWERS] ([Assessment_Id], [Question_Id], [Question_Answer]) VALUES (32, 16346, N'No')
INSERT [dbo].[NIST_SAL_QUESTION_ANSWERS] ([Assessment_Id], [Question_Id], [Question_Answer]) VALUES (32, 16350, N'No')
INSERT [dbo].[NIST_SAL_QUESTION_ANSWERS] ([Assessment_Id], [Question_Id], [Question_Answer]) VALUES (32, 16354, N'No')
INSERT [dbo].[NIST_SAL_QUESTION_ANSWERS] ([Assessment_Id], [Question_Id], [Question_Answer]) VALUES (32, 16358, N'No')
INSERT [dbo].[NIST_SAL_QUESTION_ANSWERS] ([Assessment_Id], [Question_Id], [Question_Answer]) VALUES (32, 16362, N'No')
INSERT [dbo].[NIST_SAL_QUESTION_ANSWERS] ([Assessment_Id], [Question_Id], [Question_Answer]) VALUES (32, 16366, N'No')
INSERT [dbo].[NIST_SAL_QUESTION_ANSWERS] ([Assessment_Id], [Question_Id], [Question_Answer]) VALUES (33, 16338, N'Yes')
INSERT [dbo].[NIST_SAL_QUESTION_ANSWERS] ([Assessment_Id], [Question_Id], [Question_Answer]) VALUES (33, 16342, N'Yes')
INSERT [dbo].[NIST_SAL_QUESTION_ANSWERS] ([Assessment_Id], [Question_Id], [Question_Answer]) VALUES (33, 16346, N'Yes')
INSERT [dbo].[NIST_SAL_QUESTION_ANSWERS] ([Assessment_Id], [Question_Id], [Question_Answer]) VALUES (33, 16350, N'Yes')
INSERT [dbo].[NIST_SAL_QUESTION_ANSWERS] ([Assessment_Id], [Question_Id], [Question_Answer]) VALUES (33, 16354, N'Yes')
INSERT [dbo].[NIST_SAL_QUESTION_ANSWERS] ([Assessment_Id], [Question_Id], [Question_Answer]) VALUES (33, 16358, N'Yes')
INSERT [dbo].[NIST_SAL_QUESTION_ANSWERS] ([Assessment_Id], [Question_Id], [Question_Answer]) VALUES (33, 16362, N'Yes')
INSERT [dbo].[NIST_SAL_QUESTION_ANSWERS] ([Assessment_Id], [Question_Id], [Question_Answer]) VALUES (33, 16366, N'Yes')
INSERT [dbo].[NIST_SAL_QUESTION_ANSWERS] ([Assessment_Id], [Question_Id], [Question_Answer]) VALUES (102, 16338, N'No')
INSERT [dbo].[NIST_SAL_QUESTION_ANSWERS] ([Assessment_Id], [Question_Id], [Question_Answer]) VALUES (102, 16342, N'No')
INSERT [dbo].[NIST_SAL_QUESTION_ANSWERS] ([Assessment_Id], [Question_Id], [Question_Answer]) VALUES (102, 16346, N'No')
INSERT [dbo].[NIST_SAL_QUESTION_ANSWERS] ([Assessment_Id], [Question_Id], [Question_Answer]) VALUES (102, 16350, N'No')
INSERT [dbo].[NIST_SAL_QUESTION_ANSWERS] ([Assessment_Id], [Question_Id], [Question_Answer]) VALUES (102, 16354, N'No')
INSERT [dbo].[NIST_SAL_QUESTION_ANSWERS] ([Assessment_Id], [Question_Id], [Question_Answer]) VALUES (102, 16358, N'No')
INSERT [dbo].[NIST_SAL_QUESTION_ANSWERS] ([Assessment_Id], [Question_Id], [Question_Answer]) VALUES (102, 16362, N'No')
INSERT [dbo].[NIST_SAL_QUESTION_ANSWERS] ([Assessment_Id], [Question_Id], [Question_Answer]) VALUES (102, 16366, N'No')
ALTER TABLE [dbo].[NIST_SAL_QUESTION_ANSWERS] ADD  CONSTRAINT [DF_NIST_SAL_QUESTION_ANSWERS_Question_Answer]  DEFAULT ('No') FOR [Question_Answer]
GO
ALTER TABLE [dbo].[NIST_SAL_QUESTION_ANSWERS]  WITH CHECK ADD  CONSTRAINT [FK_NIST_SAL_QUESTION_ANSWERS_NIST_SAL_QUESTIONS] FOREIGN KEY([Question_Id])
REFERENCES [dbo].[NIST_SAL_QUESTIONS] ([Question_Id])
GO
ALTER TABLE [dbo].[NIST_SAL_QUESTION_ANSWERS] CHECK CONSTRAINT [FK_NIST_SAL_QUESTION_ANSWERS_NIST_SAL_QUESTIONS]
GO
ALTER TABLE [dbo].[NIST_SAL_QUESTION_ANSWERS]  WITH CHECK ADD  CONSTRAINT [FK_NIST_SAL_QUESTION_ANSWERS_STANDARD_SELECTION] FOREIGN KEY([Assessment_Id])
REFERENCES [dbo].[STANDARD_SELECTION] ([Assessment_Id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[NIST_SAL_QUESTION_ANSWERS] CHECK CONSTRAINT [FK_NIST_SAL_QUESTION_ANSWERS_STANDARD_SELECTION]
GO
ALTER TABLE [dbo].[NIST_SAL_QUESTION_ANSWERS]  WITH CHECK ADD  CONSTRAINT [CK_NIST_SAL_QUESTION_ANSWERS] CHECK  (([Question_Answer]='No' OR [Question_Answer]='Yes'))
GO
ALTER TABLE [dbo].[NIST_SAL_QUESTION_ANSWERS] CHECK CONSTRAINT [CK_NIST_SAL_QUESTION_ANSWERS]
GO
