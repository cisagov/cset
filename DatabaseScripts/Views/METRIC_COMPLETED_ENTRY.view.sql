CREATE VIEW [dbo].[METRIC_COMPLETED_ENTRY]
AS
select distinct assessment_id from (
select  *, sum(ac) over (partition by assessment_id) totalAC from (
select an.assessment_id, Answer_Text,count(answer_Text) ac, SUM(count(answer_Text)) OVER(partition by an.assessment_id) AS total_count
from assessments a 
join  ANSWER an on a.Assessment_Id=an.Assessment_Id
join METRIC_ENTRY_QUESTIONS q on an.Question_Or_Requirement_Id=q.question_or_requirement_id and an.Question_Type=q.question_type
where GalleryItemGuid = '9219F73D-A9EC-4E13-B884-CA1677BAC576'
group by an.assessment_id, Answer_Text) test
where total_count = 20 and Answer_Text <> 'U' ) partD
where totalAC = 20

