////////////////////////////////
//
//   Copyright 2026 Battelle Energy Alliance, LLC
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
