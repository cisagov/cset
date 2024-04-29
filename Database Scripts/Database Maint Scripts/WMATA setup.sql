---for all installations make sure the TSA zero row with group id of 84 is gone
--for WMATA we need to add it back in
INSERT INTO GALLERY_ROWS VALUES ('TSA', 0, 84)

UPDATE SETS SET Is_Displayed = 1 
WHERE Set_Name = 'WMATA' 
OR Set_Name = 'WMATA YR1'
OR Set_Name = 'WMATA YR2'
OR Set_Name = 'WMATA YR3'