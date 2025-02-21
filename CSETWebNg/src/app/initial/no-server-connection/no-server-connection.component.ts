import { Component, OnInit, HostBinding } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { AlertComponent } from '../../dialogs/alert/alert.component';
import { ConfigService } from '../../services/config.service';
import { TranslocoService } from '@jsverse/transloco';


@Component({
    selector: 'app-no-server-connection',
    templateUrl: './no-server-connection.component.html',
    standalone: false
})
export class NoServerConnectionComponent implements OnInit {

  @HostBinding('class.d-none')
  apiIsVisible?: boolean = true;

  display = '';

  constructor(
    public configSvc: ConfigService,
    public dialog: MatDialog,
    public tSvc: TranslocoService
  ) {  }

  /**
   * 
   */
  ngOnInit() {
    // ping API
    this.configSvc.getCsetVersion().subscribe(() => {
      this.apiIsVisible = true;
    }, error => {
      this.apiIsVisible = false;
    });


    // build configuration display
    this.display = `<p>${this.tSvc.translate('connection.details 1')}</p>` +
    `<label class="fw-bold">${this.tSvc.translate('connection.details 2')}</label>` +
    `<div>${this.configSvc.serverUrl}</div>`;
  }

  /**
   * handle button click and display mat-dialog
   */
  showDialog() {
    this.dialog.open(AlertComponent, {
      data: { messageText: this.display, showHeader: false }
    });
  }
}
