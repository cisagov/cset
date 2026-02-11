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
import { Component, Inject, OnInit } from '@angular/core';
import { AuthenticationService } from '../../services/authentication.service';
import { MAT_DIALOG_DATA, MatDialogRef } from '@angular/material/dialog';
import { EditUserComponent } from '../edit-user/edit-user.component';
import { TranslocoService } from '@jsverse/transloco';
import { ConfigService } from '../../services/config.service';
import { DateAdapter } from '@angular/material/core';
import { firstValueFrom } from 'rxjs';
import { AssessmentService } from '../../services/assessment.service';

@Component({
  selector: 'app-user-settings',
  templateUrl: './user-settings.component.html',
  standalone: false
})
export class UserSettingsComponent implements OnInit {

  languageOptions = [];
  encryption: boolean;
  cisaWorkflowEnabled: boolean = false;
  cisaWorkflowStatusLoaded: boolean = false;

  constructor(
    private dialog: MatDialogRef<EditUserComponent>,
    @Inject(MAT_DIALOG_DATA) public data: any,
    private tSvc: TranslocoService,
    private authSvc: AuthenticationService,
    private configSvc: ConfigService,
    private dateAdapter: DateAdapter<any>,
    public assessSvc: AssessmentService
  ) { }

  langSelection: string;

  ngOnInit(): void {
    const options = this.configSvc.config.languageOptions;
    if (!!options) {
      this.languageOptions = options;
    }

    this.authSvc.getUserLang().subscribe((resp: any) => {
      this.langSelection = resp.lang.toLowerCase();
      this.dateAdapter.setLocale(this.langSelection);
    });

    this.assessSvc.getEncryptPreference().subscribe((result: boolean) => {
      this.encryption = result
    });
    this.configSvc.getCisaAssessorWorkflow().subscribe((cisaWorkflowEnabled: boolean) => {
      this.configSvc.userIsCisaAssessor = cisaWorkflowEnabled;
      this.cisaWorkflowEnabled = cisaWorkflowEnabled;
      this.cisaWorkflowStatusLoaded = true;
    });
  }

  /**
  *
  */
  save() {
    const obs = this.tSvc.load(this.langSelection);
    const prom = firstValueFrom(obs);

    prom.then(() => {
      this.tSvc.setActiveLang(this.langSelection);
      this.authSvc.setUserLang(this.langSelection).subscribe(() => {
        this.dateAdapter.setLocale(this.langSelection);
      });
    },
      error => console.error('Error updating user langugage: ' + error.message));
  }

  updateEncryptPreference() {
    this.encryption = !this.encryption
  }

  /**
   *
   */
  cancel() {
    this.dialog.close({ encryption: this.encryption, cisaWorkflowEnabled: this.cisaWorkflowEnabled });
  }

  showCisaAssessorWorkflowSwitch() {
    return this.configSvc.behaviors.showCisaAssessorWorkflowSwitch;
  }

  toggleCisaAssessorWorkflow() {
    this.cisaWorkflowEnabled = !this.cisaWorkflowEnabled;
  }
}
