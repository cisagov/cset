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
import { Component, ViewChild } from '@angular/core';
import { Subject } from 'rxjs';
import { DemographicService } from '../../../../services/demographic.service';
import { MatDialog } from '@angular/material/dialog';
import { UploadDemographicsComponent } from "../../../../dialogs/import demographics/import-demographics.component";
import { AuthenticationService } from '../../../../services/authentication.service';
import { UploadExportComponent } from "../../../../dialogs/import-assessment/import-assessment.component";
import { AssessmentService } from '../../../../services/assessment.service';


interface ImportExportData {
  flag: string;
  data: any;
}

@Component({
    selector: 'app-assessment-demog-iod',
    templateUrl: './assessment-demog-iod.component.html',
    styleUrls: ['./assessment-demog-iod.component.scss'],
    standalone: false
})


export class AssessmentDemogIodComponent {
  unsupportedImportFile: boolean = false;
  @ViewChild('demoIOD') demoIOD;
  eventImportExport: Subject<ImportExportData> = new Subject<ImportExportData>();

  constructor(
    public demoSvc: DemographicService,
    public dialog: MatDialog,
    public authSvc: AuthenticationService,
    public assessmentSvc: AssessmentService
  ) { }

  importClick(event) {
    let dialogRef = null;
    this.unsupportedImportFile = false;
    if (event.target.files[0]?.name.endsWith(".json")) {
      // Call Standard import service
      dialogRef = this.dialog.open(UploadDemographicsComponent, {
        data: { files: event.target.files, IsNormalLoad: true }
      });
    } else {
      this.unsupportedImportFile = true;
    }

    if (!this.unsupportedImportFile) {
      dialogRef.afterClosed().subscribe(result => {
        this.demoIOD.populateDemographicsModel();
        this.assessmentSvc.refreshAssessment();
        this.demoSvc.demographicUpdateCompleted$.next();
      });
    }
  }

  exportClick() {
    this.demoSvc.exportDemographics();
  }
}
