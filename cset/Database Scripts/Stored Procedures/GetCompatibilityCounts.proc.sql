CREATE PROCEDURE [dbo].[GetCompatibilityCounts]
@assessment_id int
AS
BEGIN
	SET NOCOUNT ON;
	
		select a.IntersectionType, CommonValues, Total, (cast(CommonValues as float)/Total)*100 as Compatibility from (
			select IntersectionType,count(Question_or_Requirement_Id) as CommonValues from (
				SELECT IntersectionType='Question', Question_Or_Requirement_Id,count(Assessment_Id) as inFiles
				FROM dbo.Answer_Questions where assessment_id = @assessment_id
				group by Question_Or_Requirement_Id
				having count(Assessment_Id) = (select count(af.Assessment_Id) from ASSESSMENT_FILES af)
				union
				SELECT IntersectionType='Requirement', Question_Or_Requirement_Id,count(Assessment_Id) as inFiles
				FROM dbo.Answer_Requirements where assessment_id = @assessment_id
				group by Question_Or_Requirement_Id
				having count(Assessment_Id) = (select count(af.Assessment_Id) from ASSESSMENT_FILES af)				
				) c
				group by IntersectionType
		  ) a join (		
		select case Is_Requirement
					WHEN 1 THEN 'Requirement'
					ELSE 'Question' 
			END   as IntersectionType,
			COUNT(Is_Requirement) as Total
			FROM (select distinct Is_Requirement,Question_or_Requirement_id from [dbo].[ANSWER] where assessment_id = @assessment_id) a
		  group by Is_Requirement) b on a.IntersectionType = b.IntersectionType



END
