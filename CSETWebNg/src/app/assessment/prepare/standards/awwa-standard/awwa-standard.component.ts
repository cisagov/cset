import { Component, OnInit } from '@angular/core';
import { FileUploadClientService } from '../../../../services/file-client.service';

@Component({
  selector: 'app-awwa-standard',
  templateUrl: './awwa-standard.component.html'
})
export class AwwaStandardComponent implements OnInit {

  constructor(
    public fileSvc: FileUploadClientService
  ) { }

  ngOnInit() {
  }

  /**
   * Reads the contents of the event's file.
   * @param e The 'file' event
   */
  fileSelectAwwa(e: any) {
    const file: any = e.target.files[0];

    const options = {
      methodology: "AWWA"
    };
    this.fileSvc.uploadSpreadsheet(file, options).subscribe(result => {
      console.log(result);
      // probably pop an alert here confirming the upload
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
}
