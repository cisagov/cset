////////////////////////////////
//
//   Copyright 2023 Battelle Energy Alliance, LLC
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//
////////////////////////////////
import { Component, ElementRef, OnInit, ViewChild, AfterViewInit } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { ActivatedRoute, Router } from '@angular/router';
import { filter } from 'rxjs/operators';
import { PasswordStatusResponse } from '../../models/reset-pass.model';
import { AuthenticationService } from '../../services/authentication.service';
import { ChangePasswordComponent } from "../../dialogs/change-password/change-password.component";
import { ConfigService } from '../../services/config.service';


@Component({
  selector: 'app-landing-page-tabs',
  templateUrl: './landing-page-tabs.component.html',
  styleUrls: ['./landing-page-tabs.component.scss'],
  host: { class: 'd-flex flex-column flex-11a w-100' }
})
export class LandingPageTabsComponent implements OnInit, AfterViewInit {

  currentTab: string;
  isSearch: boolean= false;
  searchString:string="";
  @ViewChild('tabs') tabsElementRef: ElementRef;

  constructor(
    private route: ActivatedRoute,
    private router: Router,
    public authSvc: AuthenticationService,
    public dialog: MatDialog,
    private configSvc: ConfigService
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

  ngAfterViewInit(): void {
    // Only implementing sticky tabs on main CSET installation mode for now.
    const tabsEl = this.tabsElementRef.nativeElement;
    tabsEl.classList.add('sticky-tabs');
    if (this.authSvc.isLocal) {
      tabsEl.style.top = '81px';
    } else {
      tabsEl.style.top = '62px';
    }
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
    if (this.authSvc.isLocal) {
      this.continueStandAlone();
      return;
    }

    this.authSvc.passwordStatus()
      .subscribe((result: PasswordStatusResponse) => {
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
