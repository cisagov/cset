

CREATE PROCEDURE [dbo].[usp_Assessments_For_User]
@User_Id int
AS

-- Replaces view Assessments_For_User.  Gathering missing alt justification is
-- more straightforward using a procedure than a view.

-- build a temp table with ALT answers without justification
select distinct assessment_id 
into #ATM
from Answer_Standards_InScope
where (isnull(alternate_justification, '') = '' and answer_text = 'A')

insert into #ATM
select distinct assessment_id 
from Answer_Maturity
where (isnull(alternate_justification, '') = '' and answer_text = 'A')

insert into #ATM
select distinct assessment_id 
from Answer_Components_InScope
where (isnull(alternate_justification, '') = '' and answer_text = 'A')


select 	
    AssessmentId = a.Assessment_Id,
	AssessmentName = Assessment_Name,
	AssessmentDate = Assessment_Date,
	AssessmentCreatedDate,
	CreatorName = u.FirstName + ' ' + u.LastName,
	LastModifiedDate = LastAccessedDate,
	MarkedForReview = isnull(mark_for_review,0),
	case when a.assessment_id in (select assessment_id from #ATM) then CAST(1 AS BIT) else CAST(0 AS BIT) END as AltTextMissing,
	c.UserId
	from ASSESSMENTS a 
		join INFORMATION i on a.Assessment_Id = i.Id
		join USERS u on a.AssessmentCreatorId = u.UserId
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
		where u.UserId = @user_id
