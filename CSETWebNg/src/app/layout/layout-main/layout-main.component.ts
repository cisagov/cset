////////////////////////////////
//
//   Copyright 2021 Battelle Energy Alliance, LLC
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
import { Component, OnInit, ViewChild, AfterViewInit, ViewEncapsulation } from '@angular/core';
import { MatDialog, MatDialogRef } from '@angular/material/dialog';
import { ActivatedRoute, Router } from '@angular/router';
import { Hotkey, HotkeysService } from 'angular2-hotkeys';
import { AboutComponent } from '../../dialogs/about/about.component';
import { AdvisoryComponent } from '../../dialogs/advisory/advisory.component';
import { AssessmentDocumentsComponent } from '../../dialogs/assessment-documents/assessment-documents.component';
import { ChangePasswordComponent } from '../../dialogs/change-password/change-password.component';
import { ConfirmComponent } from '../../dialogs/confirm/confirm.component';
import { EditUserComponent } from '../../dialogs/edit-user/edit-user.component';
import { EnableProtectedComponent } from '../../dialogs/enable-protected/enable-protected.component';
import { GlobalParametersComponent } from '../../dialogs/global-parameters/global-parameters.component';
import { KeyboardShortcutsComponent } from '../../dialogs/keyboard-shortcuts/keyboard-shortcuts.component';
import { TermsOfUseComponent } from '../../dialogs/terms-of-use/terms-of-use.component';
import { CreateUser } from '../../models/user.model';
import { AssessmentService } from '../../services/assessment.service';
import { AuthenticationService } from '../../services/authentication.service';
import { ConfigService } from '../../services/config.service';
import { NgbAccordion } from '@ng-bootstrap/ng-bootstrap';
import { ExcelExportComponent } from '../../dialogs/excel-export/excel-export.component';
import { AggregationService } from '../../services/aggregation.service';
import { FileUploadClientService } from '../../services/file-client.service';
import { RraMiniUserGuideComponent } from '../../dialogs/rra-mini-user-guide/rra-mini-user-guide.component';

declare var $: any;

@Component({
  moduleId: module.id,
  selector: 'layout-main',
  templateUrl: './layout-main.component.html',
  styleUrls: ['./layout-main.component.scss'],
  encapsulation: ViewEncapsulation.None,
  // tslint:disable-next-line:use-host-property-decorator
  host: { class: 'd-flex flex-column flex-11a w-100' }
})
export class LayoutMainComponent implements OnInit, AfterViewInit {
  docUrl: string;
  dialogRef: MatDialogRef<any>;
  isFooterVisible: boolean = false;

  @ViewChild('acc') accordion: NgbAccordion;

  constructor(
    public auth: AuthenticationService,
    public assessSvc: AssessmentService,
    public configSvc: ConfigService,
    public aggregationSvc: AggregationService,
    public fileSvc: FileUploadClientService,
    public dialog: MatDialog,
    public router: Router
  ) { }

  ngOnInit() { }
  
  ngAfterViewInit() {
    setTimeout(() => {
      this.isFooterOpen();
    }, 200);
  }

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
    if (!!this.accordion) {
      return this.accordion.isExpanded('footerPanel');
    }
    return false;
  }
}
