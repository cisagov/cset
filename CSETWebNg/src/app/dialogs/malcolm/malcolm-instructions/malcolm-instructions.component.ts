import { Component, Inject } from '@angular/core';
import { MAT_DIALOG_DATA, MatDialog, MatDialogRef } from '@angular/material/dialog';
import { HydroService } from '../../../services/hydro.service';
import { MalcolmUploadErrorComponent } from '../malcolm-upload-error.component';
import { MalcolmService } from '../../../services/malcolm.service';
import { DiagramService } from '../../../services/diagram.service';

@Component({
    selector: 'app-malcolm-instructions',
    templateUrl: './malcolm-instructions.component.html',
    styleUrls: ['./malcolm-instructions.component.scss']
})
export class MalcolmInstructionsComponent {
    iperror: boolean;
    iconClass: string = "cset-icons-bell";
    dialogTitle: string = "Upload Error(s)";
    malcolmFiles: File[];

    /**
     * 
     */
    constructor(
        @Inject(MAT_DIALOG_DATA) public data: any,
        public dialogRef: MatDialogRef<MalcolmInstructionsComponent>,
        private hydroSvc: HydroService,
        private malcolmSvc: MalcolmService,
        private diagramSvc: DiagramService,
        private dialog: MatDialog
    ) { }


    /**
     * 
     */
    async uploadMalcolmData(event: any) {
        this.malcolmFiles = event.target.files;

        if (this.malcolmFiles) {
            this.hydroSvc.uploadMalcolmFiles(this.malcolmFiles).subscribe(
                async (result) => {
                    if (result != null) {
                        this.openUploadErrorDialog(result, true);
                    } else {
                        this.dialog.closeAll();
                        await this.diagramSvc.obtainDiagram();
                    }
                });
        }
    }

    /**
     */
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

    /**
     * 
     */
    validateIP(ipAddress) {
        if (ipAddress == "") {
            this.iperror = false;
            return;
        }
        if (this.ipRegEx.test(ipAddress)) {
            this.iperror = false;
        }
        else {
            this.iperror = true;
        }
    }

    /**
     * 
     */
    async attemptToImportFromMalcolm(ipAddress: string) {
        if (this.ipRegEx.test(ipAddress)) {
            this.iperror = false;
            this.malcolmSvc.attemptToImportFromMalcolm(ipAddress).subscribe(
                async (result) => {
                    if (result != null) {
                        this.openUploadErrorDialog(result, false);
                    } else {
                        this.dialog.closeAll();
                        await this.diagramSvc.obtainDiagram();
                    }
                });
        }
        else {
            this.iperror = true;
        }
    }
}
