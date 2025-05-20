import { Component, Inject, OnInit, ViewChildren } from '@angular/core';
import { AuthenticationService } from '../../services/authentication.service';
import { MAT_DIALOG_DATA, MatDialog, MatDialogRef } from '@angular/material/dialog';
import { EditUserComponent } from '../edit-user/edit-user.component';
import { TranslocoService } from '@jsverse/transloco';
import { ConfigService } from '../../services/config.service';
import { DateAdapter } from '@angular/material/core';
import { firstValueFrom } from 'rxjs';
import { AssessmentService } from '../../services/assessment.service';
import { UserRolesEditorComponent } from '../user-roles-editor/user-roles-editor.component';

@Component({
  selector: 'app-user-settings',
  templateUrl: './user-settings.component.html',
  standalone: false
})
export class UserSettingsComponent implements OnInit {

  languageOptions = [];
  encryption: boolean;
  adminDialogRef: any;
  @ViewChildren(UserRolesEditorComponent) userRolesEditor: UserRolesEditorComponent;
  cisaWorkflowEnabled: boolean = false;
  cisaWorkflowStatusLoaded: boolean = false;

  constructor(
    private dialog: MatDialogRef<EditUserComponent>,
    private adminDialog: MatDialog,
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

  openAdminUserRolesEditor() {
    // this.dialog.close({ encryption: this.encryption });
    try {
      this.adminDialogRef = this.adminDialog.open(UserRolesEditorComponent);
      // this.adminDialog.open(UserRolesEditorComponent, {width: '500px', height: '500px'});

      this.adminDialogRef.afterClosed().subscribe((results) => {
        if (results) {
          // this.assessSvc.persistEncryptPreference(results.encryption).subscribe(() => { });
        }
      });
      console.log('success')
    } 
    catch (e: any) {
      console.log('error: ')
      console.log(e)
    }
    
  }
}
