
-- =============================================
-- Author:		Randy
-- Create date: 19-NOV-2024
-- Description:	Determine a "global" sequence for all maturity groupings in context.
-- This is needed because a child grouping may start its sequencing at 1, which would
-- put it ahead of its parent with a simple sort by sequence.
--
-- All groupings with their global sequence are stored in [MATURITY_GLOBAL_SEQUENCES].
--
-- It can currently handle a grouping structure depth of 4.  This can be expanded in the future if needed.
-- =============================================
CREATE PROCEDURE [dbo].[analytics_SequenceMaturityGroups]
AS
BEGIN
	SET NOCOUNT ON;
	
	DELETE FROM [MATURITY_GLOBAL_SEQUENCES]


	DECLARE seq_cursor CURSOR FOR
		select g1.Maturity_Model_Id, 
			ROW_NUMBER() over (order by (select null)) as global_sequence, 
			g1.grouping_Id as [g1], g2.grouping_id as [g2], g3.grouping_id as [g3], g4.grouping_id as [g4]
		from [MATURITY_GROUPINGS] g1
		left join [MATURITY_GROUPINGS] g2 on g2.parent_id = g1.grouping_id
		left join [MATURITY_GROUPINGS] g3 on g3.parent_id = g2.grouping_id
		left join [MATURITY_GROUPINGS] g4 on g4.parent_id = g3.grouping_id
		where g1.parent_id is null
			and (g1.Maturity_Model_Id = g2.Maturity_Model_Id or g2.Maturity_Model_Id is null)
			and (g2.Maturity_Model_Id = g3.Maturity_Model_Id or g3.Maturity_Model_Id is null)
			and (g3.Maturity_Model_Id = g4.Maturity_Model_Id or g4.Maturity_Model_Id is null)
		order by g1.maturity_model_id, g1.sequence, g2.sequence, g3.sequence, g4.sequence;


	DECLARE @Maturity_Model_Id int, @global_sequence int, @g1 int, @g2 int, @g3 int, @g4 int;

	OPEN seq_cursor;

	FETCH NEXT FROM seq_cursor INTO @Maturity_Model_Id, @global_sequence, @g1, @g2, @g3, @g4

	WHILE @@FETCH_STATUS = 0
	BEGIN
		INSERT INTO [MATURITY_GLOBAL_SEQUENCES](
		[Maturity_Model_Id], [global_sequence], [g1], [g2], [g3], [g4])
		values (@Maturity_Model_Id, @global_sequence, @g1, @g2, @g3, @g4)

		FETCH NEXT FROM seq_cursor into @Maturity_Model_Id, @global_sequence, @g1, @g2, @g3, @g4
	END

	CLOSE seq_cursor;
	DEALLOCATE seq_cursor;
END

