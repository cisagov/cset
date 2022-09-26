import { Component, OnInit } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { ActivatedRoute, Router } from '@angular/router';
import { filter } from 'rxjs/operators';
import { PasswordStatusResponse } from '../../models/reset-pass.model';
import { AuthenticationService } from '../../services/authentication.service';
import { ChangePasswordComponent } from "../../dialogs/change-password/change-password.component";


@Component({
  selector: 'app-landing-page-tabs',
  templateUrl: './landing-page-tabs.component.html',
  styleUrls: ['./landing-page-tabs.component.scss'],
  host: { class: 'd-flex flex-column flex-11a w-100' }
})
export class LandingPageTabsComponent implements OnInit {

  currentTab: string;
  isSearch: boolean= false;
  searchString:string="";

  constructor(
    private route: ActivatedRoute,
    private router: Router,
    public authSvc: AuthenticationService,
    public dialog: MatDialog,
    ) { }

  ngOnInit(): void {
    this.setTab('myAssessments');

    this.checkPasswordReset();

    // setting the tab when we get a query parameter.
    this.route.queryParamMap.pipe(filter(params => params.has('tab'))).subscribe(params => {
      this.setTab(params.get('tab'));
      // clear the query parameters from the url.
      this.router.navigate([], { queryParams: {} });
    });
  }

  setTab(tab) {
    this.currentTab = tab;
  }

  checkActive(tab) {
    return this.currentTab === tab;
  }
  changeToSearch(val){
    this.isSearch = true;
    this.searchString = val;
  }
  cancelSearch(){
    this.isSearch = false;
    this.searchString = '';
  }

  hasPath(rpath: string) {
    if (rpath != null) {
      localStorage.removeItem("returnPath");
      this.router.navigate([rpath], { queryParamsHandling: "preserve" });
    }
  }

  /**
   *
   */
   checkPasswordReset() {
    console.log('b');
    if (this.authSvc.isLocal) {
      this.continueStandAlone();
      return;
    }

    this.authSvc.passwordStatus()
      .subscribe((result: PasswordStatusResponse) => {
        console.log('c');
        if (result) {
          if (!result.resetRequired) {
            this.openPasswordDialog(true);
          }
        }
      });
  }

  openPasswordDialog(showWarning: boolean) {
    if (localStorage.getItem("returnPath")) {
      if (!Number(localStorage.getItem("redirectid"))) {
        this.hasPath(localStorage.getItem("returnPath"));
      }
    }
    this.dialog
      .open(ChangePasswordComponent, {
        width: "300px",
        data: { primaryEmail: this.authSvc.email(), warning: showWarning }
      })
      .afterClosed()
      .subscribe(() => {
        this.checkPasswordReset();
      });
  }

  continueStandAlone() {
    this.router.navigate(['/home']);
  }
}
