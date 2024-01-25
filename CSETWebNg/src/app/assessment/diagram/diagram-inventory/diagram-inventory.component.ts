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
import { DiagramService } from '../../../services/diagram.service';
import { ConfigService } from '../../../services/config.service';
import { saveAs } from "file-saver";
import { UploadExportComponent } from './../../../dialogs/upload-export/upload-export.component';
import { MatDialog } from '@angular/material/dialog';
import { Vendor } from '../../../models/diagram-vulnerabilities.model';
import { AssessmentService } from '../../../services/assessment.service';

@Component({
  selector: 'app-diagram-inventory',
  templateUrl: './diagram-inventory.component.html',
  styleUrls: ['./diagram-inventory.component.scss']
})
export class DiagramInventoryComponent implements OnInit {

  componentsExist: boolean = true;
  compListUpdateFromShapesTab: any = [];

  /**
   *
   */
  constructor(public diagramSvc: DiagramService,
    private dialog: MatDialog,
    private assessSvc: AssessmentService,
    private configSvc: ConfigService
  ) { }

  /**
   *
   */
  ngOnInit() {
    if (this.assessSvc.hasDiagram()) {
      this.componentsExist = true;
    }
    // console.log('components exits='+this.componentsExist)
  }

  /**
   *
   */
  onChange(list: any) {
    this.componentsExist = list.length > 0;
  }

  /**
   *
   */
  onShapeChange(list: any) {
    if (list != null) {
      if (list.length > 0) {
        this.componentsExist = true;
      }
      this.compListUpdateFromShapesTab = list;
    }
  }

  /**
   *
   */
  getExport() {
    this.diagramSvc.getExport().subscribe(data => {
      saveAs(data, 'diagram-inventory-export.xlsx');
    },
      error => {
        console.log('Error downloading file');
      });
  }

  /**
   * Programmatically clicks the corresponding file upload element.
   */
  openFileBrowserForCsafUpload() {
    const element: HTMLElement = document.getElementById('csafUpload') as HTMLElement;
    element.click();
  }

  fileSelect(e) {
    if (e.target.files.length > 0) {
      this.dialog.open(UploadExportComponent, { data: { files: e.target.files, isCsafUpload: true } })
        .afterClosed()
        .subscribe(() => {
          // Get the updated list of vendors after upload.
          this.diagramSvc.getVulnerabilities().subscribe((vendors: Vendor[]) => {
            this.diagramSvc.csafVendors = vendors;
          });
        });
    }
  }

  showCsafUploadButton() {
    return this.configSvc.behaviors?.showUpdateDiagramCsafVulnerabilitiesButton;
  }

  showVulnerabilitiesTab() {
    return this.configSvc.behaviors?.showVulnerabilitiesDiagramInventoryTab;
  }
}
