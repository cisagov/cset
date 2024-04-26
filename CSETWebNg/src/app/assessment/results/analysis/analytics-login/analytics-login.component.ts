import { Component, OnInit, Inject, Input, Output, EventEmitter } from '@angular/core';
import { FormControl, NgForm, FormGroupDirective, Validators, FormGroup } from '@angular/forms';
import { HttpErrorResponse } from '@angular/common/http'
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { ErrorStateMatcher } from '@angular/material/core';
import { LoginData } from '../../../../models/anonymous.model';
import { AnalyticsService } from '../../../../services/analytics.service';
import { MatSnackBar } from '@angular/material/snack-bar';
import { MatDialog } from '@angular/material/dialog';
import { ConfigService } from '../../../../services/config.service';
import { AlertComponent } from '../../../../dialogs/alert/alert.component';

/** Error when invalid control is dirty, touched, or submitted. */
export class MyErrorStateMatcher implements ErrorStateMatcher {
  isErrorState(control: FormControl | null, form: FormGroupDirective | NgForm | null): boolean {
    const isSubmitted = form && form.submitted;
    return !!(control && control.invalid && (control.dirty || control.touched || isSubmitted));
  }
}

@Component({
  selector: 'app-analytics-login',
  templateUrl: './analytics-login.component.html',
  styleUrls: ['./analytics-login.component.scss'],
  host: { class: 'd-flex flex-column flex-11a' }
})
export class AnalyticsloginComponent implements OnInit {

  matcherusername = new MyErrorStateMatcher();
  matcherpassword = new MyErrorStateMatcher();
  matchalias = new MyErrorStateMatcher();

  dataloginForm = new FormGroup ({
    username: new FormControl('', [Validators.required]),
    password: new FormControl('', [Validators.required])
  });



  @Input() error: string | null;

  @Output() submitEM = new EventEmitter();



  constructor(
    @Inject(MAT_DIALOG_DATA) public analytics: any,
    private dialog: MatDialogRef<AnalyticsloginComponent>, 
    private snackBar: MatSnackBar,
    private analyticsSvc: AnalyticsService,
    private config: ConfigService,
    private dialogMat: MatDialog,
    ) { }


  ngOnInit() {
  }

  submit() {
    this.postAnalyticsWithLogin()
  }

  postAnalyticsWithLogin() {
    var message;
    if(this.dataloginForm.valid){
      this.analyticsSvc.getAnalyticsToken(this.dataloginForm.controls.username.value, this.dataloginForm.controls.password.value).subscribe(
        data => {
          let token = data.token;
          console.log(token);
          this.analyticsSvc.postAnalyticsWithLogin(this.analytics, token).subscribe(
            (data: any) => {
                this.dialogMat.open(AlertComponent, {
                data: { 
                    title: 'Success',
                    iconClass: 'cset-icons-check-circle',
                    messageText: data.message 
                }
                });
              this.close();
            });
        },
        err => {
          if (err instanceof HttpErrorResponse) {
            let httpError: HttpErrorResponse = err;
            if (httpError.status === 403) {  // Username or password Failed
              this.error = 'We were unable to log you in. Verify that you have the correct credentials';
            } else if (httpError.status === 423) { // Locked Out
              this.error = 'We were unable to log you in. Locked out.';
            } else if (httpError.status === 400) { // Generic Error
              this.error = 'We were unable to log you in. Error with login. Try again.';
            } else if (httpError.status === 400) {
              this.error = 'We were unable to log you in.  Error with login. Try again.';
            } else { // All other errors
              this.error = 'We were unable to log you in.  Error with login. Try again.';
            }
          } else {
            this.error = 'We were unable to log you in.  Error with login. Try again.';
            message = err.message;
            if (message)
              this.error = message;
          }
        });
    } else {
      this.error = "Fill out required fields";
    }
  }

  /**
   * User canceled out of dialog
   */
  close() {
    return this.dialog.close({ cancel: true });
  }


  /**
   * Take user to page where they can register as a new user.
   */
  register() {
    window.open(this.config.analyticsUrl + "index.html", "_blank");
  }

  openSnackBar(message) {
    this.snackBar.open(message, "", {
      duration: 4000,
      verticalPosition: 'top',
      panelClass: ['green-snackbar']
    });
  }
}

