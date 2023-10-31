import { Component, EventEmitter, Inject, OnInit, Output } from '@angular/core';
import { AuthenticationService } from '../../services/authentication.service';
import { MAT_DIALOG_DATA, MatDialogRef } from '@angular/material/dialog';
import { EditUserComponent } from '../edit-user/edit-user.component';
import { NgForm } from '@angular/forms';
import { TranslocoService } from '@ngneat/transloco';
import { ConfigService } from '../../services/config.service';


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
    private configSvc: ConfigService
  ) { }

  langSelection: string;

  ngOnInit(): void {
    //console.log(this.configSvc.config)
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
    });
  }

  /**
  *
  */
  save() {
    this.tSvc.load(this.langSelection).toPromise().then(() => {
      this.tSvc.setActiveLang(this.langSelection);
      this.authSvc.setUserLang(this.langSelection).subscribe(() => {
    });
      // 
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
