-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetMaturityGroupings]
	@ModelID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   
select 
g1.grouping_id as [Group1_ID], g1.title as [Group1_Title], (select grouping_type_name from maturity_grouping_types where type_id = g1.Type_Id) as [Group1_Type], 
g2.grouping_id as [Group2_ID], g2.title as [Group2_Title], (select grouping_type_name from maturity_grouping_types where type_id = g2.Type_Id) as [Group2_Type], 
g3.grouping_id as [Group3_ID], g3.title as [Group3_Title], (select grouping_type_name from maturity_grouping_types where type_id = g3.Type_Id) as [Group3_Type], 
g4.grouping_id as [Group4_ID], g4.title as [Group4_Title], (select grouping_type_name from maturity_grouping_types where type_id = g4.Type_Id) as [Group4_Type], 
g5.grouping_id as [Group5_ID], g5.title as [Group5_Title], (select grouping_type_name from maturity_grouping_types where type_id = g5.Type_Id) as [Group5_Type] 
from maturity_groupings g1
left join maturity_groupings g2 on g2.parent_id = g1.grouping_id
left join maturity_groupings g3 on g3.parent_id = g2.grouping_id
left join maturity_groupings g4 on g4.parent_id = g3.grouping_id
left join maturity_groupings g5 on g5.parent_id = g4.grouping_id
where g1.maturity_model_id = @modelid 
and g1.Parent_Id is null
and (g2.Maturity_Model_Id = @modelid or g2.Maturity_Model_Id is null)
and (g3.Maturity_Model_Id = @modelid or g3.Maturity_Model_Id is null)
and (g4.Maturity_Model_Id = @modelid or g4.Maturity_Model_Id is null)
and (g5.Maturity_Model_Id = @modelid or g5.Maturity_Model_Id is null)
order by g1.sequence, g2.sequence, g3.sequence, g4.sequence, g5.sequence

END
