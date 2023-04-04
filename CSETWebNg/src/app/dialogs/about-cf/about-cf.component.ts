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
import { Component, Inject, OnInit } from '@angular/core';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { environment } from '../../../environments/environment';
import { ConfigService } from '../../services/config.service';

@Component({
  selector: 'app-about-cf',
  templateUrl: './about-cf.component.html',
  styleUrls: ['./about-cf.component.scss']
})
export class AboutCfComponent implements OnInit {

  constructor(private dialog: MatDialogRef<AboutCfComponent>,
    public configSvc: ConfigService,
    @Inject(MAT_DIALOG_DATA) public data: any) { }


    linkerTime: string = null;
      /**
       * 
       */
      ngOnInit() {
        if (this.configSvc.config.debug.showBuildTime ?? false) {
          this.linkerTime = localStorage.getItem('cset.linkerDate');
        }
        
      }
    version = environment.visibleVersion;
    helpContactEmail = this.configSvc.helpContactEmail;
    helpContactPhone = this.configSvc.helpContactPhone;

    close() {
      return this.dialog.close();
    }
  
  }