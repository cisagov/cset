import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { AuthenticationService } from '../../services/authentication.service';
import { LayoutService } from '../../services/layout.service';
import { Utilities } from '../../services/utilities.service';


@Component({
  selector: 'app-login-access-key',
  templateUrl: './login-access-key.component.html',
  styleUrls: ['./login-access-key.component.scss']
})
export class LoginAccessKeyComponent implements OnInit {

  loginKey = '';

  isGenerating = false;
  isKeyGenerated = false;
  generatedKey = '';

  loginFailed = false;

  /**
   * 
   */
  constructor(
    public layoutSvc: LayoutService,
    private utilitiesSvc: Utilities,
    private authSvc: AuthenticationService,
    private router: Router
  ) { }

  /**
   * 
   */
  ngOnInit(): void {
    this.loginFailed = false;
  }

  /**
   * 
   */
  login() {
    this.authSvc.loginWithAccessKey(this.loginKey).subscribe((resp) => {
      localStorage.setItem('accessKey', this.loginKey);
      this.router.navigate(['/home', 'landing-page-tabs']);
    },
    error => {
      this.loginFailed = true;
      localStorage.removeItem('accessKey');
      console.log(error);
    });
  }

  /**
   * 
   */
  generateKey() {
    // TODO:  let's generate this in the API so that it can 
    // check to see if the key is already in use before
    // returning it to the user.

    this.isGenerating = true;
    this.authSvc.generateAccessKey().subscribe((key: string) => {
      this.generatedKey = key;
      this.loginKey = key;
      this.isGenerating = false;
      this.isKeyGenerated = true;
    });
  }

}
