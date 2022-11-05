import { Component, OnInit } from '@angular/core';
import { LayoutService } from '../../services/layout.service';
import { Utilities } from '../../services/utilities.service';
import { LoginAcetComponent } from '../login-acet/login-acet.component';

@Component({
  selector: 'app-anonymous-login',
  templateUrl: './anonymous-login.component.html',
  styleUrls: ['./anonymous-login.component.scss']
})
export class AnonymousLoginComponent implements OnInit {

  keyGenerated = true;
  generatedKey = '';

  loginFailed = false;

  constructor(
    public layoutSvc: LayoutService,
    private utilitiesSvc: Utilities
  ) { }

  /**
   * 
   */
  ngOnInit(): void {
  }

  /**
   * 
   */
  generateKey() {
    // TODO:  let's generate this in the API so that it can 
    // check to see if the key is already in use before
    // returning it to the user.
    
    this.generatedKey = this.utilitiesSvc.makeId(10);
  }

}
