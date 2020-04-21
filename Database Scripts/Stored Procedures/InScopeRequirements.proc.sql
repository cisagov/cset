-- =============================================
-- Author:		Randy Woods
-- Create date: 15-May-2020
-- Description:	Returns a list of Requirement IDs that are
--              'in scope' for an Assessment based on assessment mode,
--              standard selection and SAL.
-- =============================================
CREATE PROCEDURE [dbo].[InScopeRequirements]
	@assessment_id int
AS
BEGIN
select s.Requirement_Id from requirement_sets s 
	join AVAILABLE_STANDARDS av on s.Set_Name=av.Set_Name
	join REQUIREMENT_LEVELS rl on s.Requirement_Id = rl.Requirement_Id
where av.Selected = 1 and av.Assessment_Id = @Assessment_Id
	and rl.Level_Type = 'NST'
	and rl.Standard_Level = (
	select ul.Universal_Sal_Level from STANDARD_SELECTION ss join UNIVERSAL_SAL_LEVEL ul on ss.Selected_Sal_Level = ul.Full_Name_Sal
	where Assessment_Id = @assessment_id 
	)	
END



