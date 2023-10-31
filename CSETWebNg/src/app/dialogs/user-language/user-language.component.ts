import { Component, EventEmitter, Inject, OnInit, Output } from '@angular/core';
import { AuthenticationService } from '../../services/authentication.service';
import { MAT_DIALOG_DATA, MatDialogRef } from '@angular/material/dialog';
import { EditUserComponent } from '../edit-user/edit-user.component';
import { NgForm } from '@angular/forms';
import { TranslocoService } from '@ngneat/transloco';
import { Moment } from 'moment';
import { DateAdapter, MAT_DATE_LOCALE } from '@angular/material/core';
import { NgbDateAdapter } from '@ng-bootstrap/ng-bootstrap';


@Component({
  selector: 'app-user-language',
  templateUrl: './user-language.component.html'
})
export class UserLanguageComponent implements OnInit {

  languageOptions = [
    { value: "en", name: "English" },
    { value: "es", name: "Español" },
    { value: "uk", name: "українська" }
  ];


  constructor(
    private dialog: MatDialogRef<EditUserComponent>,
    @Inject(MAT_DIALOG_DATA) public data: any,
    private tSvc: TranslocoService,
    private authSvc: AuthenticationService,
    private dateAdapter: DateAdapter<any>
  ) { }

  langSelection: string;

  ngOnInit(): void {
    this.authSvc.getUserLang().subscribe((resp: any) => {
      this.langSelection = resp.lang.toLowerCase();
      this.dateAdapter.setLocale(this.langSelection);
      // Moment.locale(this.langSelection);
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
        // Moment.locale(this.langSelection);
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
