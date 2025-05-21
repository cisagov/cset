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
  selector: 'app-admin-settings',
  templateUrl: './admin-settings.component.html',
  standalone: false
})
export class AdminSettingsComponent implements OnInit {

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
      this.configSvc.cisaAssessorWorkflow = cisaWorkflowEnabled;
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
