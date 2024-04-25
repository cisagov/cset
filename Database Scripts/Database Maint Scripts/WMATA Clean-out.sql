---for all installations make sure the TSA zero row with group id of 84 is gone
--for WMATA we need to add it back in
delete GALLERY_ROWS where Layout_Name = 'TSA' and Row_Index = 0 and Group_Id = 84