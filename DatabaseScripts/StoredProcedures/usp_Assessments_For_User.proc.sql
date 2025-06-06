
CREATE PROCEDURE [dbo].[usp_Assessments_For_User]
@User_Id int
AS
SET NOCOUNT ON;

-- Replaces view Assessments_For_User.  Gathering missing alt justification is
-- more straightforward using a procedure than a view.

-- build a table variable with ALT answers without justification
declare @ATM table(assessment_id INT)

insert into @ATM
select distinct assessment_id 
from Answer_Standards_InScope
where (isnull(alternate_justification, '') = '' and answer_text = 'A')

insert into @ATM
select distinct assessment_id 
from Answer_Maturity
where (isnull(alternate_justification, '') = '' and answer_text = 'A')

insert into @ATM
select distinct assessment_id 
from Answer_Components_InScope
where (isnull(alternate_justification, '') = '' and answer_text = 'A')

select 	
    AssessmentId = a.Assessment_Id,
	AssessmentName = Assessment_Name,
	AssessmentDate = Assessment_Date,
	AssessmentCreatedDate,	
	LastModifiedDate,
	MarkedForReview = isnull(mark_for_review,0),
	UseDiagram,
	UseStandard,
	UseMaturity,	
	workflow,
	SelectedMaturityModel = m.Model_Name,
	iseSubmitted = i.Ise_Submitted,
	submittedDate = i.Submitted_Date,
	SelectedStandards = string_agg(s.Short_Name, ', '),
	case when a.assessment_id in (select assessment_id from @ATM) then CAST(1 AS BIT) else CAST(0 AS BIT) END as AltTextMissing,
	c.UserId
	from ASSESSMENTS a 
		join INFORMATION i on a.Assessment_Id = i.Id
		left join AVAILABLE_MATURITY_MODELS amm on amm.Assessment_Id = a.Assessment_Id
		left join MATURITY_MODELS m on m.Maturity_Model_Id = amm.model_id
		left join AVAILABLE_STANDARDS astd on astd.Assessment_Id = a.Assessment_Id
		left join SETS s on s.Set_Name = astd.Set_Name		
		join ASSESSMENT_CONTACTS c on a.Assessment_Id = c.Assessment_Id and c.UserId = @User_Id		
		left join (
			select distinct a.Assessment_Id, v.Mark_For_Review
			from ASSESSMENTS a 
			join Answer_Standards_InScope v on a.Assessment_Id = v.Assessment_Id 
			where v.Mark_For_Review = 1 

			union

			select distinct a.Assessment_Id, Mark_For_Review
			from ASSESSMENTS a
			join Answer_Maturity v on a.Assessment_id = v.Assessment_Id
			where v.Mark_For_Review = 1

			union 

			select distinct a.Assessment_Id, Mark_For_Review 
			from ASSESSMENTS a 
			join Answer_Components_InScope v on a.Assessment_Id = v.Assessment_Id 
			where v.Mark_For_Review = 1) b 
			
		on a.Assessment_Id = b.Assessment_Id
		where c.UserId = @User_Id
		group by a.Assessment_Id, Assessment_Name, Assessment_Date, AssessmentCreatedDate, 
					LastModifiedDate, mark_for_review, UseDiagram,
					UseStandard, UseMaturity, Workflow, Model_Name, 
					Ise_Submitted, Submitted_Date, c.UserId



					

					
