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
import { Component, ViewEncapsulation, isDevMode } from '@angular/core';
import { MatDialog, MatDialogRef } from '@angular/material/dialog';
import { Router } from '@angular/router';
import { AggregationService } from '../../services/aggregation.service';
import { AssessmentService } from '../../services/assessment.service';
import { AuthenticationService } from '../../services/authentication.service';
import { ConfigService } from '../../services/config.service';
import { FileUploadClientService } from '../../services/file-client.service';
import { LayoutService } from '../../services/layout.service';


@Component({
  selector: 'rra-layout-main',
  templateUrl: './rra-layout-main.component.html',
  styleUrls: ['./rra-layout-main.component.scss', '../styles-rra.scss'],
  encapsulation: ViewEncapsulation.None,
  // eslint-disable-next-line
  host: { class: 'd-flex flex-column flex-11a w-100 h-100' }
})
export class RraLayoutMainComponent {

  docUrl: string;
  dialogRef: MatDialogRef<any>;
  footerClosed: boolean = true;
  devMode: boolean = isDevMode();

  constructor(
    public auth: AuthenticationService,
    public assessSvc: AssessmentService,
    public layoutSvc: LayoutService,
    public configSvc: ConfigService,
    public aggregationSvc: AggregationService,
    public fileSvc: FileUploadClientService,
    public dialog: MatDialog,
    public router: Router
  ) { }

  /**
   * Indicates if the user is currently within the Module Builder pages.
   * TODO:  Hard-coded paths could be replaced by asking the BreadcrumbComponent
   * or the SetBuilderService for Module Builder paths.
   */
  isModuleBuilder(rpath: string) {
    if (!rpath) {
      return false;
    }
    if (rpath === '/set-list'
      || rpath.indexOf('/set-detail') > -1
      || rpath.indexOf('/requirement-list') > -1
      || rpath.indexOf('/standard-documents') > -1
      || rpath.indexOf('/ref-document') > -1
      || rpath.indexOf('/requirement-detail') > -1
      || rpath.indexOf('/question-list') > -1
      || rpath.indexOf('/add-question') > -1) {
      return true;
    }
    return false;
  }

  goHome() {
    this.assessSvc.dropAssessment();
    this.router.navigate(['/home']);
  }

  isFooterOpen() {
    if (!this.footerClosed) {
      return this.footerClosed = true;
    }
    return this.footerClosed = false;
  }

}
