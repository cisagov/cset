
CREATE VIEW [dbo].[Answer_Standards_InScope]
AS
		select distinct mode='Q', a.assessment_id, a.answer_id, is_requirement=0, a.question_or_requirement_id, a.mark_for_review, 
			a.comment, a.alternate_justification, a.question_number, a.answer_text, 
			a.component_guid, a.is_component, a.custom_question_guid,a.is_framework,a.old_answer_id, a.reviewed, a.FeedBack
			,c.Simple_Question as Question_Text
			FROM Answer_Questions_No_Components a 
			join NEW_QUESTION c on a.Question_Or_Requirement_Id = c.Question_Id			
			join (
				select distinct s.Question_Id, v.Assessment_Id as std_assessment_id
					from NEW_QUESTION_SETS s 
					join AVAILABLE_STANDARDS v on s.Set_Name = v.Set_Name 								
					join NEW_QUESTION_LEVELS l on s.New_Question_Set_Id = l.new_question_set_id
					where v.Selected = 1 
					and l.Universal_Sal_Level = (
						select ul.Universal_Sal_Level from STANDARD_SELECTION ss join UNIVERSAL_SAL_LEVEL ul on ss.Selected_Sal_Level = ul.Full_Name_Sal
						where Assessment_Id = v.Assessment_Id
					)
			)	s on c.Question_Id = s.Question_Id and s.std_assessment_id = a.Assessment_Id			
		union	
		select distinct mode='R', a.assessment_id, a.answer_id, is_requirement=1, a.question_or_requirement_id,a.mark_for_review, 
			a.comment, a.alternate_justification, a.question_number, a.answer_text, 
			a.component_guid, a.is_component, a.custom_question_guid, a.is_framework, a.old_answer_id, a.reviewed, a.FeedBack
			,req.Requirement_Text as Question_Text
			from Answer_Requirements a
				join REQUIREMENT_SETS rs on a.Question_Or_Requirement_Id = rs.Requirement_Id and a.is_requirement= 1
				join STANDARD_SELECTION ss on a.Assessment_Id = ss.assessment_id		
				join [SETS] s on rs.Set_Name = s.Set_Name
				join AVAILABLE_STANDARDS v on s.Set_Name = v.Set_Name and ss.assessment_id = v.assessment_id
				join NEW_REQUIREMENT req on rs.Requirement_Id = req.Requirement_Id
				join REQUIREMENT_LEVELS rl on rl.Requirement_Id = req.Requirement_Id and rl.Standard_Level=dbo.convert_sal(ss.Selected_Sal_Level)
			where v.selected=1 
