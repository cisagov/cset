import { Component, Inject, OnInit } from '@angular/core';
import { AuthenticationService } from '../../services/authentication.service';
import { MAT_DIALOG_DATA, MatDialogRef } from '@angular/material/dialog';
import { EditUserComponent } from '../edit-user/edit-user.component';
import { TranslocoService } from '@ngneat/transloco';
import { ConfigService } from '../../services/config.service';
import { DateAdapter } from '@angular/material/core';

@Component({
  selector: 'app-user-language',
  templateUrl: './user-language.component.html'
})
export class UserLanguageComponent implements OnInit {

  languageOptions = [];

  constructor(
    private dialog: MatDialogRef<EditUserComponent>,
    @Inject(MAT_DIALOG_DATA) public data: any,
    private tSvc: TranslocoService,
    private authSvc: AuthenticationService,
    private configSvc: ConfigService,
    private dateAdapter: DateAdapter<any>
  ) { }

  langSelection: string;

  ngOnInit(): void {
    const options = this.configSvc.config.languageOptions;
    if (!!options) {
      this.languageOptions = options;
    }

    // This ACET check is because the config.ACET.json's languageOptions 
    // isn't being read correctly (as of 10/31/23) and I don't have time to fix it
    if (this.configSvc.config.installationMode == 'ACET') {
      this.languageOptions = [
        { value: "en", name: "English" },
        { value: "es", name: "Español" }
      ];
    }

    this.authSvc.getUserLang().subscribe((resp: any) => {
      this.langSelection = resp.lang.toLowerCase();
      this.dateAdapter.setLocale(this.langSelection);
    });
  }

  /**
  *
  */
  save() {
    this.tSvc.load(this.langSelection).toPromise().then(() => {
      this.tSvc.setActiveLang(this.langSelection);
      this.authSvc.setUserLang(this.langSelection).subscribe(() => {
        this.dateAdapter.setLocale(this.langSelection);
      });
    },
      error => console.error('Error updating user langugage: ' + error.message));
    this.dialog.close();
  }

  /**
   *
   */
  cancel() {
    this.dialog.close();
  }
}
