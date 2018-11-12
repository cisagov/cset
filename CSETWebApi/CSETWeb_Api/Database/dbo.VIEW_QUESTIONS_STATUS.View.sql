USE [CSETWeb]
GO
/****** Object:  View [dbo].[VIEW_QUESTIONS_STATUS]    Script Date: 6/28/2018 8:21:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VIEW_QUESTIONS_STATUS]
AS
SELECT        dbo.ANSWER.Question_Or_Requirement_Id,
						 CAST(CASE WHEN dbo.ANSWER.Comment IS NULL THEN 0 ELSE 1 END AS bit) AS HasComment, 
                         CAST(CASE WHEN dbo.ANSWER.Mark_For_Review IS NULL THEN 0 ELSE dbo.ANSWER.Mark_For_Review END AS bit) AS MarkForReview, 
						 CAST(CASE WHEN d .docnum IS NULL THEN 0 ELSE 1 END AS bit) AS HasDocument, 
						 ISNULL(d.docnum, 0) AS docnum, 
						 CAST(CASE WHEN f.findingnum IS NULL THEN 0 ELSE 1 END AS bit) AS HasDiscovery, 
						 ISNULL(f.findingnum, 0) AS findingnum, 
						 dbo.ANSWER.Assessment_Id, 
						 dbo.ANSWER.Answer_Id
FROM            dbo.ANSWER LEFT OUTER JOIN
                             (SELECT        Answer_Id, COUNT(Document_Id) AS docnum
                               FROM            dbo.DOCUMENT_ANSWERS
                               GROUP BY Answer_Id) AS d ON dbo.ANSWER.Answer_Id = d.Answer_Id LEFT OUTER JOIN
                             (SELECT        Answer_Id, COUNT(Finding_Id) AS findingnum
                               FROM            dbo.FINDING
                               GROUP BY Answer_Id) AS f ON dbo.ANSWER.Answer_Id = f.Answer_Id
GO
