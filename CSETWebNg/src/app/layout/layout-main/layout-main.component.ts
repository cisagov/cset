////////////////////////////////
//
//   Copyright 2024 Battelle Energy Alliance, LLC
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
import { Component, OnInit, ViewEncapsulation } from '@angular/core';
import { MatDialog, MatDialogRef } from '@angular/material/dialog';
import { Router } from '@angular/router';
import { AggregationService } from '../../services/aggregation.service';
import { AssessmentService } from '../../services/assessment.service';
import { AuthenticationService } from '../../services/authentication.service';
import { SetBuilderService } from './../../services/set-builder.service';
import { ConfigService } from '../../services/config.service';
import { FileUploadClientService } from '../../services/file-client.service';
import { OnlineDisclaimerComponent } from '../../dialogs/online-disclaimer/online-disclaimer.component';
import { LayoutService } from '../../services/layout.service';

import { AppVersion } from '../../models/app-version';
import { VersionService } from '../../services/version.service';
import { take } from 'rxjs/operators';

@Component({
  selector: 'layout-main',
  templateUrl: './layout-main.component.html',
  styleUrls: ['./layout-main.component.scss'],
  encapsulation: ViewEncapsulation.None,
  // eslint-disable-next-line
  host: { class: 'd-flex flex-column flex-11a w-100 h-100' },

})
export class LayoutMainComponent  implements OnInit{
  docUrl: string;
  dialogRef: MatDialogRef<any>;
  isFooterVisible: boolean = false;
  footerClosed: boolean = true;

  localVersion:string='';
  actualVersion:string='';
  versiontoUpdate:any;
  patchNotes:string = '';
  skippedVersion:boolean=false;
  showVersionNotification = false;
  newVersion: AppVersion;
  display = "none";
  displayNotifications="none";

  constructor(
    public auth: AuthenticationService,
    public assessSvc: AssessmentService,
    public configSvc: ConfigService,
    public layoutSvc: LayoutService,
    public aggregationSvc: AggregationService,
    public fileSvc: FileUploadClientService,
    public setBuilderSvc: SetBuilderService,
    public dialog: MatDialog,
    public router: Router,
    private versionSvc: VersionService
  ) { }
  ngOnInit() {
    // this.checkForUpdates();
  this.versionSvc.getInstalledVersion().subscribe(r=>{
    console.log(r)
  }
   
  )
  }
  /**
   * Indicates if the user is currently within the Module Builder pages.
   */
  isModuleBuilder(rpath: string) {
    if (!rpath) {
      return false;
    }

    rpath = rpath.split('/')[1];
    return this.setBuilderSvc.moduleBuilderPaths.includes(rpath);
  }

  goHome() {
    this.assessSvc.dropAssessment();
    this.router.navigate(['/home']);
  }

  isFooterOpen() {
    if (!this.footerClosed) {
      return this.footerClosed = true;
    }
    return this.footerClosed = false;
  }

  isRunningAnonymous() {
    return this.configSvc.isRunningAnonymous;
  }

  showDisclaimer() {
    this.dialog.open(OnlineDisclaimerComponent, { data: { publicDomainName: this.configSvc.publicDomainName } });
  }
// version 
  checkForUpdates(reset: boolean = false): void {
    this.versionSvc.getInstalledVersion().subscribe(
      data=>{
        this.versiontoUpdate=data;
        localStorage.setItem('versionNotificationViewed',data.cset_Version1)
        if(this.versiontoUpdate.currentVersion!=this.versiontoUpdate.cset_Version1){
          this.skippedVersion=true;
         }
      }
    )
    this.versionSvc.isNewerVersionAvailable()
      .pipe(take(1))
      .subscribe(response => {
       this.showVersionNotification = response.isNewer && this.versionSvc.compareVersion(localStorage.getItem('versionNotificationViewed'), response.version.majorVersion.toString()+'.'+response.version.minorVersion.toString()+'.'+response.version.patch.toString()+'.'+response.version.build.toString()) === 'newer'
        this.newVersion = response.version;
       if(this.showVersionNotification==true && this.versiontoUpdate?.currentVersion==localStorage.getItem('versionNotificationViewed')){
        this.showNotifications();
       }
      });
    if (reset) {
      this.showNotifications();
    }
  }

  showNotifications(): void {
    this.display = "block";
    this.localVersion=localStorage.getItem('versionNotificationViewed');
    this.actualVersion=this.newVersion.majorVersion.toString()+'.'+this.newVersion.minorVersion.toString()+'.'+this.newVersion.patch.toString()+'.'+this.newVersion.build.toString();
    this.patchNotes = this.newVersion.patchNotes;
  }

  onCloseHandled() {
    this.display = "none";
    this.displayNotifications="none"

   }
  skipVersion(){
    this.versiontoUpdate.updateVersion=this.actualVersion;
    console.log(this.versiontoUpdate.updateVersion)
    this.versionSvc.updateVersion(this.versiontoUpdate).subscribe(data=>{
      this.skippedVersion=true;
      this.display="none";
    })
  }
  downloadNewVersion(){
  
    this.versiontoUpdate.cset_Version1=this.actualVersion;
    this.versiontoUpdate.updateVersion=this.actualVersion;
    this.versionSvc.updateVersion(this.versiontoUpdate).subscribe(data=>{
      this.display = "none";
      window.location.href=this.newVersion.versionString;
      this.showVersionNotification = false;
    }

    );

  }
}
