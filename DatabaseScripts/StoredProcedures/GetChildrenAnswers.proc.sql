-- =============================================
-- Author:      <Author,,Name>
-- Create date: <Create Date,,>
-- Description: <Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetChildrenAnswers]
   @Parent_Id int,
   @Assess_Id int
  
AS
BEGIN
   SET NOCOUNT ON;
   SELECT [Mat_Question_Id], [Question_Title], [Question_Text],
          [Answer_Text], [Maturity_Level_Id], [Parent_Question_Id],
          [Ranking], [Grouping_Id] FROM MATURITY_QUESTIONS
       JOIN ANSWER
       ON MATURITY_QUESTIONS.Mat_Question_Id = ANSWER.Question_Or_Requirement_Id
   WHERE ([Parent_Question_Id] = @Parent_Id) AND ([Assessment_Id] = @Assess_Id)
END
