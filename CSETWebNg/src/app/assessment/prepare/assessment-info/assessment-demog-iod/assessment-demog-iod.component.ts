import { Component, ViewChild } from '@angular/core';
import { Subject } from 'rxjs';
import { DemographicService } from '../../../../services/demographic.service';
import { MatDialog } from '@angular/material/dialog';
import { UploadDemographicsComponent } from "../../../../dialogs/import demographics/import-demographics.component";
import { AuthenticationService } from '../../../../services/authentication.service';
import { UploadExportComponent } from "../../../../dialogs/upload-export/upload-export.component";
import { AssessmentService } from '../../../../services/assessment.service';


interface ImportExportData {
  flag: string;
  data: any;
}

@Component({
  selector: 'app-assessment-demog-iod',
  templateUrl: './assessment-demog-iod.component.html',
  styleUrls: ['./assessment-demog-iod.component.scss']
})


export class AssessmentDemogIodComponent {
  unsupportedImportFile: boolean = false;
  @ViewChild('demoIOD') demoIOD;
  eventImportExport: Subject<ImportExportData> = new Subject<ImportExportData>();

  constructor(
    public demoSvc: DemographicService,
    public dialog: MatDialog,
    public authSvc: AuthenticationService,
    public assessmSvc: AssessmentService
  ) { }

  importClick(event) {
    let dialogRef = null;
    this.unsupportedImportFile = false;
    if (event.target.files[0].name.endsWith(".json")) {
      // Call Standard import service
      dialogRef = this.dialog.open(UploadDemographicsComponent, {
        data: { files: event.target.files, IsNormalLoad: true }
      });
    } else {
      this.unsupportedImportFile = true;
    }

    if (!this.unsupportedImportFile) {
      dialogRef.afterClosed().subscribe(result => {
        this.demoIOD.populateDemographicsModel()
        this.assessmSvc.refreshAssessment()
      });
    }
  }

  exportClick() {
    this.demoSvc.exportDemographics()
  }
}
