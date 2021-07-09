_versionNum=10.3.0.0
 # Copies SQL files to dist/Data
 ECHO "Copying Database Files"
 # IF NOT EXIST "cset\dist\Data" MD "cset\dist\Data"
 mkdir -p "/dist/Data"
 # COPY /Y "cset\Database Images\" "cset\dist\Data"
 cp -r "cset/Database Images/" "/dist/Data"
 ECHO Copying Database for Enterprise Binary Complete
 # Zip files into a folder in current directory
 ECHO "Zipping file to CSET_$_versionNum-Binary.zip"
 ./"7zip/7z.exe" a -tzip "zipped_binaries/CSET_$_versionNum-Binary.zip" "./dist"
 ECHO "Completed Enterprise Binary"
