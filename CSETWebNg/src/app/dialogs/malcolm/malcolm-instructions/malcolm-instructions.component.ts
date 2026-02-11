////////////////////////////////
//
//   Copyright 2026 Battelle Energy Alliance, LLC
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//
////////////////////////////////
import { Component, Inject } from '@angular/core';
import { MAT_DIALOG_DATA, MatDialog, MatDialogRef } from '@angular/material/dialog';
import { MalcolmUploadErrorComponent } from '../malcolm-upload-error.component';
import { MalcolmService } from '../../../services/malcolm.service';
import { DiagramService } from '../../../services/diagram.service';

@Component({
    selector: 'app-malcolm-instructions',
    templateUrl: './malcolm-instructions.component.html',
    styleUrls: ['./malcolm-instructions.component.scss'],
    standalone: false
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
            this.malcolmSvc.uploadMalcolmFiles(this.malcolmFiles).subscribe(
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
