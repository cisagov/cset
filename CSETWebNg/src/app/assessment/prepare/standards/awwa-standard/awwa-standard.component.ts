import { Component, EventEmitter, OnInit, Output } from '@angular/core';
import { MatDialogRef } from '@angular/material/dialog';
import { FileUploadClientService } from '../../../../services/file-client.service';

@Component({
  selector: 'app-awwa-standard',
  templateUrl: './awwa-standard.component.html'
})
export class AwwaStandardComponent implements OnInit {

  // 1 - before upload
  // 2 - uploading/importing data
  // 3 - import complete
  importStatus = 1;
  errorMessage: string = "";

  constructor(
    public dialogRef: MatDialogRef<AwwaStandardComponent>,
    public fileSvc: FileUploadClientService
  ) { }

  ngOnInit() {
  }

  /**
   * 
   */
  openAwwaSite() {
    this.dialogRef.close();
    window.open('http://www.awwa.org/cyber');
  }

  /**
   * Reads the contents of the event's file.
   * @param e The 'file' event
   */
  fileSelectAwwa(e: any) {
    const file: any = e.target.files[0];

    this.importStatus = 2;

    const options = {
      methodology: "AWWA"
    };
    this.fileSvc.uploadAwwaSpreadsheet(file, options).subscribe(result => {
      // pop an alert here confirming the upload
      if (result.hasOwnProperty('ok')) {
        this.importStatus = 3;
      }
    }, 
    err=>{
      this.errorMessage = "Error importing excel.  Check that AWWA file is valid."; 
      this.importStatus = 1; 
    });
  }

  /**
 * Programatically clicks the corresponding file upload element.
 * @param event
 */
  openFileBrowser(event: any) {
    event.preventDefault();
    const element: HTMLElement = document.getElementById('awwaUpload') as HTMLElement;
    element.click();
  }

  /**
   * 
   */
  close() {
    this.dialogRef.close();
  }
}
