USE [CSETWeb]
GO
/****** Object:  Table [dbo].[ANSWER]    Script Date: 6/28/2018 8:21:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ANSWER](
	[Assessment_Id] [int] NOT NULL,
	[Answer_Id] [int] IDENTITY(1,1) NOT NULL,
	[Is_Requirement] [bit] NOT NULL,
	[Question_Or_Requirement_Id] [int] NOT NULL,
	[Component_Id] [int] NOT NULL,
	[Mark_For_Review] [bit] NULL,
	[Comment] [ntext] NULL,
	[Alternate_Justification] [ntext] NULL,
	[Question_Number] [int] NULL,
	[Answer_Text] [varchar](50) NOT NULL,
	[Component_Guid] [char](36) NULL,
	[Is_Component] [bit] NOT NULL,
	[Custom_Question_Guid] [varchar](50) NULL,
	[Is_Framework] [bit] NOT NULL,
 CONSTRAINT [PK_ANSWER_1] PRIMARY KEY CLUSTERED 
(
	[Answer_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[ANSWER] ON 

INSERT [dbo].[ANSWER] ([Assessment_Id], [Answer_Id], [Is_Requirement], [Question_Or_Requirement_Id], [Component_Id], [Mark_For_Review], [Comment], [Alternate_Justification], [Question_Number], [Answer_Text], [Component_Guid], [Is_Component], [Custom_Question_Guid], [Is_Framework]) VALUES (25, 27, 0, 14079, 0, 0, N'', N'', NULL, N'N', NULL, 0, NULL, 0)
INSERT [dbo].[ANSWER] ([Assessment_Id], [Answer_Id], [Is_Requirement], [Question_Or_Requirement_Id], [Component_Id], [Mark_For_Review], [Comment], [Alternate_Justification], [Question_Number], [Answer_Text], [Component_Guid], [Is_Component], [Custom_Question_Guid], [Is_Framework]) VALUES (25, 28, 0, 14080, 0, 0, NULL, N'', NULL, N'N', NULL, 0, NULL, 0)
INSERT [dbo].[ANSWER] ([Assessment_Id], [Answer_Id], [Is_Requirement], [Question_Or_Requirement_Id], [Component_Id], [Mark_For_Review], [Comment], [Alternate_Justification], [Question_Number], [Answer_Text], [Component_Guid], [Is_Component], [Custom_Question_Guid], [Is_Framework]) VALUES (25, 29, 0, 14081, 0, 0, NULL, N'', NULL, N'N', NULL, 0, NULL, 0)
INSERT [dbo].[ANSWER] ([Assessment_Id], [Answer_Id], [Is_Requirement], [Question_Or_Requirement_Id], [Component_Id], [Mark_For_Review], [Comment], [Alternate_Justification], [Question_Number], [Answer_Text], [Component_Guid], [Is_Component], [Custom_Question_Guid], [Is_Framework]) VALUES (25, 30, 0, 14082, 0, 0, NULL, N'', NULL, N'N', NULL, 0, NULL, 0)
INSERT [dbo].[ANSWER] ([Assessment_Id], [Answer_Id], [Is_Requirement], [Question_Or_Requirement_Id], [Component_Id], [Mark_For_Review], [Comment], [Alternate_Justification], [Question_Number], [Answer_Text], [Component_Guid], [Is_Component], [Custom_Question_Guid], [Is_Framework]) VALUES (25, 31, 0, 14083, 0, 0, NULL, N'', NULL, N'N', NULL, 0, NULL, 0)
INSERT [dbo].[ANSWER] ([Assessment_Id], [Answer_Id], [Is_Requirement], [Question_Or_Requirement_Id], [Component_Id], [Mark_For_Review], [Comment], [Alternate_Justification], [Question_Number], [Answer_Text], [Component_Guid], [Is_Component], [Custom_Question_Guid], [Is_Framework]) VALUES (25, 32, 0, 14084, 0, 0, NULL, N'', NULL, N'N', NULL, 0, NULL, 0)
INSERT [dbo].[ANSWER] ([Assessment_Id], [Answer_Id], [Is_Requirement], [Question_Or_Requirement_Id], [Component_Id], [Mark_For_Review], [Comment], [Alternate_Justification], [Question_Number], [Answer_Text], [Component_Guid], [Is_Component], [Custom_Question_Guid], [Is_Framework]) VALUES (25, 33, 0, 14085, 0, 0, NULL, N'', NULL, N'N', NULL, 0, NULL, 0)
INSERT [dbo].[ANSWER] ([Assessment_Id], [Answer_Id], [Is_Requirement], [Question_Or_Requirement_Id], [Component_Id], [Mark_For_Review], [Comment], [Alternate_Justification], [Question_Number], [Answer_Text], [Component_Guid], [Is_Component], [Custom_Question_Guid], [Is_Framework]) VALUES (25, 34, 0, 14086, 0, 0, NULL, N'', NULL, N'N', NULL, 0, NULL, 0)
INSERT [dbo].[ANSWER] ([Assessment_Id], [Answer_Id], [Is_Requirement], [Question_Or_Requirement_Id], [Component_Id], [Mark_For_Review], [Comment], [Alternate_Justification], [Question_Number], [Answer_Text], [Component_Guid], [Is_Component], [Custom_Question_Guid], [Is_Framework]) VALUES (25, 35, 0, 14087, 0, 0, NULL, N'', NULL, N'N', NULL, 0, NULL, 0)
INSERT [dbo].[ANSWER] ([Assessment_Id], [Answer_Id], [Is_Requirement], [Question_Or_Requirement_Id], [Component_Id], [Mark_For_Review], [Comment], [Alternate_Justification], [Question_Number], [Answer_Text], [Component_Guid], [Is_Component], [Custom_Question_Guid], [Is_Framework]) VALUES (25, 36, 0, 14088, 0, 0, NULL, N'', NULL, N'N', NULL, 0, NULL, 0)
INSERT [dbo].[ANSWER] ([Assessment_Id], [Answer_Id], [Is_Requirement], [Question_Or_Requirement_Id], [Component_Id], [Mark_For_Review], [Comment], [Alternate_Justification], [Question_Number], [Answer_Text], [Component_Guid], [Is_Component], [Custom_Question_Guid], [Is_Framework]) VALUES (25, 37, 0, 14089, 0, 0, NULL, N'', NULL, N'N', NULL, 0, NULL, 0)
INSERT [dbo].[ANSWER] ([Assessment_Id], [Answer_Id], [Is_Requirement], [Question_Or_Requirement_Id], [Component_Id], [Mark_For_Review], [Comment], [Alternate_Justification], [Question_Number], [Answer_Text], [Component_Guid], [Is_Component], [Custom_Question_Guid], [Is_Framework]) VALUES (25, 38, 0, 14090, 0, 0, NULL, N'', NULL, N'N', NULL, 0, NULL, 0)
INSERT [dbo].[ANSWER] ([Assessment_Id], [Answer_Id], [Is_Requirement], [Question_Or_Requirement_Id], [Component_Id], [Mark_For_Review], [Comment], [Alternate_Justification], [Question_Number], [Answer_Text], [Component_Guid], [Is_Component], [Custom_Question_Guid], [Is_Framework]) VALUES (25, 39, 0, 14091, 0, 0, NULL, N'', NULL, N'N', NULL, 0, NULL, 0)
INSERT [dbo].[ANSWER] ([Assessment_Id], [Answer_Id], [Is_Requirement], [Question_Or_Requirement_Id], [Component_Id], [Mark_For_Review], [Comment], [Alternate_Justification], [Question_Number], [Answer_Text], [Component_Guid], [Is_Component], [Custom_Question_Guid], [Is_Framework]) VALUES (25, 40, 0, 14092, 0, 0, NULL, N'', NULL, N'N', NULL, 0, NULL, 0)
INSERT [dbo].[ANSWER] ([Assessment_Id], [Answer_Id], [Is_Requirement], [Question_Or_Requirement_Id], [Component_Id], [Mark_For_Review], [Comment], [Alternate_Justification], [Question_Number], [Answer_Text], [Component_Guid], [Is_Component], [Custom_Question_Guid], [Is_Framework]) VALUES (25, 41, 0, 14093, 0, 0, NULL, N'', NULL, N'N', NULL, 0, NULL, 0)
INSERT [dbo].[ANSWER] ([Assessment_Id], [Answer_Id], [Is_Requirement], [Question_Or_Requirement_Id], [Component_Id], [Mark_For_Review], [Comment], [Alternate_Justification], [Question_Number], [Answer_Text], [Component_Guid], [Is_Component], [Custom_Question_Guid], [Is_Framework]) VALUES (25, 42, 0, 14094, 0, 0, NULL, N'', NULL, N'N', NULL, 0, NULL, 0)
INSERT [dbo].[ANSWER] ([Assessment_Id], [Answer_Id], [Is_Requirement], [Question_Or_Requirement_Id], [Component_Id], [Mark_For_Review], [Comment], [Alternate_Justification], [Question_Number], [Answer_Text], [Component_Guid], [Is_Component], [Custom_Question_Guid], [Is_Framework]) VALUES (25, 43, 0, 14095, 0, 0, NULL, N'', NULL, N'N', NULL, 0, NULL, 0)
INSERT [dbo].[ANSWER] ([Assessment_Id], [Answer_Id], [Is_Requirement], [Question_Or_Requirement_Id], [Component_Id], [Mark_For_Review], [Comment], [Alternate_Justification], [Question_Number], [Answer_Text], [Component_Guid], [Is_Component], [Custom_Question_Guid], [Is_Framework]) VALUES (25, 44, 0, 14096, 0, 0, NULL, N'', NULL, N'N', NULL, 0, NULL, 0)
INSERT [dbo].[ANSWER] ([Assessment_Id], [Answer_Id], [Is_Requirement], [Question_Or_Requirement_Id], [Component_Id], [Mark_For_Review], [Comment], [Alternate_Justification], [Question_Number], [Answer_Text], [Component_Guid], [Is_Component], [Custom_Question_Guid], [Is_Framework]) VALUES (25, 45, 1, 26509, 0, NULL, NULL, N'', NULL, N'N', NULL, 0, NULL, 0)
INSERT [dbo].[ANSWER] ([Assessment_Id], [Answer_Id], [Is_Requirement], [Question_Or_Requirement_Id], [Component_Id], [Mark_For_Review], [Comment], [Alternate_Justification], [Question_Number], [Answer_Text], [Component_Guid], [Is_Component], [Custom_Question_Guid], [Is_Framework]) VALUES (25, 46, 1, 26510, 0, NULL, NULL, N'', NULL, N'Y', NULL, 0, NULL, 0)
INSERT [dbo].[ANSWER] ([Assessment_Id], [Answer_Id], [Is_Requirement], [Question_Or_Requirement_Id], [Component_Id], [Mark_For_Review], [Comment], [Alternate_Justification], [Question_Number], [Answer_Text], [Component_Guid], [Is_Component], [Custom_Question_Guid], [Is_Framework]) VALUES (27, 47, 0, 5131, 0, NULL, NULL, N'jhjhgjhgjhg', NULL, N'A', NULL, 0, NULL, 0)
INSERT [dbo].[ANSWER] ([Assessment_Id], [Answer_Id], [Is_Requirement], [Question_Or_Requirement_Id], [Component_Id], [Mark_For_Review], [Comment], [Alternate_Justification], [Question_Number], [Answer_Text], [Component_Guid], [Is_Component], [Custom_Question_Guid], [Is_Framework]) VALUES (27, 48, 0, 5132, 0, NULL, NULL, N'', NULL, N'Y', NULL, 0, NULL, 0)
INSERT [dbo].[ANSWER] ([Assessment_Id], [Answer_Id], [Is_Requirement], [Question_Or_Requirement_Id], [Component_Id], [Mark_For_Review], [Comment], [Alternate_Justification], [Question_Number], [Answer_Text], [Component_Guid], [Is_Component], [Custom_Question_Guid], [Is_Framework]) VALUES (27, 49, 0, 5127, 0, 0, N'', N'', NULL, N'U', NULL, 0, NULL, 0)
INSERT [dbo].[ANSWER] ([Assessment_Id], [Answer_Id], [Is_Requirement], [Question_Or_Requirement_Id], [Component_Id], [Mark_For_Review], [Comment], [Alternate_Justification], [Question_Number], [Answer_Text], [Component_Guid], [Is_Component], [Custom_Question_Guid], [Is_Framework]) VALUES (27, 50, 0, 5128, 0, NULL, NULL, N'', NULL, N'N', NULL, 0, NULL, 0)
INSERT [dbo].[ANSWER] ([Assessment_Id], [Answer_Id], [Is_Requirement], [Question_Or_Requirement_Id], [Component_Id], [Mark_For_Review], [Comment], [Alternate_Justification], [Question_Number], [Answer_Text], [Component_Guid], [Is_Component], [Custom_Question_Guid], [Is_Framework]) VALUES (27, 51, 0, 5016, 0, NULL, NULL, N'', NULL, N'N', NULL, 0, NULL, 0)
INSERT [dbo].[ANSWER] ([Assessment_Id], [Answer_Id], [Is_Requirement], [Question_Or_Requirement_Id], [Component_Id], [Mark_For_Review], [Comment], [Alternate_Justification], [Question_Number], [Answer_Text], [Component_Guid], [Is_Component], [Custom_Question_Guid], [Is_Framework]) VALUES (27, 52, 0, 5015, 0, NULL, NULL, N'I hereby justify this.', NULL, N'A', NULL, 0, NULL, 0)
INSERT [dbo].[ANSWER] ([Assessment_Id], [Answer_Id], [Is_Requirement], [Question_Or_Requirement_Id], [Component_Id], [Mark_For_Review], [Comment], [Alternate_Justification], [Question_Number], [Answer_Text], [Component_Guid], [Is_Component], [Custom_Question_Guid], [Is_Framework]) VALUES (27, 53, 0, 5129, 0, NULL, NULL, N'', NULL, N'N', NULL, 0, NULL, 0)
INSERT [dbo].[ANSWER] ([Assessment_Id], [Answer_Id], [Is_Requirement], [Question_Or_Requirement_Id], [Component_Id], [Mark_For_Review], [Comment], [Alternate_Justification], [Question_Number], [Answer_Text], [Component_Guid], [Is_Component], [Custom_Question_Guid], [Is_Framework]) VALUES (27, 54, 0, 5130, 0, NULL, NULL, N'', NULL, N'N', NULL, 0, NULL, 0)
INSERT [dbo].[ANSWER] ([Assessment_Id], [Answer_Id], [Is_Requirement], [Question_Or_Requirement_Id], [Component_Id], [Mark_For_Review], [Comment], [Alternate_Justification], [Question_Number], [Answer_Text], [Component_Guid], [Is_Component], [Custom_Question_Guid], [Is_Framework]) VALUES (27, 55, 0, 249, 0, 0, N'', N'', NULL, N'U', NULL, 0, NULL, 0)
INSERT [dbo].[ANSWER] ([Assessment_Id], [Answer_Id], [Is_Requirement], [Question_Or_Requirement_Id], [Component_Id], [Mark_For_Review], [Comment], [Alternate_Justification], [Question_Number], [Answer_Text], [Component_Guid], [Is_Component], [Custom_Question_Guid], [Is_Framework]) VALUES (27, 56, 0, 5133, 0, NULL, NULL, N'', NULL, N'Y', NULL, 0, NULL, 0)
INSERT [dbo].[ANSWER] ([Assessment_Id], [Answer_Id], [Is_Requirement], [Question_Or_Requirement_Id], [Component_Id], [Mark_For_Review], [Comment], [Alternate_Justification], [Question_Number], [Answer_Text], [Component_Guid], [Is_Component], [Custom_Question_Guid], [Is_Framework]) VALUES (27, 57, 0, 2893, 0, NULL, NULL, N'', NULL, N'Y', NULL, 0, NULL, 0)
INSERT [dbo].[ANSWER] ([Assessment_Id], [Answer_Id], [Is_Requirement], [Question_Or_Requirement_Id], [Component_Id], [Mark_For_Review], [Comment], [Alternate_Justification], [Question_Number], [Answer_Text], [Component_Guid], [Is_Component], [Custom_Question_Guid], [Is_Framework]) VALUES (33, 58, 0, 14079, 0, NULL, NULL, N'', NULL, N'N', NULL, 0, NULL, 0)
INSERT [dbo].[ANSWER] ([Assessment_Id], [Answer_Id], [Is_Requirement], [Question_Or_Requirement_Id], [Component_Id], [Mark_For_Review], [Comment], [Alternate_Justification], [Question_Number], [Answer_Text], [Component_Guid], [Is_Component], [Custom_Question_Guid], [Is_Framework]) VALUES (33, 59, 0, 14080, 0, NULL, NULL, N'', NULL, N'N', NULL, 0, NULL, 0)
INSERT [dbo].[ANSWER] ([Assessment_Id], [Answer_Id], [Is_Requirement], [Question_Or_Requirement_Id], [Component_Id], [Mark_For_Review], [Comment], [Alternate_Justification], [Question_Number], [Answer_Text], [Component_Guid], [Is_Component], [Custom_Question_Guid], [Is_Framework]) VALUES (33, 60, 0, 14081, 0, NULL, NULL, N'', NULL, N'N', NULL, 0, NULL, 0)
INSERT [dbo].[ANSWER] ([Assessment_Id], [Answer_Id], [Is_Requirement], [Question_Or_Requirement_Id], [Component_Id], [Mark_For_Review], [Comment], [Alternate_Justification], [Question_Number], [Answer_Text], [Component_Guid], [Is_Component], [Custom_Question_Guid], [Is_Framework]) VALUES (33, 61, 0, 14082, 0, NULL, NULL, N'', NULL, N'N', NULL, 0, NULL, 0)
INSERT [dbo].[ANSWER] ([Assessment_Id], [Answer_Id], [Is_Requirement], [Question_Or_Requirement_Id], [Component_Id], [Mark_For_Review], [Comment], [Alternate_Justification], [Question_Number], [Answer_Text], [Component_Guid], [Is_Component], [Custom_Question_Guid], [Is_Framework]) VALUES (33, 62, 0, 14083, 0, NULL, NULL, N'', NULL, N'N', NULL, 0, NULL, 0)
INSERT [dbo].[ANSWER] ([Assessment_Id], [Answer_Id], [Is_Requirement], [Question_Or_Requirement_Id], [Component_Id], [Mark_For_Review], [Comment], [Alternate_Justification], [Question_Number], [Answer_Text], [Component_Guid], [Is_Component], [Custom_Question_Guid], [Is_Framework]) VALUES (33, 63, 0, 14084, 0, NULL, NULL, N'', NULL, N'N', NULL, 0, NULL, 0)
INSERT [dbo].[ANSWER] ([Assessment_Id], [Answer_Id], [Is_Requirement], [Question_Or_Requirement_Id], [Component_Id], [Mark_For_Review], [Comment], [Alternate_Justification], [Question_Number], [Answer_Text], [Component_Guid], [Is_Component], [Custom_Question_Guid], [Is_Framework]) VALUES (33, 64, 0, 14085, 0, NULL, NULL, N'', NULL, N'N', NULL, 0, NULL, 0)
INSERT [dbo].[ANSWER] ([Assessment_Id], [Answer_Id], [Is_Requirement], [Question_Or_Requirement_Id], [Component_Id], [Mark_For_Review], [Comment], [Alternate_Justification], [Question_Number], [Answer_Text], [Component_Guid], [Is_Component], [Custom_Question_Guid], [Is_Framework]) VALUES (33, 65, 0, 14086, 0, NULL, NULL, N'', NULL, N'N', NULL, 0, NULL, 0)
INSERT [dbo].[ANSWER] ([Assessment_Id], [Answer_Id], [Is_Requirement], [Question_Or_Requirement_Id], [Component_Id], [Mark_For_Review], [Comment], [Alternate_Justification], [Question_Number], [Answer_Text], [Component_Guid], [Is_Component], [Custom_Question_Guid], [Is_Framework]) VALUES (33, 66, 0, 14087, 0, NULL, NULL, N'', NULL, N'N', NULL, 0, NULL, 0)
INSERT [dbo].[ANSWER] ([Assessment_Id], [Answer_Id], [Is_Requirement], [Question_Or_Requirement_Id], [Component_Id], [Mark_For_Review], [Comment], [Alternate_Justification], [Question_Number], [Answer_Text], [Component_Guid], [Is_Component], [Custom_Question_Guid], [Is_Framework]) VALUES (33, 67, 0, 14088, 0, NULL, NULL, N'', NULL, N'N', NULL, 0, NULL, 0)
INSERT [dbo].[ANSWER] ([Assessment_Id], [Answer_Id], [Is_Requirement], [Question_Or_Requirement_Id], [Component_Id], [Mark_For_Review], [Comment], [Alternate_Justification], [Question_Number], [Answer_Text], [Component_Guid], [Is_Component], [Custom_Question_Guid], [Is_Framework]) VALUES (33, 68, 0, 14089, 0, NULL, NULL, N'', NULL, N'N', NULL, 0, NULL, 0)
INSERT [dbo].[ANSWER] ([Assessment_Id], [Answer_Id], [Is_Requirement], [Question_Or_Requirement_Id], [Component_Id], [Mark_For_Review], [Comment], [Alternate_Justification], [Question_Number], [Answer_Text], [Component_Guid], [Is_Component], [Custom_Question_Guid], [Is_Framework]) VALUES (33, 69, 0, 14090, 0, NULL, NULL, N'', NULL, N'N', NULL, 0, NULL, 0)
INSERT [dbo].[ANSWER] ([Assessment_Id], [Answer_Id], [Is_Requirement], [Question_Or_Requirement_Id], [Component_Id], [Mark_For_Review], [Comment], [Alternate_Justification], [Question_Number], [Answer_Text], [Component_Guid], [Is_Component], [Custom_Question_Guid], [Is_Framework]) VALUES (33, 70, 0, 14091, 0, NULL, NULL, N'', NULL, N'N', NULL, 0, NULL, 0)
INSERT [dbo].[ANSWER] ([Assessment_Id], [Answer_Id], [Is_Requirement], [Question_Or_Requirement_Id], [Component_Id], [Mark_For_Review], [Comment], [Alternate_Justification], [Question_Number], [Answer_Text], [Component_Guid], [Is_Component], [Custom_Question_Guid], [Is_Framework]) VALUES (33, 71, 0, 14092, 0, NULL, NULL, N'', NULL, N'N', NULL, 0, NULL, 0)
INSERT [dbo].[ANSWER] ([Assessment_Id], [Answer_Id], [Is_Requirement], [Question_Or_Requirement_Id], [Component_Id], [Mark_For_Review], [Comment], [Alternate_Justification], [Question_Number], [Answer_Text], [Component_Guid], [Is_Component], [Custom_Question_Guid], [Is_Framework]) VALUES (33, 72, 0, 14093, 0, NULL, NULL, N'', NULL, N'N', NULL, 0, NULL, 0)
INSERT [dbo].[ANSWER] ([Assessment_Id], [Answer_Id], [Is_Requirement], [Question_Or_Requirement_Id], [Component_Id], [Mark_For_Review], [Comment], [Alternate_Justification], [Question_Number], [Answer_Text], [Component_Guid], [Is_Component], [Custom_Question_Guid], [Is_Framework]) VALUES (33, 73, 0, 14094, 0, NULL, NULL, N'', NULL, N'N', NULL, 0, NULL, 0)
INSERT [dbo].[ANSWER] ([Assessment_Id], [Answer_Id], [Is_Requirement], [Question_Or_Requirement_Id], [Component_Id], [Mark_For_Review], [Comment], [Alternate_Justification], [Question_Number], [Answer_Text], [Component_Guid], [Is_Component], [Custom_Question_Guid], [Is_Framework]) VALUES (33, 74, 0, 14095, 0, NULL, NULL, N'', NULL, N'N', NULL, 0, NULL, 0)
INSERT [dbo].[ANSWER] ([Assessment_Id], [Answer_Id], [Is_Requirement], [Question_Or_Requirement_Id], [Component_Id], [Mark_For_Review], [Comment], [Alternate_Justification], [Question_Number], [Answer_Text], [Component_Guid], [Is_Component], [Custom_Question_Guid], [Is_Framework]) VALUES (33, 75, 0, 14096, 0, NULL, NULL, N'', NULL, N'Y', NULL, 0, NULL, 0)
INSERT [dbo].[ANSWER] ([Assessment_Id], [Answer_Id], [Is_Requirement], [Question_Or_Requirement_Id], [Component_Id], [Mark_For_Review], [Comment], [Alternate_Justification], [Question_Number], [Answer_Text], [Component_Guid], [Is_Component], [Custom_Question_Guid], [Is_Framework]) VALUES (102, 76, 0, 240, 0, NULL, N'', NULL, NULL, N'U', NULL, 0, NULL, 0)
INSERT [dbo].[ANSWER] ([Assessment_Id], [Answer_Id], [Is_Requirement], [Question_Or_Requirement_Id], [Component_Id], [Mark_For_Review], [Comment], [Alternate_Justification], [Question_Number], [Answer_Text], [Component_Guid], [Is_Component], [Custom_Question_Guid], [Is_Framework]) VALUES (25, 77, 0, 696, 0, NULL, N'This is a comment', NULL, NULL, N'U', NULL, 0, NULL, 0)
INSERT [dbo].[ANSWER] ([Assessment_Id], [Answer_Id], [Is_Requirement], [Question_Or_Requirement_Id], [Component_Id], [Mark_For_Review], [Comment], [Alternate_Justification], [Question_Number], [Answer_Text], [Component_Guid], [Is_Component], [Custom_Question_Guid], [Is_Framework]) VALUES (25, 78, 0, 912, 0, NULL, N'alsdkfjalskdfjlkasj', NULL, NULL, N'U', NULL, 0, NULL, 0)
INSERT [dbo].[ANSWER] ([Assessment_Id], [Answer_Id], [Is_Requirement], [Question_Or_Requirement_Id], [Component_Id], [Mark_For_Review], [Comment], [Alternate_Justification], [Question_Number], [Answer_Text], [Component_Guid], [Is_Component], [Custom_Question_Guid], [Is_Framework]) VALUES (27, 79, 0, 5144, 0, 1, N'', NULL, NULL, N'U', NULL, 0, NULL, 0)
INSERT [dbo].[ANSWER] ([Assessment_Id], [Answer_Id], [Is_Requirement], [Question_Or_Requirement_Id], [Component_Id], [Mark_For_Review], [Comment], [Alternate_Justification], [Question_Number], [Answer_Text], [Component_Guid], [Is_Component], [Custom_Question_Guid], [Is_Framework]) VALUES (27, 80, 0, 5157, 0, 0, N'COmment', NULL, NULL, N'U', NULL, 0, NULL, 0)
INSERT [dbo].[ANSWER] ([Assessment_Id], [Answer_Id], [Is_Requirement], [Question_Or_Requirement_Id], [Component_Id], [Mark_For_Review], [Comment], [Alternate_Justification], [Question_Number], [Answer_Text], [Component_Guid], [Is_Component], [Custom_Question_Guid], [Is_Framework]) VALUES (27, 81, 1, 6060, 0, 0, N'', NULL, NULL, N'U', NULL, 0, NULL, 0)
INSERT [dbo].[ANSWER] ([Assessment_Id], [Answer_Id], [Is_Requirement], [Question_Or_Requirement_Id], [Component_Id], [Mark_For_Review], [Comment], [Alternate_Justification], [Question_Number], [Answer_Text], [Component_Guid], [Is_Component], [Custom_Question_Guid], [Is_Framework]) VALUES (27, 82, 1, 6063, 0, 0, N'', NULL, NULL, N'U', NULL, 0, NULL, 0)
INSERT [dbo].[ANSWER] ([Assessment_Id], [Answer_Id], [Is_Requirement], [Question_Or_Requirement_Id], [Component_Id], [Mark_For_Review], [Comment], [Alternate_Justification], [Question_Number], [Answer_Text], [Component_Guid], [Is_Component], [Custom_Question_Guid], [Is_Framework]) VALUES (27, 83, 0, 240, 0, 0, N'', NULL, NULL, N'U', NULL, 0, NULL, 0)
INSERT [dbo].[ANSWER] ([Assessment_Id], [Answer_Id], [Is_Requirement], [Question_Or_Requirement_Id], [Component_Id], [Mark_For_Review], [Comment], [Alternate_Justification], [Question_Number], [Answer_Text], [Component_Guid], [Is_Component], [Custom_Question_Guid], [Is_Framework]) VALUES (25, 84, 0, 240, 0, 0, N'', NULL, NULL, N'U', NULL, 0, NULL, 0)
SET IDENTITY_INSERT [dbo].[ANSWER] OFF
ALTER TABLE [dbo].[ANSWER] ADD  CONSTRAINT [DF_ANSWER_Is_Requirement]  DEFAULT ((0)) FOR [Is_Requirement]
GO
ALTER TABLE [dbo].[ANSWER] ADD  CONSTRAINT [DF_ANSWER_Component_Id]  DEFAULT ((0)) FOR [Component_Id]
GO
ALTER TABLE [dbo].[ANSWER] ADD  CONSTRAINT [DF_ANSWER_Answer_Text]  DEFAULT ('U') FOR [Answer_Text]
GO
ALTER TABLE [dbo].[ANSWER] ADD  CONSTRAINT [DF_ANSWER_Is_Component]  DEFAULT ((0)) FOR [Is_Component]
GO
ALTER TABLE [dbo].[ANSWER] ADD  CONSTRAINT [DF_ANSWER_Is_Framework]  DEFAULT ((0)) FOR [Is_Framework]
GO
ALTER TABLE [dbo].[ANSWER]  WITH NOCHECK ADD  CONSTRAINT [FK_ANSWER_Answer_Lookup] FOREIGN KEY([Answer_Text])
REFERENCES [dbo].[ANSWER_LOOKUP] ([Answer_Text])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[ANSWER] CHECK CONSTRAINT [FK_ANSWER_Answer_Lookup]
GO
ALTER TABLE [dbo].[ANSWER]  WITH CHECK ADD  CONSTRAINT [FK_ANSWER_ASSESSMENTS] FOREIGN KEY([Assessment_Id])
REFERENCES [dbo].[ASSESSMENTS] ([Assessment_Id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ANSWER] CHECK CONSTRAINT [FK_ANSWER_ASSESSMENTS]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Is Requirement is used to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ANSWER', @level2type=N'COLUMN',@level2name=N'Is_Requirement'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Question Or Requirement Id is used to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ANSWER', @level2type=N'COLUMN',@level2name=N'Question_Or_Requirement_Id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Component Id is used to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ANSWER', @level2type=N'COLUMN',@level2name=N'Component_Id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Mark For Review is used to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ANSWER', @level2type=N'COLUMN',@level2name=N'Mark_For_Review'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Comment is used to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ANSWER', @level2type=N'COLUMN',@level2name=N'Comment'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Alternate Justification is used to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ANSWER', @level2type=N'COLUMN',@level2name=N'Alternate_Justification'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Question Number is used to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ANSWER', @level2type=N'COLUMN',@level2name=N'Question_Number'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Answer Text is used to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ANSWER', @level2type=N'COLUMN',@level2name=N'Answer_Text'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Component Guid is used to' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ANSWER', @level2type=N'COLUMN',@level2name=N'Component_Guid'
GO
EXEC sys.sp_addextendedproperty @name=N'BELONGS_IN_EA', @value=N'YES' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ANSWER'
GO
