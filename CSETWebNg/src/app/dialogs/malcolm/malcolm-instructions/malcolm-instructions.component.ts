import { Component, Inject } from '@angular/core';
import { MAT_DIALOG_DATA, MatDialog, MatDialogRef } from '@angular/material/dialog';
import { HydroService } from '../../../services/hydro.service';
import { MalcolmUploadErrorComponent } from '../malcolm-upload-error.component';
import { MalcolmService } from '../../../services/malcolm.service';

@Component({
  selector: 'app-malcolm-instructions',
  templateUrl: './malcolm-instructions.component.html',
  styleUrls: ['./malcolm-instructions.component.scss']
})
export class MalcolmInstructionsComponent {
    iperror: boolean;

  constructor(
    @Inject(MAT_DIALOG_DATA) public data: any,
    public dialogRef: MatDialogRef<MalcolmInstructionsComponent>,
    private hydroSvc: HydroService,
    private malcolmSvc: MalcolmService,
    private dialog: MatDialog
  ) { }

  iconClass: string = "cset-icons-bell";
  dialogTitle: string = "Upload Error(s)";
  malcolmFiles: File[];

  uploadMalcolmData(event: any) {
    this.malcolmFiles = event.target.files;

    if (this.malcolmFiles) {
        this.hydroSvc.uploadMalcolmFiles(this.malcolmFiles).subscribe(
            (result) => {
                if (result != null) {
                    this.openUploadErrorDialog(result, true);
                } else {
                    location.reload();
                }
            });
        }
    }

    openUploadErrorDialog(errorData: any, isFile: boolean) {
        let errorDialog = this.dialog.open(MalcolmUploadErrorComponent, {
            minHeight: '300px',
            minWidth: '400px',
            data: {
                error: errorData,
                isFile: isFile
            }
        });
    }

    ipRegEx = new RegExp("^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$");
    validateIP(ipAddress){
        if(ipAddress==""){
            this.iperror = false; 
            return;
        }
        if(this.ipRegEx.test(ipAddress)){
            this.iperror = false;            
        }
        else{
            this.iperror = true; 
        }
    }
    attemptToImportFromMalcolm(ipAddress: string) {
        if(this.ipRegEx.test(ipAddress)){
            this.iperror = false;
            this.malcolmSvc.attemptToImportFromMalcolm(ipAddress).subscribe(
                (result) => {
                    if (result != null) {
                        this.openUploadErrorDialog(result, false);
                    } else {
                        location.reload();
                    }
                });
        }
        else{
            this.iperror = true; 
        }
        
        
    }
}
