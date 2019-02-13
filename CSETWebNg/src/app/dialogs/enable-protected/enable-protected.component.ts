////////////////////////////////
//
//   Copyright 2018 Battelle Energy Alliance, LLC
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
import { EnableFeatureService } from './../../services/enable-feature.service';
import { Component, OnInit } from '@angular/core';
import { MatDialogRef } from '@angular/material';

@Component({
  selector: 'app-enable-protected',
  templateUrl: './enable-protected.component.html',
  // tslint:disable-next-line:use-host-property-decorator
  host: {class: 'd-flex flex-column flex-11a'}
})

export class EnableProtectedComponent implements OnInit {

  modulesList: EnabledModule[];
  unlockCode: string;
  message: string;

  constructor(private dialog: MatDialogRef<EnableProtectedComponent>,
  private featureSvc: EnableFeatureService) { }

  ngOnInit() {
    this.featureSvc.getEnabledFeatures().subscribe( x => this.modulesList = x);
  }

  enableFeature() {
    if (this.unlockCode) {
      this.featureSvc.enableFeature(this.unlockCode).subscribe( x =>  {
          this.message = x;
          this.featureSvc.getEnabledFeatures().subscribe( ml => this.modulesList = ml);
        });
    }
  }

  close() {
    return this.dialog.close();
  }
}

export interface EnabledModule {
  Short_Name: string;
  Full_Name: string;
}
