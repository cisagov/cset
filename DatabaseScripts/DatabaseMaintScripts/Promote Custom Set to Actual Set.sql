--first clean out non migrating sets from sql19dev1 then pull the data down to 
--the local machine
--THEN MUST REMOVE IDENTITY DEFINITION AND THEN PUT BACK AFTER THIS IS DONE
--FOR BOTH new_question and new_requirement
​
select * from sets
​
declare @oldName varchar(150), @newName varchar(150)
Set @oldName = 'SET.20210831.165809'
set @newName = 'FAA_PED_V2'
​
update new_question set original_set_name = @newName, std_ref = @newName where original_set_name = @oldName
update new_requirement set original_set_name = @newName where original_set_name = @oldName
update dbo.[sets] set set_name = @newName where set_name = @oldName
update dbo.[sets] set Is_Custom=0 where set_name = @newName
​
--next update the question_id's 
​
declare @nextId int, @oldId int
select @nextId = max(question_id) from new_question where question_id < 1000000
​
declare me cursor for 
select question_id from new_question where original_set_name = @newName order by question_id
​
OPEN me
FETCH NEXT FROM me INTO @oldId
set @nextId = @nextId + 1
WHILE @@FETCH_STATUS = 0  
BEGIN  
      update new_question set question_id = @nextId where question_id = @oldId
​
	  set @nextId = @nextId + 1
      FETCH NEXT FROM me into @oldId
END 
​
CLOSE me  
DEALLOCATE me
​
​
select @nextId = max(requirement_id) from new_requirement where requirement_id < 1000000
​
declare me cursor for 
select requirement_id from new_requirement where original_set_name = @newName order by requirement_id
​
OPEN me
FETCH NEXT FROM me INTO @oldId
set @nextId = @nextId + 1
WHILE @@FETCH_STATUS = 0  
BEGIN  
      update new_requirement set requirement_id = @nextId where requirement_id = @oldId
​
	  set @nextId = @nextId + 1
      FETCH NEXT FROM me into @oldId
END 
​
CLOSE me  
DEALLOCATE me
​
/*
declare @maxid int
select @maxid = max(requirement_id) from new_requirement
DBCC CHECKIDENT ('[NEW_REQUIREMENT]', RESEED, @maxid);
select @maxid = max(question_id) from new_question
DBCC CHECKIDENT ('[NEW_QUESTION]', RESEED, @maxid);
​
delete NEW_QUESTION where Question_Id > 1000000
select * from NEW_REQUIREMENT
*/
​
select * from SETS