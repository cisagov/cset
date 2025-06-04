-- =============================================
-- Author:		Randy Woods
-- Create date: 11 November 2022
-- Description:	Get a generic answer distribution for an assessment
--              without having to worry about which answers it supports.
-- =============================================
CREATE PROCEDURE [dbo].[GetAnswerDistribMaturity]
	@assessment_id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- build list of answer options supported by the assessment's model
	declare @ao varchar(20)
	select @ao = answer_options
	from maturity_models mm
	left join AVAILABLE_MATURITY_MODELS amm on mm.Maturity_Model_Id = amm.model_id
	where amm.Assessment_Id = @assessment_id

	select * into #ao from STRING_SPLIT(@ao, ',')
	insert into #ao (value) values ('U')
	update #ao set value = TRIM(value)


	select a.Answer_Full_Name, a.Answer_Text, 
		isnull(m.qc,0) as [qc],
		isnull(m.Total,0) as [Total], 
		IsNull(Cast(IsNull(Round((Cast((qc) as float)/(IsNull(NullIf(Total,0),1)))*100, 2), 0) as float),0) as [Percent] 
	from 
	(select * from ANSWER_LOOKUP where Answer_Text in (select value from #ao)) a left join (
SELECT a.Answer_Text, isnull(count(question_or_requirement_id),0) qc , SUM(count(Question_Or_Requirement_Id)) OVER(PARTITION BY assessment_id) AS Total
			FROM Answer_Maturity a 
			join MATURITY_LEVELS l on a.Maturity_Level_Id = l.Maturity_Level_Id
			where a.Assessment_Id = @assessment_id and Is_Maturity = 1 
			group by a.Assessment_Id, a.Answer_Text)
			m on a.Answer_Text = m.Answer_Text		
	LEFT JOIN ANSWER_ORDER o on a.Answer_Text = o.answer_text
	order by o.answer_order

END
