_versionNum=10.3.0.0
 # Copies SQL files to dist/Data
 ECHO "Copying Database Files"
 # IF NOT EXIST "cset\dist\Data" MD "cset\dist\Data"
 # COPY /Y "cset\Database Images\" "cset\dist\Data"
 # ECHO Copying Database for Enterprise Binary Complete
 # Zip files into a folder in current directory
 ECHO "Zipping file to CSET_$_versionNum-Binary.zip"
 # "7zip\x64\7zr.exe" a -tzip "CSET_$_versionNum%-Binary.zip" "cset\dist"
 ECHO "Completed Enterprise Binary"
