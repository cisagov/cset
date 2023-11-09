------------
-- Cleans out all custom sets/questions/requirements
------------
SET QUOTED_IDENTIFIER ON

IF OBJECT_ID('tempdb..#custom_sets') IS NOT NULL DROP TABLE #custom_sets
select [set_name] 
into #custom_sets
from sets where Is_Custom = 1


delete NEW_QUESTION where [Original_Set_Name] in (select [set_name] from #custom_sets)

delete NEW_REQUIREMENT where [Original_Set_Name] in (select [set_name] from #custom_sets)

delete SETS where Is_Custom = 1

delete NEW_QUESTION_LEVELS where New_Question_Set_Id not in (select new_question_set_id from NEW_QUESTION_SETS)

delete CUSTOM_STANDARD_BASE_STANDARD

DBCC CHECKIDENT ('[CUSTOM_STANDARD_BASE_STANDARD]', RESEED, 1);

-- Identity columns above 1 million are reserved for custom standards
DBCC CHECKIDENT ('[NEW_REQUIREMENT]', RESEED, 1000000);

DBCC CHECKIDENT ('[NEW_QUESTION]', RESEED, 1000000);
DBCC CHECKIDENT ('[NEW_QUESTION_SETS]', RESEED, 1000000);
DBCC CHECKIDENT ('[UNIVERSAL_SUB_CATEGORY_HEADINGS]', RESEED, 1000000);
DBCC CHECKIDENT ('[UNIVERSAL_SUB_CATEGORIES]', RESEED, 1000000);
