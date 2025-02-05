////////////////////////////////
//
//   Copyright 2024 Battelle Energy Alliance, LLC
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
import { Component, OnInit } from '@angular/core';
import { ConfigService } from '../../../../services/config.service';
import { LayoutService } from '../../../../services/layout.service';
import { ResourceLibraryService } from '../../../../services/resource-library.service';
import { MatDialog } from '@angular/material/dialog';
import { VersionUpgradeComponent } from '../../../../dialogs/version-upgrade/version-upgrade.component';
import { AssessmentService } from '../../../../services/assessment.service';
import { AssessmentDetail } from '../../../../models/assessment-info.model';


@Component({
  selector: 'app-tutorial-cmmc2',
  templateUrl: './tutorial-cmmc2.component.html'
})
export class TutorialCmmc2Component implements OnInit {
  show: boolean = true;
  loading = false;
  message: string;


  constructor(
    public configSvc: ConfigService,
    public layoutSvc: LayoutService,
    public assessSvc: AssessmentService,
    private resourceLibSvc: ResourceLibraryService,
    private dialog: MatDialog,

  ) { }

  ngOnInit(): void {
    if (this.configSvc.config.debug.showCmmcConversion ?? false) {
      this.assessSvc.getAssessmentDetail().subscribe((data: AssessmentDetail) => {
        if (data.maturityModel.modelName == "CMMC2") {
          this.showDialog()
        }
      });
    }

  }

  showDialog() {
    const dialogRef = this.dialog.open(VersionUpgradeComponent, {
      data: {
        targetModelName: "CMMC2F",
        callback: this.receiveMessage.bind(this)
      }
    });
    dialogRef.afterClosed().subscribe(result => {
      this.loading = false;
    })

  }

  receiveMessage() {
    this.loading = true;
  }

  documentURL(documentName: string) {
    return this.resourceLibSvc.documentUrlByName(documentName);
  }
}
