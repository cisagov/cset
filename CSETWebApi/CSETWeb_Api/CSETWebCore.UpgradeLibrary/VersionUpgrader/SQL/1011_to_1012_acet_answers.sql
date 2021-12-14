--update answers to new ids
update answer set answer.question_or_requirement_id = FINANCIAL_REQUIREMENTS.maturity_question_id, Question_Type = 'Maturity'  from FINANCIAL_REQUIREMENTS 
where Question_Or_Requirement_Id=requirement_id and Is_Requirement = 1
--leave the old answers (in case there is information there) but only copy over the questions that 
--don't already have an answer from requirements
GO
update answer set answer.question_or_requirement_id = A.maturity_question_id, Question_Type = 'Maturity' 
from (select a.Assessment_Id, a.question_id,A.maturity_question_id from (select * from answer join FINANCIAL_QUESTIONS on Question_Or_Requirement_Id=Question_Id where question_type = 'Question') A
left join (select * from answer join FINANCIAL_REQUIREMENTS on Question_Or_Requirement_Id=maturity_question_id where question_type = 'Maturity') B
on a.maturity_question_id = b.maturity_question_id and a.Assessment_Id=b.Assessment_Id
where b.maturity_question_id is null) A
where a.Assessment_Id=ANSWER.Assessment_Id and Question_Or_Requirement_Id=question_id and question_type = 'Question'
GO
select * from (select * from answer join FINANCIAL_QUESTIONS on Question_Or_Requirement_Id=Question_Id where question_type = 'Question') A
left join (select * from answer join FINANCIAL_REQUIREMENTS on Question_Or_Requirement_Id=maturity_question_id where question_type = 'Maturity') B
on a.maturity_question_id = b.maturity_question_id and a.Assessment_Id=b.Assessment_Id
where b.maturity_question_id is null
GO
update STANDARD_SELECTION set Application_Mode = 'Maturity' where assessment_id in (
select distinct s.Assessment_Id from STANDARD_SELECTION s join AVAILABLE_STANDARDS a on s.Assessment_Id=a.Assessment_Id
where Set_Name = 'ACET_V1' and selected = 1)
GO
update ASSESSMENTS set UseMaturity = 1 where Assessment_Id in (select distinct Assessment_Id from AVAILABLE_STANDARDS where Set_Name = 'ACET_V1' and selected = 1)
update INFORMATION set IsAcetOnly = 1 where Id in (select distinct Assessment_Id from AVAILABLE_STANDARDS where Set_Name = 'ACET_V1' and selected = 1)
INSERT INTO [dbo].[AVAILABLE_MATURITY_MODELS] ([Assessment_Id],[Selected],[model_id])
select Assessment_Id,1,1 from AVAILABLE_STANDARDS where Set_Name = 'ACET_V1' and selected = 1



