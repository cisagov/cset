USE [CSETWeb]
GO
/****** Object:  View [dbo].[Answer_Questions_No_Components]    Script Date: 11/14/2018 3:57:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[Answer_Questions_No_Components]
AS
SELECT        Answer_Id, Assessment_Id, Mark_For_Review, Comment, Alternate_Justification, Is_Requirement, 
                         Question_Or_Requirement_Id, Component_Id, Question_Number, Answer_Text, Component_Guid, Is_Component, 
                         Is_Framework
FROM            dbo.ANSWER
WHERE        (Is_Requirement = 0) and Is_Component = 0


GO
