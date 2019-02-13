USE [CSETWeb]
GO
/****** Object:  StoredProcedure [dbo].[usp_BuildCatNumbers]    Script Date: 11/14/2018 3:57:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		hansbk
-- Create date: 8/30/2018
-- Description:	number stored proc
-- =============================================
CREATE PROCEDURE [dbo].[usp_BuildCatNumbers]
	@assessment_id int
AS
BEGIN
	--SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
  --SELECT @NumRowsChanged = @@ROWCOUNT only call
  --if rowcount from the previous was actually greater than zeror
  --to eliminate unnecessary calls
  declare @ApplicationMode varchar(100)  
  declare @answer_id int, @question_group_heading_id int, @next int, @previousH int

	exec GetApplicationModeDefault @assessment_id,@applicationmode output
	if(@ApplicationMode = 'Questions Based')
		begin					
		set @next = 1; 
		set @previousH = 0; 
		declare me cursor Fast_forward
		for select a.Answer_Id,h.Question_Group_Heading_Id
			from Answer_Questions a join NEW_QUESTION q on a.Question_Or_Requirement_Id = q.Question_Id
			join UNIVERSAL_SUB_CATEGORY_HEADINGS h on q.Heading_Pair_Id = h.Heading_Pair_Id			
			join vQUESTION_HEADINGS hh on h.Heading_Pair_Id = hh.Heading_Pair_Id
			where a.Assessment_Id = @assessment_id
			order by hh.Question_Group_Heading,hh.Universal_Sub_Category,q.Question_Id		

		OPEN me
		FETCH NEXT FROM me into @answer_id,@question_group_heading_id

		WHILE @@FETCH_STATUS = 0  
		BEGIN  
			  if(@question_group_heading_id <> @previousH) set @next = 1
			  update ANSWER set Question_Number = @next where Answer_Id=@answer_id
			  
			  set @next = @next +1
			  set @previousH = @question_group_heading_id
			  FETCH NEXT FROM me into @answer_id,@question_group_heading_id
		END 

		close me
		deallocate me
		end
	else
	begin
		
		declare @standard_category varchar(250), @previous_std varchar(250)
		set @next = 1; 
		set @previousH = 0; 
		declare me cursor Fast_forward
		for select a.Answer_Id, q.Standard_Category
			from Answer_Requirements a join NEW_REQUIREMENT q on a.Question_Or_Requirement_Id = q.Requirement_Id			
		--	join REQUIREMENT_SETS r on q.Requirement_Id = r.Requirement_Id
			where a.Assessment_Id = @assessment_id
			order by q.Standard_Category,q.Standard_Sub_Category--,r.Requirement_Sequence

		OPEN me
		FETCH NEXT FROM me into @answer_id,@standard_category

		WHILE @@FETCH_STATUS = 0  
		BEGIN  
			  if(@standard_category <> @previous_std) set @next = 1
			  update ANSWER set Question_Number = @next where Answer_Id=@answer_id
			  
			  set @next = @next +1
			  set @previous_std = @standard_category
			  FETCH NEXT FROM me into @answer_id,@standard_category
		END 

		close me
		deallocate me
	end   
END
GO
