import { Component, Inject } from '@angular/core';
import { MAT_DIALOG_DATA, MatDialog, MatDialogRef } from '@angular/material/dialog';
import { HydroService } from '../../../services/hydro.service';
import { MalcolmUploadErrorComponent } from '../malcolm-upload-error.component';

@Component({
  selector: 'app-malcolm-instructions',
  templateUrl: './malcolm-instructions.component.html',
  styleUrls: ['./malcolm-instructions.component.scss']
})
export class MalcolmInstructionsComponent {

  constructor(
    @Inject(MAT_DIALOG_DATA) public data: any,
    public dialogRef: MatDialogRef<MalcolmInstructionsComponent>,
    private hydroSvc: HydroService,
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
                    this.openUploadErrorDialog(result);
                } else {
                    location.reload();
                }
            });
    }
}

openUploadErrorDialog(errorData: any) {
    let errorDialog = this.dialog.open(MalcolmUploadErrorComponent, {
        minHeight: '300px',
        minWidth: '400px',
        data: {
            error: errorData
        }
    });
}
}
