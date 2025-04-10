CREATE VIEW [dbo].[METRIC_ENTRY_QUESTIONS]
AS
select requirement_id as question_or_requirement_id ,'Requirement' as Question_type from NEW_REQUIREMENT 
where requirement_id in (36409, 36417, 36419, 36429, 36439, 36442, 36444, 36445, 36479, 36484, 36487, 36491, 36494, 36497, 36503)
union
select Mat_Question_Id as question_or_requirement_id,'Maturity' from MATURITY_QUESTIONS
where Mat_Question_Id in (1920, 1925, 1937, 1938, 1939)
