
CREATE VIEW [dbo].[Answer_InScope]
AS

select question_or_requirement_id, is_component, is_requirement, assessment_id from [dbo].[Answer_Standards_InScope]
union 
select Question_Or_Requirement_Id, Is_Component, Is_Requirement, assessment_id from [dbo].[Answer_Components_InScope]
