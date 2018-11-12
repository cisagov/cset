------------
-- Cleans out all custom sets/questions/requirements
------------


IF OBJECT_ID('tempdb..#custom_sets') IS NOT NULL DROP TABLE #custom_sets
select [set_name] 
into #custom_sets
from sets where Is_Custom = 1


delete NEW_QUESTION where [Original_Set_Name] in (select [set_name] from #custom_sets)

delete NEW_REQUIREMENT where [Original_Set_Name] in (select [set_name] from #custom_sets)

delete SETS where Is_Custom = 1


-- Requirement IDs above 1 million are reserved for custom standards
DBCC CHECKIDENT ('[NEW_REQUIREMENT]', RESEED, 1000000);
DBCC CHECKIDENT ('[NEW_QUESTION]', RESEED, 1000000);

