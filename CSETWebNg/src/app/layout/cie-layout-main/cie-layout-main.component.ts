import { Component, ViewEncapsulation, isDevMode } from '@angular/core';
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


@Component({
  selector: 'app-cie-layout-main',
  templateUrl: './cie-layout-main.component.html',
  styleUrls: ['./cie-layout-main.component.scss'],
  encapsulation: ViewEncapsulation.None,
  // eslint-disable-next-line
  host: { class: 'd-flex flex-column flex-11a w-100 h-100' },
})
export class CieLayoutMainComponent {
  docUrl: string;
  dialogRef: MatDialogRef<any>;
  isFooterVisible: boolean = false;
  footerClosed: boolean = true;
  devMode: boolean = isDevMode();

  constructor(
    public auth: AuthenticationService,
    public assessSvc: AssessmentService,
    public configSvc: ConfigService,
    public layoutSvc: LayoutService,
    public aggregationSvc: AggregationService,
    public fileSvc: FileUploadClientService,
    public setBuilderSvc: SetBuilderService,
    public dialog: MatDialog,
    public router: Router
  ) { }

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
}
