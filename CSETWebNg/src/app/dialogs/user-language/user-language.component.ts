import { Component, Inject, OnInit } from '@angular/core';
import { AuthenticationService } from '../../services/authentication.service';
import { MAT_DIALOG_DATA, MatDialogRef } from '@angular/material/dialog';
import { EditUserComponent } from '../edit-user/edit-user.component';
import { NgForm } from '@angular/forms';
import { TranslocoService } from '@ngneat/transloco';


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
    private authSvc: AuthenticationService
  ) { }

  langSelection: string;

  ngOnInit(): void {
    this.authSvc.getUserLang().subscribe((resp: any) => {
      this.langSelection = resp.lang.toLowerCase();
    });
  }

  /**
  *
  */
  save() {
    this.tSvc.setActiveLang(this.langSelection);
    this.authSvc.setUserLang(this.langSelection).subscribe(() => {
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
