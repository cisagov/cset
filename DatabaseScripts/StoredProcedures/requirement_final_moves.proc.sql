
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[requirement_final_moves]	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   update QUESTION_REQUIREMENT_SUPPLEMENTAL set Weight = s.weight from(
	SELECT r.Requirement_Id,nq.Weight
	  FROM 
	  QUESTION_REQUIREMENT_SUPPLEMENTAL r 
	  join REQUIREMENT_QUESTIONS_SETS rq on r.Requirement_Id=rq.Question_Id
	  join NEW_QUESTION nq on rq.Question_Id = nq.Question_Id
	  ) s
	  where QUESTION_REQUIREMENT_SUPPLEMENTAL.Requirement_Id = s.requirement_id

	update QUESTION_REQUIREMENT_SUPPLEMENTAL set Weight = 1 where Weight = 0;
	update QUESTION_REQUIREMENT_SUPPLEMENTAL set Weight = 1 where Weight is null;
	
	IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[View_Alts]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
		DROP TABLE [dbo].[View_Alts]
		
select distinct a.Requirement_Id,r.Question_Id,a.Top_U,b.User_Number,b.Top_Answer_User_Number,Alt_Text into dbo.VIEW_ALTS from 
	(SELECT Top_U,ru.User_Number,ru.REQUIREMENT_id,ru.Is_Alt
	  FROM [CSET_Control].[dbo].[REQUIREMENT_USER_NUMBERS] ru join OLD_CONTAINERS o on ru.User_Number = o.User_Number
	  where Is_Alt = 0
	  ) a
	join (
	SELECT Requirement_Title,Top_U,ru.User_Number,ru.Top_Answer_User_Number, ru.REQUIREMENT_id,ru.Is_Alt,ru.Alt_Text
	  FROM [CSET_Control].[dbo].[REQUIREMENT_USER_NUMBERS] ru join OLD_CONTAINERS o on ru.User_Number = o.User_Number
	  join QUESTION_REQUIREMENT_SUPPLEMENTAL r on ru.Requirement_Id = r.Requirement_Id  
	where Is_Alt=1) b on a.Requirement_Id = b.Requirement_Id
	join REQUIREMENT_QUESTIONS_SETS r on a.Requirement_Id = r.Requirement_Id
	
	
ALTER TABLE [dbo].[VIEW_ALTS] ADD CONSTRAINT [PK_VIEW_ALTS] PRIMARY KEY CLUSTERED  ([Requirement_Id], [Question_Id], [Top_U], [User_Number])

END
